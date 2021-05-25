import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/errors/accountExceptions.dart';
import 'package:perrow_api/src/errors/authExceptions.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:perrow_api/src/validators/auth_validation.dart';

class AuthApi {
  String secret;
  TokenService tokenService;
  AuthService authService;

  AuthApi({
    required this.secret,
    required this.tokenService,
    required this.authService,
  });

  Router get router {
    final router = Router();

    router.post(
      '/register',
      ((
        Request request,
      ) async {
        try {
          var payload = RegisterRequest.fromJson(
              json.decode(await request.readAsString()));

          if (AuthApiValidation.ageCheck(payload.age)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {'message': 'Please provide your age'}
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          if (AuthApiValidation.genderCheck(payload.gender)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {'message': 'Please provide your gender'}
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          if (AuthApiValidation.pinCheck(payload.pin)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {
                  'message': InvalidPinException().toString(),
                }
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          if (AuthApiValidation.phoneNumberCheck(payload.phoneNumber)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {'message': InvalidPhoneNumberException().toString()}
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          var response = await authService.register(
            gender: payload.gender!,
            pin: payload.pin!,
            phoneNumber: payload.phoneNumber!,
            age: payload.age!,
          );

          return Response.ok(
            json.encode({
              'data': {
                'message': 'Account Created',
                'id': response.id,
              }
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        } on FormatException catch (e) {
          print('FormatException ${e.source} ${e.message}');
          return Response(
            HttpStatus.badRequest,
            body: json.encode({
              'data': {
                'message': 'Provide a valid Request refer to documentation'
              }
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        } catch (e) {
          return Response(
            HttpStatus.forbidden,
            body: json.encode({
              'data': {'message': e.toString()}
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        }
      }),
    );

    router.post(
      '/login',
      ((
        Request request,
      ) async {
        try {
          var payload =
              LoginRequest.fromJson(json.decode(await request.readAsString()));

          if (AuthApiValidation.pinCheck(payload.pin)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {
                  'message': InvalidPinException().toString(),
                }
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          // if (AuthApiValidation.phoneNumberCheck(payload.phoneNumber)) {
          //   //Todo: Input Validation Errors
          //   return Response(
          //     HttpStatus.badRequest,
          //     body: json.encode({
          //       'data': {'message': InvalidPhoneNumberException().toString()}
          //     }),
          //     headers: {
          //       HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
          //     },
          //   );
          // }

          if (AuthApiValidation.uuidCheck(payload.id)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {
                  'message': InvalidUserIDException().toString(),
                }
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          final token = await authService.login(
            pin: payload.pin!,
            id: payload.id!,
          );

          return Response.ok(
            json.encode({'data': token.toJson()}),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        } on FormatException catch (e) {
          print('FormatException ${e.source} ${e.message}');
          return Response(
            HttpStatus.badRequest,
            body: json.encode({
              'data': {
                'message': 'Provide a valid Request refer to documentation'
              }
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        } catch (e) {
          return Response.notFound(
            json.encode({
              'data': {'message': e.toString()}
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        }
      }),
    );

    router.post('/logout', (Request req) async {
      final auth = req.context['authDetails'];

      if (auth == null) {
        return Response.forbidden(
          json.encode({
            'data': {'message': 'Not authorised to perform this request'}
          }),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
          },
        );
      }

      try {
        await tokenService.removeRefreshToken((auth as JWT).jwtId);
      } catch (e) {
        return Response.internalServerError(
            body: json.encode({
              'data': {
                'message':
                    'There was an issue logging out. Please check and try again.'
              }
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            });
      }

      return Response.ok(
        json.encode({
          'data': {'message': 'Successfully logged out'}
        }),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );
    });

    router.post('/refresh', (Request req) async {
      final payload = await req.readAsString();
      final payloadMap;
      final JWT token;

      try {
        payloadMap = json.decode(payload);

        token = verifyJWT(
          token: payloadMap['refreshToken'],
          secret: secret,
        );
      } on FormatException catch (e) {
        print('FormatException ${e.source} ${e.message}');
        return Response(
          HttpStatus.badRequest,
          body: json.encode({
            'data': {
              'message': 'Provide a valid Request refer to documentation'
            }
          }),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
          },
        );
      } catch (e) {
        //TODO Handle VerifyJWT Error
        print(e.toString());
        return Response(
          HttpStatus.badRequest,
          body: json.encode({
            'data': {'message': 'Invalid Refresh Token'}
          }),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
          },
        );
      }

      try {
        if (token.payload == null || token.payload == '') {
          return Response(HttpStatus.badRequest,
              body: json.encode({
                'data': {'message': 'Refresh token is not valid.'}
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              });
        }
      } on JWTExpiredError catch (e) {
        return Response(HttpStatus.badRequest,
            body: json.encode(
              {
                'data': {'message': '$e'}
              },
            ),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            });
      } on JWTError catch (e) {
        return Response(HttpStatus.badRequest,
            body: json.encode({
              'data': {'message': '$e'}
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            });
      }

      final dbToken = await tokenService.getRefreshToken(token.jwtId);

      if (dbToken == null) {
        return Response(HttpStatus.badRequest,
            body: json.encode({
              'data': {'message': 'Refresh token is not recognised.'}
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            });
      }
      // Generate new token pair
      final oldJwt = token;
      try {
        await tokenService.removeRefreshToken(
          token.jwtId,
        );
        final tokenPair = await tokenService.createTokenPair(
          userId: oldJwt.subject,
        );
        return Response.ok(
          json.encode(tokenPair.toJson()),
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
          },
        );
      } catch (e) {
        return Response.internalServerError(
            body: json.encode({
              'data': {
                'message':
                    'There was a problem creating a new token. Please try again.'
              }
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            });
      }
    });
    return router;
  }
}

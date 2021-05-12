import 'dart:convert';
import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:perrow_api/src/errors/authExceptions.dart';
import 'package:perrow_api/src/model/models/api/auth/user/register/registerRequest.dart';
import 'package:perrow_api/src/service/AuthService.dart';
import 'package:perrow_api/src/service/token_service.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:perrow_api/src/validators/auth_validation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthApi {
  String secret;
  TokenService tokenService;

  AuthApi({
    required this.secret,
    required this.tokenService,
  });

  Router get router {
    final router = Router();

    final _authService = AuthService();

    router.post(
      '/register',
      ((
        Request request,
      ) async {
        try {
          var data = RegisterRequest.fromJson(
              json.decode(await request.readAsString()));

          if (AuthApiValidation.ageCheck(data.age)) {
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

          if (AuthApiValidation.genderCheck(data.gender)) {
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

          if (AuthApiValidation.pinCheck(data.pin)) {
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

          if (AuthApiValidation.phoneNumberCheck(data.phoneNumber)) {
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

          await _authService.register(
            gender: data.gender!,
            pin: data.pin!,
            phoneNumber: data.phoneNumber!,
            age: data.age!,
          );

          return Response.ok(
            json.encode({
              'data': {'message': 'Account Created'}
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
            HttpStatus.badRequest,
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
          final payload = await request.readAsString();

          final userData = json.decode(payload);

          final id = userData['id'];
          final pin = userData['pin'];

          if (id == null || id == '') {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {'message': 'Please provide an id'}
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          if (pin == null || pin == '') {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {'message': 'Please provide a pin'}
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          final token = await _authService.login(
            pin: pin,
            id: id,
            tokenService: tokenService,
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

    router.post('/refreshToken', (Request req) async {
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

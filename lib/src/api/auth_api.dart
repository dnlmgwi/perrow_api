import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/errors/account_exceptions.dart';
import 'package:perrow_api/src/models/api/auth/user/login/login_request.dart';
import 'package:perrow_api/src/services/auth/authService.dart';
import 'package:perrow_api/src/validators/auth_validation.dart';

class AuthApi {
  String secret;
  AuthService authService;

  AuthApi({
    required this.secret,
    required this.authService,
  });

  Router get router {
    final router = Router();

    router.post(
      '/login',
      ((
        Request request,
      ) async {
        try {
          var payload =
              LoginRequest.fromJson(json.decode(await request.readAsString()));

          if (AuthApiValidation.inputNullCheck(payload.password)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {
                  'message': InvalidInputException().toString(),
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

          if (AuthApiValidation.inputNullCheck(payload.email)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {
                  'message': InvalidInputException().toString(),
                }
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          final session = await authService.login(
            email: payload.email!,
            password: payload.password!,
          );

          return Response.ok(
            json.encode({'data': session!.toJson()}),
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

    router.post(
      '/register',
      ((
        Request request,
      ) async {
        try {
          var payload =
              LoginRequest.fromJson(json.decode(await request.readAsString()));

          if (AuthApiValidation.inputNullCheck(payload.password)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {
                  'message': InvalidInputException().toString(),
                }
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          if (AuthApiValidation.inputNullCheck(payload.email) &&
              AuthApiValidation.inputNullCheck(payload.phone)) {
            //Todo: Input Validation Errors
            return Response(
              HttpStatus.badRequest,
              body: json.encode({
                'data': {
                  'message': InvalidInputException().toString(),
                }
              }),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          final session = await authService.register(
            payload.password!,
            email: payload.email ?? '',
            phone: payload.phone ?? '',
          );

          return Response.ok(
            json.encode({'data': session!.toJson()}),
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

    return router;
  }
}

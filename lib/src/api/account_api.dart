import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/errors/accountExceptions.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:perrow_api/src/validators/validation/AuthValidationService.dart';

class UserApi {
  WalletService walletService;

  UserApi({
    required this.walletService,
  });

  Handler get router {
    final router = Router();
    final handler =
        Pipeline().addMiddleware(checkAuthorisation()).addHandler(router);

    router.get(
      '/account',
      ((
        Request request,
      ) async {
        try {
          final authDetails = request.context['authDetails'] as JWT;
          final user = await AuthValidationService.fetchUserAccountDetails(
            id: authDetails.subject.toString(),
          );

          return Response.ok(
            json.encode({
              'data': {'account': user.toJson()}
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

    router.get(
      '/transactions',
      ((
        Request request,
      ) async {
        try {
          final authDetails = request.context['authDetails'] as JWT;
          final transactions = await AccountService.fetchUserTransactions(
            id: authDetails.subject.toString(),
          );

          return Response.ok(
            json.encode({
              'data': {'transactions': transactions}
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        } on TransactionsNotFoundException catch (e) {
          return Response(
            HttpStatus.notFound,
            body: json.encode({
              'data': {'message': e.toString()}
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

    return handler;
  }
}

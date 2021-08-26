import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/errors/account_exceptions.dart';
import 'package:perrow_api/src/models/api/blockchain/transfer_request.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:perrow_api/src/validators/account_responses.dart';
import 'package:perrow_api/src/validators/account_validation.dart';

class WalletApi {
  WalletService walletService;

  WalletApi({
    required this.walletService,
  });

  Handler get router {
    final router = Router();
    final handler =
        Pipeline().addMiddleware(checkAuthorisation()).addHandler(router);

    final _accountService = AccountService();

    router.post(
      '/transfer',
      ((
        Request request,
      ) async {
        try {
          final authDetails = request.context['authDetails'] as JWT;

          final user = await _accountService.findAccountDetails(
            id: authDetails.subject.toString(),
          );

          var data = TransferRequest.fromJson(
              json.decode(await request.readAsString()));

          AccountApiValidation.nullInputValidation(
            recipientid: data.id,
            amount: data.amount,
          );

          if (AccountApiValidation.recipientCheck(data.id!) &&
              !isUUID(data.id)) {
            return Response.forbidden(
              AccountApiResponses.recipientError(),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType
              },
            );
          }

          if (AccountApiValidation.amountCheck(data.amount!)) {
            return Response.forbidden(
              AccountApiResponses.amountError(),
              headers: {
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
              },
            );
          }

          await walletService.initiateTransfer(
            senderid: user.id,
            recipientid: data.id!,
            amount: data.amount!,
          );

          return Response.ok(
            json.encode({
              'data': {
                'message': 'Transaction Pending',
                'balance': user.balance - data.amount!,
                'transaction': data.toJson(),
              }
            }),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        } on AccountNotFoundException catch (e) {
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
          print(e);
          return Response(
            HttpStatus.badRequest,
            body: json.encode({
              'data': {
                'message': 'Provide a valid request refer to documentation'
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
              'data': {'message': '$e'}
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

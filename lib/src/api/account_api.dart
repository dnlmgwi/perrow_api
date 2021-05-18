import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/models/api/blockchain/transferRequest.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:perrow_api/src/validators/account_responses.dart';
import 'package:perrow_api/src/validators/account_validation.dart';
import 'package:perrow_api/src/validators/validation/AuthValidationService.dart';

// import 'package:dart_date/dart_date.dart';
// Account(
//                         id: user.id,
//                         age: user.age,
//                         balance: user.balance,
//                         gender: user.gender,
//                         joinedDate: user.joinedDate,
//                         phoneNumber: user.phoneNumber,
//                         pin: user.pin,
//                         salt: user.salt,
//                         status: user.status,
//                         lastTrans: user.lastTrans)
//                     .toJson()
//                     .addAll({
//                   'last_trans_text': DateTime.fromMillisecondsSinceEpoch(user.lastTrans!)
//                       .toHumanString(),
//                 })

class UserApi {
  AuthService authService;

  WalletService walletService;

  UserApi({
    required this.authService,
    required this.walletService,
  });

  Handler get router {
    final router = Router();
    final handler = Pipeline().addMiddleware(checkAuth()).addHandler(router);

    final _accountService = AccountService();

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
              'data': {'message': e}
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

          if (AccountApiValidation.recipientCheck(data.id!) ||
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
        } on FormatException catch (e) {
          print(e);
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
              'data': {'message': '${e.toString()}'}
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

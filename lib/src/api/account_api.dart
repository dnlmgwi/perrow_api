import 'dart:convert';
import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:perrow_api/src/model/models/api/blockchain/transferRequest.dart';
import 'package:perrow_api/src/service/AuthService.dart';
import 'package:perrow_api/src/service/accountService.dart';
import 'package:perrow_api/src/service/walletServices.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:perrow_api/src/validators/account_responses.dart';
import 'package:perrow_api/src/validators/account_validation.dart';
import 'package:perrow_api/src/validators/validation/AuthValidationService.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:validators/validators.dart';

class AccountApi {
  AuthService authService;

  WalletService walletService;

  AccountApi({
    required this.authService,
    required this.walletService,
  });

  Handler get router {
    final router = Router();
    final handler = Pipeline().addMiddleware(checkAuth()).addHandler(router);

    final _accountService = AccountService();

    router.get(
      '/user',
      ((
        Request request,
      ) async {
        try {
          final authDetails = request.context['authDetails'] as JWT;
          final user = await AuthValidationService.findAccount(
            id: authDetails.subject.toString(),
          );

          return Response.ok(
            json.encode({
              'data': {
                'account': user.toJson(),
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
            HttpStatus.badRequest,
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
          return Response.forbidden(
            json.encode({
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

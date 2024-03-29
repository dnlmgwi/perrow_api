import 'package:perrow_api/src/errors/account_exceptions.dart';
import 'package:perrow_api/packages/perrow_api.dart';

class AccountService {
  Future<TransAccount> findAccountDetails({required String id}) async {
    PostgrestResponse response;
    try {
      response = await DatabaseService.client
          .from('wallet')
          .select(
            'status, balance, id, last_transaction',
          )
          .match({
        'id': id,
      }).execute();
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }

    var result = response.data[0];

    if (result.isEmpty) {
      throw AccountNotFoundException();
    }

    return TransAccount.fromJson(response.data[0]);
  }

  Future<TransAccount> findRecipientDepositAccount(
      {required String phoneNumber}) async {
    PostgrestResponse? response;
    try {
      response = await DatabaseService.client
          .from('wallet')
          .select(
            'status, balance, id, last_transaction',
          )
          .match({
        'phoneNumber': phoneNumber,
      }).execute();
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }

    var result = response!.data as List;

    if (result.isEmpty) {
      throw AccountNotFoundException();
    }

    return TransAccount.fromJson(response.data[0]);
  }

  static Future<List<TransactionRecord>> fetchUserTransactions(
      {required String id, int? paginate}) async {
    //Todo Handling
    var jsonTransactions = <TransactionRecord>[];

    PostgrestResponse? response;

    response = await DatabaseService.client //TODO Login with ID/PhoneNumber
        .from('transaction')
        .select()
        .or('sender.eq.$id,recipient.eq.$id')
        .limit(paginate ??= 10)
        .order('timestamp', ascending: false)
        .execute()
        .catchError(
      (exception, stackTrace) async {
        await Sentry.captureException(
          exception,
          stackTrace: stackTrace,
        );
      },
    );

    var result = response.data as List;

    if (result.isEmpty) {
      throw TransactionsNotFoundException();
    }

    for (var transction in result) {
      jsonTransactions.add(TransactionRecord.fromJson(transction));
    }

    return jsonTransactions;
  }
}

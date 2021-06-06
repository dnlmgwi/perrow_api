import 'package:perrow_api/src/errors/accountExceptions.dart';
import 'package:perrow_api/packages/perrow_api.dart';

class AccountService {
  Future<TransAccount> findAccountDetails({required String id}) async {
    var response;
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
      // await Sentry.captureException(
      //   exception,
      //   stackTrace: stackTrace,
      // );
      //TODO: Handle Errors
      throw Exception(exception);
    }

    var result = response.data as List;

    if (result.isEmpty) {
      throw AccountNotFoundException();
    }

    return TransAccount.fromJson(response.data[0]);
  }

  Future<TransAccount> findRecipientDepositAccount(
      {required String phoneNumber}) async {
    var response;
    try {
      response = await DatabaseService.client
          .from('wallet') //TODO Change Lookup Table
          .select(
            'status, balance, id, last_transaction',
          )
          .match({
        'phoneNumber': phoneNumber,
      }).execute();
    } catch (exception, stackTrace) {
      // await Sentry.captureException(
      //   exception,
      //   stackTrace: stackTrace,
      // ); //TODO Handle Errors
    }

    var result = response.data as List;

    if (result.isEmpty) {
      throw AccountNotFoundException();
    }

    return TransAccount.fromJson(response.data[0]);
  }

  static Future<List<TransactionRecord>> fetchUserTransactions(
      {required String id, int? paginate}) async {
    //Todo Handling
    var jsonTransactions = <TransactionRecord>[];

    var response = await DatabaseService.client //TODO Login with ID/PhoneNumber
        .from('transaction')
        .select()
        .match({
          'sender': id,
        })
        .limit(paginate ??= 10)
        .order('timestamp', ascending: false)
        .execute()
        .onError(
          (error, stackTrace) => throw Exception(error),
        );

    var result = response.data as List;

    if (result.isEmpty) {
      throw TransactionsNotFoundException();
    }

    result.forEach((element) {
      jsonTransactions.add(TransactionRecord.fromJson(element));
    });

    return jsonTransactions;
  }
}

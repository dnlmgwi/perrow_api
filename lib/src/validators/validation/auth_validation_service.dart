import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/packages/services.dart';
import 'package:perrow_api/src/errors/auth_exceptions.dart';

class AuthValidationService {
  static Future<Wallet> fetchUserAccountDetails({
    required int id,
    required String phoneNumber,
  }) async {
    PostgrestResponse response;

    response = await DatabaseService.client //TODO Login with ID/PhoneNumber
        .from('wallet')
        .select()
        .match({
          'id': id,
          'phone_number': phoneNumber,
        })
        .execute()
        .onError(
          (error, stackTrace) => throw Exception(error),
        );

    var result = response.data as List;

    if (result.isEmpty) {
      response = await register(
        id: id,
        phoneNumber: phoneNumber,
      );
    }

    print(response.data[0]);

    return Wallet.fromJson(response.data[0]);
  }

  static Future findDuplicateAccountCredentials({
    required int id,
  }) async {
    try {
      var response = await DatabaseService.client
          .from('wallet')
          .select('id')
          .eq(
            'id',
            id,
          )
          .execute()
          .onError(
            (error, stackTrace) => throw Exception(error),
          );

      if (response.error != null) {
        throw Exception(response.error!);
      }

      var result = response.data as List;

      if (result.isNotEmpty) {
        throw AccountDuplicationFoundException();
      }
    } on PostgrestError catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        hint: stackTrace,
      );
      rethrow;
    }
  }

  static Future<bool> isDuplicatedAccount({
    required int id,
  }) async {
    var duplicateAccount = false;
    try {
      //TODO Refactor this Method
      //If an exception is thrown return true
      await findDuplicateAccountCredentials(
        id: id,
      );
    } catch (e) {
      // If account is found return Duplicate account is true and thrown error message.
      duplicateAccount = !duplicateAccount; //Should evaluate to true
      rethrow;
    }
    return duplicateAccount;
  }

  static Future register({
    required int id,
    required String phoneNumber,
  }) async {
    try {
      var response = PostgrestResponse();
      var isDuplicate = await AuthValidationService.isDuplicatedAccount(
        id: id,
      );
      if (!isDuplicate) {
        response = await DatabaseService.client
            .from('wallet')
            .insert(Wallet(
              id: id,
              phoneNumber: phoneNumber,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              status: 'normal',
              balance: int.parse(Env.newAccountBalance!),
              joinedDate: DateTime.now(),
            ).toJson())
            .execute()
            .catchError(
          (exception, stackTrace) async {
            await Sentry.captureException(
              exception,
              stackTrace: stackTrace,
            );
          },
        );
      }
      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      print(response.data); //TODO Notify User Once Account Is Created

      return response;
    } on PostgrestError catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:perrow_api/src/errors/accountExceptions.dart';
import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:perrow_api/src/validators/validation/AuthValidationService.dart';
import 'package:perrow_api/src/config.dart';
import 'package:postgrest/postgrest.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  TokenService tokenService;

  AuthService({required this.tokenService});

  Future register({
    required String pin,
    required String gender,
    required int age,
    required String phoneNumber,
  }) async {
    final salt = generateSalt();

    final hashpin = hashPin(
      pin: pin,
      salt: salt,
    );

    try {
      var response;
      var isDuplicate = await AuthValidationService.isDuplicatedAccount(
        phoneNumber: phoneNumber,
      );

      if (!isDuplicate) {
        response = await DatabaseService.client
            .from('beneficiary_accounts')
            .insert(Account(
              id: Uuid().v4(),
              age: age,
              gender: gender,
              phoneNumber: phoneNumber,
              pin: hashpin,
              salt: salt,
              status: 'normal',
              balance: int.parse(Env.newAccountBalance!),
              joinedDate: DateTime.now().millisecondsSinceEpoch,
            ).toJson())
            .execute()
            .catchError(
          (exception, stackTrace) async {
            // await Sentry.captureException(
            //   exception,
            //   stackTrace: stackTrace,
            // );
            //TODO Handle Errors
          },
        ); //TODO Muliple Fails Alert People In Area.
      }

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      print(response.data); //TODO Notify User Once Account Is Created

      return response.data; //TODO Should it return this data?

    } on PostgrestError catch (exception, stackTrace) {
      // await Sentry.captureException(
      //   exception,
      //   stackTrace: stackTrace,
      //   hint: stackTrace,
      // );
      //TODO Handle Erros
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<TokenPair> login({
    required String pin,
    required String id,
  }) async {
    Account user;
    TokenPair tokenPair;

    try {
      user = await AuthValidationService.fetchUserAccountDetails(
        id: id,
      ); //TODO Login with ID or PIN

      final hashpin = hashPin(
        pin: pin,
        salt: user.salt,
      );

      if (hashpin != user.pin) {
        throw IncorrectInputException();
      }

      tokenPair = await tokenService.createTokenPair(userId: user.id);
    } catch (e) {
      rethrow;
    }

    return tokenPair;
  }
}

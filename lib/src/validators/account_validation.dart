import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/src/errors/account_exceptions.dart';

class AccountApiValidation {
  //Check if the correct Keys Where Provided in the request if null prompt the user on what to provide.
  static void nullInputValidation(
      {required recipientid, required amount, required currency}) {
    if (!isUUID(recipientid) ||
        recipientid.toString().isEmpty ||
        recipientid == null) {
      //If Body Doesn't container id & amount key
      throw InvalidUserIDException();
    } else if (amount.toString().isEmpty || amount == null) {
      throw InvalidAmountException();
    } else if (currency.toString().isEmpty || currency.toString().length != 3) {
      throw InvalidCurrencyException();
    }
  }

  //Is Amount > Min Amount
  static bool amountCheck(int amount) {
    return amount <
        int.parse(
          Env.minTransactionAmount!,
        );
  }

  //Is Recipient Provided
  static bool recipientCheck(String data) => data == '' || data.isEmpty;

  static bool phoneNumberCheck(String data) => data == '' || data.isEmpty;
}

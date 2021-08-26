import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/src/errors/account_exceptions.dart';

class AccountApiValidation {
  //Check if the correct Keys Where Provided in the request if null prompt the user on what to provide.
  static void nullInputValidation({required recipientid, required amount}) {
    if (recipientid == null) {
      //If Body Doesn't container id & amount key
      throw InvalidUserIDException();
    } else if (amount == null) {
      throw InvalidAmountException();
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
}

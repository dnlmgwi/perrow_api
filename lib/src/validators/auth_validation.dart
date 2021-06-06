import 'package:validators/validators.dart';

class AuthApiValidation {
  /// Is Valid PhoneNumber Provided
  static bool phoneNumberCheck(phoneNumber) {
    var isphoneNumberRegEx =
        RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$');
    return phoneNumber == null ||
        phoneNumber == '' ||
        !isphoneNumberRegEx.hasMatch(phoneNumber);
  }

  /// Is Valid gender Provided
  static bool ageCheck(age) => age == null || age == '';

  static bool inputNullCheck(input) => input == null || input == '';

  /// Is Strong Pin Provided
  /// 4-6 Digits Long
  static bool pinCheck(pin) {
    //4-6 Digit Pin
    var isPINRegExp = RegExp(r'^\d{4}$|^\d{6}$');
    return pin == null || pin == '' || !isPINRegExp.hasMatch(pin);
  }

  //Is Valid UUID
  static bool uuidCheck(uuid) {
    return uuid == null || uuid == '' || !isUUID(uuid);
  }

  /// Is Valid Input Provided
  static bool genderCheck(gender) => gender == null || gender == '';
}

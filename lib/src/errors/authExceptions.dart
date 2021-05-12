class InvalidPinException implements Exception {
  ///This Exception is thrown when there is an invalid Input Entered in the DB
  late String _message;

  InvalidPinException(
      [String message = 'Please provide a valid PIN Code 4/6 Digits Long']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}

class InvalidPhoneNumberException implements Exception {
  ///This Exception is thrown when there is an invalid Input Entered in the DB
  late String _message;

  InvalidPhoneNumberException(
      [String message = 'Please provide a valid Input']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}

class UnauthorisedException implements Exception {
  ///This Exception is thrown when there is an excisting account in the DB
  late String _message;

  UnauthorisedException(
      [String message = 'Not authorised to perform this request']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}

class AccountDuplicationFoundException implements Exception {
  ///This Exception is thrown when there is an excisting account in the DB
  late String _message;

  AccountDuplicationFoundException(
      [String message = 'Please, login Instead.']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}

class RegisteredCredentialsException implements Exception {
  ///This Exception is thrown when there is an excisting account in the DB
  late String _message;

  RegisteredCredentialsException(
      [String message = 'These Details are Registered, Login instead']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}

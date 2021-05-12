import 'dart:convert';
import 'package:perrow_api/src/config.dart';

class AccountApiResponses {
  //No Recipient Provided
  static String recipientError() {
    return json.encode({
      'data': {
        'message': 'Please Provide Recipient id',
      }
    });
  }

  //No Amount Provided
  static String amountError() {
    return json.encode({
      'data': {
        'message':
            'Please include valid amount Greater Than P${Env.minTransactionAmount}',
      }
    });
  }
}

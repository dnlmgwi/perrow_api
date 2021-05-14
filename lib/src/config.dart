import 'package:dotenv/dotenv.dart';

class Env {
  /// Server Side
  static final hostName = '0.0.0.0';

  ///DO NOT TOUCH

  ///Crash Analytics
  static final sentry = env['SENTRY'];

  /// API System Address
  static final systemAddress = env['SYSTEM_ADDRESS'];

  /// Redis Cache Details PORT
  static final redisPort = env['REDIS_PORT'];

  /// Redis Cache Details Hostname
  static final redisHostname = env['REDIS_HOSTNAME'];

  /// Redis Cache Details Password
  static final redisPassword = env['REDIS_PASSWORD'];

  ///PubNub Credentials

  static final pnSubscribeKey = env['PUBNUB_SUBSCRIBE_KEY'];

  static final pnPublishKey = env['PUBNUB_PUBLISH_KEY'];

  ///Database URL
  static final supabaseUrl = env['SUPABASE_URL'];

  ///Database Key
  static final supabaseKey = env['SUPABASE_KEY'];

  ///JWT Auth Secret
  static final secret = env['SECRET'];

  ///JWT Auth Issuer
  static final issuer = env['ISSUER'];

  ///JWT Auth Subject
  static final subject = env['SUBJECT'];

  ///JWT Auth Max Age
  static final maxAge = env['MAX_AGE'];

  ///JWT Auth TYP
  static final typ = env['TYP'];

  ///Api Economy Minimum Transaction Amount
  static final minTransactionAmount = env['MIN_TRANSACTION_AMOUNT'];

  ///Api Economy Minimum Block Difficulty
  static final difficulty = env['DIFFICULTY'];

  ///Api Economy Registered Account Opening Balance
  static final newAccountBalance = env['NEW_ACCOUNT_BALANCE'];
}

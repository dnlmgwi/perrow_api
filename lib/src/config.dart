import 'package:dotenv/dotenv.dart';

class Env {
  /// Server Side
  /// DO NOT TOUCH
  static final hostName = env['HOST_NAME'];

  ///Crash Analytics
  static final sentry = env['SENTRY'];

  //Cookie Secret Keys
  static final cookieKey = env['COOKIE_KEY'];

  /// API System Address
  static final systemAddress = env['SYSTEM_ADDRESS'];

  /// Redis Cache Details PORT
  static final redisPort = env['REDIS_PORT'];

  static final africasTalking = env['AFRICAS_TALKING'];

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

  ///Mail Server
  static final mailHost = env['MAIL_HOST'];
  static final mailFromAddress = env['MAIL_FROM_ADDRESS'];
  static final mailFromName = env['MAIL_FROM_NAME'];
  static final mailUsername = env['MAIL_USERNAME'];
  static final mailPassword = env['MAIL_PASSWORD'];
  static final mailPort = env['MAIL_PORT'];

  ///Twilio Api
  static final twilioFrom = env['TWILIO_FROM'];
  static final twilioCred = env['CRED'];
  static final twilioAccountSid = env['ACCOUNT_SID'];
  static final twilioTo = env['TWILIO_TO'];

  ///MailJet
  static final mailjetUser = env['MAIL_JET_USER'];
  static final mailjetKey = env['MAIL_JET_KEY'];
}

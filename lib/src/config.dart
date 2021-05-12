import 'package:dotenv/dotenv.dart';

class Env {
  /// Server Side
  static final hostName = '0.0.0.0'; //DO NOT TOUCH

  static final sentry = env['SENTRY'];

  /// API System Address
  static final systemAddress = env['SYSTEM_ADDRESS'];

  /// Redis Cache
  static final redisPort = env['REDIS_PORT'];
  static final redisHostname = env['REDIS_HOSTNAME'];
  static final redisPassword = env['REDIS_PASSWORD'];

  ///Database
  static final supabaseUrl = env['SUPABASE_URL'];
  static final supabaseKey = env['SUPABASE_KEY'];

  ///JWT AuthValues
  static final secret = env['SECRET'];
  static final issuer = env['ISSUER'];
  static final subject = env['SUBJECT'];
  static final maxAge = env['MAX_AGE'];
  static final typ = env['TYP'];

  ///Api Economy
  static final minTransactionAmount = env['MIN_TRANSACTION_AMOUNT'];
  static final difficulty = env['DIFFICULTY'];
  static final newAccountBalance = env['NEW_ACCOUNT_BALANCE'];
}

import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:redis_dart/redis_dart.dart';
import 'package:uuid/uuid.dart';

class TokenService {
  late RedisClient client;

  final String _prefix = 'token';
  final refreshTokenExpiry = Duration(
    days: 2,
  ); //TODO: 2 Days is best practice? Add To Env

  Future<void> start() async {
    client = await RedisClient.connect(
      Env.redisHostname!,
      int.parse(
        Env.redisPort!,
      ),
    );
  }

  Future<TokenPair> createTokenPair({required String? userId}) async {
    final tokenId = Uuid().v4();

    final token = generateJWT(
      subject: userId,
      issuer: Env.hostName!,
      secret: Env.secret!,
      jwtId: tokenId,
      expiry: Duration(minutes: 5), //TODO 15min
    );

    final refreshToken = generateJWT(
      subject: userId,
      issuer: Env.hostName!,
      secret: Env.secret!,
      jwtId: Uuid().v4(),
      expiry: refreshTokenExpiry,
    );

    await addRefreshToken(
      id: tokenId,
      token: refreshToken,
      expiry: refreshTokenExpiry,
    );

    return TokenPair(token: token, refreshToken: refreshToken);
  }

  Future<void> addRefreshToken({
    required String id,
    required String token,
    required Duration expiry,
  }) async {
    await client.set('$_prefix: $id', token);
    await client.expire(
      '$_prefix: $id',
      Duration(
        hours: expiry.inSeconds,
      ),
    );
  }

  Future<dynamic> getRefreshToken(String? id) async {
    return await client.get('$_prefix: $id');
  }

  Future<void> removeRefreshToken(String? id) async {
    await client.expireAt(
        '$_prefix: $id', DateTime.now()); //TODO Token Not Being Removed?
  }
}

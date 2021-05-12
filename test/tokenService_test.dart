import 'package:dotenv/dotenv.dart';
import 'package:perrow_api/src/service/token_service.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() async {
  setUp(() async {
    ///Load Env Variables
    load();
  });

  final tokenService = TokenService();

  group('Token Service', () {
    test('Start Token Service', () async {
      expect(tokenService.start(), isNotNull);
    });

    test('Get Refresh Token Pair', () async {
      await tokenService.start();
      expect(tokenService.getRefreshToken('uuid'), isNotNull);
    });

    test('Remove Token Pair', () async {
      await tokenService.start();
      expect(tokenService.removeRefreshToken('uuid'), isNotNull);
    });
  });
}

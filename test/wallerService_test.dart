import 'package:dotenv/dotenv.dart';
import 'package:perrow_api/packages/services.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:mockito/annotations.dart';
import 'wallerService_test.mocks.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateMocks([WalletService])
void main() async {
  setUp(() async {
    ///Load Env Variables
    load();
  });

  final walletService = MockWalletService();

  group('Wallet Service', () {
    test(
      'Check Account Status',
      () async => expect(
        await walletService.accountStatusCheck(''),
        true,
      ),
    );
  });
}

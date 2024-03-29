import 'package:perrow_api/packages/perrow_api.dart';

class AutomatedTasks {
  WalletService walletService;
  BlockchainService blockchainService;

  AutomatedTasks({
    required this.blockchainService,
    required this.walletService,
  });

  /// Listerning to Internal Hive for Changes
  Future<void> startAutomatedTasks() async {
    var transStream = walletService.pendingTransactions.watch();
    var depositStream = walletService.pendingDepositsTansactions.watch();
    transStream.listen((event) async {
      final deb = Debouncing(
        duration: const Duration(seconds: 5),
      ); //TODO Default 30s
      await deb.debounce(() async {
        if (walletService.pendingTransactions.isNotEmpty) {
          await _processPendingPayments();
        }
      });
    });

    depositStream.listen((event) async {
      final deb =
          Debouncing(duration: const Duration(seconds: 5)); //TODO Default 5
      await deb.debounce(() async {
        if (walletService.pendingDepositsTansactions.isEmpty) {
          await _getUnclaimedDeposits();
        }
      });
    });
  }

  Future<void> _processPendingPayments() async {
    print('payments?');
    try {
      await blockchainService.mine();
      print('Processing Payments');
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _getUnclaimedDeposits() async {
    try {
      var response = await DatabaseService.client
          .from('recharge_notifications')
          .select()
          .match({
            'claimed': false,
          })
          .execute()
          .catchError(
            (exception, stackTrace) async {
              await Sentry.captureException(
                exception,
                stackTrace: stackTrace,
              );
            },
          );

      if (response.data == null) {
        //TODO Review
      } else {
        if ((response.data as List).isNotEmpty) {
          print('Found something');
          for (var item in response.data as List) {
            await walletService.pendingDepositsTansactions
                .add(RechargeNotification.fromJson(item));
          }
        }
      }
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      //Todo handle Erros
      rethrow;
    }
  }
}

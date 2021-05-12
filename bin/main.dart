import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:hive/hive.dart';
import 'package:pedantic/pedantic.dart';
import 'package:perrow_api/src/api/account_api.dart';
import 'package:perrow_api/src/api/auth_api.dart';
import 'package:perrow_api/src/api/blockchain_api.dart';
import 'package:perrow_api/src/api/status_api.dart';
import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/src/model/models/hive/0.transactionRecord/transactionRecord.dart';
import 'package:perrow_api/src/model/models/hive/1.rechargeNotification/rechargeNotification.dart';
import 'package:perrow_api/src/service/AuthService.dart';
import 'package:perrow_api/src/service/accountService.dart';
import 'package:perrow_api/src/service/automatedTasks.dart';
import 'package:perrow_api/src/service/blockchainService.dart';
import 'package:perrow_api/src/service/mineService.dart';
import 'package:perrow_api/src/service/token_service.dart';
import 'package:perrow_api/src/service/walletServices.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf/shelf.dart';

void main(List<String> args) async {
  ///Load Env Variables
  load();

  Hive.init('./storage');
  Hive.registerAdapter(TransactionRecordAdapter());
  Hive.registerAdapter(RechargeNotificationAdapter());
  await Hive.openBox<TransactionRecord>('transactions');
  await Hive.openBox<RechargeNotification>('rechargeNotifications');

  /// Start Redis Token Service
  final tokenService = TokenService();
  await tokenService.start();

  final accountService = AccountService();

  final walletService = WalletService(accountService: accountService);

  final authService = AuthService();

  final blockchainService = BlockchainService(
    walletService: walletService,
  );

  final miner = MineServices(
    blockchain: blockchainService,
  );

  final automatedTasks = AutomatedTasks(
    miner: miner,
    walletService: walletService,
  );

  // final statsService = StatisticsService();

  //Automated Tasks
  unawaited(automatedTasks.startAutomatedTasks());

  /// Shelf Router
  var app = Router();

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addMiddleware(handleAuth(
        secret: Env.secret!,
      ))
      .addHandler(app);

  app.mount(
    '/api/v1/',
    StatusApi().router,
  );

  // app.mount(
  //   '/api/v1/stats/',
  //   StatusApi(statsService: statsService).router,
  // );

  // app.mount(
  //   '/api/v1/sync/',
  //   OfflineSyncApi(
  //     offlineScans: offlineScans,
  //     offlineTransactions: offlineTransactions,
  //   ).router,
  // );

  app.mount(
    '/api/v1/auth/',
    AuthApi(
      secret: Env.secret!,
      tokenService: tokenService,
    ).router,
  );

  app.mount(
    '/api/v1/blockchain/',
    BlockChainApi(
      blockchainService: blockchainService,
    ).router,
  );

  app.mount(
    '/api/v1/account/',
    AccountApi(
      authService: authService,
      walletService: walletService,
    ).router,
  );

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);

  var server = await shelf_io.serve(handler, '0.0.0.0', port);
  server.autoCompress;
  print('Serving at http://${server.address.host}:${server.port}');
}

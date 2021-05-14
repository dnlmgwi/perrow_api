import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:hive/hive.dart';
import 'package:pedantic/pedantic.dart';
import 'package:perrow_api/src/api/account_api.dart';
import 'package:perrow_api/src/api/auth_api.dart';
import 'package:perrow_api/src/api/blockchain_api.dart';
import 'package:perrow_api/src/api/status_api.dart';
import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/src/model/hive/0.transactionRecord/transactionRecord.dart';
import 'package:perrow_api/src/model/hive/1.rechargeNotification/rechargeNotification.dart';
import 'package:perrow_api/src/services/api_services.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main(List<String> args) async {
  ///Load Env Variables
  load();
  Hive.init('./storage');
  Hive.registerAdapter(TransactionRecordAdapter());
  Hive.registerAdapter(RechargeNotificationAdapter());
  await Hive.openBox<TransactionRecord>('transactions');
  await Hive.openBox<RechargeNotification>('rechargeNotifications');

  ///
  await tokenService.start();

  /// Automated Tasks
  /// Unwaited future as it continously
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
    '/v1/info/',
    StatusApi().router,
  );

  app.mount(
    '/v1/auth/',
    AuthApi(
      secret: Env.secret!,
      tokenService: tokenService,
      authService: authService,
    ).router,
  );

  app.mount(
    '/v1/blockchain/',
    BlockChainApi(
      blockchainService: blockchainService,
    ).router,
  );

  app.mount(
    '/v1/user/',
    UserApi(
      authService: authService,
      walletService: walletService,
    ).router,
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

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9999 : int.parse(portEnv);

  var server = await shelf_io.serve(handler, '127.0.0.1', port);

  print('Serving at http://${server.address.host}:${server.port}');
}

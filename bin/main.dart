import 'package:pedantic/pedantic.dart';
import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/api/auth_api.dart';
import 'package:perrow_api/src/api/wallet_api.dart';
import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:sentry/sentry.dart';
// import 'package:retry/retry.dart';
// import 'package:shelf_secure_cookie/shelf_secure_cookie.dart';

void main(List<String> args) async {
  /// Load Env Variables
  load();

  //Sentry Crash Anaytics
  await Sentry.init((options) => options.dsn = Env.sentry);

  /// Load Internal Stores
  Hive.init('./storage');
  Hive.registerAdapter(TransactionRecordAdapter());
  Hive.registerAdapter(RechargeNotificationAdapter());

  await Hive.openBox<TransactionRecord>('transactions');
  await Hive.openBox<RechargeNotification>('rechargeNotifications');

  /// Start Token Service

  // await retry(
  //   // Make a GET request
  //   () => tokenService.start(),
  //   // Retry on SocketException or TimeoutException
  //   retryIf: (e) => e is SocketException || e is TimeoutException,
  //   onRetry: (e) {
  //     //Todo: Notify Service Provider
  //     //Todo: Start the servie again
  //   },
  // ).onError((error, stackTrace) {
  //   //Todo Notify Redis Service is down
  //   print(error);
  //   print(stackTrace);
  // });

  try {
    /// Automated Tasks
    /// Unwaited future as it continously running
    unawaited(automatedTasks.startAutomatedTasks());
  } catch (e) {
    print(e);
  }

  /// Shelf Router
  var app = Router();

  // optionally override default headers
  final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_ORIGIN: '*',
    'Content-Type': 'application/json;charset=utf-8'
  };

  var handler = Pipeline()
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      // .addMiddleware(cookieParser(Env.cookieKey!))
      // .addMiddleware(handleSession())
      .addMiddleware(logRequests())
      .addMiddleware(handleAuth(
        secret: Env.secret!,
      ))
      .addHandler(app);

  app.mount(
    '/v1/info/',
    StatusApi().router,
  );

  // app.mount(
  //   '/v1/auth/',
  //   AuthApi(
  //     secret: Env.secret!,
  //     tokenService: tokenService,
  //     authService: authService,
  //   ).router,
  // );

  app.mount(
    '/v1/auth/',
    AuthApi(
      secret: Env.secret!,
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
      walletService: walletService,
    ).router,
  );

  app.mount(
    '/v1/wallet/',
    WalletApi(
      walletService: walletService,
    ).router,
  );

  // app.mount(
  //   '/api/v1/sync/',
  //   OfflineSyncApi(
  //     offlineScans: offlineScans,
  //     offlineTransactions: offlineTransactions,
  //   ).router,
  // );

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 8989 : int.parse(portEnv);

  try {
    ///TODO: Change IP On Platform
    ///Windows Run ipconfig
    /// Mac 127.0.0.1
    /// default for Cloud 0.0.0.0
    var server = await serve(
      handler,
      Env.hostName,
      port,
    );

    // Enable content compression
    server.autoCompress = true;

    print('Serving at http://${server.address.host}:${server.port}');
  } catch (exception, stackTrace) {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
}

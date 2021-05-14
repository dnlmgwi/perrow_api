

import 'package:perrow_api/packages/perrow_api.dart';

/// Start Redis Token Service
final tokenService = TokenService();
final notificationService = NotificationService();

/// User Account managments
final accountService = AccountService();

/// User Wallet Service
final walletService = WalletService(
    accountService: accountService, notificationService: notificationService);

/// User Authentication Service
/// Login
/// Register
/// Logout [Pending]
/// Reset Passowrd [Unimplemented]
final authService = AuthService(tokenService: tokenService);

/// Blockchain Services
final blockchainService = BlockchainService(
  walletService: walletService,
);

//Automated Payment and Deposit Processing
final automatedTasks = AutomatedTasks(
  walletService: walletService,
  blockchainService: blockchainService,
);

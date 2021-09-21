

import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/services/auth/auth_service.dart';

/// Start Redis Token Service
// final tokenService = TokenService();
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

final authService = AuthService();

/// Blockchain Services
final blockchainService = BlockchainService(
  walletService: walletService,
);

//Automated Payment and Deposit Processing
final automatedTasks = AutomatedTasks(
  walletService: walletService,
  blockchainService: blockchainService,
);

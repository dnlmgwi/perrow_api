import 'package:perrow_api/src/services/services_packages.dart';

/// Start Redis Token Service
final tokenService = TokenService();

/// User Account managments
final accountService = AccountService();

/// User Wallet Service
final walletService = WalletService(accountService: accountService);

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

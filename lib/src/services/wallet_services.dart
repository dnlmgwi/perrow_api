import 'package:perrow_api/packages/perrow_api.dart';
import 'package:hive/hive.dart';
import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/src/errors/account_exceptions.dart';

import 'package:perrow_api/packages/services.dart';
import 'package:perrow_api/src/validators/enum_values.dart';
import 'package:postgrest/postgrest.dart';
import 'package:uuid/uuid.dart';

class WalletService {
  AccountService accountService;
  // NotificationService notificationService;

  WalletService({
    required this.accountService,
    // required this.notificationService,
  });

  var pendingTransactions = Hive.box<TransactionRecord>('transactions');
  var pendingDepositsTansactions =
      Hive.box<RechargeNotification>('rechargeNotifications');

  Future<void> processPayments(Block prevBlock, String id) async {
    try {
      if (prevBlock.timestamp.isBefore(DateTime.now())) {
        for (var transaction in pendingTransactions.values) {
          switch (transaction.transType) {
            case 0:
              await withdrawProcess(transaction);
              break;
            case 1:
              await depositProcess(transaction);
              break;

            case 2:
              await transferProcess(transaction);
              break;
          }
          try {
            await DatabaseService.client
                .from('transaction')
                .insert(TransactionRecord(
                  sender: transaction.sender,
                  recipient: transaction.recipient,
                  amount: transaction.amount,
                  timestamp: transaction.timestamp,
                  transId: transaction.transId,
                  transType: transaction.transType,
                  currency: transaction.currency,
                  blockId: id,
                ).toJson()) //TODO on Error Return Account to Normal
                .execute()
                .then((response) async {
              if (response.error != null) {
                throw Exception(response.error!.message);
              }
              // await notificationService.sendNotification(transaction,
              //     response); //TODO Enable Only When in Development Env.
            }).whenComplete(
              //Every Transaction is Proccessed and Removed from the List
              () => transaction.delete(),
            );
          } catch (exception, stackTrace) {
            await Sentry.captureException(
              exception,
              stackTrace: stackTrace,
              hint: transaction.toJson(),
            );
          }
        }
      }
    } on PostgrestError catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        hint: stackTrace,
      );
      rethrow;
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> depositProcess(TransactionRecord element) async {
    try {
      var foundAccount = await accountService.findAccountDetails(
        id: int.parse(element.recipient),
      );

      await editAccountBalance(
          senderAccount: foundAccount,
          value: element.amount,
          transactionType: element.transType);
      await changeAccountStatusNormal(foundAccount.id!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> withdrawProcess(TransactionRecord element) async {
    try {
      var foundAccount = await accountService.findAccountDetails(
          id: int.parse(element.sender));

      await editAccountBalance(
          senderAccount: foundAccount,
          value: element.amount,
          transactionType: element.transType);
      await changeAccountStatusNormal(foundAccount.id!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> transferProcess(TransactionRecord element) async {
    try {
      var recipientAccount = await accountService.findAccountDetails(
        id: int.parse(element.recipient),
      );

      var senderAccount = await accountService.findAccountDetails(
        id: int.parse(element.sender),
      );

      /// Edit User Account Balance
      /// String id - User Perrow API id
      /// String value - Transaction Value
      /// String transactionType - 0: Withdraw, 1: Deposit
      ///
      await editAccountBalance(
        senderAccount: senderAccount,
        recipientAccount: recipientAccount,
        value: element.amount,
        transactionType: element.transType,
      );
      await changeAccountStatusNormal(senderAccount.id!);
    } catch (e) {
      rethrow;
    }
  }

  Future editAccountBalance({
    required TransAccount senderAccount,
    TransAccount? recipientAccount,
    required int value,
    required int transactionType,
  }) async {
    try {
      switch (transactionType) {
        case 0:
          await withdraw(
            account: senderAccount,
            value: value,
          );

          break;
        case 1:
          await deposit(
            account: senderAccount,
            value: value,
          );
          break;
        case 2:
          await transfer(
            value: value,
            senderAccount: senderAccount,
            recipientAccount: recipientAccount!,
          );
          break;
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<TransAccount> deposit({
    required int value,
    required TransAccount account,
  }) async {
    PostgrestResponse response;
    try {
      response = await DatabaseService.client
          .from('wallet')
          .update({'balance': account.balance + value})
          .eq('id', account.id)
          .execute();
      return TransAccount.fromJson(response.data[0]);
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> transfer({
    required int value,
    required TransAccount senderAccount,
    required TransAccount recipientAccount,
  }) async {
    try {
      await DatabaseService.client
          .from('wallet')
          .update({
            'balance': senderAccount.balance - value,
          })
          .eq('id', senderAccount.id)
          .execute()
          .then((_) => DatabaseService.client
              .from('wallet')
              .update({
                'balance': recipientAccount.balance + value,
                'last_transaction': DateTime.now().millisecondsSinceEpoch
              })
              .eq('id', recipientAccount.id)
              .execute());
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> withdraw({
    required int value,
    required TransAccount account,
  }) async {
    //TODO: External Provider Withdraw Provider Needed
    try {
      if (value > account.balance) {
        throw InsufficientFundsException();
      } else if (value < int.parse(Env.minTransactionAmount!)) {
        throw InvalidInputException();
      } else {
        await DatabaseService.client
            .from('wallet')
            .update({
              'balance': account.balance - value,
            })
            .eq('id', account.id)
            .execute();
      }
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> checkAccountBalance({
    required int value,
    required TransAccount account,
  }) async {
    try {
      if (await accountStatusCheck(account.id!)) {
        if (value > account.balance) {
          throw InsufficientFundsException();
        } else if (value < int.parse(Env.minTransactionAmount!)) {
          throw InvalidInputException();
        }
      } else {
        PendingTransactionException();
      }
    } catch (e) {
      rethrow;
    }

    // return account.balance;
  }

  Future<void> initiateTopUp({required Box<RechargeNotification> data}) async {
    try {
      //Check if TransID and Amount match the recieved notification.
      print('Total Items: ${data.values.length}');

      for (var item in data.values) {
        await accountService
            .findRecipientDepositAccount(phoneNumber: item.phoneNumber)
            .then((account) => addToPendingDeposit(
                  item.transID,
                  account.id!.toString(),
                  extractMKAmount(item),
                  item.currency,
                )
                    .then((_) => changeClaimToTrue(item.transID))
                    .then((_) => changeAccountStatusToProcessing(account.id!))
                    .then((_) => item.delete()));
      }
    } catch (e) {
      rethrow;
    }
  }

  int extractMKAmount(RechargeNotification item) =>
      int.parse(item.amount.toString().split('MK').last);

  Future<String> initiateTransfer(
      {required int senderid,
      required int recipientid,
      required int amount,
      required String currency}) async {
    var transId = Uuid().v4();
    if (senderid == recipientid) {
      //Prevents User from Sending Points To Self Compounding Account Balance.
      throw SelfTransferException();
    }
    //Check if the sender & recipient are in the system
    if (await recipientValidation(recipientid.toString())) {
      try {
        await checkAccountBalance(
            value: amount,
            account: await accountService.findAccountDetails(
              id: senderid,
            ));
      } catch (exception, stackTrace) {
        await Sentry.captureException(
          exception,
          stackTrace: stackTrace,
        );
        rethrow;
      }

      if (await accountStatusCheck(
        senderid,
      )) {
        addToPendingTransfer(senderid.toString(), recipientid.toString(),
            amount, currency, transId);

        await changeAccountStatusToProcessing(
          senderid,
        );
      } else {
        throw PendingTransactionException();
      }
    }
    return transId;
  }

  Future addToPendingDeposit(
    String sender,
    String recipient,
    int amount,
    String currency,
  ) async {
    /// Edit User Account Balance
    /// String id - User Perrow API id
    /// String value - Transaction Value
    /// String transactionType - 0: Withdraw, 1: Deposit
    await pendingTransactions.add(TransactionRecord(
      sender: sender,
      recipient: recipient,
      amount: amount,
      currency: currency,
      timestamp: DateTime.now(),
      transId: Uuid().v4(),
      transType: TransactionType.deposit.index,
    ));
  }

  void addToPendingWithDraw(
    String sender,
    String recipient,
    int amount,
    String transId,
  ) async {
    /// Edit User Account Balance
    /// String id - User Perrow API id
    /// String value - Transaction Value
    /// String [transactionType] - 0: Withdraw, 1: Deposit, 2: Transfer
    await pendingTransactions.add(TransactionRecord(
      sender: sender,
      recipient: recipient,
      amount: amount,
      currency: 'MWK',
      timestamp: DateTime.now(),
      transId: transId,
      transType: TransactionType.withdraw.index,
    ));
  }

  void addToPendingTransfer(
    String sender,
    String recipient,
    int amount,
    String currency,
    String transId,
  ) async {
    //Allows users to transfer points between each other
    /// String transactionType - 0: Withdraw, 1: Deposit, 2: Transfer
    await pendingTransactions.add(TransactionRecord(
      sender: sender,
      recipient: recipient,
      amount: amount,
      currency: currency,
      timestamp: DateTime.now(),
      transId: transId,
      transType: TransactionType
          .transfer.index, //TODO: Change 0 and 1 to Deposit and Withdaw;
    ));
  }

  Future<bool> accountStatusCheck(
    int sender,
  ) async {
    var foundAccount = await accountService.findAccountDetails(
      id: sender,
    );
    return foundAccount.status == 'normal';
  }

  Future<bool> recipientValidation(
    String recipient,
  ) async {
    //Validates the reciepeinet of the reward has an account the system
    bool accountValid;

    try {
      var recipientAccount = await accountService.findAccountDetails(
        id: int.parse(recipient),
      );

      //TODO: If Recent Transaction was made throw please wait x minutes

      if (recipientAccount.id!.toString().isNotEmpty) {
        //if the Account Server return an account it is a valid account
        accountValid = true;
      } else {
        //the Accout is not Valid
        accountValid = false;
      }

      return accountValid;
    } on RecentTransException catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeAccountStatusToProcessing(
    int id,
  ) async {
    //Changes the Users Account Status to processing.
    try {
      await DatabaseService.client
          .from('wallet')
          .update({
            'status': 'processing',
            'last_transaction': DateTime.now().millisecondsSinceEpoch
          })
          .eq('id', id)
          .execute();
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> changeClaimToTrue(
    String transID,
  ) async {
    await DatabaseService.client
        .from('recharge_notifications')
        .update({'claimed': true})
        .eq('trans_id', transID)
        .execute()
        .catchError(
          (exception, stackTrace) async {
            await Sentry.captureException(
              exception,
              stackTrace: stackTrace,
            );
          },
        );
  }

  Future<void> changeAccountStatusNormal(
    int id,
  ) async {
    //Changes the Users Account Status to normal.
    try {
      await DatabaseService.client
          .from('wallet')
          .update({'status': 'normal'})
          .eq('id', id)
          .execute()
          .catchError(
            (exception, stackTrace) async {
              await Sentry.captureException(
                exception,
                stackTrace: stackTrace,
              );
            },
          );
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

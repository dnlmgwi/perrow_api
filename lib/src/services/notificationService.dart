import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/packages/perrow_api.dart';

class NotificationService {
  /// Send Nofication
  Future sendNotification(
    TransactionRecord transaction,
    PostgrestResponse response,
  ) async {
    switch (transaction.transType) {
      case 0:
        UnimplementedError(); //TODO
        // await notificationService.withdrawNotification(value);
        break;
      case 1:
        UnimplementedError(); //TODO
        // await notificationService.depositNotification(value);
        break;

      case 2:
        await transferNotification(response);

        break;
    }
  }

  /// Notify the Sender and The Reciver of this transaction
  Future<void> transferNotification(PostgrestResponse value) async {
    /// Notify Sender
    await paymentProcessed(
      id: TransactionRecord.fromJson(value.data[0]).sender,
      message: {
        'message': 'Transfer Complete',
        'recipient': TransactionRecord.fromJson(value.data[0]).recipient,
        'amount': TransactionRecord.fromJson(value.data[0]).amount,
      },
    );

    /// Nofitfy Recipient
    await paymentProcessed(
      id: TransactionRecord.fromJson(value.data[0]).recipient,
      message: {
        'message': 'Payment Recieved',
        'sender': TransactionRecord.fromJson(value.data[0]).sender,
        'amount': TransactionRecord.fromJson(value.data[0]).amount,
      },
    );
  }

  Future<void> depositNotification(PostgrestResponse value) async {
    /// Notify User of their deposit
    await paymentProcessed(
      id: TransactionRecord.fromJson(value.data[0]).sender,
      message: {
        'message': 'Deposit Complete',
        'amount': TransactionRecord.fromJson(value.data[0])
            .amount, //TODO Details in Notifcation
      },
    );
  }

  Future<void> withdrawNotification(PostgrestResponse value) async {
    /// Notify User of their withdraw
    await paymentProcessed(
      id: TransactionRecord.fromJson(value.data[0]).sender,
      message: {
        'message': 'Withdraw Complete',
        'amount': TransactionRecord.fromJson(value.data[0])
            .amount, //TODO Details in Notification
      },
    );
  }

  /// Base Notification
  Future<void> paymentProcessed({
    required String id,
    required Map message,
  }) async {
    africasTalking.isLive = false;

    var sms = africasTalking.sms('67567');

    await sms.send(
        message: 'Dear Customer SMS Notification Test, ${message['message']}. ${message['amount']} ',
        to: ['+********']).onError((error, stackTrace) {
      print(error);
      throw UnimplementedError(); //TODO Handle Error
    });
  }

  static final africasTalking = AfricasTalking('sandbox', Env.africasTalking!);
}

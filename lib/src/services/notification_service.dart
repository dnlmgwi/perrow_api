// import 'package:perrow_api/src/api/mailjet_api/mailjet_api.dart';
// import 'package:perrow_api/src/api/twilio_api/twilio_api.dart';
// import 'package:perrow_api/src/config.dart';
// import 'package:perrow_api/packages/perrow_api.dart';

// class NotificationService {
//   static final africasTalking = AfricasTalking('sandbox', Env.africasTalking!);

//   final mocean = TwilioAPI();
  // final mailJet = MailJetAPI();

  /// Send Nofication
  // Future sendNotification(
  //   TransactionRecord transaction,
  //   PostgrestResponse response,
  // ) async {
  //   switch (transaction.transType) {
  //     case 0:
  //       UnimplementedError(); //TODO
  //       // await notificationService.withdrawNotification(value);
  //       break;
  //     case 1:
  //       UnimplementedError(); //TODO
  //       // await notificationService.depositNotification(value);
  //       break;

  //     case 2:
  //       await transferNotification(response);

  //       break;
  //   }
  // }

  /// Notify the Sender and The Reciver of this transaction
  // Future<void> transferNotification(PostgrestResponse value) async {
  //   /// Notify Sender
  //   await senderNotificationSMS(
  //     id: TransactionRecord.fromJson(value.data[0]).sender,
  //     phoneNumber: '',
  //     message: {
  //       'message': 'Transfer Complete',
  //       'recipient': TransactionRecord.fromJson(value.data[0]).recipient,
  //       'amount': TransactionRecord.fromJson(value.data[0]).amount,
  //       'trans_id': TransactionRecord.fromJson(value.data[0]).transId,
  //       'timestamp': TransactionRecord.fromJson(value.data[0]).timestamp
  //     },
  //   );

  //   /// Nofitfy Recipient
  //   await recipientNotificationSMS(
  //     id: TransactionRecord.fromJson(value.data[0]).recipient,
  //     phoneNumber: '',
  //     message: {
  //       'message': 'Payment Recieved',
  //       'sender': TransactionRecord.fromJson(value.data[0]).sender,
  //       'amount': TransactionRecord.fromJson(value.data[0]).amount,
  //       'trans_id': TransactionRecord.fromJson(value.data[0]).transId,
  //       'timestamp': TransactionRecord.fromJson(value.data[0]).timestamp
  //     },
  //   );
  // }

  // Future<void> depositNotification(PostgrestResponse value) async {
  //   /// Notify User of their deposit
  //   await sendSMS(
  //     id: TransactionRecord.fromJson(value.data[0]).sender,
  //     phoneNumber: '',
  //     message: {
  //       'message': 'Deposit Complete',
  //       'amount': TransactionRecord.fromJson(value.data[0])
  //           .amount, //TODO Details in Notifcation
  //       'trans_id': TransactionRecord.fromJson(value.data[0]).transId,
  //       'timestamp': TransactionRecord.fromJson(value.data[0]).timestamp
  //     },
  //   );
  // }

  // Future<void> withdrawNotification(PostgrestResponse value) async {
  //   /// Notify User of their withdraw
  //   await sendSMS(
  //     id: TransactionRecord.fromJson(value.data[0]).sender,
  //     phoneNumber: '',
  //     message: {
  //       'message': 'Withdraw Complete',
  //       'amount': TransactionRecord.fromJson(value.data[0])
  //           .amount, //TODO Details in Notification
  //       'trans_id': TransactionRecord.fromJson(value.data[0]).transId,
  //       'timestamp': TransactionRecord.fromJson(value.data[0]).timestamp
  //     },
  //   );
  // }

  // /// Base Notification
  // Future<void> sendSMS(
  //     {required String id,
  //     required Map message,
  //     required String phoneNumber}) async {
  //   africasTalking.isLive = false;

  //   var sms = africasTalking.sms('67567');

  //   await sms.send(
  //       message:
  //           'Dear Customer ${message['message']}, ${message['amount']} from ${message['id']}, on ${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(message['timestamp']), format: 'D, M j, H:i')}, Ref: ${message['trans_id']} ',
  //       to: ['+265997176756']).onError((error, stackTrace) {
  //     //TODO Add Phone Number Variable
  //     print(error);
  //     throw UnimplementedError(); //TODO Handle Error
  //   });
  // }

  // Future<void> senderNotificationSMS({
  //   required String id,
  //   required Map message,
  //   required String phoneNumber,
  // }) async {
    // africasTalking.isLive = false;

    // var sms = africasTalking.sms('67567');

    ///SMS Notification
    // await mocean
    //     .sendSMS(
    //         message:
    //             'Dear customer ${message['message']}, ${message['amount']} to $id on ${dateTimeReadable(message)}. Ref: ${message['trans_id']}')
    //     .onError((error, stackTrace) {
    //   //TODO Add Phone Number Variable
    //   print(error);
    //   throw UnimplementedError(); //TODO Handle Error
    // });

    // await mocean
    //     .sendWhatsApp(
    //         message:
    //             'Dear customer ${message['message']}, ${message['amount']} to $id on ${dateTimeReadable(message)}. Ref: ${message['trans_id']}')
    //     .onError((error, stackTrace) {
    //   //TODO Add Phone Number Variable
    //   print(error);
    //   throw UnimplementedError(); //TODO Handle Error
    // });

    // await sms.send(
    //     message:
    //         'Dear customer ${message['message']}, ${message['amount']} to $id on ${dateTimeReadable(message)}. Ref: ${message['trans_id']}',
    //     to: ['+265997176756']).onError((error, stackTrace) {
    //   //TODO Add Phone Number Variable
    //   print(error);
    //   throw UnimplementedError(); //TODO Handle Error
    // });
  //   await mailJet
  //       .sendEmail(
  //           transactionMessage: 'To $id',
  //           toAddress: 'pdmgawi@gmail.com',
  //           toName: 'User 1',
  //           subject: message['message'],
  //           date: dateTimeReadable(message),
  //           amount: message['amount'],
  //           ref: message['trans_id'])
  //       .onError((error, stackTrace) {
  //     //TODO Add Phone Number Variable
  //     print(error);
  //     throw UnimplementedError(); //TODO Handle Error
  //   });
  // }

  // Future<void> recipientNotificationSMS({
  //   required String id,
  //   required Map message,
  //   required String phoneNumber,
  // }) async {
    ///SMS Nofitication
    // await mocean
    //     .sendSMS(
    //         message:
    //             'Dear customer ${message['message']}, ${message['amount']} from $id on ${dateTimeReadable(message)}. Ref: ${message['trans_id']}')
    //     .onError((error, stackTrace) {
    //   //TODO Add Phone Number Variable
    //   print(error);
    //   throw UnimplementedError(); //TODO Handle Error
    // });
    // await mocean
    //     .sendWhatsApp(
    //         message:
    //             'Dear customer ${message['message']}, ${message['amount']} from $id on ${dateTimeReadable(message)}. Ref: ${message['trans_id']}')
    //     .onError((error, stackTrace) {
    //   //TODO Add Phone Number Variable
    //   print(error);
    //   throw UnimplementedError(); //TODO Handle Error
    // });
    // africasTalking.isLive = false;

    // var sms = africasTalking.sms('67567');

    // await sms.send(
    //     message:
    //         'Dear customer ${message['message']}, ${message['amount']} from $id on ${dateTimeReadable(message)}. Ref: ${message['trans_id']}',
    //     to: ['+265997176756']).onError((error, stackTrace) {
    //   //TODO Add Phone Number Variable
    //   print(error);
    //   throw UnimplementedError(); //TODO Handle Error
    // });

    // await mailJet
    //     .sendEmail(
    //         transactionMessage: 'From $id',
    //         toAddress: 'pdmgawi@gmail.com',
    //         toName: 'User 1',
    //         subject: message['message'],
    //         date: dateTimeReadable(message),
    //         amount: message['amount'],
    //         ref: message['trans_id'])
    //     .onError((error, stackTrace) {
    //   //TODO Add Phone Number Variable
    //   print(error);
    //   throw UnimplementedError(); //TODO Handle Error
    // });
  // }

  // String dateTimeReadable(Map<dynamic, dynamic> message) =>
  //     DateTimeFormat.format(
  //       DateTime.fromMillisecondsSinceEpoch(message['timestamp']),
  //       format: 'D, M j, H:i',
  //     );
// }

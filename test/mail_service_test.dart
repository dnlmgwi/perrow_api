// import 'package:mailer/mailer.dart';
// // import 'package:mailer/smtp_server.dart';

// void main() async {
//   var username = 'pdmgawi@gmail.com';
//   var password = 'Yk5ynI9XJRhwdWDm';

//   // final smtpServer = SmtpServer(
//   //   'smtp-relay.sendinblue.com',
//   //   password: password,
//   //   username: username,
//   //   allowInsecure: ,
//   //   ignoreBadCertificate: ,
//   //   name: ,
//   //   port: ,
//   //   ssl: false
//   // );

//   // Use the SmtpServer class to configure an SMTP server:
//   // final smtpServer = SmtpServer('smtp.domain.com');
//   // See the named arguments of SmtpServer for further configuration
//   // options.

//   // Create our message.
//   final message = Message()
//     ..from = Address(username, 'Your name')
//     ..recipients.add('destination@example.com')
//     ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//     ..bccRecipients.add(Address('bccAddress@example.com'))
//     ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
//     ..text = 'This is the plain text.\nThis is line 2 of the text part.'
//     ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

//   try {
//     final sendReport = await send(message, smtpServer);
//     print('Message sent: ' + sendReport.toString());
//   } on MailerException catch (e) {
//     print('Message not sent.');
//     for (var p in e.problems) {
//       print('Problem: ${p.code}: ${p.msg}');
//     }
//   }
//   // DONE

//   // Sending multiple messages with the same connection
//   //
//   // Create a smtp client that will persist the connection
//   var connection = PersistentConnection(smtpServer);

//   // Send the first message
//   await connection.send(message);

//   // close the connection
//   await connection.close();
// }

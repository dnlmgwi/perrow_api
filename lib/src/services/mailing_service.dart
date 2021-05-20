import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailingService {
  static final _username = 'pdmgawi@gmail.com';
  static final _password = 'Yk5ynI9XJRhwdWDm';
  static final _port = 587;

  static final smtpServer = SmtpServer(
    'smtp-relay.sendinblue.com',
    password: _password,
    username: _username,
    allowInsecure: true,
    ignoreBadCertificate: true,
    port: _port,
    ssl: false,
  );

  var connection = PersistentConnection(smtpServer);

  void sendMail(Message message) async {
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    await connection.send(message);
    await connection.close();
  }

  Future<Message> invoiceEmail() async {
    // Create our message.
    final message = Message()
      ..from = Address(_username, 'Your name')
      ..recipients.add('destination@example.com')
      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    return message;
  }
}

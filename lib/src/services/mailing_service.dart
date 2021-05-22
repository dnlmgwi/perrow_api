import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:perrow_api/src/config.dart';

class MailingService {
  static final smtpServer = SmtpServer(
    Env.mail_host!,
    password: Env.mail_password!,
    username: Env.mail_username!,
    allowInsecure: true,
    ignoreBadCertificate: true,
    port: int.parse(Env.mail_port!),
    ssl: true,
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
  }

  Future<Message> invoiceEmail(String recipeintEmail) async {
    // Create our message.
    final message = Message()
      ..from = Address(Env.mail_from_address!, Env.mail_from_name!)
      ..recipients.add(recipeintEmail)
      ..subject = 'Test Invoice ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    return message;
  }
}

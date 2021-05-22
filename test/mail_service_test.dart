import 'package:dotenv/dotenv.dart';
import 'package:perrow_api/src/services/mailing_service.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() async {
  load();
  var mailService = MailingService();
  test('Get Email Message', () async {
    expect(mailService.invoiceEmail('pdmgawi@gmail.com'), isNotNull);
  });

  test('Send Email Message', () async {
    mailService.sendMail(await mailService.invoiceEmail('pdmgawi@gmail.com'));
  });
}

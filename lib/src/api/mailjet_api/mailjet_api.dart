// import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:perrow_api/packages/core.dart';
import 'package:perrow_api/src/config.dart';

class MailJetAPI {
  ///Mailjet Credentials
  var user = Env.mailjetUser!;
  var key = Env.mailjetKey!;
  var issuer = Env.issuer!;

  Future<int?> sendEmail({
    required String transactionMessage,
    required String toAddress,
    required String toName,
    required String subject,
    required String date,
    required int amount,
    required String ref,
  }) async {
    var message = jsonEncode({
      'Messages': [
        {
          'From': {'Email': 'pdmgawi@gmail.com', 'Name': 'Transfer'},
          'To': [
            {'Email': toAddress, 'Name': toName}
          ],
          'TemplateID': 3092335,
          'TemplateLanguage': true,
          'Subject': subject,
          'TextPart': 'Greetings from $issuer.',
          'Variables': {
            'date_time': date,
            'transaction_message': transactionMessage,
            'amount': amount,
            'transaction_ref': ref,
          },
          'CustomID': issuer
        }
      ]
    });

    var url = Uri.https('api.mailjet.com', '/v3.1/send', {'q': '{http}'});

    final client = http.Client();

    var bytes = utf8.encode('$user:$key');
    var base64Str = base64.encode(bytes);

    try {
      var response = await client.post(url, body: message, headers: {
        HttpHeaders.authorizationHeader: 'Basic $base64Str',
        HttpHeaders.acceptHeader: ContentType.json.mimeType,
      });

      // decodedResponse = convert.jsonDecode(response.body) as Map;

      print(response.body);
      return response.statusCode;
    } catch (e) {
      print('Mococean $e');
    } finally {
      client.close();
    }
  }
}

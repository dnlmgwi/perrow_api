import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class MoceanAPI {
  
  Future<String> sendSMS({
    required String phoneNumber,
    required String message,
  }) async {
    var decodedResponse;
    var company = 'YourCompany';

    var url = Uri.https('rest.moceanapi.com', '/rest/2/sms', {'q': '{http}'});

    var client = http.Client();

    try {
      var response = await client.post(url, body: {
        'mocean-api-key': 'API_KEY_HERE',
        'mocean-api-secret': 'API_SECRET_HERE',
        'mocean-from': company,
        'mocean-to': phoneNumber,
        'mocean-text': message,
      });

      decodedResponse =
          convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
      var uri = Uri.parse(decodedResponse['uri'] as String);
      print(await client.get(uri));
    } finally {
      client.close();
    }
    return decodedResponse;
  }
}

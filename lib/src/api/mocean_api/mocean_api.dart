// // import 'dart:convert' as convert;

// import 'package:http/http.dart' as http;
// import 'package:perrow_api/packages/core.dart';

// class MoceanAPI {
//   Future<String?> sendSMS({
//     required String message,
//   }) async {
//     String? decodedResponse;
//     var company = 'Qash';

//     var url = Uri.https('rest.moceanapi.com', '/rest/2/sms', {'q': '{http}'});

//     var client = http.Client();

//     try {
//       var response = await client.post(url, body: {
//         'mocean-api-key': '2dc85003',
//         'mocean-api-secret': '057a763d',
//         'mocean-from': company,
//         'mocean-to': '265997176756',
//         'mocean-text': message,
//       }, headers: {
//         HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
//         HttpHeaders.acceptHeader: ContentType.json.mimeType,
//       });

//       // decodedResponse = convert.jsonDecode(response.body) as Map;

//       print(response);
//     } catch (e) {
//       print('Mococean $e');
//     } finally {
//       client.close();
//     }
//     return decodedResponse;
//   }
// }

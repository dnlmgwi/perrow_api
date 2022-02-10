// import 'dart:convert' as convert;

// import 'package:http/http.dart' as http;
// import 'package:perrow_api/packages/core.dart';
// import 'package:perrow_api/src/config.dart';

class TwilioAPI {
  // Future<int?> sendWhatsApp({
  //   required String message,
  // }) async {

  //   ///Twilio Credentials
  //   var accountSid = Env.twilioAccountSid!;
  //   var cred = Env.twilioCred!;
  //   var to = Env.twilioTo!;
  //   var from = Env.twilioFrom!;

  //   var url = Uri.https('api.twilio.com',
  //       '/2010-04-01/Accounts/$accountSid/Messages.json', {'q': '{http}'});

  //   final client = http.Client();

  //   var bytes = utf8.encode('$accountSid:$cred');
  //   var base64Str = base64.encode(bytes);

  //   try {
  //     var response = await client.post(url, body: {
  //       'Body': message,
  //       'From': 'whatsapp:$from',
  //       'To': 'whatsapp:$to',
  //     }, headers: {
  //       HttpHeaders.authorizationHeader: 'Basic $base64Str',
  //       HttpHeaders.acceptHeader: ContentType.json.mimeType,
  //     });

  //     // decodedResponse = convert.jsonDecode(response.body) as Map;

  //     print(response.body);
  //     return response.statusCode;
  //   } catch (e) {
  //     print('Mococean $e');
  //   } finally {
  //     client.close();
  //   }
  // }

  // Future<int?> sendSMS({ //TODO Delay in Delivery From Twilio WA is The Test Alernative
  //   required String message,
  // }) async {
  //   var accountSid = 'ACca98e843ab4c793b53d2a6b01dc28138';
  //   var from = '+14433962315';
  //   var cred = '2a5ddeb90511f673c3d075b2f59fc9fe';
  //   var to = '+265997176756';

  //   var url = Uri.https('api.twilio.com',
  //       '/2010-04-01/Accounts/$accountSid/Messages.json', {'q': '{http}'});

  //   final client = http.Client();

  //   var bytes = utf8.encode('$accountSid:$cred');
  //   var base64Str = base64.encode(bytes);

  //   try {
  //     var response = await client.post(url, body: {
  //       'Body': message,
  //       'From': from,
  //       'To': to,
  //     }, headers: {
  //       HttpHeaders.authorizationHeader: 'Basic $base64Str',
  //       HttpHeaders.acceptHeader: ContentType.json.mimeType,
  //     });

  //     // decodedResponse = convert.jsonDecode(response.body) as Map;

  //     print(response.body);
  //     return response.statusCode;
  //   } catch (e) {
  //     print('Mococean $e');
  //   } finally {
  //     client.close();
  //   }
  // }
}

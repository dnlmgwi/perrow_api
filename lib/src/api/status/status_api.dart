import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class StatusApi {
  Router get router {
    final router = Router();

    router.get('/status', (Request request) {
      final data = {
        'message': 'Perrow API',
        'status': 'Development',
        'version': '0.0.1',
      };
      return Response.ok(
        json.encode(data),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );
    });

    return router;
  }
}

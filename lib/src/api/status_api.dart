import 'package:perrow_api/packages/perrow_api.dart';

class StatusApi {
  Router get router {
    final router = Router();

    router.get('/status', (Request request) {
      final data = {
        'message': 'Perrow API',
        'status': 'Development',
        'version': '0.1.1',
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

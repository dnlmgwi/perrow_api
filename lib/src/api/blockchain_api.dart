import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/utils.dart';
import 'package:perrow_api/src/validators/validation/blockchainValidationService.dart';
import 'package:perrow_api/packages/dependencies.dart';

class BlockChainApi {
  BlockchainService blockchainService;

  BlockChainApi({
    required this.blockchainService,
  });

  Handler get router {
    final router = Router();
    final handler = Pipeline().addMiddleware(checkAuthorisation()).addHandler(router);

    router.get(
      '/pending',
      (Request request) async {
        if (BlockChainValidationService.isBlockChainValid(
            chain: await blockchainService.getBlockchain(),
            blockchain: blockchainService)) {
          return Response.ok(
            blockchainService.getPendingTransactions(),
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        } else {
          return Response.notFound(
            'Invalid Blockchain',
            headers: {
              HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
            },
          );
        }
      },
    );

    return handler;
  }
}

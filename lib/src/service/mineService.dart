import 'package:perrow_api/src/model/models/mineResult/mineResult.dart';
import 'package:perrow_api/src/service/blockchainService.dart';
import 'package:perrow_api/src/validators/validation/blockchainValidationService.dart';

class MineServices {
  BlockchainService blockchain;
  var blockChainValidity = BlockChainValidationService();

  MineServices({required this.blockchain});

  Future mine() async {
    if (blockchain.pendingTransactions.isEmpty) {
      // throw NoPendingTransactionException();
      //TODO IGNORE
    }

    var lastBlock = await blockchain.lastBlock;
    var lastProof = lastBlock.proof;
    var proof = await blockchain.proofOfWork(lastProof);

    // Forge the new Block by adding it to the chain
    var prevHash = blockchain.hash(lastBlock);
    var block = await blockchain.newBlock(
      lastBlock,
      proof,
      prevHash,
    );

    var validblock = BlockChainValidationService.isNewBlockValid(
      blockchain: blockchain,
      newBlock: block,
      previousBlock: lastBlock,
    );

    return MineResult(
      message: 'New Block Forged',
      validBlock: validblock,
      index: block.index,
      transactions: block.blockTransactions,
      proof: proof,
      prevHash: prevHash,
    );
  }
}

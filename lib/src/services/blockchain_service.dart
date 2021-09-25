import 'package:perrow_api/packages/core.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:hex/hex.dart';
import 'package:perrow_api/packages/perrow_api.dart';

import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/packages/services.dart';
import 'package:postgrest/postgrest.dart';
import 'package:uuid/uuid.dart';

class BlockchainService {
  WalletService walletService;

  BlockchainService({
    required this.walletService,
  });

  Future<Block> get getLastBlock async {
    PostgrestResponse response;
    try {
      response = await DatabaseService.client
          .from('blockchain')
          .select()
          .limit(1)
          .order('timestamp', ascending: false)
          .execute()
          .onError(
            (
              error,
              stackTrace,
            ) =>
                throw Exception(
              '$error $stackTrace',
            ),
          );
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      rethrow;
    }

    return Block.fromJson(response.data[0]);
  }

  Future<Block> newBlock(
      Block prevBlock, int proof, String previousHash) async {
    if (previousHash.isEmpty) {
      previousHash = hash(prevBlock);
    }

    try {
      var id = Uuid().v4();

      var blockTransactions = List.of(walletService.pendingTransactions.values);

      for (var transaction in blockTransactions) {
        transaction.blockId = id;
      }

      await walletService
          .processPayments(prevBlock, id)
          .then(
            (_) => DatabaseService.client
                .from('blockchain')
                .insert(
                  Block(
                    id: id,
                    index: prevBlock.index! + 1, //DO NOT TOUCH
                    timestamp: DateTime.now().millisecondsSinceEpoch,
                    proof: proof,
                    prevHash: previousHash,
                    blockTransactions: blockTransactions,
                  ).toJson(),
                )
                .execute()
                .then(
                  (value) => blockTransactions.clear(),
                )
                .onError(
                  (error, stackTrace) => throw Exception('$error $stackTrace'),
                ), //TODO Stacktace
          )
          .onError(
            (error, stackTrace) =>
                throw Exception(' Error: $error StackTrace: $stackTrace'),
          );
      //Successfully Mined

      var latestBlock = await DatabaseService.client
          .from('blockchain')
          .select()
          .limit(1)
          .order('timestamp', ascending: false)
          .execute()
          .onError(
            (error, stackTrace) => throw Exception('$error $stackTrace'),
          ); //TODO on Error Handle Exceptions

      return Block.fromJson(latestBlock.data[0]);
    } on PostgrestError catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<Block> mine() async {
    if (pendingTransactions.isEmpty) {
      print('No Transactions Pending');
      // throw NoPendingTransactionException();
      //TODO IGNORE
    }

    var lastBlock = await getLastBlock;
    var lastProof = lastBlock.proof;
    var proof = await proofOfWork(lastProof);

    // Forge the new Block by adding it to the chain
    var prevHash = hash(lastBlock);
    var block = await newBlock(
      lastBlock,
      proof,
      prevHash,
    );

    return block;

    // var validblock = BlockChainValidationService.isNewBlockValid(
    //   blockchain: ,
    //   newBlock: block,
    //   previousBlock: lastBlock,
    // );

    // return MineResult(
    //   message: 'New Block Forged',
    //   validBlock: validblock,
    //   index: block.index,
    //   transactions: block.blockTransactions,
    //   proof: proof,
    //   prevHash: prevHash,
    // );
  }

  List<TransactionRecord> get pendingTransactions {
    return walletService.pendingTransactions.values.toList();
  }

  String hash(Block block) {
    var blockStr = json.encode(block.toJson());
    var bytes = utf8.encode(blockStr);
    var converted = crypto.sha256.convert(bytes).bytes;
    return HEX.encode(converted);
  }

  Future<int> proofOfWork(int? lastProof) async {
    var proof = 0;
    while (!validProof(lastProof, proof)) {
      proof++;
    }
    return proof;
  }

  bool validProof(int? lastProof, int proof) {
    var guess = utf8.encode('$lastProof$proof');
    var guessHash = crypto.sha256.convert(guess).bytes;
    return HEX.encode(guessHash).substring(0, 4) == Env.difficulty;
  }

  Future<List<Block>> getBlockchain() async {
    //Todo Error Handling with try/catch
    var jsonChain = <Block>[];
    var response = await DatabaseService.client
        .from('blockchain')
        .select()
        .limit(3) //TODO Get The Whole Blockchain
        .order('index', ascending: true)
        .execute(); //TODO Error Handling

    var chain = response.data as List;

    for (var block in chain) {
      jsonChain.add(Block.fromJson(block));
    }

    return jsonChain;
  }

  String getPendingTransactions() {
    var jsonChain = [];
    for (var transaction in walletService.pendingTransactions.values) {
      jsonChain.add(transaction.toJson());
    }
    json.encode(jsonChain);
    return jsonChain.toString();
  }
}

import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hex/hex.dart';

import 'package:perrow_api/src/config.dart';
import 'package:perrow_api/src/model/models/block/block.dart';
import 'package:perrow_api/src/model/models/hive/0.transactionRecord/transactionRecord.dart';
import 'package:perrow_api/src/service/databaseService.dart';
import 'package:perrow_api/src/service/walletServices.dart';
import 'package:postgrest/postgrest.dart';
import 'package:uuid/uuid.dart';

class BlockchainService {
  WalletService walletService;

  BlockchainService({
    required this.walletService,
  });

  Future<Block> newBlock(
      Block prevBlock, int proof, String previousHash) async {
    if (previousHash.isEmpty) {
      previousHash = hash(prevBlock);
    }

    try {
      var blockTransactions =
          List.of(walletService.pendingTransactions.values.toList());

      var id = Uuid().v4();

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
      // await Sentry.captureException(
      //   exception,
      //   stackTrace: stackTrace,
      //   hint: stackTrace,
      // );//TODO Handle Errors
      rethrow;
    }
  }

  Future<Block> get lastBlock async {
    var response;
    try {
      response = await DatabaseService.client
          .from('blockchain')
          .select()
          .limit(1)
          .order('timestamp', ascending: false)
          .execute()
          .onError(
            (error, stackTrace) => throw Exception('$error $stackTrace'),
          ); //TODO Stacktace
    } catch (e, trace) {
      print('lastBlock ${e.toString()} ${trace.toString()}');
      rethrow;
    }
    ;
    return Block.fromJson(response.data[0]);
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
    //Todo Handling
    var jsonChain = <Block>[];
    var response = await DatabaseService.client
        .from('blockchain')
        .select()
        // .limit(1) //TODO Get The Whole Blockchain
        .order('index', ascending: true)
        .execute(); //TODO Error Handling

    var chain = response.data as List;
    chain.forEach((element) {
      jsonChain.add(Block.fromJson(element));
    });

    return jsonChain;
  }

  String getPendingTransactions() {
    var jsonChain = [];
    walletService.pendingTransactions.values.forEach((element) {
      jsonChain.add(element.toJson());
    });
    json.encode(jsonChain);
    return jsonChain.toString();
  }
}

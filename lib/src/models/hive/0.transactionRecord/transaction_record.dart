import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'transaction_record.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class TransactionRecord extends HiveObject {
  @HiveField(1)
  String sender;

  @HiveField(2)
  String recipient;

  @HiveField(3)
  int amount;

  @HiveField(4)
  int timestamp;

  @HiveField(5)
  @JsonKey(name: 'trans_id')
  String transId;

  @HiveField(6)
  @JsonKey(name: 'trans_type')
  int transType;

  @HiveField(7)
  @JsonKey(name: 'block_id')
  late String? blockId;

  TransactionRecord({
    required this.sender,
    required this.recipient,
    required this.amount,
    required this.timestamp,
    required this.transId,
    required this.transType,
    this.blockId,
  });

  factory TransactionRecord.fromJson(Map<String, dynamic> json) =>
      _$TransactionRecordFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionRecordToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
part 'mineResult.g.dart';

@JsonSerializable(explicitToJson: true)
class MineResult {
  final String message;

  final int? index;

  final bool? validBlock;

  final List? transactions;

  final int proof;

  final String prevHash;

  MineResult({
    required this.index,
    required this.message,
    required this.validBlock,
    required this.transactions,
    required this.proof,
    required this.prevHash,
  });

  factory MineResult.fromJson(Map<String, dynamic> json) =>
      _$MineResultFromJson(json);
  Map<String, dynamic> toJson() => _$MineResultToJson(this);
}

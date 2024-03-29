import 'package:json_annotation/json_annotation.dart';

part 'trans_account.g.dart';

@JsonSerializable(explicitToJson: true)
class TransAccount {
  String? id;

  String status;

  int balance;

  @JsonKey(name: 'last_transaction')
  DateTime? lastTrans;

  TransAccount({
    required this.status,
    required this.id,
    required this.balance,
    required this.lastTrans,
  });

  factory TransAccount.fromJson(Map<String, dynamic> json) =>
      _$TransAccountFromJson(json);

  Map<String, dynamic> toJson() => _$TransAccountToJson(this);
}

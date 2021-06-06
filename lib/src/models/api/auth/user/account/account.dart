import 'package:json_annotation/json_annotation.dart';
part 'account.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class Account {
  String? id;

  String status;

  int balance;

  @JsonKey(name: 'joined_date')
  int joinedDate;

  @JsonKey(name: 'last_transaction')
  late int? lastTransaction;

  Account({
    this.id,
    required this.status,
    required this.balance,
    required this.joinedDate,
    this.lastTransaction,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

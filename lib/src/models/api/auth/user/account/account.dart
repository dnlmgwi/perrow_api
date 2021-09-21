import 'package:json_annotation/json_annotation.dart';
part 'account.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class Account {
  int? id;

  String status;

  int balance;

  @JsonKey(name: 'phone_number')
  String phoneNumber;

  @JsonKey(name: 'created_at')
  late DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  late DateTime? updatedAt;

  @JsonKey(name: 'joined_date')
  int joinedDate;

  @JsonKey(name: 'last_transaction')
  late int? lastTransaction;

  Account({
    this.id,
    required this.phoneNumber,
    required this.status,
    required this.balance,
    required this.joinedDate,
    this.createdAt,
    this.updatedAt,
    this.lastTransaction,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

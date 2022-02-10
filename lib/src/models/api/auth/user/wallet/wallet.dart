import 'package:json_annotation/json_annotation.dart';
part 'wallet.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class Wallet {
  String? id;

  String status;

  int balance;

  String currency;

  @JsonKey(name: 'phone_number')
  late String? phoneNumber;

  @JsonKey(name: 'created_at')
  late DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  late DateTime? updatedAt;

  @JsonKey(name: 'joined_date')
  DateTime joinedDate;

  @JsonKey(name: 'last_transaction')
  late DateTime? lastTransaction;

  Wallet({
    this.id,
    this.phoneNumber,
    required this.status,
    required this.balance,
    required this.joinedDate,
    required this.currency,
    this.createdAt,
    this.updatedAt,
    this.lastTransaction,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);
}

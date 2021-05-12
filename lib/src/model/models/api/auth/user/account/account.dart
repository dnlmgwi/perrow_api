import 'package:json_annotation/json_annotation.dart';
part 'account.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class Account {
  String? id;

  String gender;

  String pin;

  @JsonKey(name: 'phone_number')
  String phoneNumber;

  String salt;

  String status;

  int balance;

  @JsonKey(name: 'joined_date')
  int joinedDate;

  int age;

  @JsonKey(name: 'last_trans')
  late int? lastTrans;

  Account({
    this.id,
    required this.gender,
    required this.pin,
    required this.phoneNumber,
    required this.salt,
    required this.status,
    required this.balance,
    required this.joinedDate,
    required this.age,
    this.lastTrans,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

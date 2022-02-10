import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'recharge_notification.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class RechargeNotification extends HiveObject {
  @HiveField(1)
  @JsonKey(name: 'trans_id')
  String transID;

  @HiveField(2)
  @JsonKey(name: 'phone_number')
  String phoneNumber;

  @HiveField(3)
  double amount;

  @HiveField(4)
  int timestamp;

  @HiveField(5)
  String currency;

  RechargeNotification({
    required this.phoneNumber,
    required this.amount,
    required this.transID,
    required this.timestamp,
    required this.currency,
  });

  factory RechargeNotification.fromJson(Map<String, dynamic> json) =>
      _$RechargeNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$RechargeNotificationToJson(this);
}

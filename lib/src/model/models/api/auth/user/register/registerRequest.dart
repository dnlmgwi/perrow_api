import 'package:json_annotation/json_annotation.dart';

part 'registerRequest.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class RegisterRequest {
  late final int? age;
  late final String? gender;
  late final String? pin;
  late final String? phoneNumber;

  RegisterRequest({
    required this.age,
    required this.gender,
    required this.pin,
    required this.phoneNumber,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

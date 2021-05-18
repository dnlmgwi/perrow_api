import 'package:json_annotation/json_annotation.dart';

part 'loginRequest.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class LoginRequest {
  late final String? id;
  late final String? pin;
  // late final String? phoneNumber; //TODO Login with PhoneNumber aswell

  LoginRequest({
    required this.id,
    required this.pin,
    // required this.phoneNumber,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

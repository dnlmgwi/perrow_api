import 'package:json_annotation/json_annotation.dart';

part 'loginRequest.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class LoginRequest {
  late final String? email;
  late final String? password;
  late final String? phone;

  LoginRequest({
    required this.email,
    required this.password,
    required this.phone,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

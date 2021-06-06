import 'package:json_annotation/json_annotation.dart';

part 'loginRequestv2.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class LoginRequestV2 {
  late final String? email;
  late final String? password;

  LoginRequestV2({
    required this.email,
    required this.password,
    // required this.phoneNumber,
  });

  factory LoginRequestV2.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestV2FromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestV2ToJson(this);
}

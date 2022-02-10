import 'package:json_annotation/json_annotation.dart';
part 'perrow_response.g.dart';

@JsonSerializable(explicitToJson: true)
class PerrowResponse {
  final String message;

  final List? errors;

  final List? trace;

  final Map? data;

  PerrowResponse({
    required this.message,
    this.errors,
    this.data,
    this.trace,
  });

  factory PerrowResponse.fromJson(Map<String, dynamic> json) =>
      _$PerrowResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PerrowResponseToJson(this);
}

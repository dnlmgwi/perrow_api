import 'package:json_annotation/json_annotation.dart';
part 'transferRequest.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class TransferRequest {
  late String? id;

  late int? amount;

  TransferRequest({
    required this.id,
    required this.amount,
  });

  factory TransferRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransferRequestToJson(this);
}

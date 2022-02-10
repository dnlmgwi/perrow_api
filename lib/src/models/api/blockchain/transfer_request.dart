import 'package:json_annotation/json_annotation.dart';
part 'transfer_request.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class TransferRequest {
  late int? id;

  late int? amount;

  late String? currency;

  TransferRequest({
    required this.id,
    required this.amount,
    required this.currency,
  });

  factory TransferRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransferRequestToJson(this);
}

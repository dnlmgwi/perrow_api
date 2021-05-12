import 'package:json_annotation/json_annotation.dart';
part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  int? id;

  String address;

  double lat;

  double lng;

  Location({
    this.id,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

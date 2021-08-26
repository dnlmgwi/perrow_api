import 'package:geodesy/geodesy.dart';

class LocationService {
  late Geodesy geodesy;

  LocationService({required Geodesy geodesy});

  List<LatLng> findPointsInRange({
    required List<LatLng> pointsToCheck,
    required int distance,
    required LatLng point,
  }) {
    //Determine The Search Area
    var geofencedPoints = geodesy.pointsInRange(point, <LatLng>[], distance);
    return geofencedPoints;
  }
}

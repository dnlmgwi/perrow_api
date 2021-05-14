import 'package:geodesy/geodesy.dart';

class UserActivityService {
  Geodesy geodesy = Geodesy();

  Map movementActivity(
    double startLat,
    double startLng,
    double endLat,
    double endLng, {
    required int timeInMin,
    required double weight,
    required double MET,
  }) {
    var distanceInMeters =
        distanceTraveledInMeters(startLat, startLng, endLat, endLng);

    var activityStats = {
      'pace': _pace(timeInMin, distanceInMeters),
      'distance': distanceInMeters,
      'calories': _calories(
        weight: weight,
        MET: MET,
      )
    };
    return activityStats;
  }

  double _pace(
    int time,
    num distanceMeters,
  ) {
    //Time between two scans < 30 Mins
    /// Pace = Time\Distanc
    /// per meter
    /// It takes a healthy person about 10 minutes to walk 1 kilometer
    /// at a speed of 6 kilometers per hour. Athletes complete it in less
    /// than five minutes. Most people who are not physically fit
    /// take 12 to 15 minutes to walk a kilometer.
    var pace;
    if (time <= 35) {
      //TODO Determine time frame freq
      pace = Duration(minutes: time).inMinutes / distanceMeters;
      //Todo Only Calc Pace if time is less then 30min?
    } else {
      pace = 0.0;
    }
    return pace;
  }

  double distanceTraveledInMeters(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    //MUST BE WITHIN 15 min of Scanning for a valid estimation
    return geodesy
        .distanceBetweenTwoGeoPoints(
            LatLng(startLat, startLng), LatLng(endLat, endLng))
        .toDouble();
  }

  double _calories({
    required double weight,
    required double MET,
  }) {
    //Activity Calories Burned Calculator per minute
    //Compendium of Physical Activities
    //know the MET value of a particular activity
    //Suggest Foods to suppliment the user based off Activites
    //The formula to use is: METs x 3.5 x (your body weight in kilograms) / 200 = calories burned per minute.
    return MET * 3.5 * (weight / 200);
  }
}

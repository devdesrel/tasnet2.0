import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  var geolocator = Geolocator();

  ///[location stream]
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  StreamSubscription<Position> positionStream;

  ///[get user's location]
  Future<Position> getCurrentLocation() async {
    return await geolocator.getCurrentPosition();
  }

  ///[get distance between 2 positions in m]
  Future<double> getDistance(
      {double startLat,
      double startLong,
      double endLat,
      double endLong}) async {
    final double distance = await geolocator.distanceBetween(
        // 41.3395157, 69.3035727, 41.326824, 69.330721
        startLat,
        startLong,
        endLat,
        endLong);
    print('DISTANCE');
    print(distance);
    return distance;
  }

  ///[check if location is enabled]
  Future<bool> isLocationEnabled() async {
    try {
      return await geolocator.isLocationServiceEnabled();
    } catch (e) {
      print(e);
      return false;
    }
  }

  ///[get PlaceMark]
  Future<String> getPlace(Position position) async {
    String _res;
    geolocator.placemarkFromPosition(position).then((val) {
      val.isNotEmpty ? _res = val[0].name : _res = 'Not found';
    });
    return _res;
  }

  dispose() {
    positionStream.cancel();
  }
}

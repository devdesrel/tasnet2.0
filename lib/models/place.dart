import 'package:mapbox_gl/mapbox_gl.dart';

class Place {
  Place({this.name, this.description, this.distance, this.latlng});
  final String name;
  final String description;
  final String distance;
  final LatLng latlng;
}

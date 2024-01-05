import 'package:geolocator/geolocator.dart';

class Constants {
  static const currentCity = 'currentCity';
  static const location = 'location';
  static Position defaultPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
}

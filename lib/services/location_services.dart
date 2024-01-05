import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
final currentPositionProvider = FutureProvider(
  (ref) => ref.read(locationServiceProvider).getPosition(),
);


final yourLocationStateProvider = StateProvider<Position?>((ref) => null);

final locationServiceProvider = Provider((ref) => LocationServices());

class LocationServices {
  Position? position;

  Future<Position?> getPosition() async {
    final status = await Permission.location.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      return null;
    }

    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    final isLocationEnabled = await geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return null;
    }
    final Position position = await geolocator.getCurrentPosition();
    return position;
  }
}

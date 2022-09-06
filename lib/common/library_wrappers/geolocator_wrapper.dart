import 'package:geolocator/geolocator.dart';
import 'package:weather_application/common/constants.dart';
import 'package:weather_application/common/errors/location_permission_denied_error.dart';
import 'package:weather_application/common/errors/location_permission_denied_forever_error.dart';

class GeolocatorWrapper {
  final GeolocatorPlatform geolocatorPlatformInstance;
  late LocationPermission locationPermission;

  GeolocatorWrapper({required this.geolocatorPlatformInstance});

  Future<void> requestPermission() async {
    locationPermission = await geolocatorPlatformInstance.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await geolocatorPlatformInstance.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        throw (LocationPermissionDeniedError());
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      throw (LocationPermissionDeniedForeverError());
    }
  }

  Future<Map<String, double>> getCurrentPositionCoordinates({
    int? distanceFilter,
    Duration? timeLimit,
    GeolocatorWrapperAccuracy? accuracy,
  }) async {
    late LocationAccuracy locationAccuracy;

    switch (accuracy) {
      case GeolocatorWrapperAccuracy.low:
        locationAccuracy = LocationAccuracy.low;
        break;
      case GeolocatorWrapperAccuracy.lowest:
        locationAccuracy = LocationAccuracy.lowest;
        break;
      case GeolocatorWrapperAccuracy.medium:
        locationAccuracy = LocationAccuracy.medium;
        break;
      case GeolocatorWrapperAccuracy.high:
        locationAccuracy = LocationAccuracy.high;
        break;
      case GeolocatorWrapperAccuracy.best:
        locationAccuracy = LocationAccuracy.best;
        break;
      case GeolocatorWrapperAccuracy.bestForNavigation:
        locationAccuracy = LocationAccuracy.bestForNavigation;
        break;
      case GeolocatorWrapperAccuracy.reduced:
        locationAccuracy = LocationAccuracy.reduced;
        break;
      default:
        locationAccuracy = LocationAccuracy.low;
    }

    try {
      Position position = await geolocatorPlatformInstance.getCurrentPosition(
          locationSettings: LocationSettings(
              accuracy: locationAccuracy,
              distanceFilter: distanceFilter ?? 0,
              timeLimit: timeLimit));

      return <String, double>{
        Constants.latitude: position.latitude,
        Constants.longitude: position.longitude
      };
    } catch (error) {
      if (error is PermissionDeniedException) {
        throw LocationPermissionDeniedError();
      } else {
        rethrow;
      }
    }
  }
}

enum GeolocatorWrapperAccuracy {
  lowest,
  low,
  medium,
  high,
  best,
  bestForNavigation,
  reduced,
}

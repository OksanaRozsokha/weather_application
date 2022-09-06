import 'package:weather_application/common/library_wrappers/geolocator_wrapper.dart';
import 'package:weather_application/data/models/location.dart';

abstract class ILocationRepository {
  Future<Location> getCurrentLocation({
    int? distanceFilter,
    Duration? timeLimit,
    GeolocatorWrapperAccuracy? accuracy,
  });
}

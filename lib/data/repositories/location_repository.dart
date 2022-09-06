import 'package:weather_application/common/library_wrappers/geolocator_wrapper.dart';
import 'package:weather_application/domain/contracts/location_repository_interface.dart';
import 'package:weather_application/data/models/location.dart';

class LocationRepository implements ILocationRepository {
  final GeolocatorWrapper geolocatorWrapper;

  LocationRepository({required this.geolocatorWrapper});
  @override
  Future<Location> getCurrentLocation(
      {int? distanceFilter,
      Duration? timeLimit,
      GeolocatorWrapperAccuracy? accuracy}) async {
    await geolocatorWrapper.requestPermission();
    Map<String, double> positionCoordinatesMap =
        await geolocatorWrapper.getCurrentPositionCoordinates(
            accuracy: accuracy,
            distanceFilter: distanceFilter,
            timeLimit: timeLimit);
    return Location.fromMap(positionCoordinatesMap);
  }
}

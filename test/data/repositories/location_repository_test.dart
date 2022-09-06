import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_application/common/constants.dart';
import 'package:weather_application/common/library_wrappers/geolocator_wrapper.dart';
import 'package:weather_application/data/models/location.dart';
import 'package:weather_application/data/repositories/location_repository.dart';

import 'location_repository_test.mocks.dart';

@GenerateMocks(<Type>[GeolocatorWrapper])
void main() {
  late MockGeolocatorWrapper mockGeolocatorWrapper;
  late LocationRepository locationRepository;

  group('Weather Forecast repository', () {
    setUp(() {
      mockGeolocatorWrapper = MockGeolocatorWrapper();
      locationRepository =
          LocationRepository(geolocatorWrapper: mockGeolocatorWrapper);
    });

    test('Location Repository gets Location response', () async {
      when(mockGeolocatorWrapper.getCurrentPositionCoordinates()).thenAnswer(
          (realInvocation) => Future.value(
              {Constants.latitude: 12.3434, Constants.longitude: 45.4553}));

      Future<Location> response = locationRepository.getCurrentLocation();

      expect(response, completion(const TypeMatcher<Location>()));
    });
  });
}

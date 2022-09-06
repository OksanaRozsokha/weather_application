import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_application/common/constants.dart';
import 'package:weather_application/common/errors/location_permission_denied_forever_error.dart';
import 'package:weather_application/common/errors/location_permission_denied_error.dart';
import 'package:weather_application/common/library_wrappers/geolocator_wrapper.dart';

import 'geolocator_wrapper_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<GeolocatorPlatform>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<Position>(onMissingStub: OnMissingStub.returnDefault),
])
void main() {
  late MockGeolocatorPlatform mockGeolocatorPlatform;
  late GeolocatorWrapper geolocatorWrapper;

  group('Weather Forecast repository', () {
    setUp(() {
      mockGeolocatorPlatform = MockGeolocatorPlatform();
      geolocatorWrapper =
          GeolocatorWrapper(geolocatorPlatformInstance: mockGeolocatorPlatform);
    });

    group('Check requestPermission method of GeolocatorWrapper', () {
      test('checkPermission - success response', () async {
        when(mockGeolocatorPlatform.checkPermission()).thenAnswer(
            (realInvocation) => Future.value(LocationPermission.always));

        expect(geolocatorWrapper.requestPermission(), completes);
      });

      test('checkPermission - denied and requestPermission with success',
          () async {
        when(mockGeolocatorPlatform.checkPermission()).thenAnswer(
            (realInvocation) => Future.value(LocationPermission.denied));
        when(mockGeolocatorPlatform.requestPermission()).thenAnswer(
            ((realInvocation) => Future.value(LocationPermission.always)));

        expect(geolocatorWrapper.requestPermission(), completes);
      });

      test(
          'checkPermission - denied and requestPermission - denied, throw LocationPermissionDeniedError',
          () async {
        when(mockGeolocatorPlatform.checkPermission()).thenAnswer(
            (realInvocation) => Future.value(LocationPermission.denied));
        when(mockGeolocatorPlatform.requestPermission()).thenAnswer(
            ((realInvocation) => Future.value(LocationPermission.denied)));

        expect(geolocatorWrapper.requestPermission(),
            throwsA(const TypeMatcher<LocationPermissionDeniedError>()));
      });

      test(
          'checkPermission - deniedForever, throw LocationPermissionDeniedForeverError ',
          () async {
        when(mockGeolocatorPlatform.checkPermission()).thenAnswer(
            (realInvocation) => Future.value(LocationPermission.deniedForever));

        expect(geolocatorWrapper.requestPermission(),
            throwsA(const TypeMatcher<LocationPermissionDeniedForeverError>()));
      });
    });

    group('Check getCurrentPositionCoordinates method of GeolocatorWrapper',
        () {
      test('test success response', () async {
        final MockPosition mockPosition = MockPosition();
        when(mockGeolocatorPlatform.getCurrentPosition(
                locationSettings: anyNamed('locationSettings')))
            .thenAnswer((realInvocation) => Future.value(mockPosition));

        Future<Map<String, double>> response =
            geolocatorWrapper.getCurrentPositionCoordinates();

        expect(response, completion(
            predicate<Map<String, dynamic>>((Map<String, dynamic> obj) {
          return obj.containsKey(Constants.latitude) &&
                  obj.containsKey(Constants.longitude) &&
                  obj[Constants.latitude] == 0.0 &&
                  obj[Constants.longitude] == 0.0
              ? true
              : false;
        })));
      });

      test('test LocationPermissionDeniedError', () async {
        when(mockGeolocatorPlatform.getCurrentPosition(
                locationSettings: anyNamed('locationSettings')))
            .thenAnswer((realInvocation) =>
                Future.error(const PermissionDeniedException('message')));

        Future<Map<String, double>> response =
            geolocatorWrapper.getCurrentPositionCoordinates();

        expect(response,
            throwsA(const TypeMatcher<LocationPermissionDeniedError>()));
      });

      test('test Error', () async {
        when(mockGeolocatorPlatform.getCurrentPosition(
                locationSettings: anyNamed('locationSettings')))
            .thenAnswer((realInvocation) => Future.error(Error()));

        Future<Map<String, double>> response =
            geolocatorWrapper.getCurrentPositionCoordinates();

        expect(response, throwsA(const TypeMatcher<Error>()));
      });
    });
  });
}

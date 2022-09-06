import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_application/common/errors/location_permission_denied_error.dart';
import 'package:weather_application/common/errors/location_permission_denied_forever_error.dart';
import 'package:weather_application/data/models/location.dart';
import 'package:weather_application/domain/contracts/location_repository_interface.dart';
import 'package:weather_application/presentation/bloc/location_cubit/location_cubit.dart';

import 'location_cubit_test.mocks.dart';

@GenerateMocks(<Type>[ILocationRepository])
void main() {
  late MockILocationRepository mockLocationRepository;

  setUp(() {
    mockLocationRepository = MockILocationRepository();
  });

  blocTest<LocationCubit, LocationState>(
    'emits [LocationLoadingState, LocationLoadedState] when getCurrentLocation method is called.',
    build: () {
      when(mockLocationRepository.getCurrentLocation(
              accuracy: anyNamed('accuracy'),
              distanceFilter: anyNamed('distanceFilter'),
              timeLimit: anyNamed('timeLimit')))
          .thenAnswer(
        (realInvocation) =>
            Future<Location>.value(Location(latitude: 0.0, longitude: 0.0)),
      );
      return LocationCubit(locationRepository: mockLocationRepository);
    },
    act: (LocationCubit cubit) => cubit.getCurrentLocation(),
    expect: () => <TypeMatcher<LocationState>>[
      const TypeMatcher<LocationLoadingState>(),
      const TypeMatcher<LocationLoadedState>()
    ],
  );

  blocTest<LocationCubit, LocationState>(
    'emits [LocationLoadingState, LocationAccessDeniedErrorState] when getCurrentLocation method is called.',
    build: () {
      when(mockLocationRepository.getCurrentLocation(
              accuracy: anyNamed('accuracy'),
              distanceFilter: anyNamed('distanceFilter'),
              timeLimit: anyNamed('timeLimit')))
          .thenAnswer(
        (realInvocation) =>
            Future<Location>.error(LocationPermissionDeniedError()),
      );
      return LocationCubit(locationRepository: mockLocationRepository);
    },
    act: (LocationCubit cubit) => cubit.getCurrentLocation(),
    expect: () => <TypeMatcher<LocationState>>[
      const TypeMatcher<LocationLoadingState>(),
      const TypeMatcher<LocationAccessDeniedErrorState>()
    ],
  );

  blocTest<LocationCubit, LocationState>(
    'emits [LocationLoadingState, LocationAccessDeniedForeverState] when getCurrentLocation method is called.',
    build: () {
      when(mockLocationRepository.getCurrentLocation(
              accuracy: anyNamed('accuracy'),
              distanceFilter: anyNamed('distanceFilter'),
              timeLimit: anyNamed('timeLimit')))
          .thenAnswer(
        (realInvocation) =>
            Future<Location>.error(LocationPermissionDeniedForeverError()),
      );
      return LocationCubit(locationRepository: mockLocationRepository);
    },
    act: (LocationCubit cubit) => cubit.getCurrentLocation(),
    expect: () => <TypeMatcher<LocationState>>[
      const TypeMatcher<LocationLoadingState>(),
      const TypeMatcher<LocationAccessDeniedForeverState>()
    ],
  );

  blocTest<LocationCubit, LocationState>(
    'emits [LocationLoadingState, GetLocationErrorSate] when getCurrentLocation method is called.',
    build: () {
      when(mockLocationRepository.getCurrentLocation(
              accuracy: anyNamed('accuracy'),
              distanceFilter: anyNamed('distanceFilter'),
              timeLimit: anyNamed('timeLimit')))
          .thenAnswer(
        (realInvocation) => Future<Location>.error(Error()),
      );
      return LocationCubit(locationRepository: mockLocationRepository);
    },
    act: (LocationCubit cubit) => cubit.getCurrentLocation(),
    expect: () => <TypeMatcher<LocationState>>[
      const TypeMatcher<LocationLoadingState>(),
      const TypeMatcher<GetLocationErrorSate>()
    ],
  );
}

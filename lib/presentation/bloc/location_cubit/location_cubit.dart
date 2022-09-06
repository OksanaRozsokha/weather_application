import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_application/common/errors/location_permission_denied_error.dart';
import 'package:weather_application/common/errors/location_permission_denied_forever_error.dart';
import 'package:weather_application/data/models/location.dart';
import 'package:weather_application/domain/contracts/location_repository_interface.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final ILocationRepository locationRepository;
  LocationCubit({required this.locationRepository})
      : super(GetLocationInitialState());

  void getCurrentLocation() {
    emit(LocationLoadingState());
    locationRepository.getCurrentLocation().then((Location location) {
      emit(
          LocationLoadedState(lat: location.latitude, lon: location.longitude));
    }).catchError((error) {
      switch (error.runtimeType) {
        case LocationPermissionDeniedError:
          emit(LocationAccessDeniedErrorState(
              message: (error as LocationPermissionDeniedError).message));
          break;
        case LocationPermissionDeniedForeverError:
          emit(LocationAccessDeniedForeverState(
              message:
                  (error as LocationPermissionDeniedForeverError).message));
          break;
        default:
          emit(GetLocationErrorSate());
      }
    });
  }
}

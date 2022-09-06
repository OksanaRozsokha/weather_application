part of 'location_cubit.dart';

@immutable
abstract class LocationState {}

class GetLocationInitialState extends LocationState {}

class LocationLoadingState extends LocationState {}

class LocationLoadedState extends LocationState {
  final double lat;
  final double lon;

  LocationLoadedState({required this.lat, required this.lon});
}

class LocationAccessDeniedErrorState extends LocationState {
  final String message;

  LocationAccessDeniedErrorState({required this.message});
}

class LocationAccessDeniedForeverState extends LocationState {
  final String message;

  LocationAccessDeniedForeverState({required this.message});
}

class GetLocationErrorSate extends LocationState {
  final String message;

  GetLocationErrorSate(
      {this.message =
          'Unable to get location. Please search your weather by city.'});
}

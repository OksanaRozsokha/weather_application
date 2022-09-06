class LocationPermissionDeniedForeverError extends Error {
  final String message;

  LocationPermissionDeniedForeverError(
      {this.message =
          'Location permissions are permanently denied, we cannot request permissions. Please search your weather by city.'});
}

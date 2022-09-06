class LocationPermissionDeniedError extends Error {
  final String message;

  LocationPermissionDeniedError(
      {this.message =
          'Location access denied error. Please provide access to your location or search your weather by city.'});
}

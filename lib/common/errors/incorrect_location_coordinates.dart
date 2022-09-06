import 'package:weather_application/common/errors/request_error.dart';

class IncorrectLocationCoordinatesError extends RequestError {
  IncorrectLocationCoordinatesError(
      {required super.statusCode, super.message, super.data});
}

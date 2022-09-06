import 'package:weather_application/common/errors/request_error.dart';

class CityNotFoundError extends RequestError {
  CityNotFoundError({
    required super.statusCode,
    super.data,
    super.message,
  });
}

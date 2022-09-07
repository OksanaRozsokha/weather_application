import 'package:flutter_test/flutter_test.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/weather_forecast_response.dart';

import '../../api/test_response_json.dart';

void main() {
  group('WeatherForecastResponse', () {
    test('WeatherForecastResponse equility test', () {
      WeatherForecastResponse weatherForecastResponse1 =
          WeatherForecastResponse.fromJson(testResponse);
      WeatherForecastResponse weatherForecastResponse2 =
          WeatherForecastResponse.fromJson(testResponse);

      expect(weatherForecastResponse1, weatherForecastResponse2);
      expect(
          weatherForecastResponse1.hashCode, weatherForecastResponse2.hashCode);
    });
  });
}

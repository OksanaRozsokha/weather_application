import 'package:flutter_test/flutter_test.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_response.dart';

import '../../api/test_response_json.dart';

void main() {
  group('WeatherForecastResponse', () {
    test('WeatherForecastResponse toJson() test', () {
      Map<String, dynamic> testResponseMap = testResponse;
      WeatherForecastResponse weatherForecastResponse =
          WeatherForecastResponse.fromJson(testResponseMap);

      expect(weatherForecastResponse.toJson(), testResponseMap);
    });

    test('WeatherForecastResponse equility test', () {
      Map<String, dynamic> testResponseMap = testResponse;
      WeatherForecastResponse weatherForecastResponse1 =
          WeatherForecastResponse.fromJson(testResponseMap);
      WeatherForecastResponse weatherForecastResponse2 =
          WeatherForecastResponse.fromJson(testResponseMap);

      expect(weatherForecastResponse1, weatherForecastResponse2);
      expect(
          weatherForecastResponse1.hashCode, weatherForecastResponse2.hashCode);
    });
  });
}

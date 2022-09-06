import 'package:weather_application/data/models/request/getWeatherForecastRequest.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_response.dart';

abstract class IWeatherForecastRepository {
  Future<WeatherForecastResponse> getWeatherForecast(
      {required GetWeatherForecastRequest request});
}

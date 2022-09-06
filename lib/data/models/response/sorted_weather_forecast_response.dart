import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_list.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_response.dart';

class SortedWeatherForecastResponse extends WeatherForecastResponse {
  final List<List<WeatherForecast>> sortedWeatherForecastList;
  SortedWeatherForecastResponse(
      {required this.sortedWeatherForecastList,
      required super.cod,
      required super.message,
      required super.cnt,
      required super.weatherForecastList,
      required super.city});

  factory SortedWeatherForecastResponse.create(
          {required List<List<WeatherForecast>> sortedList,
          required WeatherForecastResponse weatherForecastResponse}) =>
      SortedWeatherForecastResponse(
          sortedWeatherForecastList: sortedList,
          cod: weatherForecastResponse.cod,
          message: weatherForecastResponse.message,
          cnt: weatherForecastResponse.cnt,
          weatherForecastList: weatherForecastResponse.weatherForecastList,
          city: weatherForecastResponse.city);
}

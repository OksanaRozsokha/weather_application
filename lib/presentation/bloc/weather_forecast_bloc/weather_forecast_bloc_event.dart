part of 'weather_forecast_bloc.dart';

@immutable
abstract class WeatherForecastBlocEvent {}

class GetWeatherForecastEvent extends WeatherForecastBlocEvent {
  final String? cityName;
  final bool byCityName;
  final double? lat;
  final double? lon;

  GetWeatherForecastEvent(
      {this.cityName, this.byCityName = false, this.lat, this.lon});
}

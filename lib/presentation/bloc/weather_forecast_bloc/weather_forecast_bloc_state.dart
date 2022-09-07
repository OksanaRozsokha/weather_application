part of 'weather_forecast_bloc.dart';

@immutable
abstract class WeatherForecastBlocState {}

class WeatherForecastBlocInitialState extends WeatherForecastBlocState {}

class WeatherForecastLoadingState extends WeatherForecastBlocState {}

class WeatherForecastLoadedState extends WeatherForecastBlocState {
  final WeatherForecastResponse weatherForecastResponse;

  WeatherForecastLoadedState({required this.weatherForecastResponse});
}

class WeatherForecastCityNotFoundErrorState extends WeatherForecastBlocState {
  final String message;

  WeatherForecastCityNotFoundErrorState({required this.message});
}

class WeatherForecastLocationAccessDeniedState
    extends WeatherForecastBlocState {}

class WeatherForecastIncorectLocationCoordinatesState
    extends WeatherForecastBlocState {}

class WeatherForecastGetLocationErrorState extends WeatherForecastBlocState {}

class WeatherForecastRequestErrorState extends WeatherForecastBlocState {}

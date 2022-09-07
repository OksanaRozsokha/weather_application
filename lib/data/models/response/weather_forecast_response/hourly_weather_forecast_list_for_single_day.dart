// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:weather_application/data/models/response/weather_forecast_response/weather_forecast_list.dart';

class SingleDayWeatherForecastList {
  final List<WeatherForecast> hourlyWeatherForecastList;

  SingleDayWeatherForecastList({required this.hourlyWeatherForecastList});

  factory SingleDayWeatherForecastList.create(
          List<WeatherForecast> chunkedWeatherForecastList) =>
      SingleDayWeatherForecastList(
          hourlyWeatherForecastList: chunkedWeatherForecastList);

  @override
  bool operator ==(covariant SingleDayWeatherForecastList other) {
    if (identical(this, other)) return true;

    return listEquals(
        other.hourlyWeatherForecastList, hourlyWeatherForecastList);
  }

  @override
  int get hashCode => hashList(hourlyWeatherForecastList);
}

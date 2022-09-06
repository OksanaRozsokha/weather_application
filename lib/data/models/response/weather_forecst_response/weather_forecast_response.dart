import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:weather_application/data/models/response/abstract_response.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/city.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_list.dart';

class WeatherForecastResponse extends AbstractResponse {
  String cod;
  int message;
  int cnt;
  List<WeatherForecast> weatherForecastList;
  City city;

  WeatherForecastResponse(
      {required this.cod,
      required this.message,
      required this.cnt,
      required this.weatherForecastList,
      required this.city});

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) =>
      WeatherForecastResponse(
          cod: json['cod'],
          message: json['message'],
          cnt: json['cnt'],
          weatherForecastList: (json['list'] as List<dynamic>)
              .map((json) => WeatherForecast.fromJson(json))
              .toList(),
          city: City.fromJson(json['city']));

  Map<String, dynamic> toJson() => {
        'cod': cod,
        'message': message,
        'cnt': cnt,
        'list': weatherForecastList
            .map((weatherForecastElem) => weatherForecastElem.toJson())
            .toList(),
        'city': city.toJson(),
      };

  @override
  bool operator ==(covariant WeatherForecastResponse other) {
    if (identical(this, other)) return true;

    return other.cod == cod &&
        other.message == message &&
        other.cnt == cnt &&
        listEquals(other.weatherForecastList, weatherForecastList) &&
        other.city == city;
  }

  @override
  int get hashCode =>
      hashValues(cod, message, cnt, hashList(weatherForecastList), city);
}

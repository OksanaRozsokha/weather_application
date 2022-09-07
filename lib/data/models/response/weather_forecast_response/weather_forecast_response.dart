// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_application/data/models/response/abstract_response.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/city.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/hourly_weather_forecast_list_for_single_day.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/weather_forecast_list.dart';

class WeatherForecastResponse extends AbstractResponse {
  String cod;
  int message;
  int cnt;
  List<SingleDayWeatherForecastList> dailyWeatherForecastList;
  City city;

  WeatherForecastResponse(
      {required this.cod,
      required this.message,
      required this.cnt,
      required this.dailyWeatherForecastList,
      required this.city});

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) {
    List<WeatherForecast> defaultWeatherForecastList =
        (json['list'] as List<dynamic>)
            .map((json) => WeatherForecast.fromJson(json))
            .toList();
    return WeatherForecastResponse(
        cod: json['cod'],
        message: json['message'],
        cnt: json['cnt'],
        dailyWeatherForecastList:
            sortWeatherForecastListByDate(defaultWeatherForecastList)
                .map((List<WeatherForecast> sortedWeatherForecastSubList) =>
                    SingleDayWeatherForecastList.create(
                        sortedWeatherForecastSubList))
                .toList(),
        city: City.fromJson(json['city']));
  }

  @visibleForTesting
  static List<List<WeatherForecast>> sortWeatherForecastListByDate(
      List<WeatherForecast> weatherForecastList) {
    List<List<WeatherForecast>> sortedWeatherForecastList =
        <List<WeatherForecast>>[];
    List<WeatherForecast> weatherForecastSortedChunk = <WeatherForecast>[];
    WeatherForecast currentWeatherForecastValue = weatherForecastList[0];
    int i = 0;

    for (WeatherForecast weatherForecastItem in weatherForecastList) {
      i++;
      if (weatherForecastItem.dtTxt!.substring(0, 10) ==
          currentWeatherForecastValue.dtTxt!.substring(0, 10)) {
        weatherForecastSortedChunk.add(weatherForecastItem);
        currentWeatherForecastValue = weatherForecastItem;
        if (i == weatherForecastList.length) {
          sortedWeatherForecastList.add(weatherForecastSortedChunk);
        }
      } else {
        sortedWeatherForecastList.add(weatherForecastSortedChunk);
        weatherForecastSortedChunk = <WeatherForecast>[];
        weatherForecastSortedChunk.add(weatherForecastItem);
        currentWeatherForecastValue = weatherForecastItem;
      }
    }

    return sortedWeatherForecastList;
  }

  @override
  int get hashCode =>
      hashValues(cod, message, cnt, hashList(dailyWeatherForecastList), city);

  @override
  bool operator ==(covariant WeatherForecastResponse other) {
    if (identical(this, other)) return true;

    return other.cod == cod &&
        other.message == message &&
        other.cnt == cnt &&
        listEquals(other.dailyWeatherForecastList, dailyWeatherForecastList) &&
        other.city == city;
  }
}

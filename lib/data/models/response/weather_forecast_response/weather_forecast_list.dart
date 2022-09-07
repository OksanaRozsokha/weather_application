import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/clouds.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/main_indicators.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/sys.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/weather.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/wind.dart';

class WeatherForecast {
  int dt;
  MainIndicators mainIndicators;
  List<Weather> weather;
  Clouds clouds;
  Wind wind;
  int visibility;
  double pop;
  Sys sys;
  String? dtTxt;

  WeatherForecast(
      {required this.dt,
      required this.mainIndicators,
      required this.weather,
      required this.clouds,
      required this.wind,
      required this.visibility,
      required this.pop,
      required this.sys,
      required this.dtTxt});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      WeatherForecast(
          dt: json['dt'],
          mainIndicators: MainIndicators.fromJson(json['main']),
          weather: (json['weather'] as List<dynamic>)
              .map((json) => Weather.fromJson(json))
              .toList(),
          clouds: Clouds.fromJson(json['clouds']),
          wind: Wind.fromJson(json['wind']),
          visibility: json['visibility'],
          pop: json['pop'].toDouble(),
          sys: Sys.fromJson(json['sys']),
          dtTxt: json['dt_txt']);

  @override
  bool operator ==(covariant WeatherForecast other) {
    if (identical(this, other)) return true;

    return other.dt == dt &&
        other.mainIndicators == mainIndicators &&
        listEquals(other.weather, weather) &&
        other.clouds == clouds &&
        other.wind == wind &&
        other.visibility == visibility &&
        other.pop == pop &&
        other.sys == sys &&
        other.dtTxt == dtTxt;
  }

  @override
  int get hashCode => hashValues(
        dt,
        mainIndicators,
        hashList(weather),
        clouds,
        wind,
        visibility,
        pop,
        sys,
        dtTxt,
      );
}

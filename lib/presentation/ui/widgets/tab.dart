import 'package:flutter/material.dart';
import 'package:weather_application/common/utils/dates_operations.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/hourly_weather_forecast_list_for_single_day.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/weather_forecast_list.dart';
import 'package:weather_application/settings.dart';

class TabWidget extends StatelessWidget {
  final SingleDayWeatherForecastList singleDayweatherForecastList;
  const TabWidget({Key? key, required this.singleDayweatherForecastList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildTab();
  }

  Widget _buildTab() {
    WeatherForecast weatherForecastItem =
        singleDayweatherForecastList.hourlyWeatherForecastList[0];
    DateTime weatherForecastDate = DateTime.parse(weatherForecastItem.dtTxt!);
    String weekDayShortName =
        DatesOperations.weekDayIntToWeekDayName(weatherForecastDate.weekday)
            .substring(0, 3);
    String monthShortName =
        DatesOperations.monthIntToMonthName(weatherForecastDate.month)
            .substring(0, 3);

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(right: 5),
      child: Tab(
        text: '$weekDayShortName, $monthShortName ${weatherForecastDate.day}',
        icon: Image.network(_getImageUrl()),
        iconMargin: const EdgeInsets.only(bottom: 5),
      ),
    );
  }

  String _getImageUrl() {
    WeatherForecast afternoonOrFirstWeatherForecastItem =
        singleDayweatherForecastList.hourlyWeatherForecastList.firstWhere(
            (element) => element.dtTxt!.substring(10, 16).trim() == '12:00',
            orElse: () =>
                singleDayweatherForecastList.hourlyWeatherForecastList[0]);

    return '${Settings.imagesUrl}${afternoonOrFirstWeatherForecastItem.weather[0].icon}.png';
  }
}

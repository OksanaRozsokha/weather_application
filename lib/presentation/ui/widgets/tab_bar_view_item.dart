import 'package:flutter/material.dart';
import 'package:weather_application/common/extensions/string_extension.dart';
import 'package:weather_application/common/utils/dates_operations.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/hourly_weather_forecast_list_for_single_day.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/weather_forecast_list.dart';
import 'package:weather_application/settings.dart';

class TabBarViewItem extends StatelessWidget {
  final SingleDayWeatherForecastList singleDayweatherForecastList;
  const TabBarViewItem({Key? key, required this.singleDayweatherForecastList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildMainView(),
        const SizedBox(
          height: 20,
        ),
        _buildHourlyListView(),
      ],
    );
  }

  Widget _buildMainView() {
    WeatherForecast afternoonOrFirstWeatherForecastItem =
        singleDayweatherForecastList.hourlyWeatherForecastList.firstWhere(
            (element) => element.dtTxt!.substring(10, 16).trim() == '12:00',
            orElse: () =>
                singleDayweatherForecastList.hourlyWeatherForecastList[0]);

    DateTime weatherForecastDate =
        DateTime.parse(afternoonOrFirstWeatherForecastItem.dtTxt!);

    String weekDayName =
        DatesOperations.weekDayIntToWeekDayName(weatherForecastDate.weekday);
    String monthName =
        DatesOperations.monthIntToMonthName(weatherForecastDate.month);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Image.network(_getImageUrl(
                  weatherForecastItem: afternoonOrFirstWeatherForecastItem,
                  imageSizeString: '@4x'))),
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$weekDayName, $monthName ${weatherForecastDate.day}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${afternoonOrFirstWeatherForecastItem.mainIndicators.temp.round()}°C',
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: Text(
                        'Feels like:',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        ' ${afternoonOrFirstWeatherForecastItem.mainIndicators.feelsLike.round()}°C',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                    afternoonOrFirstWeatherForecastItem.weather[0].description
                        .capitalize(),
                    style: const TextStyle(
                      fontSize: 16,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _getImageUrl(
      {required WeatherForecast weatherForecastItem,
      required String imageSizeString}) {
    return '${Settings.imagesUrl}${weatherForecastItem.weather[0].icon}$imageSizeString.png';
  }

  Widget _buildHourlyListView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 330,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            WeatherForecast weatherForecastItem =
                singleDayweatherForecastList.hourlyWeatherForecastList[index];

            return Center(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 175, 81, 81),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Text(
                      weatherForecastItem.dtTxt!.substring(10, 16),
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white60),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${weatherForecastItem.mainIndicators.temp.round()}°C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.network(_getImageUrl(
                        weatherForecastItem: weatherForecastItem,
                        imageSizeString: '@2x')),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextRow(
                            title: 'Feels like:',
                            value:
                                '${weatherForecastItem.mainIndicators.feelsLike.round()}°C'),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildTextRow(
                            title: 'Min:',
                            value:
                                '${weatherForecastItem.mainIndicators.tempMin.round()}°C'),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildTextRow(
                            title: 'Max:',
                            value:
                                '${weatherForecastItem.mainIndicators.tempMax.round()}°C'),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildTextRow(
                            title: 'Humidity:',
                            value:
                                '${weatherForecastItem.mainIndicators.humidity}%'),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildTextRow(
                            title: '',
                            value: weatherForecastItem.weather[0].description
                                .capitalize()),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          itemCount:
              singleDayweatherForecastList.hourlyWeatherForecastList.length),
    );
  }

  Widget _buildTextRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white60),
          ),
        if (title.isNotEmpty)
          const SizedBox(
            width: 5,
          ),
        Text(value,
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold))
      ],
    );
  }
}

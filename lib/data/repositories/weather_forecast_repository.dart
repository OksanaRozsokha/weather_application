import 'package:flutter/cupertino.dart';
import 'package:weather_application/common/errors/city_not_found_error.dart';
import 'package:weather_application/common/errors/incorrect_location_coordinates.dart';
import 'package:weather_application/common/errors/request_error.dart';
import 'package:weather_application/data/api/api_config.dart';
import 'package:weather_application/data/api/api_handler.dart';
import 'package:weather_application/data/models/response/sorted_weather_forecast_response.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_list.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_response.dart';
import 'package:weather_application/data/models/request/getWeatherForecastRequest.dart';
import 'package:weather_application/domain/contracts/weather_forecast_repository_interface.dart';

class WeatherForecastRepository implements IWeatherForecastRepository {
  final ApiHandler apiHandler;

  WeatherForecastRepository({required this.apiHandler});

  @override
  Future<WeatherForecastResponse> getWeatherForecast(
      {required GetWeatherForecastRequest request}) async {
    return await apiHandler.peformingRequest<WeatherForecastResponse,
            GetWeatherForecastRequest, RequestError>(
        request: request,
        endpointType: EndpointType.getWeatherForecast,
        jsonToResponseBuilder: (Map<String, dynamic> json) {
          WeatherForecastResponse weatherForecastResponse =
              WeatherForecastResponse.fromJson(json);
          return SortedWeatherForecastResponse.create(
              sortedList: sortWeatherForecastListByDate(
                  weatherForecastResponse.weatherForecastList),
              weatherForecastResponse: weatherForecastResponse);
        },
        errorBuilder: (RequestError requestError) {
          switch (requestError.statusCode) {
            case 404:
              return CityNotFoundError(
                statusCode: requestError.statusCode,
                message: requestError.message,
              );
            case 400:
              return IncorrectLocationCoordinatesError(
                  statusCode: requestError.statusCode,
                  message: requestError.message,
                  data: requestError.data);
            default:
              return requestError;
          }
        });
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
}

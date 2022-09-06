import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:weather_application/common/errors/incorrect_location_coordinates.dart';
import 'package:weather_application/common/errors/city_not_found_error.dart';
import 'package:weather_application/common/errors/request_error.dart';
import 'package:weather_application/data/api/api_config.dart';
import 'package:weather_application/data/api/api_handler.dart';
import 'package:weather_application/data/models/request/getWeatherForecastRequest.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_response.dart';
import 'package:weather_application/data/repositories/weather_forecast_repository.dart';

import '../api/test_response_json.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiHandler apiHandler;
  late ApiConfig apiConfig;

  group('Weather Forecast repository', () {
    setUp(() {
      apiConfig = ApiConfig(
          baseUrl: 'https://baseUrl', endpoints: DefaultApiConfig.endpoints);
      dio = Dio(BaseOptions(baseUrl: apiConfig.baseUrl));
      dioAdapter = DioAdapter(dio: dio);
      apiHandler =
          ApiHandler(apiConfig: apiConfig, httpClientAdapter: dioAdapter);
    });
    test('Get weather forecast response', () async {
      GetWeatherForecastRequest request = GetWeatherForecastRequest(
          byCityName: false, lat: 49.442875, lon: 32.0771775);

      dioAdapter
          .onGet(apiConfig.endpoints[EndpointType.getWeatherForecast]!.route,
              (server) {
        return server.reply(200, testResponse);
      },
              queryParameters: request.queryParamsToMap(),
              data: request.bodyParamsToMap());

      final WeatherForecastRepository weatherForecastRepository =
          WeatherForecastRepository(apiHandler: apiHandler);

      final Future<WeatherForecastResponse> weatherForecastResponse =
          weatherForecastRepository.getWeatherForecast(request: request);

      expect(weatherForecastResponse,
          completion(const TypeMatcher<WeatherForecastResponse>()));
    });

    test('test 404 the city is not found error', () async {
      GetWeatherForecastRequest request =
          GetWeatherForecastRequest(byCityName: true, cityName: 'testName');

      dioAdapter
          .onGet(apiConfig.endpoints[EndpointType.getWeatherForecast]!.route,
              (server) {
        return server
            .reply(404, <String, dynamic>{'message': 'city is not found'});
      },
              queryParameters: request.queryParamsToMap(),
              data: request.bodyParamsToMap());

      final WeatherForecastRepository weatherForecastRepository =
          WeatherForecastRepository(apiHandler: apiHandler);

      final Future<WeatherForecastResponse> weatherForecastResponse =
          weatherForecastRepository.getWeatherForecast(request: request);

      expect(weatherForecastResponse,
          throwsA(const TypeMatcher<CityNotFoundError>()));
    });

    test('test 400 Incorrect location coordinates error', () async {
      GetWeatherForecastRequest request = GetWeatherForecastRequest(
          byCityName: false, lat: 0.23323, lon: 0.000);

      dioAdapter
          .onGet(apiConfig.endpoints[EndpointType.getWeatherForecast]!.route,
              (server) {
        return server.reply(400,
            <String, dynamic>{'message': 'incorrect location coordinates'});
      },
              queryParameters: request.queryParamsToMap(),
              data: request.bodyParamsToMap());

      final WeatherForecastRepository weatherForecastRepository =
          WeatherForecastRepository(apiHandler: apiHandler);

      final Future<WeatherForecastResponse> weatherForecastResponse =
          weatherForecastRepository.getWeatherForecast(request: request);

      expect(weatherForecastResponse,
          throwsA(const TypeMatcher<IncorrectLocationCoordinatesError>()));
    });

    test('test 500 Request error', () async {
      GetWeatherForecastRequest request = GetWeatherForecastRequest(
          byCityName: false, lat: 0.23323, lon: 0.000);

      dioAdapter
          .onGet(apiConfig.endpoints[EndpointType.getWeatherForecast]!.route,
              (server) {
        return server.reply(500, null);
      },
              queryParameters: request.queryParamsToMap(),
              data: request.bodyParamsToMap());

      final WeatherForecastRepository weatherForecastRepository =
          WeatherForecastRepository(apiHandler: apiHandler);

      final Future<WeatherForecastResponse> weatherForecastResponse =
          weatherForecastRepository.getWeatherForecast(request: request);

      expect(
          weatherForecastResponse, throwsA(const TypeMatcher<RequestError>()));
    });
  });
}

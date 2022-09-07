import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:weather_application/common/errors/request_error.dart';
import 'package:weather_application/data/api/api_config.dart';
import 'package:weather_application/data/api/api_endpoint.dart';
import 'package:weather_application/data/api/api_handler.dart';
import 'package:weather_application/data/models/request/getWeatherForecastRequest.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/weather_forecast_response.dart';

import 'test_response_json.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late ApiHandler apiHandler;
  late ApiConfig apiConfig;

  group('API handler', () {
    setUp(() {
      apiConfig = ApiConfig(
          baseUrl: 'https://localhost', endpoints: DefaultApiConfig.endpoints);
      dio = Dio(BaseOptions(baseUrl: apiConfig.baseUrl));
      dioAdapter = DioAdapter(dio: dio);
      apiHandler =
          ApiHandler(apiConfig: apiConfig, httpClientAdapter: dioAdapter);
    });
    test('GET request - weather forecast, correct response', () async {
      GetWeatherForecastRequest request =
          GetWeatherForecastRequest(cityName: 'Cherkasy', byCityName: true);
      dioAdapter
          .onGet(apiConfig.endpoints[EndpointType.getWeatherForecast]!.route,
              (server) {
        return server.reply(200, testResponse);
      },
              queryParameters: request.queryParamsToMap(),
              data: request.bodyParamsToMap());
      final Future<WeatherForecastResponse> response =
          apiHandler.peformingRequest<WeatherForecastResponse,
                  GetWeatherForecastRequest, RequestError>(
              request: request,
              endpointType: EndpointType.getWeatherForecast,
              jsonToResponseBuilder: (Map<String, dynamic> json) =>
                  WeatherForecastResponse.fromJson(json));

      expect(response, completion(isA<WeatherForecastResponse>()));
    });

    test('GET request - weather forecast, error', () async {
      GetWeatherForecastRequest request =
          GetWeatherForecastRequest(cityName: 'Cherkasy', byCityName: true);
      dioAdapter
          .onGet(apiConfig.endpoints[EndpointType.getWeatherForecast]!.route,
              (server) {
        return server.reply(500, null);
      },
              queryParameters: request.queryParamsToMap(),
              data: request.bodyParamsToMap());
      final Future<WeatherForecastResponse> response =
          apiHandler.peformingRequest<WeatherForecastResponse,
              GetWeatherForecastRequest, RequestError>(
        request: request,
        endpointType: EndpointType.getWeatherForecast,
        jsonToResponseBuilder: (Map<String, dynamic> json) =>
            WeatherForecastResponse.fromJson(json),
      );

      expect(response, throwsA(const TypeMatcher<RequestError>()));
    });

    test('GET request - weather forecast, error with message field', () async {
      GetWeatherForecastRequest request =
          GetWeatherForecastRequest(cityName: 'Cherkasy', byCityName: true);
      dioAdapter
          .onGet(apiConfig.endpoints[EndpointType.getWeatherForecast]!.route,
              (server) {
        return server
            .reply(400, <String, dynamic>{'message': 'some test message'});
      },
              queryParameters: request.queryParamsToMap(),
              data: request.bodyParamsToMap());
      final Future<WeatherForecastResponse> response =
          apiHandler.peformingRequest<WeatherForecastResponse,
              GetWeatherForecastRequest, RequestError>(
        request: request,
        endpointType: EndpointType.getWeatherForecast,
        jsonToResponseBuilder: (Map<String, dynamic> json) =>
            WeatherForecastResponse.fromJson(json),
      );

      expect(response, throwsA(predicate<RequestError>((RequestError error) {
        final Map<String, dynamic>? data = error.data;
        if (data != null) {
          if (data.containsKey('message') &&
              data['message'] == 'some test message') {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      })));
    });

    test('GET request - weather forecast, error passed to error builder',
        () async {
      GetWeatherForecastRequest request =
          GetWeatherForecastRequest(cityName: 'Cherkasy', byCityName: true);
      dioAdapter
          .onGet(apiConfig.endpoints[EndpointType.getWeatherForecast]!.route,
              (server) {
        return server.reply(500, null);
      },
              queryParameters: request.queryParamsToMap(),
              data: request.bodyParamsToMap());
      final Future<WeatherForecastResponse> response =
          apiHandler.peformingRequest<WeatherForecastResponse,
                  GetWeatherForecastRequest, RequestError>(
              request: request,
              endpointType: EndpointType.getWeatherForecast,
              jsonToResponseBuilder: (Map<String, dynamic> json) =>
                  WeatherForecastResponse.fromJson(json),
              errorBuilder: (RequestError requestError) =>
                  RequestError(statusCode: requestError.statusCode));

      expect(response, throwsA(const TypeMatcher<RequestError>()));
    });

    test('Unimplemented error on unimplemented request method', () async {
      final Map<EndpointType, ApiEndpoint> fakeEndpoints =
          <EndpointType, ApiEndpoint>{
        EndpointType.getWeatherForecast: ApiEndpoint(
            route: '/randomRoute', requestMethod: RequestMethod.delete)
      };

      final ApiConfig apiConfigWithFakeEndpoints =
          ApiConfig(endpoints: fakeEndpoints, baseUrl: 'https"//baseUrl');
      GetWeatherForecastRequest request =
          GetWeatherForecastRequest(cityName: 'Cherkasy', byCityName: true);
      final ApiHandler apiHandlerWithFakeEndpoints =
          ApiHandler(apiConfig: apiConfigWithFakeEndpoints);

      final Future<WeatherForecastResponse> response =
          apiHandlerWithFakeEndpoints.peformingRequest<WeatherForecastResponse,
                  GetWeatherForecastRequest, RequestError>(
              request: request,
              endpointType: EndpointType.getWeatherForecast,
              jsonToResponseBuilder: (Map<String, dynamic> json) =>
                  WeatherForecastResponse.fromJson(json),
              errorBuilder: (RequestError requestError) =>
                  RequestError(statusCode: requestError.statusCode));
      expect(response, throwsA(const TypeMatcher<UnimplementedError>()));
    });
  });
}

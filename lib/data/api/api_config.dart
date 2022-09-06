import 'package:weather_application/data/api/api_endpoint.dart';
import 'package:weather_application/settings.dart';

class ApiConfig {
  late Map<EndpointType, ApiEndpoint> endpoints;
  late String baseUrl;

  ApiConfig({
    Map<EndpointType, ApiEndpoint>? endpoints,
    this.baseUrl = Settings.baseUrl,
  }) {
    this.endpoints = endpoints ?? DefaultApiConfig.endpoints;
  }
}

class DefaultApiConfig {
  static Map<EndpointType, ApiEndpoint> endpoints = {
    EndpointType.getWeatherForecast: ApiEndpoint(
        route: '/data/2.5/forecast', requestMethod: RequestMethod.get)
  };
}

enum EndpointType { getWeatherForecast }

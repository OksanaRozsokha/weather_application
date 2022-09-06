import 'package:weather_application/data/models/request/abstract_request.dart';
import 'package:weather_application/settings.dart';

class GetWeatherForecastRequest extends AbstractRequest {
  final String? cityName;
  final double? lat;
  final double? lon;
  final bool byCityName;

  GetWeatherForecastRequest(
      {this.cityName, this.lat, this.lon, this.byCityName = false});

  @override
  Map<String, dynamic>? queryParamsToMap() {
    Map<String, dynamic> queryParamsMap = {
      'appId': Settings.apiKey,
      'units': 'metric'
    };
    if (byCityName) {
      queryParamsMap['q'] = cityName;
    } else {
      queryParamsMap['lat'] = lat;
      queryParamsMap['lon'] = lon;
    }

    return queryParamsMap;
  }

  @override
  Map<String, dynamic>? bodyParamsToMap() {
    return null;
  }
}

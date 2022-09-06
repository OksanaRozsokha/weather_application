import 'package:dio/dio.dart';
import 'package:weather_application/common/errors/request_error.dart';
import 'package:weather_application/data/api/api_config.dart';
import 'package:weather_application/data/api/api_endpoint.dart';
import 'package:weather_application/data/models/request/abstract_request.dart';
import 'package:weather_application/data/models/response/abstract_response.dart';

class ApiHandler {
  late Dio dio;
  final HttpClientAdapter? httpClientAdapter;
  final ApiConfig apiConfig;

  ApiHandler({this.httpClientAdapter, required this.apiConfig}) {
    dio = Dio(BaseOptions(baseUrl: apiConfig.baseUrl));

    if (httpClientAdapter != null) {
      dio.httpClientAdapter = httpClientAdapter!;
    }
  }

  Future<K> peformingRequest<K extends AbstractResponse,
          T extends AbstractRequest, Z extends RequestError>(
      {required T request,
      required EndpointType endpointType,
      required K Function(Map<String, dynamic> json) jsonToResponseBuilder,
      Z Function(RequestError requestError)? errorBuilder}) async {
    switch (apiConfig.endpoints[endpointType]!.requestMethod) {
      case RequestMethod.get:
        return await _getRequest(
            request: request,
            endpointType: endpointType,
            jsonToResponseBuilder: jsonToResponseBuilder,
            errorBuilder: errorBuilder);
      // Can also add post, put, delete etc. cases here if needed

      default:
        throw UnimplementedError();
    }
  }

  Future<K> _getRequest<K extends AbstractResponse, T extends AbstractRequest,
          Z extends RequestError>(
      {required T request,
      required EndpointType endpointType,
      required K Function(Map<String, dynamic> json) jsonToResponseBuilder,
      Z Function(RequestError requestError)? errorBuilder}) async {
    try {
      Response response = await dio.get(
          apiConfig.endpoints[endpointType]!.route,
          queryParameters: request.queryParamsToMap());

      return jsonToResponseBuilder(response.data);
    } on DioError catch (error) {
      throw errorBuilder?.call(_dioErrorToRequestError(error)) ??
          _dioErrorToRequestError(error);
    }
  }

  RequestError _dioErrorToRequestError(DioError error) {
    return RequestError(
        statusCode: error.response?.statusCode ?? 500,
        message: error.response?.data is Map<String, dynamic> &&
                (error.response?.data as Map<String, dynamic>)
                    .containsKey('message')
            ? (error.response!.data as Map<String, dynamic>)['message']
            : null,
        data: error.response?.data is Map<String, dynamic>
            ? error.response!.data
            : null);
  }
}

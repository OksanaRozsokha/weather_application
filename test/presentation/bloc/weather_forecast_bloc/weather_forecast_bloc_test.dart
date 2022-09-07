import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_application/common/errors/city_not_found_error.dart';
import 'package:weather_application/common/errors/incorrect_location_coordinates.dart';
import 'package:weather_application/common/errors/request_error.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/weather_forecast_response.dart';
import 'package:weather_application/domain/contracts/weather_forecast_repository_interface.dart';
import 'package:weather_application/presentation/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';

import '../../../data/api/test_response_json.dart';
import 'weather_forecast_bloc_test.mocks.dart';

@GenerateMocks(<Type>[IWeatherForecastRepository])
void main() {
  late MockIWeatherForecastRepository mockWeatherForecastRepository;
  late WeatherForecastResponse weatherForecastResponse;
  setUp(() {
    mockWeatherForecastRepository = MockIWeatherForecastRepository();
    weatherForecastResponse = WeatherForecastResponse.fromJson(testResponse);
  });

  blocTest<WeatherForecastBloc, WeatherForecastBlocState>(
    'emits [WeatherForecastLoadingState, WeatherForecastLoadedState] when GetWeatherForecastEvent is added.',
    build: () {
      when(mockWeatherForecastRepository.getWeatherForecast(
              request: anyNamed('request')))
          .thenAnswer(
        (realInvocation) =>
            Future<WeatherForecastResponse>.value(weatherForecastResponse),
      );
      return WeatherForecastBloc(
          weatherForecastRepository: mockWeatherForecastRepository);
    },
    act: (WeatherForecastBloc bloc) => bloc
        .add(GetWeatherForecastEvent(byCityName: true, cityName: 'Cherkasy')),
    expect: () => <TypeMatcher<WeatherForecastBlocState>>[
      const TypeMatcher<WeatherForecastLoadingState>(),
      const TypeMatcher<WeatherForecastLoadedState>()
    ],
  );

  blocTest<WeatherForecastBloc, WeatherForecastBlocState>(
    'emits [WeatherForecastLoadingState, WeatherForecastIncorectLocationCoordinatesState] when GetWeatherForecastEvent is added.',
    build: () {
      when(mockWeatherForecastRepository.getWeatherForecast(
              request: anyNamed('request')))
          .thenAnswer(
        (realInvocation) => Future<WeatherForecastResponse>.error(
            IncorrectLocationCoordinatesError(statusCode: 400)),
      );
      return WeatherForecastBloc(
          weatherForecastRepository: mockWeatherForecastRepository);
    },
    act: (WeatherForecastBloc bloc) => bloc
        .add(GetWeatherForecastEvent(byCityName: true, cityName: 'Cherkasy')),
    expect: () => <TypeMatcher<WeatherForecastBlocState>>[
      const TypeMatcher<WeatherForecastLoadingState>(),
      const TypeMatcher<WeatherForecastIncorectLocationCoordinatesState>()
    ],
  );

  blocTest<WeatherForecastBloc, WeatherForecastBlocState>(
    'emits [WeatherForecastLoadingState, WeatherForecastCityNotFoundErrorState] when GetWeatherForecastEvent is added.',
    build: () {
      when(mockWeatherForecastRepository.getWeatherForecast(
              request: anyNamed('request')))
          .thenAnswer(
        (realInvocation) => Future<WeatherForecastResponse>.error(
            CityNotFoundError(statusCode: 404, message: 'test')),
      );
      return WeatherForecastBloc(
          weatherForecastRepository: mockWeatherForecastRepository);
    },
    act: (WeatherForecastBloc bloc) => bloc
        .add(GetWeatherForecastEvent(byCityName: true, cityName: 'Cherkasy')),
    expect: () => <TypeMatcher<WeatherForecastBlocState>>[
      const TypeMatcher<WeatherForecastLoadingState>(),
      const TypeMatcher<WeatherForecastCityNotFoundErrorState>()
    ],
  );

  blocTest<WeatherForecastBloc, WeatherForecastBlocState>(
    'emits [WeatherForecastLoadingState, WeatherForecastRequestErrorState] when GetWeatherForecastEvent is added.',
    build: () {
      when(mockWeatherForecastRepository.getWeatherForecast(
              request: anyNamed('request')))
          .thenAnswer(
        (realInvocation) => Future<WeatherForecastResponse>.error(RequestError(
          statusCode: 500,
        )),
      );
      return WeatherForecastBloc(
          weatherForecastRepository: mockWeatherForecastRepository);
    },
    act: (WeatherForecastBloc bloc) => bloc
        .add(GetWeatherForecastEvent(byCityName: true, cityName: 'Cherkasy')),
    expect: () => <TypeMatcher<WeatherForecastBlocState>>[
      const TypeMatcher<WeatherForecastLoadingState>(),
      const TypeMatcher<WeatherForecastRequestErrorState>()
    ],
  );
}

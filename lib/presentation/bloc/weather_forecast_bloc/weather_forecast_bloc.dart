import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_application/common/errors/city_not_found_error.dart';
import 'package:weather_application/common/errors/incorrect_location_coordinates.dart';
import 'package:weather_application/data/models/request/getWeatherForecastRequest.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_response.dart';
import 'package:weather_application/domain/contracts/weather_forecast_repository_interface.dart';

part 'weather_forecast_bloc_event.dart';
part 'weather_forecast_bloc_state.dart';

class WeatherForecastBloc
    extends Bloc<WeatherForecastBlocEvent, WeatherForecastBlocState> {
  final IWeatherForecastRepository weatherForecastRepository;
  WeatherForecastBloc({
    required this.weatherForecastRepository,
  }) : super(WeatherForecastBlocInitialState()) {
    on<GetWeatherForecastEvent>((GetWeatherForecastEvent event,
        Emitter<WeatherForecastBlocState> emit) async {
      emit(WeatherForecastLoadingState());
      GetWeatherForecastRequest weatherForecastRequest =
          GetWeatherForecastRequest(
              byCityName: event.byCityName,
              cityName: event.cityName,
              lon: event.lon,
              lat: event.lat);
      try {
        WeatherForecastResponse weatherForecastResponse =
            await weatherForecastRepository.getWeatherForecast(
                request: weatherForecastRequest);

        emit(WeatherForecastLoadedState(
            sortedWeatherForecastResponse: weatherForecastResponse));
      } catch (error) {
        switch (error.runtimeType) {
          case IncorrectLocationCoordinatesError:
            emit(WeatherForecastIncorectLocationCoordinatesState());
            break;
          case CityNotFoundError:
            emit(WeatherForecastCityNotFoundErrorState(
                message: (error as CityNotFoundError).message ??
                    'city is not found'));
            break;
          default:
            emit(WeatherForecastRequestErrorState());
        }
      }
    });
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_application/common/library_wrappers/geolocator_wrapper.dart';
import 'package:weather_application/data/api/api_config.dart';
import 'package:weather_application/data/api/api_handler.dart';
import 'package:weather_application/data/repositories/location_repository.dart';
import 'package:weather_application/data/repositories/weather_forecast_repository.dart';
import 'package:weather_application/domain/contracts/location_repository_interface.dart';
import 'package:weather_application/domain/contracts/weather_forecast_repository_interface.dart';
import 'package:weather_application/presentation/bloc/location_cubit/location_cubit.dart';
import 'package:weather_application/presentation/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';

final GetIt injector = GetIt.instance;

Future<void> init() async {
  // BLoC // Cubit
  injector.registerFactory<WeatherForecastBloc>(() => WeatherForecastBloc(
        weatherForecastRepository: injector(),
      ));
  injector.registerFactory<LocationCubit>(
      () => LocationCubit(locationRepository: injector()));

  // Repositories
  injector.registerLazySingleton<IWeatherForecastRepository>(
      () => WeatherForecastRepository(apiHandler: injector()));
  injector.registerLazySingleton<ILocationRepository>(
      () => LocationRepository(geolocatorWrapper: injector()));

  // Api Hadler
  injector.registerLazySingleton<ApiHandler>(
      () => ApiHandler(apiConfig: ApiConfig()));

  //Library wrappers
  injector.registerLazySingleton<GeolocatorWrapper>(
      () => GeolocatorWrapper(geolocatorPlatformInstance: injector()));

  // External dependencies
  injector.registerLazySingleton<GeolocatorPlatform>(
      () => GeolocatorPlatform.instance);
}

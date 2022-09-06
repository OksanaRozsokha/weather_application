import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_application/common/dependency_injection.dart';
import 'package:weather_application/presentation/bloc/location_cubit/location_cubit.dart';
import 'package:weather_application/presentation/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:weather_application/presentation/ui/common/custom_scroll_behavior.dart';
import 'package:weather_application/presentation/ui/pages/weather_forecast_page.dart';

class WeatherForecastApp extends StatelessWidget {
  const WeatherForecastApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherForecastBloc>(
            create: (context) => injector<WeatherForecastBloc>()),
        BlocProvider<LocationCubit>(
            create: (context) =>
                injector<LocationCubit>()..getCurrentLocation()),
      ],
      child: MaterialApp(
        scrollBehavior: CustomScrollBehavior(),
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WeatherForecastPage(),
      ),
    );
  }
}

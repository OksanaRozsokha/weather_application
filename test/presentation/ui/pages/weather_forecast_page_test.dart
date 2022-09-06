import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_application/presentation/bloc/location_cubit/location_cubit.dart';
import 'package:weather_application/presentation/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:weather_application/presentation/ui/pages/weather_forecast_page.dart';

import '../test_widget.dart';

class MockLocationCubit extends MockCubit<LocationState>
    implements LocationCubit {}

class MockWeatherForecastBloc
    extends MockBloc<WeatherForecastBlocEvent, WeatherForecastBlocState>
    implements WeatherForecastBloc {}

void main() {
  late MockLocationCubit locationCubit;
  late MockWeatherForecastBloc weatherForecastBloc;
  group('WeatherForecastPage test', () {
    setUp(() {
      locationCubit = MockLocationCubit();
      weatherForecastBloc = MockWeatherForecastBloc();
      when(() => locationCubit.state)
          .thenReturn(LocationLoadedState(lat: 0.0, lon: 0.0));
      when(() => weatherForecastBloc.state)
          .thenReturn(WeatherForecastBlocInitialState());
    });
    testWidgets('getCurrentLocation function called on button pressed',
        (tester) async {
      await tester
          .pumpWidget(testWidget(blocsList: <BlocProvider<BlocBase<Object>>>[
        BlocProvider<LocationCubit>(create: (context) => locationCubit),
        BlocProvider<WeatherForecastBloc>(
            create: (context) => weatherForecastBloc)
      ], child: const WeatherForecastPage()));

      final Finder locationButtonFinder =
          find.byKey(const Key(WeatherForecastPage.locationButton));

      await tester.tap(locationButtonFinder);
      await tester.pumpAndSettle();

      verify(() => locationCubit.getCurrentLocation()).called(1);
    });
  });
}

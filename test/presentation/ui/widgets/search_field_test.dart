import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_application/presentation/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:weather_application/presentation/ui/widgets/search_field.dart';

import '../test_widget.dart';

class MockWeatherForecastBloc
    extends MockBloc<WeatherForecastBlocEvent, WeatherForecastBlocState>
    implements WeatherForecastBloc {}

class FakeGetWeatherForecastEvent extends Fake
    implements GetWeatherForecastEvent {}

void main() {
  late MockWeatherForecastBloc weatherForecastBloc;

  group('SearchField widget', () {
    setUp(() {
      weatherForecastBloc = MockWeatherForecastBloc();
      registerFallbackValue(FakeGetWeatherForecastEvent());
    });

    testWidgets('Test search field', (tester) async {
      await tester.pumpWidget(testWidget(
          blocsList: <BlocProvider<BlocBase<Object?>>>[
            BlocProvider<WeatherForecastBloc>(
                create: (context) => weatherForecastBloc)
          ],
          child: const Scaffold(body: SearchFieald())));
      final Finder textFieldFinder =
          find.byKey(const Key(SearchFieald.textFieldKey));

      await tester.enterText(textFieldFinder, 'hello :)');
      await tester.pump();

      final Finder searchButtonFinder =
          find.byKey(const Key(SearchFieald.buttonKey));

      await tester.tap(searchButtonFinder);
      await tester.pumpAndSettle();

      verify(() => weatherForecastBloc
          .add(any(that: const TypeMatcher<GetWeatherForecastEvent>())));
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:weather_application/data/models/response/sorted_weather_forecast_response.dart';
import 'package:weather_application/data/models/response/weather_forecst_response/weather_forecast_response.dart';
import 'package:weather_application/data/repositories/weather_forecast_repository.dart';
import 'package:weather_application/presentation/bloc/location_cubit/location_cubit.dart';
import 'package:weather_application/presentation/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:weather_application/presentation/ui/widgets/weather_forecast_content_widget.dart';

import '../../../data/api/test_response_json.dart';
import '../test_widget.dart';

class MockLocationCubit extends MockCubit<LocationState>
    implements LocationCubit {}

class MockWeatherForecastBloc
    extends MockBloc<WeatherForecastBlocEvent, WeatherForecastBlocState>
    implements WeatherForecastBloc {}

class FakeGetWeatherForecastEvent extends Fake
    implements GetWeatherForecastEvent {}

void main() {
  late MockLocationCubit locationCubit;
  late MockWeatherForecastBloc weatherForecastBloc;
  late WeatherForecastResponse weatherForecastResponse;
  group('Test WeatherForecastContent widget', () {
    setUp(() {
      locationCubit = MockLocationCubit();
      weatherForecastBloc = MockWeatherForecastBloc();
      weatherForecastResponse = WeatherForecastResponse.fromJson(testResponse);
    });

    group('WeatherForecastBloc cases', () {
      setUp(() {
        when(() => locationCubit.state)
            .thenReturn(LocationLoadedState(lat: 0.0, lon: 0.0));
      });

      testWidgets('render content on success', (WidgetTester tester) async {
        when(() => weatherForecastBloc.state).thenReturn(
            WeatherForecastLoadedState(
                sortedWeatherForecastResponse:
                    SortedWeatherForecastResponse.create(
                        sortedList: WeatherForecastRepository
                            .sortWeatherForecastListByDate(
                                weatherForecastResponse.weatherForecastList),
                        weatherForecastResponse: weatherForecastResponse)));

        await mockNetworkImagesFor(() => tester.pumpWidget(
                testWidget(blocsList: <BlocProvider<BlocBase<Object?>>>[
              BlocProvider<LocationCubit>(create: (context) => locationCubit),
              BlocProvider<WeatherForecastBloc>(
                  create: (context) => weatherForecastBloc),
            ], child: const Scaffold(body: WeatherForecastContentWidget()))));
        final Finder weatherForecastContent =
            find.byKey(const Key(WeatherForecastContentWidget.contentKey));

        await tester.pumpAndSettle();

        expect(weatherForecastContent, findsOneWidget);
      });
      testWidgets('render incorect location coordinates error',
          (WidgetTester tester) async {
        when(() => weatherForecastBloc.state)
            .thenReturn(WeatherForecastIncorectLocationCoordinatesState());

        await tester
            .pumpWidget(testWidget(blocsList: <BlocProvider<BlocBase<Object?>>>[
          BlocProvider<LocationCubit>(create: (context) => locationCubit),
          BlocProvider<WeatherForecastBloc>(
              create: (context) => weatherForecastBloc),
        ], child: const Scaffold(body: WeatherForecastContentWidget())));

        final Finder errorText =
            find.byKey(const Key(WeatherForecastContentWidget.errorKey));
        await tester.pumpAndSettle();
        expect(errorText, findsOneWidget);
      });

      testWidgets('render city is not found error',
          (WidgetTester tester) async {
        when(() => weatherForecastBloc.state).thenReturn(
            WeatherForecastCityNotFoundErrorState(
                message: 'city is not found'));

        await tester
            .pumpWidget(testWidget(blocsList: <BlocProvider<BlocBase<Object?>>>[
          BlocProvider<LocationCubit>(create: (context) => locationCubit),
          BlocProvider<WeatherForecastBloc>(
              create: (context) => weatherForecastBloc),
        ], child: const Scaffold(body: WeatherForecastContentWidget())));

        final Finder errorText =
            find.byKey(const Key(WeatherForecastContentWidget.errorKey));
        await tester.pumpAndSettle();
        expect(errorText, findsOneWidget);
      });

      testWidgets('render request error', (WidgetTester tester) async {
        when(() => weatherForecastBloc.state)
            .thenReturn(WeatherForecastRequestErrorState());

        await tester
            .pumpWidget(testWidget(blocsList: <BlocProvider<BlocBase<Object?>>>[
          BlocProvider<LocationCubit>(create: (context) => locationCubit),
          BlocProvider<WeatherForecastBloc>(
              create: (context) => weatherForecastBloc),
        ], child: const Scaffold(body: WeatherForecastContentWidget())));

        final Finder errorText =
            find.byKey(const Key(WeatherForecastContentWidget.errorKey));
        await tester.pumpAndSettle();
        expect(errorText, findsOneWidget);
      });
    });

    group('LocationCubit cases', () {
      setUp(() {
        when(() => weatherForecastBloc.state)
            .thenReturn(WeatherForecastBlocInitialState());

        registerFallbackValue(FakeGetWeatherForecastEvent());
      });

      testWidgets('LocationLoadedState, verify adding GetWeatherForecastEvent',
          (tester) async {
        when(() => locationCubit.state).thenReturn(GetLocationInitialState());
        whenListen(
            locationCubit,
            Stream<LocationState>.value(
                LocationLoadedState(lat: 0.0, lon: 0.0)));

        await tester
            .pumpWidget(testWidget(blocsList: <BlocProvider<BlocBase<Object?>>>[
          BlocProvider<LocationCubit>(create: (context) => locationCubit),
          BlocProvider<WeatherForecastBloc>(
              create: (context) => weatherForecastBloc),
        ], child: const Scaffold(body: WeatherForecastContentWidget())));

        await tester.pumpAndSettle();
        verify(() => weatherForecastBloc.add(
            any(that: const TypeMatcher<GetWeatherForecastEvent>()))).called(1);
      });

      testWidgets('LocationAccessDeniedErrorState, show snackBar',
          (tester) async {
        when(() => locationCubit.state).thenReturn(GetLocationInitialState());
        whenListen(
            locationCubit,
            Stream<LocationState>.value(LocationAccessDeniedErrorState(
                message: 'access denied error')));

        await tester
            .pumpWidget(testWidget(blocsList: <BlocProvider<BlocBase<Object?>>>[
          BlocProvider<LocationCubit>(create: (context) => locationCubit),
          BlocProvider<WeatherForecastBloc>(
              create: (context) => weatherForecastBloc),
        ], child: const Scaffold(body: WeatherForecastContentWidget())));

        await tester.pumpAndSettle();
        Finder snackBarTeextFinder =
            find.byKey(const Key(WeatherForecastContentWidget.snackBarTextKey));

        expect(snackBarTeextFinder, findsOneWidget);
      });

      testWidgets('LocationAccessDeniedForeverState, show snackBar',
          (tester) async {
        when(() => locationCubit.state).thenReturn(GetLocationInitialState());
        whenListen(
            locationCubit,
            Stream<LocationState>.value(LocationAccessDeniedForeverState(
                message: 'access denied forever error')));

        await tester
            .pumpWidget(testWidget(blocsList: <BlocProvider<BlocBase<Object?>>>[
          BlocProvider<LocationCubit>(create: (context) => locationCubit),
          BlocProvider<WeatherForecastBloc>(
              create: (context) => weatherForecastBloc),
        ], child: const Scaffold(body: WeatherForecastContentWidget())));

        await tester.pumpAndSettle();
        Finder snackBarTeextFinder =
            find.byKey(const Key(WeatherForecastContentWidget.snackBarTextKey));

        expect(snackBarTeextFinder, findsOneWidget);
      });

      testWidgets('GetLocationErrorSate, show snackBar', (tester) async {
        when(() => locationCubit.state).thenReturn(GetLocationInitialState());
        whenListen(
            locationCubit,
            Stream<LocationState>.value(
                GetLocationErrorSate(message: 'error')));

        await tester
            .pumpWidget(testWidget(blocsList: <BlocProvider<BlocBase<Object?>>>[
          BlocProvider<LocationCubit>(create: (context) => locationCubit),
          BlocProvider<WeatherForecastBloc>(
              create: (context) => weatherForecastBloc),
        ], child: const Scaffold(body: WeatherForecastContentWidget())));

        await tester.pumpAndSettle();
        Finder snackBarTeextFinder =
            find.byKey(const Key(WeatherForecastContentWidget.snackBarTextKey));

        expect(snackBarTeextFinder, findsOneWidget);
      });
    });
  });
}

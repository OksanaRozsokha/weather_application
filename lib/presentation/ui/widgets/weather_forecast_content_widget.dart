import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/hourly_weather_forecast_list_for_single_day.dart';
import 'package:weather_application/data/models/response/weather_forecast_response/weather_forecast_response.dart';
import 'package:weather_application/presentation/bloc/location_cubit/location_cubit.dart';
import 'package:weather_application/presentation/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';
import 'package:weather_application/presentation/ui/widgets/tab.dart';
import 'package:weather_application/presentation/ui/widgets/tab_bar_view_item.dart';

class WeatherForecastContentWidget extends StatelessWidget {
  const WeatherForecastContentWidget({Key? key}) : super(key: key);
  static const String contentKey = 'WeatherForecastContent';
  static const String errorKey = 'WeatherForecastError';
  static const String snackBarTextKey = 'WeatherForecastSnackBarText';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocListener<LocationCubit, LocationState>(
        listener: (context, state) {
          if (state is LocationLoadedState) {
            BlocProvider.of<WeatherForecastBloc>(context)
                .add(GetWeatherForecastEvent(lat: state.lat, lon: state.lon));
          }

          if (state is LocationAccessDeniedErrorState) {
            _showSnackBar(message: state.message, context: context);
          }

          if (state is LocationAccessDeniedForeverState) {
            _showSnackBar(message: state.message, context: context);
          }

          if (state is GetLocationErrorSate) {
            _showSnackBar(message: state.message, context: context);
          }
        },
        listenWhen: (LocationState prev, LocationState current) =>
            (prev is! LocationLoadedState && current is LocationLoadedState) ||
            (prev is! LocationAccessDeniedErrorState &&
                current is LocationAccessDeniedErrorState) ||
            (prev is! LocationAccessDeniedForeverState &&
                current is LocationAccessDeniedForeverState) ||
            (prev is! GetLocationErrorSate && current is GetLocationErrorSate),
        child: _getWeatherForecastBlocBuilder(),
      ),
    );
  }

  BlocBuilder<WeatherForecastBloc, WeatherForecastBlocState>
      _getWeatherForecastBlocBuilder() {
    return BlocBuilder<WeatherForecastBloc, WeatherForecastBlocState>(
      builder: (context, state) {
        if (state is WeatherForecastLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is WeatherForecastLoadedState) {
          return _buildWeatherForecastContent(
              weatherForecastResponse: state.weatherForecastResponse,
              context: context);
        }

        if (state is WeatherForecastIncorectLocationCoordinatesState) {
          return _buildError(errorMessage: 'Incorrect location coordinates');
        }

        if (state is WeatherForecastCityNotFoundErrorState) {
          return _buildError(errorMessage: state.message);
        }

        if (state is WeatherForecastRequestErrorState) {
          return _buildError(errorMessage: 'Something went wrong');
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildWeatherForecastContent(
      {required WeatherForecastResponse weatherForecastResponse,
      required BuildContext context}) {
    return DefaultTabController(
      length: weatherForecastResponse.dailyWeatherForecastList.length,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Column(
            key: const Key(contentKey),
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Weather in ${weatherForecastResponse.city.name}, ${weatherForecastResponse.city.country}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildTabBar(
                  dailyWeatherForecastList:
                      weatherForecastResponse.dailyWeatherForecastList,
                  context: context),
              const SizedBox(
                height: 15,
              ),
              _buildTabBarView(
                  dailyWeatherForecastList:
                      weatherForecastResponse.dailyWeatherForecastList),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError({required String errorMessage}) {
    return Center(
      child: Text(key: const Key(errorKey), errorMessage),
    );
  }

  Widget _buildTabBar(
      {required List<SingleDayWeatherForecastList> dailyWeatherForecastList,
      required BuildContext context}) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 50,
      ),
      child: TabBar(
          physics: const AlwaysScrollableScrollPhysics(),
          indicatorColor: const Color.fromARGB(255, 175, 81, 81),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 4.0,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: EdgeInsets.zero,
          isScrollable: true,
          labelColor: const Color.fromARGB(255, 175, 81, 81),
          unselectedLabelColor: Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: dailyWeatherForecastList
              .map(
                  (SingleDayWeatherForecastList singleDayWeatherForecastList) =>
                      TabWidget(
                        singleDayweatherForecastList:
                            singleDayWeatherForecastList,
                      ))
              .toList()),
    );
  }

  Widget _buildTabBarView(
      {required List<SingleDayWeatherForecastList> dailyWeatherForecastList}) {
    return SizedBox(
      width: 700,
      height: 700,
      child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: dailyWeatherForecastList
              .map(
                  (SingleDayWeatherForecastList singleDayweatherForecastList) =>
                      TabBarViewItem(
                          singleDayweatherForecastList:
                              singleDayweatherForecastList))
              .toList()),
    );
  }

  void _showSnackBar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 7000),
      content: Text(
        key: const Key(snackBarTextKey),
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
    ));
  }
}

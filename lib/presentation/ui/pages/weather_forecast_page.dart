import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_application/presentation/bloc/location_cubit/location_cubit.dart';
import 'package:weather_application/presentation/ui/shapes/app_bar_clipper.dart';
import 'package:weather_application/presentation/ui/widgets/search_field.dart';
import 'package:weather_application/presentation/ui/widgets/weather_forecast_content_widget.dart';

class WeatherForecastPage extends StatelessWidget {
  const WeatherForecastPage({Key? key}) : super(key: key);
  static const String locationButton = 'LocationButton';
  @override
  Widget build(BuildContext context) {
    double fullScreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 203, 198, 198),
          appBar: AppBar(
            toolbarHeight: 200,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Stack(
              children: [
                ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    width: fullScreenWidth,
                    color: const Color.fromARGB(255, 175, 81, 81),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 15,
                  child: Tooltip(
                    message: 'Get your weather by current location :)',
                    child: IconButton(
                      key: const Key(locationButton),
                      onPressed: () {
                        BlocProvider.of<LocationCubit>(context)
                            .getCurrentLocation();
                      },
                      icon: const Icon(
                        Icons.location_on_rounded,
                        size: 30,
                      ),
                      color: const Color.fromARGB(136, 18, 16, 16),
                    ),
                  ),
                ),
                Positioned(
                    top: 80,
                    left: 10,
                    child: SizedBox(
                        width: fullScreenWidth - 60,
                        height: 200,
                        child: const SearchFieald())),
              ],
            ),
          ),
          body: const WeatherForecastContentWidget()),
    );
  }
}

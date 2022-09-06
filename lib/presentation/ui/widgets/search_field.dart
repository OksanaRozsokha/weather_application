import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_application/presentation/bloc/weather_forecast_bloc/weather_forecast_bloc.dart';

class SearchFieald extends StatefulWidget {
  const SearchFieald({Key? key}) : super(key: key);
  static const String textFieldKey = 'SearchFieldTextField';
  static const String buttonKey = 'SearchFieldButtonKey';

  @override
  State<SearchFieald> createState() => _SearchFiealdState();
}

class _SearchFiealdState extends State<SearchFieald> {
  final TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          key: const Key(SearchFieald.textFieldKey),
          controller: _textFieldController,
          cursorColor: const Color.fromARGB(255, 175, 81, 81),
          decoration: InputDecoration(
              filled: true,
              hintText: 'Search weather by city name',
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 175, 81, 81)),
              border: InputBorder.none,
              hoverColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50.0)),
              fillColor: Colors.white70,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50.0)),
              contentPadding: const EdgeInsets.only(
                  left: 20, right: 50, top: 15, bottom: 15)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        Positioned(
            right: -5,
            top: -5,
            child: SizedBox(
              height: 60,
              width: 60,
              child: IconButton(
                  key: const Key(SearchFieald.buttonKey),
                  onPressed: _textFieldController.text.trim().isNotEmpty
                      ? () => _onSearchPressed()
                      : null,
                  icon: const Icon(Icons.search_rounded)),
            )),
      ],
    );
  }

  void _onSearchPressed() {
    BlocProvider.of<WeatherForecastBloc>(context).add(GetWeatherForecastEvent(
        byCityName: true, cityName: _textFieldController.text.trim()));
  }
}

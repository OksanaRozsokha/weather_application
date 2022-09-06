import 'package:flutter/material.dart';
import 'package:weather_application/common/dependency_injection.dart' as di;
import 'package:weather_application/presentation/ui/weather_forecast_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const WeatherForecastApp());
}

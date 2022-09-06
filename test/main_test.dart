// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_application/presentation/ui/pages/weather_forecast_page.dart';
import 'package:weather_application/common/dependency_injection.dart' as di;
import 'package:weather_application/presentation/ui/weather_forecast_app.dart';

void main() {
  setUp(() {
    di.init();
  });

  tearDown(() async {
    di.injector.reset();
  });
  testWidgets('Run App', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherForecastApp());
    await tester.pumpAndSettle();

    expect(find.byType(WeatherForecastPage), findsOneWidget);
  });
}

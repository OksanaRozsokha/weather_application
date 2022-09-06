import 'package:flutter_test/flutter_test.dart';
import 'package:weather_application/common/extensions/string_extension.dart';

void main() {
  test('Test capitalize String extension', () {
    String testString = 'test string';
    expect(testString.capitalize(), 'Test string');
  });
}

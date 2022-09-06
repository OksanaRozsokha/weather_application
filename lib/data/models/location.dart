import 'package:weather_application/common/constants.dart';

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromMap(Map<String, double> map) => Location(
      latitude: map[Constants.latitude]!, longitude: map[Constants.longitude]!);
}

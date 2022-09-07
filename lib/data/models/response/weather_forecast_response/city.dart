import 'package:weather_application/data/models/response/weather_forecast_response/coordinates.dart';

class City {
  int id;
  String name;
  Coordinates coord;
  String country;
  int population;
  int timezone;
  int sunrise;
  int sunset;

  City(
      {required this.id,
      required this.name,
      required this.coord,
      required this.country,
      required this.population,
      required this.timezone,
      required this.sunrise,
      required this.sunset});

  factory City.fromJson(Map<String, dynamic> json) => City(
      id: json['id'],
      name: json['name'],
      coord: Coordinates.fromJson(json['coord']),
      country: json['country'],
      population: json['population'],
      timezone: json['timezone'],
      sunrise: json['sunrise'],
      sunset: json['sunset']);

  @override
  bool operator ==(covariant City other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.coord == coord &&
        other.country == country &&
        other.population == population &&
        other.timezone == timezone &&
        other.sunrise == sunrise &&
        other.sunset == sunset;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        coord.hashCode ^
        country.hashCode ^
        population.hashCode ^
        timezone.hashCode ^
        sunrise.hashCode ^
        sunset.hashCode;
  }
}

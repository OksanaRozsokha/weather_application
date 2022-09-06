class Coordinates {
  final double lat;
  final double lon;

  Coordinates({required this.lat, required this.lon});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      Coordinates(lat: json['lat'].toDouble(), lon: json['lon'].toDouble());

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lon': lon};
  }

  @override
  bool operator ==(covariant Coordinates other) {
    if (identical(this, other)) return true;

    return other.lat == lat && other.lon == lon;
  }

  @override
  int get hashCode => lat.hashCode ^ lon.hashCode;
}

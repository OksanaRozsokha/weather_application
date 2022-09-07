class Clouds {
  int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) =>
      Clouds(all: json['all']);

  @override
  bool operator ==(covariant Clouds other) {
    if (identical(this, other)) return true;

    return other.all == all;
  }

  @override
  int get hashCode => all.hashCode;
}

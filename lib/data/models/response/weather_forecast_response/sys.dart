class Sys {
  String pod;

  Sys({required this.pod});

  factory Sys.fromJson(Map<String, dynamic> json) => Sys(pod: json['pod']);

  @override
  bool operator ==(covariant Sys other) {
    if (identical(this, other)) return true;

    return other.pod == pod;
  }

  @override
  int get hashCode => pod.hashCode;
}

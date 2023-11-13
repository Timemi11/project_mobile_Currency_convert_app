class Currency {
  late DateTime lastUpdatedAt;
  late Map<String, Datum> data;

  Currency({required this.lastUpdatedAt, required this.data});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      lastUpdatedAt: DateTime.parse(json['meta']['last_updated_at']),
      data: Map.from(json['data'])
          .map((k, v) => MapEntry<String, Datum>(k, Datum.fromJson(v))),
    );
  }
}

class Datum {
  late String code;
  late double value;

  Datum({required this.code, required this.value});

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      code: json['code'],
      value: json['value']?.toDouble() ?? 0.0,
    );
  }
}

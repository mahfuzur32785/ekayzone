import 'dart:convert';

import 'package:equatable/equatable.dart';

class TopCountry extends Equatable{
  const TopCountry({
    required this.country,
    required this.total,
  });

  final String country;
  final String total;

  TopCountry copyWith({
    String? country,
    String? total,
  }) =>
      TopCountry(
        country: country ?? this.country,
        total: total ?? this.total,
      );

  factory TopCountry.fromJson(String str) => TopCountry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopCountry.fromMap(Map<String, dynamic> json) => TopCountry(
    country: json["country"] ?? '',
    total: json["total"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "country": country,
    "total": total,
  };

  @override
  String toString() {
    return 'TopCountry(country: $country, total: $total)';
  }

  @override
  List<Object?> get props {
    return [
      country,
      total,
    ];
  }
}

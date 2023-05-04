import 'dart:convert';

import 'package:equatable/equatable.dart';

class LanguageModel extends Equatable{
  const LanguageModel({
    required this.name,
    required this.code,
    required this.icon,
    required this.direction,
    required this.jsonData,
  });

  final String name;
  final String code;
  final String icon;
  final String direction;
  final Map<String, String>? jsonData;

  LanguageModel copyWith({
    String? name,
    String? code,
    String? icon,
    String? direction,
    Map<String, String>? jsonData,
  }) =>
      LanguageModel(
        name: name ?? this.name,
        code: code ?? this.code,
        icon: icon ?? this.icon,
        direction: direction ?? this.direction,
        jsonData: jsonData ?? this.jsonData,
      );

  factory LanguageModel.fromJson(String str) => LanguageModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LanguageModel.fromMap(Map<String, dynamic> json) => LanguageModel(
    name: json["name"] ?? '',
    code: json["code"] == 'bi' ? 'bs' : json["code"],
    icon: json["icon"],
    direction: json["direction"] ?? '',
    jsonData: Map.from(json["json_data"]).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "code": code,
    "icon": icon,
    "direction": direction,
    "json_data": Map.from(jsonData!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };

  @override
  String toString() {
    return 'CategoryModel(name: $name, code: $code, icon: $icon, direction: $direction, json_data: $jsonData)';
  }

  @override
  List<Object> get props {
    return [
      name,
      code,
      icon,
      direction,
      jsonData!,
    ];
  }
}
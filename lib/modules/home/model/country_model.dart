import 'dart:convert';

import 'package:equatable/equatable.dart';

class TopCountry extends Equatable{
  const TopCountry({
    required this.id,
    required this.iso,
    required this.name,
    required this.nicename,
    required this.iso3,
    required this.numcode,
    required this.phonecode,
    required this.isDefault,
    required this.status,
  });

  final String id;
  final String iso;
  final String name;
  final String nicename;
  final String iso3;
  final String numcode;
  final String phonecode;
  final String isDefault;
  final String status;

  TopCountry copyWith({
    String? id,
    String? iso,
    String? name,
    String? nicename,
    String? iso3,
    String? numcode,
    String? phonecode,
    String? isDefault,
    String? status,
  }) =>
      TopCountry(
        id: id ?? this.id,
        iso: iso ?? this.iso,
        name: name ?? this.name,
        nicename: nicename ?? this.nicename,
        iso3: iso3 ?? this.iso3,
        numcode: numcode ?? this.numcode,
        phonecode: phonecode ?? this.phonecode,
        isDefault: isDefault ?? this.isDefault,
        status: status ?? this.status,
      );

  factory TopCountry.fromJson(String str) => TopCountry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopCountry.fromMap(Map<String, dynamic> json) => TopCountry(
    id: json["id"],
    iso: json["iso"],
    name: json["name"],
    nicename: json["nicename"],
    iso3: json["iso3"],
    numcode: json["numcode"],
    phonecode: json["phonecode"],
    isDefault: json["is_default"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "iso": iso,
    "name": name,
    "nicename": nicename,
    "iso3": iso3,
    "numcode": numcode,
    "phonecode": phonecode,
    "is_default": isDefault,
    "status": status,
  };

  @override
  String toString() {
    return 'TopCountry(id: $id,status:$status, iso: $iso, name:$name,nicename:$nicename, iso3:$iso3,numcode:$numcode, phonecode:$phonecode,isDefault:$isDefault)';
  }

  @override
  List<Object?> get props {
    return [
      id,
      iso,
      name,
      nicename,
      iso3,
      numcode,
      phonecode,
      isDefault,
      status
    ];
  }
}

import 'dart:convert';

import 'package:ekayzone/modules/home/model/category_model.dart';

class EventParamsModel {
  EventParamsModel({
    required this.status,
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  final int status;
  final bool success;
  final int code;
  final String message;
  final Data data;

  EventParamsModel copyWith({
    int? status,
    bool? success,
    int? code,
    String? message,
    Data? data,
  }) =>
      EventParamsModel(
        status: status ?? this.status,
        success: success ?? this.success,
        code: code ?? this.code,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory EventParamsModel.fromJson(String str) => EventParamsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EventParamsModel.fromMap(Map<String, dynamic> json) => EventParamsModel(
    status: json["status"],
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "success": success,
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class Data {
  Data({
    required this.categories,
    required this.tags,
    required this.venues,
    required this.organiser,
  });

  final List<Brand> categories;
  final List<Brand> tags;
  final List<Venue> venues;
  final List<Organiser> organiser;

  Data copyWith({
    List<Brand>? categories,
    List<Brand>? tags,
    List<Venue>? venues,
    List<Organiser>? organiser,
  }) =>
      Data(
        categories: categories ?? this.categories,
        tags: tags ?? this.tags,
        venues: venues ?? this.venues,
        organiser: organiser ?? this.organiser,
      );

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    categories: json["categories"] == null ? [] : List<Brand>.from(json["categories"].map((x) => Brand.fromMap(x))),
    tags: json["tags"] == null ? [] : List<Brand>.from(json["tags"].map((x) => Brand.fromMap(x))),
    venues: json["venues"] == null ? [] : List<Venue>.from(json["venues"].map((x) => Venue.fromMap(x))),
    organiser: json["organiser"] == null ? [] : List<Organiser>.from(json["organiser"].map((x) => Organiser.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
    "tags": List<dynamic>.from(tags.map((x) => x.toMap())),
    "venues": List<dynamic>.from(venues.map((x) => x.toMap())),
    "organiser": List<dynamic>.from(organiser.map((x) => x.toMap())),
  };
}

class Venue {
  Venue({
    required this.id,
    required this.name,
    required this.slug,
    required this.address,
    required this.city,
    required this.country,
    required this.state,
    required this.postalCode,
    required this.phone,
    required this.website,
    required this.status,
  });

  final int id;
  final String name;
  final String slug;
  final String address;
  final String city;
  final String country;
  final String state;
  final String postalCode;
  final String phone;
  final String website;
  final int status;

  Venue copyWith({
    int? id,
    String? name,
    String? slug,
    String? address,
    String? city,
    String? country,
    String? state,
    String? postalCode,
    String? phone,
    String? website,
    int? status,
  }) =>
      Venue(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        address: address ?? this.address,
        city: city ?? this.city,
        country: country ?? this.country,
        state: state ?? this.state,
        postalCode: postalCode ?? this.postalCode,
        phone: phone ?? this.phone,
        website: website ?? this.website,
        status: status ?? this.status,
      );

  factory Venue.fromJson(String str) => Venue.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Venue.fromMap(Map<String, dynamic> json) => Venue(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    address: json["address"],
    city: json["city"],
    country: json["country"],
    state: json["state"],
    postalCode: json["postal_code"],
    phone: json["phone"],
    website: json["website"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "slug": slug,
    "address": address,
    "city": city,
    "country": country,
    "state": state,
    "postal_code": postalCode,
    "phone": phone,
    "website": website,
    "status": status,
  };
}

class Organiser {
  Organiser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.status,
  });

  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;
  final int status;

  Organiser copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? website,
    int? status,
  }) =>
      Organiser(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        website: website ?? this.website,
        status: status ?? this.status,
      );

  factory Organiser.fromJson(String str) => Organiser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Organiser.fromMap(Map<String, dynamic> json) => Organiser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    website: json["website"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "website": website,
    "status": status,
  };
}
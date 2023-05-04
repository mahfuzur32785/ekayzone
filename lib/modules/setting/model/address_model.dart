import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'city_model.dart';
import 'country_model.dart';
import 'country_state_model.dart';

class AddressModel extends Equatable {
  final int id;
  final int userId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final int countryId;
  final int stateId;
  final int cityId;
  final String zipCode;
  final String createdAt;
  final String updatedAt;
  final CountryModel? country;
  final CountryStateModel? countryState;
  final CityModel? city;
  const AddressModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.zipCode,
    required this.createdAt,
    required this.updatedAt,
    required this.country,
    required this.countryState,
    required this.city,
  });

  AddressModel copyWith({
    int? id,
    int? userId,
    String? name,
    String? email,
    String? phone,
    String? address,
    int? countryId,
    int? stateId,
    int? cityId,
    String? zipCode,
    String? createdAt,
    String? updatedAt,
    CountryModel? country,
    CountryStateModel? countryState,
    CityModel? city,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      countryId: countryId ?? this.countryId,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      zipCode: zipCode ?? this.zipCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      country: country ?? this.country,
      countryState: countryState ?? this.countryState,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'user_id': userId});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'phone': phone});
    result.addAll({'address': address});
    result.addAll({'country_id': countryId});
    result.addAll({'state_id': stateId});
    result.addAll({'city_id': cityId});
    result.addAll({'zip_code': zipCode});
    result.addAll({'created_at': createdAt});
    result.addAll({'updated_at': updatedAt});
    if (country != null) {
      result.addAll({'country': country!.toMap()});
    }
    if (countryState != null) {
      result.addAll({'country_state': countryState!.toMap()});
    }
    if (city != null) result.addAll({'city': city!.toMap()});

    return result;
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id']?.toInt() ?? 0,
      userId: map['user_id'] != null ? int.parse("${map['user_id']}") : 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      countryId: map['country_id'] ?? 0,
      stateId: map['state_id'] ?? 0,
      cityId: map['city_id'] ?? 0,
      zipCode: map['zip_code'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      country:
          map['country'] != null ? CountryModel.fromMap(map['country']) : null,
      countryState: map['country_state'] != null
          ? CountryStateModel.fromMap(map['country_state'])
          : null,
      city: map['city'] != null ? CityModel.fromMap(map['city']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressModel(id: $id, user_id: $userId, name: $name, email: $email, phone: $phone, address: $address, country_id: $countryId, state_id: $stateId, city_id: $cityId, zip_code: $zipCode, created_at: $createdAt, updated_at: $updatedAt, country: $country, country_state: $countryState, city: $city)';
  }

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      name,
      email,
      phone,
      address,
      countryId,
      stateId,
      cityId,
      zipCode,
      createdAt,
      updatedAt,
      country,
      countryState,
      city,
    ];
  }
}

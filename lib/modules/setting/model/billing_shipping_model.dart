import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:ekayzone/modules/setting/model/country_model.dart';
import 'address_model.dart';
import 'city_model.dart';
import 'country_state_model.dart';

class BillingShippingModel extends Equatable {
  final AddressModel? billing;
  final AddressModel? shipping;
  final List<CountryModel>? countries;
  final List<CountryStateModel>? shippingStates;
  final List<CityModel>? shippingCities;
  final List<CountryStateModel>? billingStates;
  final List<CityModel>? billingCities;
  const BillingShippingModel({
    this.billing,
    this.shipping,
    this.countries,
    this.shippingCities,
    this.shippingStates,
    this.billingCities,
    this.billingStates,
  });

  BillingShippingModel copyWith({
    AddressModel? billing,
    AddressModel? shipping,
    List<CountryModel>? countries,
    List<CountryStateModel>? shippingStates,
    List<CityModel>? shippingCities,
    List<CountryStateModel>? billingStates,
    List<CityModel>? billingCities,
  }) {
    return BillingShippingModel(
      billing: billing ?? this.billing,
      shipping: shipping ?? this.shipping,
      countries: countries ?? this.countries,
      shippingStates: shippingStates ?? this.shippingStates,
      shippingCities: shippingCities ?? this.shippingCities,
      billingStates: billingStates ?? this.billingStates,
      billingCities: billingCities ?? this.billingCities,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (billing != null) {
      result.addAll({'billing': billing!.toMap()});
    }
    if (shipping != null) {
      result.addAll({'shipping': shipping!.toMap()});
    }
    if (countries!.isNotEmpty) {
      result.addAll({'countries': countries!.map((x) => x.toMap()).toList()});
    }
    if (shippingStates!.isNotEmpty) {
      result.addAll({'shippingStates': shippingStates!.map((x) => x.toMap()).toList()});
    }
    if (shippingCities!.isNotEmpty) {
      result.addAll({'shippingCities': shippingCities!.map((x) => x.toMap()).toList()});
    }
    if (billingStates!.isNotEmpty) {
      result.addAll({'billingStates': billingStates!.map((x) => x.toMap()).toList()});
    }
    if (billingCities!.isNotEmpty) {
      result.addAll({'billingCities': billingCities!.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory BillingShippingModel.fromMap(Map<String, dynamic> map) {
    return BillingShippingModel(
      billing:
          map['billing'] != null ? AddressModel.fromMap(map['billing']) : null,
      shipping: map['shipping'] != null
          ? AddressModel.fromMap(map['shipping'])
          : null,
      countries: map['countries'] == null
          ? []
          : List<CountryModel>.from(
          map['countries']?.map((x) => CountryModel.fromMap(x))),
      shippingStates: map['shippingStates'] == null
          ? []
          : List<CountryStateModel>.from(
          map['shippingStates']?.map((x) => CountryStateModel.fromMap(x))),
      shippingCities: map['shippingCities'] == null
          ? []
          : List<CityModel>.from(
          map['shippingCities']?.map((x) => CityModel.fromMap(x))),
      billingStates: map['billingStates'] == null
          ? []
          : List<CountryStateModel>.from(
          map['billingStates']?.map((x) => CountryStateModel.fromMap(x))),
      billingCities: map['billingCities'] == null
          ? []
          : List<CityModel>.from(
          map['billingCities']?.map((x) => CityModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory BillingShippingModel.fromJson(String source) =>
      BillingShippingModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'BillingShippingModel(billing: $billing, shipping: $shipping, countries: $countries, shippingStates: $shippingStates,shippingCities: $shippingCities, billingStates: $billingStates, billingCities: $billingCities)';

  @override
  List<Object?> get props => [billing, shipping, countries, shippingStates, shippingCities, billingStates, billingCities];
}

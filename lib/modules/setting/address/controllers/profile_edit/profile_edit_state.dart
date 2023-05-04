part of 'profile_edit_cubit.dart';

class ProfileEditStateModel extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String phoneCode;
  final String iso;
  final String countryCode;
  final String zipCode;
  final String address;
  final String image;
  final int country;
  final int state;
  final int city;
  final ProfileEditState stateStatus;
  const ProfileEditStateModel({
    required this.name,
    required this.phone,
    required this.phoneCode,
    required this.iso,
    required this.email,
    required this.countryCode,
    required this.zipCode,
    required this.address,
    required this.image,
    required this.country,
    required this.state,
    required this.city,
    required this.stateStatus,
  });

  factory ProfileEditStateModel.init(UserProfileModel user) {
    return ProfileEditStateModel(
      address: user.address ?? '',
      city: user.cityId ?? 0,
      email: user.email,
      country: user.countryId ?? 0,
      state: user.stateId ?? 0,
      countryCode: '',
      image: '',
      name: user.name,
      phone: user.phone ?? '',
      phoneCode: user.phoneCode ?? '',
      iso: user.iso ?? '',
      zipCode: user.zipCode ?? '',
      stateStatus: const ProfileEditStateInitial(),
    );
  }

  ProfileEditStateModel copyWith({
    String? name,
    String? phone,
    String? phoneCode,
    String? iso,
    String? zipCode,
    String? address,
    String? image,
    int? country,
    int? state,
    int? city,
    String? email,
    ProfileEditState? stateStatus,
  }) {
    return ProfileEditStateModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneCode: phoneCode ?? this.phoneCode,
      iso: iso ?? this.iso,
      countryCode: phoneCode ?? countryCode,
      zipCode: zipCode ?? this.zipCode,
      address: address ?? this.address,
      image: image ?? this.image,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      stateStatus: stateStatus ?? this.stateStatus,
    );
  }

  Map<String, String> toMap() {
    final result = <String, String>{};

    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'phone': phone});
    result.addAll({'phonecode': phoneCode});
    result.addAll({'iso': iso});
    result.addAll({'zip_code': zipCode});
    result.addAll({'address': address});
    // result.addAll({'image': image});
    result.addAll({'country': country.toString()});
    result.addAll({'state': state.toString()});
    result.addAll({'city': city.toString()});

    return result;
  }

  factory ProfileEditStateModel.fromMap(Map<String, dynamic> map) {
    return ProfileEditStateModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      phoneCode: map['phonecode'] ?? '',
      iso: map['iso'] ?? '',
      countryCode: map['countryCode'] ?? '',
      zipCode: map['zip_code'] ?? '',
      address: map['address'] ?? '',
      image: map['image'] ?? '',
      country: map['country'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      stateStatus: const ProfileEditStateInitial(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileEditStateModel.fromJson(String source) =>
      ProfileEditStateModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileEditStateModel(name: $name, email: $email, phone: $phone, phonecode: $phoneCode, iso: $iso, countryCode: $countryCode, zip_code: $zipCode, address: $address, image: $image, country: $country, state: $state, city: $city, status: $stateStatus)';
  }

  @override
  List<Object> get props {
    return [
      name,
      phone,
      phoneCode,
      iso,
      countryCode,
      zipCode,
      address,
      image,
      country,
      state,
      city,
      stateStatus,
    ];
  }
}

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object> get props => [];
}

class ProfileEditStateInitial extends ProfileEditState {
  const ProfileEditStateInitial();
}

class ProfileEditStateLoading extends ProfileEditState {
  const ProfileEditStateLoading();
}

class ProfileEditStateLoaded extends ProfileEditState {
  final String message;
  const ProfileEditStateLoaded(this.message);
  @override
  List<Object> get props => [message];
}

class ProfileEditStateError extends ProfileEditState {
  final String message;
  final int statusCode;
  const ProfileEditStateError(this.message, this.statusCode);
  @override
  List<Object> get props => [message, statusCode];
}

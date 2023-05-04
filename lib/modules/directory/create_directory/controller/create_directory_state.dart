part of 'create_directory_bloc.dart';

class CreateDirectoryModalState extends Equatable {
  final String title;
  final String email;
  final String category;
  final String subCategory;
  final String phone;
  final String backupPhone;
  final String description;
  final String businessProfile;
  final String location;
  final String image;
  final String lat;
  final String lng;
  final CreateDirectoryState state;
  const CreateDirectoryModalState({
    this.title = '',
    this.email = '',
    this.category = '',
    this.subCategory = '',
    this.phone = '',
    this.backupPhone = '',
    this.businessProfile = '',
    this.description = '',
    this.location = '',
    this.image = '',
    this.lat = '',
    this.lng = '',
    this.state = const CreateDirectoryStateInitial(),
  });

  CreateDirectoryModalState copyWith({
    String? title,
    String? email,
    String? category,
    String? subCategory,
    String? phone,
    String? backupPhone,
    String? businessProfile,
    String? description,
    String? location,
    String? image,
    String? lat,
    String? lng,
    CreateDirectoryState? state,
  }) {
    return CreateDirectoryModalState(
      title: title ?? this.title,
      email: email ?? this.email,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      phone: phone ?? this.phone,
      backupPhone: backupPhone ?? this.backupPhone,
      businessProfile: businessProfile ?? this.businessProfile,
      description: description ?? this.description,
      location: location ?? this.location,
      image: image ?? this.image,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title.trim()});
    result.addAll({'email': email.trim()});
    result.addAll({'category_id': category});
    result.addAll({'subcategory_id': subCategory});
    result.addAll({'phone': phone.trim()});
    result.addAll({'phone_2': backupPhone.trim()});
    result.addAll({'business_profile_link': businessProfile.trim()});
    result.addAll({'description': description.trim()});
    result.addAll({'address': location.trim()});
    result.addAll({'lat': lat});
    result.addAll({'lng': lng});
    result.addAll({'thumbnail': image});
    // result.addAll({'state': state});

    return result;
  }

  factory CreateDirectoryModalState.fromMap(Map<String, dynamic> map) {
    return CreateDirectoryModalState(
      title: map['title'] ?? '',
      email: map['email'] ?? '',
      category: map['category_id'] ?? '',
      subCategory: map['subcategory_id'] ?? '',
      phone: map['phone'] ?? '',
      backupPhone: map['phone_2'] ?? '',
      businessProfile: map['business_profile_link'] ?? '',
      description: map['description'] ?? '',
      location: map['address'] ?? '',
      image: map['thumbnail'] ?? '',
      lat: map['lat'] ?? '0.0',
      lng: map['lng'] ?? '0.0',
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateDirectoryModalState.fromJson(String source) =>
      CreateDirectoryModalState.fromMap(json.decode(source));

  @override
  String toString() =>
      'CreateDirectoryModalState(title: $title, email: $email, category_id: $category, subcategory_id: $subCategory, phone: $phone, phone_2: $backupPhone, business_profile_link: $businessProfile, description: $description, address: $location, thumbnail: $image, lat: $lat, lng: $lng, state: $state)';

  @override
  List<Object> get props => [title, email, category, subCategory, phone, backupPhone, description, businessProfile, location, lat, lng, image, state];
}

abstract class CreateDirectoryState extends Equatable {
  const CreateDirectoryState();

  @override
  List<Object> get props => [];
}

class CreateDirectoryStateInitial extends CreateDirectoryState {
  const CreateDirectoryStateInitial();
}

class CreateDirectoryStateLoading extends CreateDirectoryState {
  const CreateDirectoryStateLoading();
}

class CreateDirectoryStateFormSubmitLoading extends CreateDirectoryState {
  const CreateDirectoryStateFormSubmitLoading();
}

class CreateDirectoryStateFormSubmitError extends CreateDirectoryState {
  final String errorMsg;
  final int statusCode;

  const CreateDirectoryStateFormSubmitError(this.errorMsg, this.statusCode);

  @override
  List<Object> get props => [errorMsg, statusCode];
}
class CreateDirectoryStateError extends CreateDirectoryState {
  final String errorMsg;
  final int statusCode;

  const CreateDirectoryStateError(this.errorMsg, this.statusCode);

  @override
  List<Object> get props => [errorMsg, statusCode];
}
class CreateDirectoryStateLoaded extends CreateDirectoryState {
  final String message;
  const CreateDirectoryStateLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class CreateDirectoryCategoryStateLoaded extends CreateDirectoryState {
  final List<Category> categories;
  const CreateDirectoryCategoryStateLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}
part of 'create_directory_bloc.dart';

abstract class CreateDirectoryEvent extends Equatable {
  const CreateDirectoryEvent();

  @override
  List<Object> get props => [];
}

class CreateDirectoryEventTitle extends CreateDirectoryEvent {
  final String title;
  const CreateDirectoryEventTitle(this.title);

  @override
  List<Object> get props => [title];
}

class CreateDirectoryEventEmail extends CreateDirectoryEvent {
  final String email;
  const CreateDirectoryEventEmail(this.email);

  @override
  List<Object> get props => [email];
}

class CreateDirectoryEventCategory extends CreateDirectoryEvent {
  final String category;
  const CreateDirectoryEventCategory(this.category);

  @override
  List<Object> get props => [category];
}

class CreateDirectoryEventSubCategory extends CreateDirectoryEvent {
  final String subCategory;
  final Brand subCategoryData;
  const CreateDirectoryEventSubCategory(this.subCategory,this.subCategoryData);

  @override
  List<Object> get props => [subCategory];
}

class CreateDirectoryEventPhone extends CreateDirectoryEvent {
  final String phone;
  const CreateDirectoryEventPhone(this.phone);

  @override
  List<Object> get props => [phone];
}

class CreateDirectoryEventBackupPhone extends CreateDirectoryEvent {
  final String backupPhone;
  const CreateDirectoryEventBackupPhone(this.backupPhone);

  @override
  List<Object> get props => [backupPhone];
}

class CreateDirectoryEventBusinessProfile extends CreateDirectoryEvent {
  final String businessProfile;
  const CreateDirectoryEventBusinessProfile(this.businessProfile);

  @override
  List<Object> get props => [businessProfile];
}

class CreateDirectoryEventDescription extends CreateDirectoryEvent {
  final String description;
  const CreateDirectoryEventDescription(this.description);

  @override
  List<Object> get props => [description];
}

class CreateDirectoryEventLocation extends CreateDirectoryEvent {
  final String location;
  const CreateDirectoryEventLocation(this.location);

  @override
  List<Object> get props => [location];
}

class CreateDirectoryEventImage extends CreateDirectoryEvent {
  final String image;
  const CreateDirectoryEventImage(this.image);

  @override
  List<Object> get props => [image];
}

class CreateDirectoryEventLatLng extends CreateDirectoryEvent {
  final String lat;
  final String lng;
  const CreateDirectoryEventLatLng(this.lat,this.lng);

  @override
  List<Object> get props => [lat,lng];
}


class CreateDirectoryEventGetBCategory extends CreateDirectoryEvent {
  const CreateDirectoryEventGetBCategory();
  @override
  List<Object> get props => [];
}

class CreateDirectoryEventSubmit extends CreateDirectoryEvent {
  final String token;
  const CreateDirectoryEventSubmit(this.token);
  @override
  List<Object> get props => [token];
}
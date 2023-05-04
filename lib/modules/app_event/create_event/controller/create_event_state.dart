part of 'create_event_bloc.dart';

class CreateEventModalState extends Equatable {
  final String title;
  final String details;
  final String shortDescription;
  final String venueId;
  final String venueName;
  final String venueAddress;
  final String venueCity;
  final String venueCountry;
  final String venuePhone;
  final String venueState;
  final String venuePostalCode;
  final String venueWebsite;
  final String image;
  final bool wheelChair;
  final bool accessible;
  final bool allDayEventStatus;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String timezone;
  final List<String> categoryId;
  final List<String> tagId;
  final String eventStatus;
  final String eventStatusReason;
  final String eventInfoLink;
  final String cost;
  final List<Organiser> organisers;
  final CreateEventState state;
  const CreateEventModalState({
    this.title = '',
    this.details = '',
    this.shortDescription = '',
    this.venueId = '',
    this.venueName = '',
    this.venueAddress = '',
    this.venueCity = '',
    this.venueCountry = '',
    this.venuePhone = '',
    this.venueState = '',
    this.venuePostalCode = '',
    this.venueWebsite = '',
    this.image = '',
    this.wheelChair = false,
    this.accessible = false,
    this.allDayEventStatus = false,
    this.startDate = '',
    this.startTime = '',
    this.endDate = '',
    this.endTime = '',
    this.timezone = '',
    this.categoryId = const [],
    this.tagId = const [],
    this.eventStatus = '1',
    this.eventStatusReason = '',
    this.eventInfoLink = '',
    this.cost = '',
    this.organisers = const [],
    this.state = const CreateEventStateInitial(),
  });

  CreateEventModalState copyWith({
    String? title,
    String? details,
    String? shortDescription,
    String? venueId,
    String? venueName,
    String? venueAddress,
    String? venueCity,
    String? venueCountry,
    String? venuePhone,
    String? venueState,
    String? venuePostalCode,
    String? venueWebsite,
    String? image,
    bool? wheelChair,
    bool? accessible,
    bool? allDayEventStatus,
    String? startDate,
    String? startTime,
    String? endDate,
    String? endTime,
    String? timezone,
    List<String>? categoryId,
    List<String>? tagId,
    String? eventStatus,
    String? eventStatusReason,
    String? eventInfoLink,
    String? cost,
    List<Organiser>? organisers,
    CreateEventState? state,
  }) {
    return CreateEventModalState(
      title: title ?? this.title,
      details: details ?? this.details,
      shortDescription: shortDescription ?? this.shortDescription,
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      venueAddress: venueAddress ?? this.venueAddress,
      venueCity: venueCity ?? this.venueCity,
      venueCountry: venueCountry ?? this.venueCountry,
      venuePhone: venuePhone ?? this.venuePhone,
      venueState: venueState ?? this.venueState,
      venuePostalCode: venuePostalCode ?? this.venuePostalCode,
      venueWebsite: venueWebsite ?? this.venueWebsite,
      image: image ?? this.image,
      wheelChair: wheelChair ?? this.wheelChair,
      accessible: accessible ?? this.accessible,
      allDayEventStatus: allDayEventStatus ?? this.allDayEventStatus,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      endDate: endDate ?? this.endDate,
      endTime: endTime ?? this.endTime,
      timezone: timezone ?? this.timezone,
      categoryId: categoryId ?? this.categoryId,
      tagId: tagId ?? this.tagId,
      eventStatus: eventStatus ?? this.eventStatus,
      eventStatusReason: eventStatusReason ?? this.eventStatusReason,
      eventInfoLink: eventInfoLink ?? this.eventInfoLink,
      cost: cost ?? this.cost,
      organisers: organisers ?? this.organisers,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title.trim()});
    result.addAll({'details': details.trim()});
    result.addAll({'short_description': shortDescription.trim()});
    result.addAll({'venue_id': venueId});
    result.addAll({'venue_name': venueName.trim()});
    result.addAll({'venue_address': venueAddress.trim()});
    result.addAll({'venue_city': venueCity.trim()});
    result.addAll({'venue_country': venueCountry.trim()});
    result.addAll({'venue_state': venueState.trim()});
    result.addAll({'venue_postal_code': venuePostalCode.trim()});
    result.addAll({'venue_website': venueWebsite.trim()});
    result.addAll({'venue_phone': venuePhone.trim()});
    result.addAll({'image': image});
    result.addAll({'accessible': accessible ? '1' : '0'});
    result.addAll({'wheelchair': wheelChair ? '1' : '0'});
    result.addAll({'allDayEventStatus': allDayEventStatus ? '1' : '0'});
    result.addAll({'start_date': startDate});
    result.addAll({'start_time': startTime});
    result.addAll({'end_date': endDate});
    result.addAll({'end_time': endTime});
    result.addAll({'categoryId[]': categoryId.map((e) => e).toList()});
    result.addAll({'tagId[]': tagId.map((e) => e).toList()});
    result.addAll({'timezone': timezone});
    result.addAll({'eventStatus': eventStatus});
    result.addAll({'eventStatusReason': eventStatusReason});
    result.addAll({'eventInfoLink': eventInfoLink});
    result.addAll({'cost': cost.trim()});
    result.addAll({'organisers': organisers.map((e) => e.toMap()).toList()});
    // result.addAll({'state': state});

    return result;
  }

  factory CreateEventModalState.fromMap(Map<String, dynamic> map) {
    return CreateEventModalState(
      title: map['title'] ?? '',
      details: map['details'] ?? '',
      shortDescription: map['short_description'] ?? '',
      venueId: map['venue_id'] ?? '',
      venuePhone: map['venue_phone'] ?? '',
      venueWebsite: map['venue_website'] ?? false,
      venuePostalCode: map['venue_postal_code'] ?? '',
      venueState: map['venue_state'] ?? '',
      venueCountry: map['venue_country'] ?? '',
      venueCity: map['venue_city'] ?? [],
      venueAddress: map['venue_address'] ?? '',
      venueName: map['venue_name'] ?? [],
      wheelChair: map['wheelchair'] ?? false,
      image: map['image'] ?? false,
      accessible: map['accessible'] ?? false,
      allDayEventStatus: map['allDayEventStatus'] ?? '',
      tagId: map['tagId'] ?? [],
      timezone: map['timezone'] ?? '',
      categoryId: map['categoryId'] ?? [],
      cost: map['cost'] ?? '',
      eventStatus: map['eventStatus'] ?? '',
      eventInfoLink: map['eventInfoLink'] ?? '',
      eventStatusReason: map['eventStatusReason'] ?? '',
      endTime: map['end_time'] ?? '',
      endDate: map['end_date'] ?? '',
      startTime: map['start_time'] ?? '',
      startDate: map['start_date'] ?? '',
      organisers: map["organisers"] == null ? [] : List<Organiser>.from(map["organisers"].map((x) => Organiser.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateEventModalState.fromJson(String source) =>
      CreateEventModalState.fromMap(json.decode(source));

  // @override
  // String toString() =>
  //     'CreateEventModalState(title: $name, price: $price, category_id: $category, subcategory_id: $subCategory, phone: $phone, show_phone: $isShowPhone phone_2: $backupPhone, whatsapp: $weChat, description: $description, features[]: $features, address: $location, images[]: $images, brand: $brand, state: $state)';
  //
  @override
  List<Object> get props => [
        title,
        details,
        shortDescription,
        venueId,
        venueName,
        venueState,
        venueCountry,
        venuePostalCode,
        venueAddress,
        venueCity,
        venuePhone,
        venueWebsite,
        wheelChair,
        image,
        accessible,
        startDate,
        startTime,
        endDate,
        endTime,
        eventStatus,
        eventStatusReason,
        eventInfoLink,
        cost,
        categoryId,
        allDayEventStatus,
        tagId,
        timezone,
        organisers,
        state
      ];
}

abstract class CreateEventState extends Equatable {
  const CreateEventState();

  @override
  List<Object> get props => [];
}

class CreateEventStateInitial extends CreateEventState {
  const CreateEventStateInitial();
}

class CreateEventStateLoading extends CreateEventState {
  const CreateEventStateLoading();
}

class CreateEventStateError extends CreateEventState {
  final String errorMsg;
  final int statusCode;

  const CreateEventStateError(this.errorMsg, this.statusCode);

  @override
  List<Object> get props => [errorMsg, statusCode];
}

class CreateEventStateLoaded extends CreateEventState {
  final String message;
  const CreateEventStateLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class CreateEventStateCategoryLoading extends CreateEventState {
  const CreateEventStateCategoryLoading();
}

class CreateEventStateCategoryError extends CreateEventState {
  final String errorMsg;
  final int statusCode;
  const CreateEventStateCategoryError(this.errorMsg, this.statusCode);

  @override
  List<Object> get props => [errorMsg, statusCode];
}

class CreateEventStateCategoryLoaded extends CreateEventState {
  final EventParamsModel eventParamsModel;
  const CreateEventStateCategoryLoaded(this.eventParamsModel);

  @override
  List<Object> get props => [eventParamsModel];
}

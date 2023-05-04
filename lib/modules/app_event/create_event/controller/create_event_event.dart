part of 'create_event_bloc.dart';

abstract class CreateEventEvent extends Equatable {
  const CreateEventEvent();

  @override
  List<Object> get props => [];
}

class CreateEventEvenTitle extends CreateEventEvent {
  final String title;
  const CreateEventEvenTitle(this.title);

  @override
  List<Object> get props => [title];
}

class CreateEventEventDetails extends CreateEventEvent {
  final String details;
  const CreateEventEventDetails(this.details);

  @override
  List<Object> get props => [details];
}

class CreateEventEvenShortDescription extends CreateEventEvent {
  final String shortDescription;
  const CreateEventEvenShortDescription(this.shortDescription);

  @override
  List<Object> get props => [shortDescription];
}

class CreateEventEventVenueId extends CreateEventEvent {
  final String value;
  const CreateEventEventVenueId(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventVenueName extends CreateEventEvent {
  final String value;
  const CreateEventEventVenueName(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventVenueAddress extends CreateEventEvent {
  final String value;
  const CreateEventEventVenueAddress(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventVenueCity extends CreateEventEvent {
  final String value;
  const CreateEventEventVenueCity(this.value);

  @override
  List<Object> get props => [value];
}
class CreateEventEventVenueCountry extends CreateEventEvent {
  final String value;
  const CreateEventEventVenueCountry(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventVenueState extends CreateEventEvent {
  final String value;
  const CreateEventEventVenueState(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventVenuePostalCode extends CreateEventEvent {
  final String value;
  const CreateEventEventVenuePostalCode(this.value);

  @override
  List<Object> get props => [value];
}
class CreateEventEventVenueWebLink extends CreateEventEvent {
  final String value;
  const CreateEventEventVenueWebLink(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventLink extends CreateEventEvent {
  final String link;
  const CreateEventEventLink(this.link);

  @override
  List<Object> get props => [link];
}

class CreateEventEventVenuePhone extends CreateEventEvent {
  final String phone;
  const CreateEventEventVenuePhone(this.phone);

  @override
  List<Object> get props => [phone];
}

class CreateEventEventImage extends CreateEventEvent {
  final String image;
  const CreateEventEventImage(this.image);

  @override
  List<Object> get props => [image];
}

class CreateEventEventWheelChair extends CreateEventEvent {
  final bool value;
  const CreateEventEventWheelChair(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventAccessible extends CreateEventEvent {
  final bool value;
  const CreateEventEventAccessible(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventAllDayEvent extends CreateEventEvent {
  final bool value;
  const CreateEventEventAllDayEvent(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventStartDate extends CreateEventEvent {
  final String value;
  const CreateEventEventStartDate(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventEndDate extends CreateEventEvent {
  final String value;
  const CreateEventEventEndDate(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventEndTime extends CreateEventEvent {
  final String value;
  const CreateEventEventEndTime(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventStartTime extends CreateEventEvent {
  final String value;
  const CreateEventEventStartTime(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventTimezone extends CreateEventEvent {
  final String value;
  const CreateEventEventTimezone(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventCategoryId extends CreateEventEvent {
  final List<String> value;
  const CreateEventEventCategoryId(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventTagId extends CreateEventEvent {
  final List<String> value;
  const CreateEventEventTagId(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEvenStatus extends CreateEventEvent {
  final String value;
  const CreateEventEvenStatus(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventReason extends CreateEventEvent {
  final String value;
  const CreateEventEventReason(this.value);

  @override
  List<Object> get props => [value];
}
class CreateEventEvenInfoLink extends CreateEventEvent {
  final String value;
  const CreateEventEvenInfoLink(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventCost extends CreateEventEvent {
  final String value;
  const CreateEventEventCost(this.value);

  @override
  List<Object> get props => [value];
}

class CreateEventEventOrganiser extends CreateEventEvent {
  final List<Organiser> organisers;
  const CreateEventEventOrganiser(this.organisers);

  @override
  List<Object> get props => [organisers];
}


class CreateEventLoadParams extends CreateEventEvent {
  const CreateEventLoadParams();
  @override
  List<Object> get props => [];
}
class CreateEventEventSubmit extends CreateEventEvent {
  const CreateEventEventSubmit();
  @override
  List<Object> get props => [];
}
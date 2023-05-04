part of 'event_details_cubit.dart';

class EventDetailsState extends Equatable {
  const EventDetailsState();
  @override
  List<Object> get props => [];
}

class EventDetailsStateLoading extends EventDetailsState {
  const EventDetailsStateLoading();
}

class EventDetailsStateError extends EventDetailsState {
  final String message;
  const EventDetailsStateError(this.message);
  @override
  List<Object> get props => [message];
}

class EventDetailsStateLoaded extends EventDetailsState {
  final EventModel eventModel;
  const EventDetailsStateLoaded(this.eventModel);
  @override
  List<Object> get props => [eventModel];
}
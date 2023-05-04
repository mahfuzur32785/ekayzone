part of 'events_bloc.dart';

class EventState {
  const EventState();

  @override
  List<Object> get props => [];
}

class EventStateInitial extends EventState {
  const EventStateInitial();
}
class EventStateLoading extends EventState {
  const EventStateLoading();
}

class EventStateError extends EventState {
  final String message;
  final int code;
  const EventStateError(this.message,this.code);
  @override
  List<Object> get props => [message];
}

class EventStateLoaded extends EventState {
  final List<EventModel> eventList;
  const EventStateLoaded(this.eventList);
  @override
  List<Object> get props => [eventList];
}

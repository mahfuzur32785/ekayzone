part of 'my_events_bloc.dart';

class MyEventState {
  const MyEventState();

  @override
  List<Object> get props => [];
}

class MyEventStateInitial extends MyEventState {
  const MyEventStateInitial();
}
class MyEventStateLoading extends MyEventState {
  const MyEventStateLoading();
}

class MyEventStateError extends MyEventState {
  final String message;
  final int code;
  const MyEventStateError(this.message,this.code);
  @override
  List<Object> get props => [message];
}

class MyEventStateLoaded extends MyEventState {
  final List<EventModel> eventList;
  const MyEventStateLoaded(this.eventList);
  @override
  List<Object> get props => [eventList];
}

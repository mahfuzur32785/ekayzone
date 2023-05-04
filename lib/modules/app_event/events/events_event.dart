part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class EventsLoadEvent extends EventsEvent {
  const EventsLoadEvent(this.search,this.date);

  final String date;
  final String search;

  @override
  List<Object> get props => [search, date];
}
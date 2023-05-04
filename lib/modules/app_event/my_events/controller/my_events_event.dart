part of 'my_events_bloc.dart';

abstract class MyEventsEvent extends Equatable {
  const MyEventsEvent();

  @override
  List<Object> get props => [];
}

class MyEventsLoadEvent extends MyEventsEvent {
  const MyEventsLoadEvent(this.search,this.date);

  final String date;
  final String search;

  @override
  List<Object> get props => [search, date];
}
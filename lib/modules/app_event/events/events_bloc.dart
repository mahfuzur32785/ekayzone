import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/remote_urls.dart';
import '../../authentication/controllers/login/login_bloc.dart';
import '../model/event_model.dart';
import 'controller/event_repository.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventState> {
  final LoginBloc _loginBloc;
  final EventRepository _eventRepository;
  EventsBloc({
    required LoginBloc loginBloc,
    required EventRepository eventRepository,
  })  : _eventRepository = eventRepository,
        _loginBloc = loginBloc,
        super(const EventStateInitial()) {
    on<EventsLoadEvent>(_loadEvents);
  }

  void _loadEvents(
    EventsLoadEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventStateLoading());

    final uri = Uri.parse(RemoteUrls.getEvents).replace(
      queryParameters: {
        'search': event.search,
        'date': event.date,
        'venue': '',
      },
    );

    final result = await _eventRepository.getEvents(uri);

    result.fold((error) {
      emit( EventStateError(error.message, error.statusCode));
    }, (data) {
      emit( EventStateLoaded(data));
    });
  }
}

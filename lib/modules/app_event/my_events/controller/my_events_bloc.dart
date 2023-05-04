import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/remote_urls.dart';
import '../../../authentication/controllers/login/login_bloc.dart';
import '../../events/controller/event_repository.dart';
import '../../model/event_model.dart';

part 'my_events_event.dart';
part 'my_events_state.dart';

class MyEventsBloc extends Bloc<MyEventsEvent, MyEventState> {
  final LoginBloc _loginBloc;
  final EventRepository _eventRepository;
  MyEventsBloc({
    required LoginBloc loginBloc,
    required EventRepository eventRepository,
  })  : _eventRepository = eventRepository,
        _loginBloc = loginBloc,
        super(const MyEventStateInitial()) {
    on<MyEventsLoadEvent>(_loadEvents);
  }

  void _loadEvents(
      MyEventsLoadEvent event,
      Emitter<MyEventState> emit,
      ) async {
    emit(const MyEventStateLoading());

    final uri = Uri.parse(RemoteUrls.getUserEvents).replace(
      queryParameters: {
        'search': event.search,
        'date': event.date,
        'venue': '',
      },
    );

    final result = await _eventRepository.getEvents(uri);

    result.fold((error) {
      emit( MyEventStateError(error.message, error.statusCode));
    }, (data) {
      emit( MyEventStateLoaded(data));
    });
  }
}

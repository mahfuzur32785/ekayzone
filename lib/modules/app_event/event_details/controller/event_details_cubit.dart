import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/ad_details/controller/ad_details_state.dart';
import 'package:ekayzone/modules/ad_details/repository/ad_details_repository.dart';
import 'package:ekayzone/modules/app_event/events/controller/event_repository.dart';
import 'package:ekayzone/modules/authentication/controllers/login/login_bloc.dart';

import '../../model/event_model.dart';

part 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState>{
  EventDetailsCubit(this.eventRepository, this.loginBloc) : super(const EventDetailsStateLoading());
  final EventRepository eventRepository;
  final LoginBloc loginBloc;

  Future<void> getEventDetails(String slug, bool isLoading) async {
    if (isLoading) {
      emit(const EventDetailsStateLoading());
    }

    String token = '';
    if (loginBloc.userInfo != null) {
      token = '${loginBloc.userInfo?.accessToken}';
    }

    final result = await eventRepository.getEventDetails(slug,token);
    result.fold((error) => emit(EventDetailsStateError(error.message)), (data) => emit(EventDetailsStateLoaded(data)));
  }
}
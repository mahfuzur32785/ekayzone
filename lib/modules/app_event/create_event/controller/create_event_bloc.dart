import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ekayzone/modules/authentication/controllers/login/login_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../events/controller/event_repository.dart';
import '../../model/event_params_model.dart';

part 'create_event_event.dart';
part 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventModalState> {
  final EventRepository _eventRepository;
  final LoginBloc _loginBloc;
  final formKey = GlobalKey<FormState>();

  var titleController = TextEditingController(text: "");
  var detailsController = TextEditingController(text: "");
  var shortDescriptionController = TextEditingController(text: "");
  var venueNameController = TextEditingController(text: "");
  var venueAddressController = TextEditingController(text: "");
  var venueCityController = TextEditingController(text: "");
  var venueStateController = TextEditingController(text: "");
  var venueCountryController = TextEditingController(text: "");
  var venuePhoneController = TextEditingController(text: "");
  var venueWebLinkController = TextEditingController(text: "");
  var venuePostalCodeController = TextEditingController(text: "");
  var startDateController = TextEditingController(text: "");
  var startTimeController = TextEditingController(text: "");
  var endTimeController = TextEditingController(text: "");
  var endDateController = TextEditingController(text: "");
  var eventLinkController = TextEditingController(text: "");
  var costController = TextEditingController(text: "");
  var statusReasonController = TextEditingController(text: "");

  CreateEventBloc({
    required EventRepository eventRepository,
    required LoginBloc loginBloc,
  })  : _eventRepository = eventRepository,
        _loginBloc = loginBloc,
        super(const CreateEventModalState()) {
    on<CreateEventEvenTitle>((event, emit) {
      emit(state.copyWith(title: event.title));
    });
    on<CreateEventEventDetails>((event, emit) {
      emit(state.copyWith(details: event.details));
    });
    on<CreateEventEvenShortDescription>((event, emit) {
      emit(state.copyWith(shortDescription: event.shortDescription));
    });
    on<CreateEventEventVenueCountry>((event, emit) {
      emit(state.copyWith(venueCountry: event.value));
    });
    on<CreateEventEventVenueCity>((event, emit) {
      emit(state.copyWith(venueCity: event.value));
    });
    on<CreateEventEventVenueId>((event, emit) {
      emit(state.copyWith(venueId: event.value));
    });
    on<CreateEventEventVenueName>((event, emit) {
      emit(state.copyWith(venueName: event.value));
    });
    on<CreateEventEventVenuePhone>((event, emit) {
      emit(state.copyWith(venuePhone: event.phone));
    });
    on<CreateEventEventVenuePostalCode>((event, emit) {
      emit(state.copyWith(venuePostalCode: event.value));
    });
    on<CreateEventEventVenueState>((event, emit) {
      emit(state.copyWith(venueState: event.value));
    });
    on<CreateEventEventVenueAddress>((event, emit) {
      emit(state.copyWith(venueAddress: event.value));
    });
    on<CreateEventEventVenueWebLink>((event, emit) {
      emit(state.copyWith(venueWebsite: event.value));
    });
    on<CreateEventEventImage>((event, emit) {
      emit(state.copyWith(image: event.image));
    });
    on<CreateEventEventAccessible>((event, emit) {
      emit(state.copyWith(accessible: event.value));
    });
    on<CreateEventEventWheelChair>((event, emit) {
      emit(state.copyWith(wheelChair: event.value));
    });
    on<CreateEventEventAllDayEvent>((event, emit) {
      emit(state.copyWith(allDayEventStatus: event.value));
    });
    on<CreateEventEventStartDate>((event, emit) {
      emit(state.copyWith(startDate: event.value));
    });
    on<CreateEventEventStartTime>((event, emit) {
      emit(state.copyWith(startTime: event.value));
    });
    on<CreateEventEventEndTime>((event, emit) {
      emit(state.copyWith(endTime: event.value));
    });
    on<CreateEventEventEndDate>((event, emit) {
      emit(state.copyWith(endDate: event.value));
    });
    on<CreateEventEventTimezone>((event, emit) {
      emit(state.copyWith(timezone: event.value));
    });
    on<CreateEventEventCategoryId>((event, emit) {
      emit(state.copyWith(categoryId: event.value));
    });
    on<CreateEventEventTagId>((event, emit) {
      emit(state.copyWith(tagId: event.value));
    });
    on<CreateEventEvenStatus>((event, emit) {
      emit(state.copyWith(eventStatus: event.value));
    });
    on<CreateEventEventReason>((event, emit) {
      emit(state.copyWith(eventStatusReason: event.value));
    });
    on<CreateEventEventLink>((event, emit) {
      emit(state.copyWith(eventInfoLink: event.link));
    });
    on<CreateEventEventCost>((event, emit) {
      emit(state.copyWith(cost: event.value));
    });
    on<CreateEventEventOrganiser>((event, emit) {
      emit(state.copyWith(organisers: event.organisers));
    });
    on<CreateEventEventSubmit>(_submitCreateEventForm);
    on<CreateEventLoadParams>(_loadEventParams);
  }

  EventParamsModel? eventParamsModel;
  List<Venue> venueList = [];

  Future<void> _submitCreateEventForm(
    CreateEventEventSubmit event,
    Emitter<CreateEventModalState> emit,
  ) async {
    if (!formKey.currentState!.validate()) return;

    if (_loginBloc.userInfo == null) {
      const error = CreateEventStateError("Please Sign in", 401);
      emit(state.copyWith(state: error));
      return;
    }

    emit(state.copyWith(state: const CreateEventStateLoading()));

    final token = _loginBloc.userInfo!.accessToken;

    final result = await _eventRepository.createEventSubmit(state, token);

    result.fold(
      (Failure failure) {
        final error =
            CreateEventStateError(failure.message, failure.statusCode);
        emit(state.copyWith(state: error));
      },
      (message) async {
        final loadedData = CreateEventStateLoaded(message);
        titleController.text = '';
        detailsController.text = '';
        shortDescriptionController.text = '';
        venueNameController.text = '';
        venueAddressController.text = '';
        venueCityController.text = '';
        venueStateController.text = '';
        venueCountryController.text = '';
        venuePhoneController.text = '';
        venueWebLinkController.text = '';
        venuePostalCodeController.text = '';
        startDateController.text = '';
        startTimeController.text = '';
        endTimeController.text = '';
        endDateController.text = '';
        eventLinkController.text = '';
        costController.text = '';
        statusReasonController.text = '';
        emit(state.copyWith(state: loadedData));
      },
    );
  }

  Future<void> _loadEventParams(
    CreateEventLoadParams event,
    Emitter<CreateEventModalState> emit,
  ) async {
    emit(state.copyWith(state: const CreateEventStateCategoryLoading()));

    final result = await _eventRepository.getEventParams();

    result.fold(
      (Failure failure) {
        final error = CreateEventStateCategoryError(failure.message, failure.statusCode);
        emit(state.copyWith(state: error));
      },
      (data) async {
        eventParamsModel = data;
        venueList = getVenues(data.data.venues);
        final loadedData = CreateEventStateCategoryLoaded(data);
        emit(state.copyWith(state: loadedData));
      },
    );
  }

  Venue demoVenue = Venue(
      id: 0,
      name: 'Create New Venue',
      phone: '',
      website: '',
      status: 1,
      slug: '',
      address: '',
      city: '',
      country: 'create_new_venue',
      state: '',
      postalCode: '');
  List<Venue> getVenues(List<Venue> venues) {
    venues.add(demoVenue);
    return venues;
  }

}

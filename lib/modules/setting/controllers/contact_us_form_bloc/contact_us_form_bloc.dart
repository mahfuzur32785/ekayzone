import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../utils/utils.dart';
import '../../model/contact_us_mesage_model.dart';
import '../repository/setting_repository.dart';
part 'contact_us_form_event.dart';
part 'contact_us_form_state.dart';

class ContactUsFormBloc extends Bloc<ContactUsFormEvent, ContactUsFormState> {
  final SettingRepository settingRepository;
  final formKey = GlobalKey<FormState>();

  ContactUsFormBloc(this.settingRepository)
      : super(const ContactUsFormState()) {
    on<ContactUsFormNameChange>(_nameChange);
    on<ContactUsFormEmailChange>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<ContactUsFormPhoneChange>((event, emit) {
      emit(state.copyWith(phone: event.phone));
    });
    on<ContactUsFormSubjectChange>((event, emit) {
      emit(state.copyWith(subject: event.subject));
    });
    on<ContactUsFormMessageChange>((event, emit) {
      emit(state.copyWith(message: event.message));
    });
    on<ContactUsFormSubmit>(_formSubmitChange);
  }

  var nameCtr = TextEditingController();
  var emailCtr = TextEditingController();
  var subjectCtr = TextEditingController();
  var messageCtr = TextEditingController();
  var phoneCtr = TextEditingController();

  void _nameChange(
      ContactUsFormNameChange event, Emitter<ContactUsFormState> emit) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _formSubmitChange(
    ContactUsFormSubmit event,
    Emitter<ContactUsFormState> emit,
  ) async {
    if (!formKey.currentState!.validate()) return;

    emit(state.copyWith(status: const ContactUsFormStatusLoading()));
    final messageModel = ContactUsMessageModel.fromMap(state.toMap());

    final result =
        await settingRepository.getContactUsMessageSend(messageModel);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContactUsFormStatusError(failure.message),
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
              name: '',
              email: '',
              subject: '',
              phone: '',
              message: '',
              status: const ContactUsFormStatusLoaded("Thank you, We will contact you soon.")),
        );
        nameCtr.text = '';
        emailCtr.text = '';
        subjectCtr.text = '';
        messageCtr.text = '';
        phoneCtr.text = '';
      },
    );
  }
}

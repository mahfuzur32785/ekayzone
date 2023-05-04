import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/core/error/failure.dart';
import 'package:ekayzone/modules/authentication/controllers/login/login_bloc.dart';
import 'package:ekayzone/modules/setting/controllers/repository/setting_repository.dart';

part 'acc_deletion_event.dart';
part 'acc_deletion_state_model.dart';

class AccDeletionBloc extends Bloc<AccDeletionEvent, AccDeletionState> {
  final SettingRepository _settingRepository;
  final LoginBloc _loginBloc;

  AccDeletionBloc({
    required SettingRepository settingRepository,
    required LoginBloc loginBloc,
  })  : _settingRepository = settingRepository,
        _loginBloc = loginBloc,
        super(const AccDeletionStateInitial()) {
    on<AccDeletionEventSubmit>(_submitAccDeletionForm);
  }

  List<String> reasonList = [
    'I don\'t nee it anymore',
    'I accidentally made another account',
    'I registered by mistake, I don\'t need this account',
    'I\'m switching to someone else',
    'I\'m getting to many emails',
    'I\'m concern about privacy',
    'I want a business account',
    'Other',
  ];

  Future<void> _submitAccDeletionForm(
    AccDeletionEventSubmit event,
    Emitter<AccDeletionState> emit,
  ) async {
    if (_loginBloc.userInfo == null) {
      emit(const AccDeletionStateError('Signin please', 401));
      return;
    }

    emit(const AccDeletionStateLoading());

    final result = await _settingRepository.deletionRequest(event.reason,event.inputReason,_loginBloc.userInfo!.accessToken);

    result.fold(
      (Failure failure) {
        final error = AccDeletionStateError(failure.message, failure.statusCode);
        emit(error);
      },
      (successData) {
        emit(AccDeletionStateLoaded(successData));
      },
    );
  }
}

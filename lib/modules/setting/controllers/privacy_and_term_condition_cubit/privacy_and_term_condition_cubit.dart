import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/privacy_policy_model.dart';
import '../repository/setting_repository.dart';
part 'privacy_and_term_condition_cubit_state.dart';

class PrivacyAndTermConditionCubit
    extends Cubit<PrivacyTermConditionCubitState> {
  PrivacyAndTermConditionCubit(this.settingRepository)
      : super(TermConditionCubitStateLoading());

  final SettingRepository settingRepository;

  Future<void> getTermsAndConditionData(bool isLoading) async {
    if (isLoading) {
      emit(TermConditionCubitStateLoading());
    }

    final result = await settingRepository.getTermsAndCondition();
    result.fold(
      (failure) {
        emit(TermConditionCubitStateError(errorMessage: failure.message));
      },
      (data) {
        emit(
          TermConditionCubitStateLoaded(
            data: data,
          ),
        );
      },
    );
  }

  Future<void> getPrivacyPolicyData(bool isLoading) async {
    if (isLoading) {
      emit(TermConditionCubitStateLoading());
    }
    final result = await settingRepository.getPrivacyPolicy();
    result.fold(
      (failure) {
        emit(TermConditionCubitStateError(errorMessage: failure.message));
      },
      (data) {
        emit(
          TermConditionCubitStateLoaded(
            data: data,
          ),
        );
      },
    );
  }

  Future<void> getPostingRulesData(bool isLoading) async {
    if (isLoading) {
      emit(TermConditionCubitStateLoading());
    }
    final result = await settingRepository.getPostingRules();
    result.fold(
      (failure) {
        emit(TermConditionCubitStateError(errorMessage: failure.message));
      },
      (data) {
        emit(
          TermConditionCubitStateLoaded(
            data: data,
          ),
        );
      },
    );
  }
}

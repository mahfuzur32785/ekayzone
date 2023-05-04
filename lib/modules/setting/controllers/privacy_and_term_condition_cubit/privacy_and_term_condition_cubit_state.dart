part of 'privacy_and_term_condition_cubit.dart';

abstract class PrivacyTermConditionCubitState extends Equatable {
  const PrivacyTermConditionCubitState();

  @override
  List<Object> get props => [];
}

class TermConditionCubitStateLoading extends PrivacyTermConditionCubitState {}

class TermConditionCubitStateError extends PrivacyTermConditionCubitState {
  final String errorMessage;
  const TermConditionCubitStateError({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class TermConditionCubitStateLoaded extends PrivacyTermConditionCubitState {
  final String data;
  const TermConditionCubitStateLoaded(
      {required this.data});

  TermConditionCubitStateLoaded copyWith(
      {String?
          data}) {
    return TermConditionCubitStateLoaded(
      data: data ??
          this.data,
    );
  }

  @override
  List<Object> get props => [data];
}

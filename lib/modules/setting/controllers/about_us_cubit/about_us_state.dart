part of 'about_us_cubit.dart';

abstract class AboutUsState extends Equatable {
  const AboutUsState();

  @override
  List<Object> get props => [];
}

class AboutUsStateLoading extends AboutUsState {}

class AboutUsStateError extends AboutUsState {
  final String errorMessage;
  const AboutUsStateError({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class AboutUsStateLoaded extends AboutUsState {
  final String data;
  const AboutUsStateLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

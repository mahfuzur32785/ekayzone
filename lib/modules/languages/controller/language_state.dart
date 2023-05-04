part of 'language_cubit.dart';

class LanguageState extends Equatable{
  const LanguageState();
  @override
  List<Object> get props => [];
}

class LanguageStateLoading extends LanguageState {
  const LanguageStateLoading();
}

class LanguageStateError extends LanguageState {
  final String message;
  const LanguageStateError(this.message);
  @override
  List<Object> get props => [message];
}

class LanguageStateLoaded extends LanguageState {
  final List<LanguageModel> languageList;
  const LanguageStateLoaded(this.languageList);
  @override
  List<Object> get props => [languageList];
}
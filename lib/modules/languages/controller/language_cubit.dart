import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/ad_details/controller/ad_details_state.dart';
import 'package:ekayzone/modules/ad_details/repository/ad_details_repository.dart';
import 'package:ekayzone/modules/languages/controller/language_repository.dart';
import 'package:ekayzone/modules/languages/model/language_model.dart';

import '../../ad_details/model/details_response_model.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit(this.languageRepository) : super(const LanguageStateLoading());
  final LanguageRepository languageRepository;

  List<LanguageModel> languages = [];

  Future<void> getLanguages() async {
    emit(const LanguageStateLoading());
    languageRepository.checkLanguage().fold((l) async {
      final result = await languageRepository.getLanguages();
      result.fold((error) => emit(LanguageStateError(error.message)),
              (data) {
        languages = data;
                emit(LanguageStateLoaded(data));
              });
    }, (r) {
      print("ssssssssssssssssssssssss");
      final result = languageRepository.getCachedLanguages();
      result.fold((error) => emit(LanguageStateError(error.message)),
              (data) {
            languages = data;
            emit(LanguageStateLoaded(data));
          });
    });
  }

  String getCountryName(code){
    for(LanguageModel language in languages){
      if (language.code == code) {
        return language.name;
      }
    }
    return "English";
  }

}

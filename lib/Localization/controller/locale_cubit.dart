import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/utils/k_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/datasources/local_data_source.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleSate>{
  // LocaleCubit() : super(SelectedLocale(const Locale('en')));
  final LocalDataSource _localDataSource;
  LocaleCubit(LocalDataSource localDataSource) : _localDataSource = localDataSource, super(SelectedLocale(const Locale('en')));

  void toEnglish() => emit(SelectedLocale(const Locale('en')));

  void toFrance() => emit(SelectedLocale(const Locale('fr')));

  void toChinese() => emit(SelectedLocale(const Locale('zh')));

  void toBislama() => emit(SelectedLocale(const Locale('bi')));

  void toChange(String code) => emit(SelectedLocale(Locale(code)));
}
import 'package:flutter/material.dart';
import 'package:ekayzone/Localization/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizationsSetup {
  static const Iterable<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('zh'),
    Locale('bs'),
  ];

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegate = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    AppLocalizations.delegate,
  ];

  static Locale localeResolutionCallBack(Locale? locale, Iterable<Locale>? supportedLocales){
    for(Locale supportedLocale in supportedLocales!){
      if (supportedLocale.languageCode == locale?.languageCode && supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }  
    }
    return supportedLocales.first;
  }
}
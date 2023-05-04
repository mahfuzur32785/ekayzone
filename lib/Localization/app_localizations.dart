import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ekayzone/Localization/app_localizations_delegate.dart';
import 'package:ekayzone/core/remote_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  Map<String, String> _localizedString = {};

  Future<void> load() async {
    SharedPreferences ls = await SharedPreferences.getInstance();
    var langData = ls.getString(locale.languageCode);
    if (langData != null) {
      loadFromLocal();
    } else {
      try {
        // Uri url = Uri.parse("http://192.168.203.60:8000/api/lenguage/${locale.languageCode}");
        String code = locale.languageCode == 'bs' ? 'bi' : locale.languageCode;
        Uri url = Uri.parse(RemoteUrls.getSingleLanguage(code));
        await http.get(url).then((response) {
          var body = json.decode(response.body);
          if (body["status"] == 1) {
            var jsonString = json.encode(body["data"]);
            ls.setString(locale.languageCode, jsonString).then((value) => print("mmmmmmmmmmmmmmmmmmmmmmmm $value mmmmmmmmmmmmmmmmmmm"));
            Map<String, dynamic> jsonMap = body["data"];
            _localizedString = jsonMap.map((key, value) {
              return MapEntry(key, value.toString());
            });
          } else {
            loadFromLocal();
          }

        });
      } catch (e){
        loadFromLocal();
      }
    }
  }

  void loadFromLocal() async {
    print(".............. Language From Local ...............");
    SharedPreferences ls = await SharedPreferences.getInstance();
    var langData = ls.getString(locale.languageCode);
    if (langData != null) {
      Map<String, dynamic> jsonMap = json.decode(langData);
      _localizedString = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } else {
      String jsonString = await rootBundle.loadString('lang/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedString = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    }
  }

  String? translate(String key) => _localizedString[key] ?? key;

  bool get isEnLocale => locale.languageCode == 'en';

  String get countryName {
    if (locale.languageCode == 'en') {
      return 'English';
    } else if (locale.languageCode == 'fr') {
      return 'French';
    } else if (locale.languageCode == 'zh') {
      return 'Chinese';
    } else if (locale.languageCode == 'bi') {
      return 'Bislama';
    }
    return 'English';
  }

  String get languageCode => locale.languageCode;
}
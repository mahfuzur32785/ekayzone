import 'dart:convert';
import 'dart:developer';
import 'package:ekayzone/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exception.dart';
import '../../../modules/authentication/models/user_login_response_model.dart';
import '../../../modules/authentication/models/user_prfile_model.dart';
import '../../../modules/languages/model/language_model.dart';
import '../../../modules/setting/model/setting_model.dart';
import '../../../utils/k_strings.dart';

abstract class LocalDataSource {
  /// Gets the cached [UserLoginResponseModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  UserLoginResponseModel getUserResponseModel();

  Future<bool> cacheUserResponse(UserLoginResponseModel userLoginResponseModel);
  Future<bool> cacheUserProfile(UserProfileModel userProfileModel);
  Future<bool> clearUserProfile();
  bool checkOnBoarding();
  Future<bool> cacheOnBoarding();

  Future<bool> cacheWebsiteSetting(SettingModel result);
  SettingModel getWebsiteSetting();

  //.............. language ..............
  Future<bool> cacheLanguages(List<LanguageModel> languages);
  bool checkLanguage();
  Future<bool> cacheLanguage();

  List<LanguageModel> getCachedLanguages();
}

class LocalDataSourceImpl implements LocalDataSource {
  final _className = 'LocalDataSourceImpl';
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  UserLoginResponseModel getUserResponseModel() {
    final jsonString =
    sharedPreferences.getString(KStrings.cachedUserResponseKey);
    if (jsonString != null) {
      return UserLoginResponseModel.fromJson(jsonString);
    } else {
      throw const DatabaseException('Not cached yet');
    }
  }

  @override
  Future<bool> cacheUserResponse(
      UserLoginResponseModel userLoginResponseModel) {
    return sharedPreferences.setString(
      KStrings.cachedUserResponseKey,
      userLoginResponseModel.toJson(),
    );
  }

  @override
  Future<bool> cacheUserProfile(UserProfileModel userProfileModel) {
    final user = getUserResponseModel();
    user.user != userProfileModel;
    return cacheUserResponse(user);
  }

  @override
  Future<bool> clearUserProfile() {
    return sharedPreferences.remove(KStrings.cachedUserResponseKey);
  }

  @override
  bool checkOnBoarding() {
    final jsonString = sharedPreferences.getBool(KStrings.cacheOnBoardingKey);
    if (jsonString != null) {
      return true;
    } else {
      throw const DatabaseException('Not cached yet');
    }
  }

  @override
  Future<bool> cacheOnBoarding() {
    return sharedPreferences.setBool(KStrings.cacheOnBoardingKey, true);
  }

  @override
  Future<bool> cacheWebsiteSetting(SettingModel settingModel) async {
    // log(settingModel.toJson(), name: _className);
    return sharedPreferences.setString(
        KStrings.cachedWebSettingKey, settingModel.toJson());
  }

  @override
  SettingModel getWebsiteSetting() {
    final jsonString =
    sharedPreferences.getString(KStrings.cachedWebSettingKey);
    // log(jsonString.toString(), name: _className);
    if (jsonString != null) {
      return SettingModel.fromJson(jsonString);
    } else {
      throw const DatabaseException('Not cached yet');
    }
  }

  //................ Language ................

  @override
  bool checkLanguage() {
    final jsonString = sharedPreferences.getString(KStrings.isCachedAllLanguage);
    if (jsonString != null) {
      int days = Utils.calculateMaxDays(jsonString, DateTime.now().toString());
      print("........ Days $days .............");
      return days > 0 ? false : true;
    } else {
      throw const DatabaseException('Not cached yet');
    }
  }

  @override
  Future<bool> cacheLanguage() {
    return sharedPreferences.setString(KStrings.isCachedAllLanguage, DateTime.now().toString());
  }

  @override
  Future<bool> cacheLanguages(List<LanguageModel> languages) async {
    var data = {};
    data["data"] = languages;
    sharedPreferences.setString(KStrings.cachedAllLanguage, json.encode(data));
    for(LanguageModel language in languages){
      sharedPreferences.setString(language.code, json.encode(language.jsonData));
    }
    return true;
  }

  @override
  List<LanguageModel> getCachedLanguages() {
    final jsonString =
    sharedPreferences.getString(KStrings.cachedAllLanguage);
    // log(jsonString.toString(), name: _className);
    if (jsonString != null) {
      var mapData = json.decode(jsonString.toString());
      // print('zzzzzzzzzzzzzzzzzzzzzzzzzzzz $mapData zzzzzzzzzzzzzzzzzzzzzzzz');
      return List<dynamic>.from(mapData["data"]).map((e) => LanguageModel.fromJson(e)).toList();
    } else {
      throw const DatabaseException('Not cached yet');
    }
  }

}

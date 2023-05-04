import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ekayzone/modules/ad_details/model/ad_details_model.dart';
import 'package:flutter/foundation.dart';
import 'package:ekayzone/modules/home/model/category_model.dart' as CategoroyModel;
import 'package:http/http.dart' as http;
import 'package:ekayzone/modules/ad_details/model/details_response_model.dart';
import 'package:ekayzone/modules/ads/model/customer_adlist_response_model.dart';
import 'package:ekayzone/modules/chat/model/chat_model.dart';
import 'package:ekayzone/modules/dashboard/model/overview_model.dart';
import 'package:ekayzone/modules/directory/model/directory_model.dart';
import 'package:ekayzone/modules/directory/model/directory_response_model.dart';
import 'package:ekayzone/modules/home/model/ad_model.dart';
import 'package:ekayzone/modules/languages/model/language_model.dart';
import 'package:ekayzone/modules/my_plans/model/plans_billing_model.dart';
import 'package:ekayzone/modules/post_ad/controller/postad_bloc.dart';
import 'package:ekayzone/modules/price_planing/model/payment_gateways_response_model.dart';
import 'package:ekayzone/modules/home/model/pricing_model.dart';
import 'package:ekayzone/modules/profile/model/public_profile_model.dart';
import 'package:ekayzone/modules/seller/model/seller_response_model.dart';
import 'package:ekayzone/modules/setting/model/contact_us_mesage_model.dart';
import 'package:ekayzone/modules/setting/model/contact_us_mode.dart';
import 'package:ekayzone/modules/setting/model/setting_model.dart';
import 'package:ekayzone/modules/setting/model/user_with_country_response.dart';
import 'package:ekayzone/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../modules/ads/model/adlist_response_model.dart';
import '../../../modules/ads/new_ad_edit/controller/new_ad_edit_bloc.dart';
import '../../../modules/app_event/create_event/controller/create_event_bloc.dart';
import '../../../modules/app_event/model/event_model.dart';
import '../../../modules/app_event/model/event_params_model.dart';
import '../../../modules/authentication/models/set_password_model.dart';
import '../../../modules/authentication/models/user_login_response_model.dart';
import '../../../modules/chat/model/message_model.dart';
import '../../../modules/directory/create_directory/controller/create_directory_bloc.dart';
import '../../../modules/home/model/home_model.dart';
import '../../../modules/new_post_ad/controller/new_posted_bloc.dart';
import '../../../modules/profile/controller/change_password/change_password_cubit.dart';
import '../../../modules/setting/address/controllers/profile_edit/profile_edit_cubit.dart';
import '../../../modules/setting/model/billing_shipping_model.dart';
import '../../../modules/setting/model/city_model.dart';
import '../../../modules/setting/model/country_state_model.dart';
import '../../../modules/setting/model/faq_category_model.dart';
import '../../../utils/k_strings.dart';
import '../../error/exception.dart';
import '../../remote_urls.dart';

abstract class RemoteDataSource {
  Future<UserLoginResponseModel> signIn(Map<String, dynamic> body);
  Future<UserWithCountryResponse> userProfile(String token);
  Future<PublicProfileModel> publicProfile(String username);
  Future<DOverViewModel> dashboardOverview(String token);
  // Future<String> passwordChange(
  //     ChangePasswordStateModel changePassData, String token);
  // Future<String> profileUpdate(ProfileEditStateModel user, String token);

  Future<HomeModel> getHomeData();
  Future<DetailsResponseModel> getAdDetails(String slug,String token);
  Future<AdListResponseModel> searchAds(Uri uri);
  Future<CustomerAdListResponseModel> customerAds(Uri uri,String token);
  Future<String> deleteMyAd(int id,String token);
  Future<SellerResponseModel> sellers(Uri uri);
  Future<String> postSellerReview(Map<String, dynamic> body,String seller,String token);

  //......... Directory .............
  Future<DirectoryResponseModel> searchDirectory(Uri uri);
  Future<DirectoryResponseModel> getMyDirectory(Uri uri,String token);
  Future<DirectoryModel> getDirectoryDetails(Uri uri);
  Future<String> createDirectory(CreateDirectoryModalState state,String token);
  Future<List<CategoroyModel.Category>> getDirectoryCategories();
  Future<String> contactWithAuthor(Map<String, String> body, String token);
  Future<String> claimBusiness(Map<String, String> body, String token);

  //........... Events ..............
  Future<List<EventModel>> getEvents(Uri uri);
  Future<EventModel> getEventDetails(String slug,String token);
  Future<EventParamsModel> getEventParams();
  Future<String> createEventSubmit(CreateEventModalState state,String token);

  Future<String> postAdSubmit(PostAdModalState state,String token);

  Future<AdDetails> newPostAdSubmit(NewPostAdModalState state,String token);
  Future<String> newAdEditSubmit(NewEditAdModalState state,String token,String id);


  Future<List<PricingModel>> getPricingList();
  Future<List<PlansBillingModel>> getMyPlanBillingList(String token);
  Future<PaymentGatewaysResponseModel> paymentGateways(String token);

  Future<String> sendForgotPassCode(Map<String, dynamic> body);
  Future<String> setPassword(Map<String, dynamic> body);
  Future<String> sendActiveAccountCode(String email);
  Future<String> activeAccountCodeSubmit(String code);
  Future<String> logOut(String token);
  Future<SettingModel> websiteSetup();
  Future<List<LanguageModel>> getLanguages();
  Future<String> userRegister(Map<String, dynamic> userInfo);
  Future<UserLoginResponseModel> socialLogin(Map<String, dynamic> userInfo);

  Future<ChatModel> getChatUsers(String token,{String user = ''});
  Future<List<MessageModel>> postSendMessage(String token,String body,String user);

  Future<String> getAboutUsData();
  Future<List<FaqCategoryModel>> getFaqList();
  Future<String> getPrivacyPolicy();
  Future<String> getPostingRules();
  Future<String> getTermsAndCondition();
  Future<ContactUsModel> getContactUsContent();
  Future<String> accDeletionRequest(String reason,String reasonInText,String token);
  Future<bool> getContactUsMessageSend(ContactUsMessageModel body);

  Future<List<CountryStateModel>> statesByCountryId(
      String countryID, String token);
  Future<List<CityModel>> citiesByStateId(String countryID, String token);
  Future<BillingShippingModel> getShippingAndBillingAddress(String token);
  Future<String> billingUpdate(Map<String, String> dataMap, String token);
  Future<String> shippingUpdate(Map<String, String> dataMap, String token);

  Future<List<AdModel>> wishList(String token);
  Future<String> removeWishList(int id, String token);
  Future<String> addWishList(int id, String token);
  Future<String> passwordChange(ChangePasswordStateModel changePassData, String token);
  Future<String> profileUpdate(ProfileEditStateModel user, String token);
  Future<Map<String, dynamic>> editProfile( Map<String,String> body, String token);
  Future<String> changePassword( Map<String,String> body, String token);
  Future<String> socialMediaUpdate( Map<String,dynamic> body, String token);
  Future<String> deleteAccount(String token);

  Future<String> stripePay(String token, Map<String, String> body);
  Future<String> paymentConfirmation(String token, Map<String, String> body);

  Future<dynamic> createPayfastPayment(Map<String, dynamic> body, String token);

}

typedef CallClientMethod = Future<http.Response> Function();

class RemoteDataSourceImpl extends RemoteDataSource {
  final http.Client client;
  final _className = 'RemoteDataSourceImpl';

  RemoteDataSourceImpl({required this.client});

  Future<dynamic> callClientWithCatchException(
      CallClientMethod callClientMethod) async {
    try {
      final response = await callClientMethod();
      // log(response.statusCode.toString(), name: _className);
      // log(response.body, name: _className);
      if (kDebugMode) {
        print("status code : ${response.statusCode}");
        print(response.body);
      }
      return _responseParser(response);
    } on SocketException {
      log('SocketException', name: _className);
      // var text = '';
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // print(connectivityResult.name);
      // if (connectivityResult == ConnectivityResult.none) {
      //   text = 'Internet Connection';
      // }  else if (connectivityResult == ConnectivityResult.mobile) {
      //   text = 'Mobile Data Connection';
      // } else if (connectivityResult == ConnectivityResult.wifi) {
      //   text = 'Wifi Connection';
      // }
      throw const NetworkException('Please check your \nInternet Connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormatException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
  }

  @override
  Future<HomeModel> getHomeData() async {
    final uri = Uri.parse(RemoteUrls.homeUrl);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return HomeModel.fromMap(responseJsonBody["data"]);
  }

  @override
  Future<String> postAdSubmit(PostAdModalState state,String token) async {
    final headers = {'Accept': 'application/json','Content-Type': 'application/json','Authorization': 'Bearer $token'};
    // final headers = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.postAdCreate);

    // final result = <String, dynamic>{};
    //
    // // result.addAll({'title': state.name.trim()});
    // result.addAll({'price': state.price.trim()});
    // result.addAll({'category_id': state.category});
    // result.addAll({'subCategory': state.subCategory});
    // result.addAll({'phone': state.phone.trim()});
    // result.addAll({'show_phone': state.isShowPhone ? '1' : '0'});
    // result.addAll({'phone_2': state.backupPhone.trim()});
    // result.addAll({'whatsapp': state.weChat.trim()});
    // result.addAll({'description': state.description.trim()});
    // result.addAll({'features[]': state.features.map((e) => e).toList()});
    // result.addAll({'images': state.images.map((e) => e).toList()});
    // result.addAll({'address': state.location.trim()});
    // result.addAll({'featured': '0'});
    // result.addAll({'brand': ''});
    //
    // Map<String, String> stringQueryParameters =
    // result.map((key, value) => MapEntry(key, value!.toString()));
    // if (kDebugMode) {
    //   print(stringQueryParameters);
    // }
    // final request = http.MultipartRequest('POST', uri);
    // request.fields.addAll(stringQueryParameters);
    // request.headers.addAll(headers);
    //
    // if (state.images.isNotEmpty) {
    //   List<http.MultipartFile> files = [];
    //   for(var path in state.images){
    //     files.add(await http.MultipartFile.fromPath('images', path));
    //   }
    //   request.files.addAll(files);
    // }
    // print("xxxxxxxxxxxxxxx");
    //
    // http.StreamedResponse response = await request.send();
    // final clientMethod = http.Response.fromStream(response);

    //...........................
    Map<String, String> stringQueryParameters =
    state.toMap().map((key, value) => MapEntry(key, value!.toString()));

    var request = jsonEncode(stringQueryParameters);
    if (kDebugMode) {
      print(request);
    }

    final clientMethod = client.post(uri, headers: headers, body: request,);
    //.................
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      // final errorMsg = parsingDoseNotExist(responseJsonBody);
      final errorMsg = responseJsonBody["data"];
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["message"];
    }
  }


  @override
  Future<AdDetails> newPostAdSubmit(NewPostAdModalState state,String token) async {
    final headers = {'Accept': 'application/json','Content-Type': 'application/json','Authorization': 'Bearer $token'};
    // final headers = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.postAdCreate);

    Map<String, String> stringQueryParameters =
    state.toMap().map((key, value) => MapEntry(key, value!.toString()));

    var request = jsonEncode(stringQueryParameters);
    if (kDebugMode) {
      print(request);
    }

    final clientMethod = client.post(uri, headers: headers, body: request,);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody["data"];
      throw UnauthorisedException(errorMsg, 401);
    } {
      return AdDetails.fromMap(responseJsonBody["data"]);
    }
  }


  @override
  Future<String> newAdEditSubmit(NewEditAdModalState state,String token,String id) async {
    final headers = {'Accept': 'application/json','Content-Type': 'application/json','Authorization': 'Bearer $token'};
    // final headers = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.adUpdate(id));

    Map<String, String> stringQueryParameters =
    state.toMap().map((key, value) => MapEntry(key, value!.toString()));

    var request = jsonEncode(stringQueryParameters);
    if (kDebugMode) {
      // print(request);
      request.log();
    }

    final clientMethod = client.post(uri, headers: headers, body: request);
    //.................
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      // final errorMsg = parsingDoseNotExist(responseJsonBody);
      final errorMsg = responseJsonBody["data"];
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["message"];
    }
  }

  @override
  Future<List<PricingModel>> getPricingList() async {
    final uri = Uri.parse(RemoteUrls.pricingPlan);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return List.from(responseJsonBody["data"]).map((e) => PricingModel.fromMap(e)).toList();
    }
  }

  @override
  Future<List<PlansBillingModel>> getMyPlanBillingList(String token) async {
    final uri = Uri.parse(RemoteUrls.myPlanBilling);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'}
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return List.from(responseJsonBody["data"]).map((e) => PlansBillingModel.fromMap(e)).toList();
    }
  }

  @override
  Future<PaymentGatewaysResponseModel> paymentGateways(String token) async {
    final uri = Uri.parse(RemoteUrls.paymentGateways);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'}
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return PaymentGatewaysResponseModel.fromMap(responseJsonBody);
    }
  }

  @override
  Future<DetailsResponseModel> getAdDetails(String slug,String token) async {
    final uri = Uri.parse(RemoteUrls.productDetail(slug));

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'}
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return DetailsResponseModel.fromMap(responseJsonBody["data"]);
  }

  @override
  Future<AdListResponseModel> searchAds(Uri uri) async {
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return AdListResponseModel.fromMap(responseJsonBody["data"]);
  }

  @override
  Future<CustomerAdListResponseModel> customerAds(Uri uri,String token) async {
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return CustomerAdListResponseModel.fromMap(responseJsonBody["data"]);
  }

  @override
  Future<String> deleteMyAd(int id,String token) async {
    final uri = Uri.parse(RemoteUrls.deleteMyAd(id));
    final clientMethod = client.delete(
      uri,
      // body: {'id': '$id'},
      headers: {'Accept': 'application/json','Authorization': 'Bearer $token'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["status"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } else {
      return responseJsonBody["message"];
    }
  }

  //............ Directory .............

  @override
  Future<DirectoryResponseModel> searchDirectory(Uri uri) async {
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return DirectoryResponseModel.fromMap(responseJsonBody["data"]);
  }

  @override
  Future<DirectoryResponseModel> getMyDirectory(Uri uri,String token) async {
    final clientMethod = client.get(
      uri,
      headers: {'Accept': 'application/json','Authorization': 'Bearer $token'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["success"] == false) {
      // final errorMsg = parsingDoseNotExist(responseJsonBody);
      final errorMsg = responseJsonBody["message"];
      throw UnauthorisedException(errorMsg, 401);
    } {
      return DirectoryResponseModel.fromMap(responseJsonBody["data"]);
    }
  }

  @override
  Future<DirectoryModel> getDirectoryDetails(Uri uri) async {
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["status"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } else {
      return DirectoryModel.fromMap(responseJsonBody["data"]);
    }
  }


  @override
  Future<String> createDirectory(CreateDirectoryModalState state,String token) async {
    final headers = {'Accept': 'application/json','Content-Type': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.createDirectory);

    Map<String, String> stringQueryParameters =
    state.toMap().map((key, value) => MapEntry(key, value!.toString()));

    var request = jsonEncode(stringQueryParameters);
    if (kDebugMode) {
      print(request);
    }

    final clientMethod = client.post(uri, headers: headers, body: request,);
    //.................
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      // final errorMsg = parsingDoseNotExist(responseJsonBody);
      final errorMsg = responseJsonBody["message"];
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["message"];
    }
  }

  @override
  Future<List<CategoroyModel.Category>> getDirectoryCategories() async {
    final uri = Uri.parse(RemoteUrls.getDirectoryCategory);
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw DataNotFoundException(errorMsg);
    } {
      SharedPreferences ls = await SharedPreferences.getInstance();
      ls.setString(KStrings.businessCategory, json.encode(responseJsonBody));
      return List.from(responseJsonBody["data"]).map((e) => CategoroyModel.Category.fromMap(e)).toList();
    }

  }
  @override
  Future<String> contactWithAuthor(Map<String, String> body, String token) async {
    final uri = Uri.parse(RemoteUrls.contactAuthor);
    final clientMethod = client.post(
      uri,
      body: body,
      headers: {'Accept': 'application/json','Authorization': 'Bearer $token'}
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw DataNotFoundException(errorMsg);
    } {
      return responseJsonBody["message"];
    }
  }

  @override
  Future<String> claimBusiness(Map<String, String> body, String token) async {
    final uri = Uri.parse(RemoteUrls.claimBusiness(body["post_id"]!));
    final clientMethod = client.post(
      uri,
      body: body,
      headers: {'Accept': 'application/json','Authorization': 'Bearer $token'}
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw DataNotFoundException(errorMsg);
    } {
      return responseJsonBody["message"];
    }
  }

  // ............ Events ................
  @override
  Future<List<EventModel>> getEvents(Uri uri) async {
    // final uri = Uri.parse(RemoteUrls.getEvents);
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw DataNotFoundException(errorMsg);
    } {
      SharedPreferences ls = await SharedPreferences.getInstance();
      ls.setString(KStrings.businessCategory, json.encode(responseJsonBody));
      return List.from(responseJsonBody["data"]).map((e) => EventModel.fromMap(e)).toList();
    }
  }


  @override
  Future<String> createEventSubmit(CreateEventModalState state,String token) async {
    final headers = {'Accept': 'application/json','Content-Type': 'application/json','Authorization': 'Bearer $token'};
    // final headers = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.createEvent);

    Map<String, String> stringQueryParameters =
    state.toMap().map((key, value) => MapEntry(key, value!.toString()));

    var request = jsonEncode(stringQueryParameters);
    if (kDebugMode) {
      print(request);
    }

    final clientMethod = client.post(uri, headers: headers, body: request,);

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody["data"];
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["message"];
    }
  }

  @override
  Future<EventModel> getEventDetails(String slug,String token) async {
    final uri = Uri.parse(RemoteUrls.getEventDetails(slug));
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw DataNotFoundException(errorMsg);
    } {
      return EventModel.fromMap(responseJsonBody["data"]);
    }
  }

  @override
  Future<EventParamsModel> getEventParams() async {
    final uri = Uri.parse(RemoteUrls.eventParams);
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw DataNotFoundException(errorMsg);
    } {
      return EventParamsModel.fromMap(responseJsonBody);
    }
  }


  @override
  Future<SellerResponseModel> sellers(Uri uri) async {
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw DataNotFoundException(errorMsg);
    } {
      return SellerResponseModel.fromMap(responseJsonBody["data"]);
    }

  }

  @override
  Future<String> postSellerReview(Map body,String seller,String token) async {
    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.postSellerReview(seller));

    final clientMethod = client.post(uri, headers: headers, body: body);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["message"];
    }
  }

  @override
  Future<UserLoginResponseModel> signIn(Map body) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.userLogin);

    final clientMethod = client.post(uri, headers: headers, body: body);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return UserLoginResponseModel.fromMap(responseJsonBody["data"]);
    }
  }

  @override
  Future<String> logOut(String token) async {
    final headers = {'Accept': 'application/json','bearer-token': token};
    final uri = Uri.parse(RemoteUrls.userLogOut());

    final clientMethod = client.post(uri, headers: headers);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'] as String;
  }

  @override
  Future<UserWithCountryResponse> userProfile(String token) async {
    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.userProfile);

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    return UserWithCountryResponse.fromMap(responseJsonBody);
  }

  @override
  Future<PublicProfileModel> publicProfile(String username) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.publicProfile(username));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return PublicProfileModel.fromMap(responseJsonBody["data"]);
    }
  }

  @override
  Future<DOverViewModel> dashboardOverview(String token) async {
    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.dashboardOverview);

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return DOverViewModel.fromMap(responseJsonBody["data"]);
    }
  }

  @override
  Future<String> userRegister(Map<String, dynamic> userInfo) async {
    final uri = Uri.parse(RemoteUrls.userRegister);

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: userInfo,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['data'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody['message'];
    }
  }

  @override
  Future<UserLoginResponseModel> socialLogin(Map<String, dynamic> userInfo) async {
    final uri = Uri.parse(RemoteUrls.socialLogin);

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: userInfo,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['data'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return UserLoginResponseModel.fromMap(responseJsonBody["data"]);
    }
  }

  @override
  Future<String> sendForgotPassCode(Map<String, dynamic> body) async {
    final uri = Uri.parse(RemoteUrls.sendForgetPassword);

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: body,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'];
  }

  @override
  Future<String> setPassword(Map<String, dynamic> body) async {
    final uri = Uri.parse(RemoteUrls.storeResetPassword);

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: body,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    return responseJsonBody['message'];
  }

  @override
  Future<String> sendActiveAccountCode(String email) async {
    final uri = Uri.parse(RemoteUrls.resendRegisterCode);

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: {'email': email},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'];
  }

  @override
  Future<String> activeAccountCodeSubmit(String code) async {
    final uri = Uri.parse(RemoteUrls.userVerification(code));

    final clientMethod =
    client.get(uri, headers: {'Accept': 'application/json'});

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'];
  }

  ///.............. App Settings Related Methods ...............
  @override
  Future<SettingModel> websiteSetup() async {
    // final uri = Uri.parse(RemoteUrls.websiteSetup);
    final uri = Uri.parse(RemoteUrls.websiteSetup);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    print(responseJsonBody['data']);

    return SettingModel.fromMap(responseJsonBody['data']);
  }

  @override
  Future<List<LanguageModel>> getLanguages() async {
    final uri = Uri.parse(RemoteUrls.getLanguages);
    // final uri = Uri.parse("http://192.168.203.60:8000/api/lenguage/sync");

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } else {
      return List<dynamic>.from(responseJsonBody["data"]).map((e) => LanguageModel.fromMap(e)).toList();
    }
  }

  @override
  Future<String> getAboutUsData() async {
    final uri = Uri.parse(RemoteUrls.aboutUs);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["data"]["about_content"]["about_body"];
    }
  }

  @override
  Future<String> accDeletionRequest(String reason,String reasonInText,String token) async {
    final result = <String, String>{};
    result.addAll({'token': token.toString()});
    result.addAll({'reason': reason.toString()});
    result.addAll({'reason_input': reasonInText});
    final uri = Uri.parse(RemoteUrls.accDeletion).replace(queryParameters: result);
    if (kDebugMode) {
      print(uri);
    }
    final clientMethod = client.get(
      uri,
      // body: {"reason": reason,"reason_input": reasonInText,"token":token},
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'] as String;
  }

  @override
  Future<bool> getContactUsMessageSend(ContactUsMessageModel body) async {
    final uri = Uri.parse(RemoteUrls.sendContactMessage);

    final clientMethod = client.post(
      uri,
      body: body.toMap(),
      headers: {'Accept': 'application/json'},
    );

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return true;
    }
  }

  @override
  Future<ContactUsModel> getContactUsContent() async {
    final uri = Uri.parse(RemoteUrls.contactUs);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return ContactUsModel.fromMap(responseJsonBody['contact']);
  }

  @override
  Future<ChatModel> getChatUsers(String token,{String user = ''}) async {
    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.getChatUsers(user));
    if (kDebugMode) {
      print(uri);
    }

    final clientMethod = client.get(
      uri,
      headers: headers,
    );

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return ChatModel.fromMap(responseJsonBody['data']);
    }
  }

  @override
  Future<List<MessageModel>> postSendMessage(String token,String body,String user) async {
    final uri = Uri.parse(RemoteUrls.getChatUsers(user));

    final clientMethod = client.post(
      uri,
      body: {"body": body},
      headers: {'Accept': 'application/json','Authorization': 'Bearer $token'},
    );

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return List<dynamic>.from(responseJsonBody["data"]["messages"]).map((e) => MessageModel.fromMap(e)).toList();
    }
  }

  @override
  Future<String> getPrivacyPolicy() async {
    final uri = Uri.parse(RemoteUrls.privacyPolicy);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final responseJsonBody = await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["data"]["privacy_body"];
    }
  }

  @override
  Future<String> getPostingRules() async {
    final uri = Uri.parse(RemoteUrls.postingRules);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final responseJsonBody = await callClientWithCatchException(() => clientMethod);
    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["data"]["posting_rules_body"];
    }
  }

  @override
  Future<String> getTermsAndCondition() async {
    final uri = Uri.parse(RemoteUrls.termsAndConditions);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["data"]["terms_body"];
    }
  }

  @override
  Future<List<FaqCategoryModel>> getFaqList() async {
    final uri = Uri.parse(RemoteUrls.faq);

    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["data"] == null ? [] : List<dynamic>.from(responseJsonBody["data"]).map((e) => FaqCategoryModel.fromMap(e)).toList();
    }
  }

  ///.............. Profile Related Method ............
  @override
  Future<BillingShippingModel> getShippingAndBillingAddress(String token) async {
    final uri = Uri.parse(RemoteUrls.address(token));
    if (kDebugMode) {
      print(uri);
    }
    final clientMethod = client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return BillingShippingModel.fromMap(responseJsonBody);
  }

  @override
  Future<String> billingUpdate(
      Map<String, String> dataMap,
      String token,
      ) async {
    final uri = Uri.parse(RemoteUrls.billingAddress(token));

    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: dataMap,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'] as String;
  }

  @override
  Future<String> shippingUpdate(
      Map<String, String> dataMap,
      String token,
      ) async {
    final uri = Uri.parse(RemoteUrls.shippingAddress(token));

    final headers = {'Accept': 'application/json'};
    final clientMethod = client.post(
      uri,
      headers: headers,
      body: dataMap,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'] as String;
  }

  @override
  Future<List<CountryStateModel>> statesByCountryId(
      String countryID, String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.stateByCountryId(countryID, token));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['states'] as List;

    return List<CountryStateModel>.from(
        mapList.map((e) => CountryStateModel.fromMap(e)));
  }

  @override
  Future<List<CityModel>> citiesByStateId(String stateID, String token) async {
    final headers = {'Accept': 'application/json'};
    final uri = Uri.parse(RemoteUrls.citiesByStateId(stateID, token));

    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    final mapList = responseJsonBody['cities'] as List;

    return List<CityModel>.from(mapList.map((e) => CityModel.fromMap(e)));
  }


  @override
  Future<List<AdModel>> wishList(String token) async {
    final uri = Uri.parse(RemoteUrls.wishList);

    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["success"] == false) {
      final errorMsg = responseJsonBody['message'].toString();
      throw UnauthorisedException(errorMsg, 401);
    } {
      final wishlist = responseJsonBody['data'] as List?;

      if (wishlist == null) {
        return [];
      } else {
        return wishlist.map((e) {
          final mapData = e['ad'] as Map<String, dynamic>;
          return AdModel.fromMap(mapData);
        }).toList();
      }
    }

  }

  @override
  Future<String> removeWishList(int id, String token) async {
    final uri = Uri.parse(RemoteUrls.removeWish(id, token));

    final headers = {'Accept': 'application/json'};
    final clientMethod = client.get(uri, headers: headers);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return responseJsonBody['notification'] as String;
  }

  @override
  Future<String> addWishList(int id, String token) async {
    final uri = Uri.parse(RemoteUrls.addWish(id));

    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final clientMethod = client.post(uri, headers: headers);
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'] as String;
  }

  @override
  Future<String> passwordChange(
      ChangePasswordStateModel changePassData,
      String token,
      ) async {
    final headers = {'Accept': 'application/json', 'Authorization': 'Bearer $token' };
    final uri = Uri.parse(RemoteUrls.passwordChange);

    final clientMethod =
    client.post(uri, headers: headers, body: changePassData.toMap());
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    // if (responseJsonBody["success"] == false) {
    //   final errorMsg = parsingDoseNotExist(responseJsonBody);
    //   throw UnauthorisedException(errorMsg, 401);
    // } {
    //   return responseJsonBody["message"];
    // }
    return responseJsonBody['notification'] as String;
  }

  @override
  Future<String> profileUpdate(ProfileEditStateModel user, String token) async {
    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.updateProfile(token));

    final request = http.MultipartRequest('POST', uri);
    request.fields.addAll(user.toMap());

    request.headers.addAll(headers);
    if (user.image.isNotEmpty) {
      final file = await http.MultipartFile.fromPath('image', user.image);
      request.files.add(file);
    }

    http.StreamedResponse response = await request.send();
    final clientMethod = http.Response.fromStream(response);

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    return responseJsonBody['notification'] as String;
  }


  @override
  Future<Map<String, dynamic>> editProfile(Map<String,String> body, String token) async {
    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.editProfile);

    final clientMethod = client.post(uri, headers: headers, body: body);

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    // return responseJsonBody;
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody;
    }
  }

  @override
  Future<String> changePassword(Map<String,String> body, String token) async {
    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.changePassword);

    final clientMethod = client.post(uri, headers: headers, body: body);

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    // return responseJsonBody["message"];
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["message"];
    }
  }

  @override
  Future<String> socialMediaUpdate(Map<String,dynamic> body, String token) async {
    final headers = {'Accept': 'application/json','Content-Type': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.socialUpdate);
    var request = jsonEncode(body);

    final clientMethod = client.post(uri, headers: headers, body: request);

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    // return responseJsonBody["message"];
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["message"];
    }
  }

  @override
  Future<String> deleteAccount(String token) async {
    final headers = {'Accept': 'application/json','Authorization': 'Bearer $token'};
    final uri = Uri.parse(RemoteUrls.deleteAccount);

    final clientMethod = client.delete(uri, headers: headers,);

    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);
    // return responseJsonBody["message"];
    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["message"];
    }
  }

  @override
  Future<String> stripePay(String token, Map<String, String> body) async {
    final uri = Uri.parse(RemoteUrls.paymentConfirmation);
    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json','Authorization': 'Bearer $token'},
      body: body,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    return responseJsonBody['message'];
  }

  @override
  Future<String> paymentConfirmation(String token, Map<String, String> body) async {
    final uri = Uri.parse(RemoteUrls.paymentConfirmation);
    final clientMethod = client.post(
      uri,
      headers: {'Accept': 'application/json','Authorization': 'Bearer $token'},
      body: body,
    );
    final responseJsonBody =
    await callClientWithCatchException(() => clientMethod);

    if (responseJsonBody["success"] == false) {
      final errorMsg = parsingDoseNotExist(responseJsonBody);
      throw UnauthorisedException(errorMsg, 401);
    } {
      return responseJsonBody["message"];
    }
  }
  @override
  Future<dynamic> createPayfastPayment(Map<String, dynamic> body, String token) async {

    var htmlWidget;

    print('Body data $body');
    // print('Token data $token');
    String url = 'https://sandbox.payfast.co.za/eng/process';

    Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      };

    http.Response response = await http.post(Uri.parse(url), headers: headers, body: body);

    print("response ${response.body}");

    return htmlWidget = response.body;

    // final uri = Uri.parse("https://sandbox.payfast.co.za/eng/process");
    // final clientMethod = client.post(
    //   uri,
    //   headers: {
    //     'Content-Type': 'application/x-www-form-urlencoded',
    //     'Accept': 'application/json',
    //     // 'Authorization': 'Bearer $token'
    //   },
    //   body: body,
    // );
    //
    // final responseJsonBody =
    // await callClientWithCatchException(() => clientMethod);

    // print("Response $responseJsonBody");
    // return responseJsonBody;

    // if (responseJsonBody["success"] == false) {
    //   final errorMsg = parsingDoseNotExist(responseJsonBody);
    //   throw UnauthorisedException(errorMsg, 401);
    // } {
    //   return responseJsonBody["message"];
    // }
  }


  dynamic _responseParser(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        // if (responseJson["status"] != null) {
        //   if (responseJson["status"] == 0) {
        //     if (kDebugMode) {
        //       print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        //     }
        //     final errorMsg = parsingDoseNotExist(responseJson["message"]);
        //     throw ServerResponseException(errorMsg, 201);
        //   }
        // }
        return responseJson;
      case 400:
        final errorMsg = parsingDoseNotExist(response.body);
        throw BadRequestException(errorMsg, 400);
      case 401:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 401);
      case 402:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 402);
      case 403:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 403);
      case 404:
        throw const UnauthorisedException('Request not found', 404);
      case 405:
        throw const UnauthorisedException('Method not allowed', 405);
      case 408:

      ///408 Request Timeout
        throw const NetworkException('Request timeout', 408);
      case 415:

      /// 415 Unsupported Media Type
        throw const DataFormatException('Data format exception');

      case 422:

      ///Unprocessable Entity
        final errorMsg = parsingError(response.body);
        throw InvalidInputException(errorMsg, 422);
      case 500:

      ///500 Internal Server Error
        throw const InternalServerException('Internal server error', 500);

      default:
        throw FetchDataException(
            'Error occurred while communication with Server',
            response.statusCode);
    }
  }
  String parsingError(String body) {
    final errorsMap = json.decode(body);
    try {
      if (errorsMap['errors'] != null) {
        final errors = errorsMap['errors'] as Map;
        final firstErrorMsg = errors.values.first;
        if (firstErrorMsg is List) return firstErrorMsg.first;
        return firstErrorMsg.toString();
      }
      if (errorsMap['message'] != null) {
        return errorsMap['message'];
      }
    } catch (e) {
      log(e.toString(), name: _className);
    }

    return 'Unknown error';
  }
  String parsingDoseNotExist(String body) {
    final errorsMap = json.decode(body);
    try {
      if (errorsMap['notification'] != null) {
        return errorsMap['notification'];
      }
      if (errorsMap['message'] != null) {
        return errorsMap['message'];
      }
    } catch (e) {
      log(e.toString(), name: _className);
    }
    return 'Credentials does not match';
  }
}
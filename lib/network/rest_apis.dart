import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:client/main.dart';
import 'package:client/model/base_response_model.dart';
import 'package:client/model/booking_data_model.dart';
import 'package:client/model/booking_detail_model.dart';
import 'package:client/model/booking_list_model.dart';
import 'package:client/model/booking_status_model.dart';
import 'package:client/model/category_model.dart';
import 'package:client/model/city_list_model.dart';
import 'package:client/model/country_list_model.dart';
import 'package:client/model/dashboard_model.dart';
import 'package:client/model/get_my_post_job_list_response.dart';
import 'package:client/model/login_model.dart';
import 'package:client/model/notification_model.dart';
import 'package:client/model/post_job_detail_response.dart';
import 'package:client/model/provider_info_response.dart';
import 'package:client/model/provider_list_model.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/model/service_detail_response.dart';
import 'package:client/model/service_response.dart';
import 'package:client/model/service_review_response.dart';
import 'package:client/model/state_list_model.dart';
import 'package:client/model/user_data_model.dart';
import 'package:client/model/verify_transaction_response.dart';
import 'package:client/network/network_utils.dart';
import 'package:client/screens/dashboard/dashboard_screen.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/configs.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/model_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../model/configuration_response.dart';
import '../model/payment_list_reasponse.dart';
import '../model/wallet_response.dart';

//region Auth Api
Future<LoginResponse> createUser(Map request) async {
  return LoginResponse.fromJson(await (handleResponse(await buildHttpResponse('register', request: request, method: HttpMethodType.POST))));
}

Future<LoginResponse> loginUser(Map request, {bool isSocialLogin = false}) async {
  request.remove("uid");
  appStore.setLoading(true);
  LoginResponse res = LoginResponse.fromJson(await handleResponse(await buildHttpResponse(isSocialLogin ? 'social-login' : 'login', request: request, method: HttpMethodType.POST)));

  if (res.userData != null && res.userData!.userType != USER_TYPE_USER) {
    appStore.setLoading(false);
    throw language.lblNotValidUser;
  }

  if (!isSocialLogin) await appStore.setLoginType(LOGIN_TYPE_USER);

  return res;
}

Future<void> saveUserData(UserData data) async {
  if (data.apiToken.validate().isNotEmpty) await appStore.setToken(data.apiToken!);
  appStore.setLoggedIn(true);

  await appStore.setUserId(data.id.validate());
  await appStore.setFirstName(data.firstName.validate());
  await appStore.setLastName(data.lastName.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.username.validate());
  await appStore.setCountryId(data.countryId.validate());
  await appStore.setStateId(data.stateId.validate());
  await appStore.setCityId(data.cityId.validate());
  await appStore.setContactNumber(data.contactNumber.validate());
  if (data.loginType.validate().isNotEmpty) await appStore.setLoginType(data.loginType.validate());
  await appStore.setAddress(data.address.validate());

  if (data.playerId.validate().isNotEmpty) {
    appStore.setPlayerId(data.playerId.validate());
  }

  if (data.loginType != LOGIN_TYPE_GOOGLE) {
    await appStore.setUserProfile(data.profileImage.validate());
  }

  if (data.uid.validate().isEmpty) {
    await userService.getUser(email: data.email.validate()).then((value) async {
      appStore.setUId(value.uid.validate());
      if (data.loginType == LOGIN_TYPE_GOOGLE) {
        appStore.setUserProfile(value.profileImage.validate());
      }
    }).catchError((e) {
      log(e.toString());

      if (e.toString() == USER_NOT_FOUND) {
        toast(language.userNotFound);
      }
    });
  } else {
    appStore.setUId(data.uid.validate());
  }

  ///Set app configurations
  if (appStore.isLoggedIn) {
    getAppConfigurations();
  }
}

Future<void> clearPreferences() async {
  if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');

  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setUserId(0);
  await appStore.setUserName('');
  await appStore.setContactNumber('');
  await appStore.setCountryId(0);
  await appStore.setStateId(0);
  await appStore.setUserProfile('');
  await appStore.setCityId(0);
  await appStore.setUId('');
  await appStore.setLatitude(0.0);
  await appStore.setLongitude(0.0);
  await appStore.setCurrentAddress('');

  await appStore.setCurrentLocation(false);

  await appStore.setToken('');
  await appStore.setPrivacyPolicy('');
  await appStore.setTermConditions('');
  await appStore.setInquiryEmail('');
  await appStore.setHelplineNumber('');

  await appStore.setLoggedIn(false);
  await removeKey(LOGIN_TYPE);

  // TODO: Please do not remove this condition because this feature not supported on iOS.
  if (isAndroid) await OneSignal.shared.clearOneSignalNotifications();
}

Future<void> logout(BuildContext context) async {
  return showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (p0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(logout_image, width: context.width(), fit: BoxFit.cover),
          32.height,
          Text(language.lblLogoutTitle, style: boldTextStyle(size: 18)),
          16.height,
          Text(language.lblLogoutSubTitle, style: secondaryTextStyle()),
          28.height,
          Row(
            children: [
              AppButton(
                child: Text(language.lblNo, style: boldTextStyle()),
                elevation: 0,
                onTap: () {
                  finish(context);
                },
              ).expand(),
              16.width,
              AppButton(
                child: Text(language.lblYes, style: boldTextStyle(color: white)),
                color: primaryColor,
                elevation: 0,
                onTap: () async {
                  finish(context);

                  if (await isNetworkAvailable()) {
                    appStore.setLoading(true);

                    logoutApi().then((value) async {
                      //
                    }).catchError((e) {
                      log(e.toString());
                    });

                    await clearPreferences();
                    await FirebaseAuth.instance.signOut();

                    appStore.setLoading(false);
                    DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                  }
                },
              ).expand(),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 24);
    },
  );
}

Future<void> logoutApi() async {
  cachedDashboardResponse = null;
  cachedBookingList = null;
  cachedCategoryList = null;
  cachedBookingStatusDropdown = null;

  return await handleResponse(await buildHttpResponse('logout', method: HttpMethodType.GET));
}

Future<BaseResponseModel> changeUserPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('change-password', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> forgotPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('forgot-password', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteAccountCompletely() async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-user-account', request: {}, method: HttpMethodType.POST)));
}

Future<void> editUserProfileData({required Map<String, dynamic> req, File? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');

  multiPartRequest.fields.addAll(await getMultipartFields(val: req));
  if (imageFile != null) {
    multiPartRequest.files.add(await MultipartFile.fromPath(UserKeys.profileImage, imageFile.path));
  }

  multiPartRequest.headers.addAll(buildHeaderTokens());
  log("MultiPart Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");
  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    if ((temp as String).isJson()) {
      LoginResponse res = LoginResponse.fromJson(jsonDecode(temp));

      saveUserData(res.userData!);
      finish(getContext);
      toast(res.message.validate().capitalizeFirstLetter());
    }
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}

//endregion

//region Country Api
Future<List<CountryListResponse>> getCountryList() async {
  Iterable res = await (handleResponse(await buildHttpResponse('country-list', method: HttpMethodType.POST)));
  return res.map((e) => CountryListResponse.fromJson(e)).toList();
}

Future<List<StateListResponse>> getStateList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('state-list', request: request, method: HttpMethodType.POST)));
  return res.map((e) => StateListResponse.fromJson(e)).toList();
}

Future<List<CityListResponse>> getCityList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('city-list', request: request, method: HttpMethodType.POST)));
  return res.map((e) => CityListResponse.fromJson(e)).toList();
}
//endregion

//region Configurations Api
Future<ConfigurationResponse> getAppConfigurations({bool isCurrentLocation = false, double? lat, double? long}) async {
  try {
    ConfigurationResponse? data = ConfigurationResponse.fromJson(await handleResponse(await buildHttpResponse('configurations', method: HttpMethodType.GET)));

    data.configurations.validate().forEach((data) {
      if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_APP_ID_PROVIDER) {
        compareValuesInSharedPreference(ONESIGNAL_APP_ID_PROVIDER, data.value);
      } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_REST_API_KEY_PROVIDER) {
        compareValuesInSharedPreference(ONESIGNAL_REST_API_KEY_PROVIDER, data.value);
      } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_CHANNEL_KEY_PROVIDER) {
        compareValuesInSharedPreference(ONESIGNAL_CHANNEL_KEY_PROVIDER, data.value);
      } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_API_KEY) {
        compareValuesInSharedPreference(ONESIGNAL_API_KEY, data.value);
      } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_REST_API_KEY) {
        compareValuesInSharedPreference(ONESIGNAL_REST_API_KEY, data.value);
      } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_CHANNEL_KEY) {
        compareValuesInSharedPreference(ONESIGNAL_CHANNEL_KEY, data.value);
      }
    });

    1.seconds.delay.then((value) {
      initializeOneSignal();
    });

    if (data.paymentSettings != null) {
      compareValuesInSharedPreference(PAYMENT_LIST, PaymentSetting.encode(data.paymentSettings.validate()));
    }

    return data;
  } catch (e) {
    throw e;
  }
}
//endregion

//region User Api
Future<DashboardResponse> userDashboard({bool isCurrentLocation = false, double? lat, double? long}) async {
  Completer<DashboardResponse> completer = Completer();

  String endPoint = 'dashboard-detail';

  if (isCurrentLocation && appStore.isLoggedIn && appStore.userId.validate() != 0) {
    endPoint = "$endPoint?latitude=$lat&longitude=$long&?customer_id=${appStore.userId.validate()}}";
  } else if (isCurrentLocation) {
    endPoint = "$endPoint?latitude=$lat&longitude=$long";
  } else if (appStore.isLoggedIn && appStore.userId.validate() != 0) {
    endPoint = "$endPoint?customer_id=${appStore.userId.validate()}";
  }

  try {
    final response = await buildHttpResponse(endPoint, method: HttpMethodType.GET);
    final dashboardResponse = DashboardResponse.fromJson(await handleResponse(response));

    completer.complete(dashboardResponse);
    // Perform additional code or post-processing
    _performAdditionalProcessing(dashboardResponse);
  } catch (e) {
    completer.completeError(e);
  }

  return completer.future;
}

void _performAdditionalProcessing(DashboardResponse dashboardResponse) async {
  cachedDashboardResponse = dashboardResponse;
  appStore.setLoading(false);

  appStore.setPrivacyPolicy(dashboardResponse.privacyPolicy?.value.validate() ?? PRIVACY_POLICY_URL);
  appStore.setTermConditions(dashboardResponse.termConditions?.value.validate() ?? TERMS_CONDITION_URL);

  dashboardResponse.configurations.validate().forEach((data) {
    if (data.key == CONFIGURATION_KEY_CURRENCY_COUNTRY_ID && data.country != null) {
      if (data.country!.currencyCode.validate() != appStore.currencyCode) appStore.setCurrencyCode(data.country!.currencyCode.validate());
      if (data.country!.id.validate().toString() != appStore.countryId.toString()) appStore.setCurrencyCountryId(data.country!.id.validate().toString());
      if (data.country!.symbol.validate() != appStore.currencySymbol) appStore.setCurrencySymbol(data.country!.symbol.validate());
    } else if (data.key == CONFIGURATION_TYPE_CURRENCY_POSITION && data.value.validate().isNotEmpty) {
      compareValuesInSharedPreference(CURRENCY_POSITION, data.value);
    }
  });

  if (dashboardResponse.appDownload != null) {
    compareValuesInSharedPreference(APPSTORE_URL, dashboardResponse.appDownload!.appstore_url.validate());
    compareValuesInSharedPreference(PLAY_STORE_URL, dashboardResponse.appDownload!.playstore_url.validate());
    compareValuesInSharedPreference(PROVIDER_PLAY_STORE_URL, dashboardResponse.appDownload!.provider_playstore_url.validate());
    compareValuesInSharedPreference(PROVIDER_APPSTORE_URL, dashboardResponse.appDownload!.provider_appstore_url.validate());
  }

  if (dashboardResponse.languageOption != null) {
    compareValuesInSharedPreference(SERVER_LANGUAGES, jsonEncode(dashboardResponse.languageOption!.toList()));
  }

  if (dashboardResponse.generalSetting != null) {
    final generalSetting = dashboardResponse.generalSetting!;
    compareValuesInSharedPreference(SITE_DESCRIPTION, generalSetting.siteDescription.validate());
    compareValuesInSharedPreference(SITE_COPYRIGHT, generalSetting.siteCopyright.validate());
    compareValuesInSharedPreference(FACEBOOK_URL, generalSetting.facebookUrl.validate());
    compareValuesInSharedPreference(INSTAGRAM_URL, generalSetting.instagramUrl.validate());
    compareValuesInSharedPreference(TWITTER_URL, generalSetting.twitterUrl.validate());
    compareValuesInSharedPreference(LINKEDIN_URL, generalSetting.linkedinUrl.validate());
    compareValuesInSharedPreference(YOUTUBE_URL, generalSetting.youtubeUrl.validate());

    appStore.setInquiryEmail(generalSetting.inquriyEmail.validate(value: INQUIRY_SUPPORT_EMAIL));
    appStore.setHelplineNumber(generalSetting.helplineNumber.validate(value: HELP_LINE_NUMBER));
  }

  compareValuesInSharedPreference(IS_ADVANCE_PAYMENT_ALLOWED, dashboardResponse.isAdvancedPaymentAllowed == '1');
  appStore.setEnableUserWallet(dashboardResponse.enableUserWallet.validate());
  appStore.setUnreadCount(dashboardResponse.notificationUnreadCount.validate());
  if (appStore.isLoggedIn) {
    await getAppConfigurations();
  }
}

Future<num> getUserWalletBalance() async {
  var res = WalletResponse.fromJson(await handleResponse(await buildHttpResponse('user-wallet-balance', method: HttpMethodType.GET)));

  return res.balance.validate();
}
//endregion

//region Service Api
Future<ServiceDetailResponse> getServiceDetail(Map request) async {
  return ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethodType.POST)));
}

Future<ServiceDetailResponse> getServiceDetails({required int serviceId, int? customerId, bool fromBooking = false}) async {
  if (fromBooking) {
    toast(language.pleaseWait);
  }
  Map request = {CommonKeys.serviceId: serviceId, if (appStore.isLoggedIn) CommonKeys.customerId: customerId};
  var res = ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethodType.POST)));

  appStore.setLoading(false);
  return res;
}

@Deprecated('Do not use this')
Future<ServiceResponse> getSearchListServices({
  String categoryId = '',
  String providerId = '',
  String handymanId = '',
  String isPriceMin = '',
  String isPriceMax = '',
  String search = '',
  String latitude = '',
  String longitude = '',
  String isFeatured = '',
  String subCategory = '',
  int page = 1,
}) async {
  String categoryIds = categoryId.isNotEmpty ? 'category_id=$categoryId&' : '';
  String searchPara = search.isNotEmpty ? 'search=$search&' : '';
  String providerIds = providerId.isNotEmpty ? 'provider_id=$providerId&' : '';
  String isPriceMinPara = isPriceMin.isNotEmpty ? 'is_price_min=$isPriceMin&' : '';
  String isPriceMaxPara = isPriceMax.isNotEmpty ? 'is_price_max=$isPriceMax&' : '';
  String latitudes = latitude.isNotEmpty ? 'latitude=$latitude&' : '';
  String longitudes = longitude.isNotEmpty ? 'longitude=$longitude&' : '';
  String isFeatures = isFeatured.isNotEmpty ? 'is_featured=$isFeatured&' : '';
  String subCategorys = subCategory.validate().isNotEmpty
      ? subCategory != "-1"
          ? 'subcategory_id=$subCategory&'
          : ''
      : '';
  String pages = 'page=$page&';
  String perPages = 'per_page=$PER_PAGE_ITEM';
  String customerId = appStore.isLoggedIn ? 'customer_id=${appStore.userId}&' : '';

  return ServiceResponse.fromJson(await handleResponse(
    await buildHttpResponse('search-list?$categoryIds$customerId$providerIds$isPriceMinPara$isPriceMaxPara$subCategorys$searchPara$latitudes$longitudes$isFeatures$pages$perPages'),
  ));
}

Future<List<ServiceData>> searchServiceAPI({
  String categoryId = '',
  String providerId = '',
  String isPriceMin = '',
  String isPriceMax = '',
  String search = '',
  String latitude = '',
  String longitude = '',
  String isFeatured = '',
  String subCategory = '',
  int page = 1,
  required List<ServiceData> list,
  Function(bool)? lastPageCallBack,
}) async {
  String categoryIds = categoryId.isNotEmpty ? 'category_id=$categoryId&' : '';
  String searchPara = search.isNotEmpty ? 'search=$search&' : '';
  String providerIds = providerId.isNotEmpty ? 'provider_id=$providerId&' : '';
  String isPriceMinPara = isPriceMin.isNotEmpty ? 'is_price_min=$isPriceMin&' : '';
  String isPriceMaxPara = isPriceMax.isNotEmpty ? 'is_price_max=$isPriceMax&' : '';
  String latitudes = latitude.isNotEmpty ? 'latitude=$latitude&' : '';
  String longitudes = longitude.isNotEmpty ? 'longitude=$longitude&' : '';
  String isFeatures = isFeatured.isNotEmpty ? 'is_featured=$isFeatured&' : '';
  String subCategorys = subCategory.validate().isNotEmpty
      ? subCategory != "-1"
          ? 'subcategory_id=$subCategory&'
          : ''
      : '';
  String pages = 'page=$page&';
  String perPages = 'per_page=$PER_PAGE_ITEM';
  String customerId = appStore.isLoggedIn ? 'customer_id=${appStore.userId}&' : '';

  try {
    var res = ServiceResponse.fromJson(await handleResponse(
      await buildHttpResponse('search-list?$categoryIds$customerId$providerIds$isPriceMinPara$isPriceMaxPara$subCategorys$searchPara$latitudes$longitudes$isFeatures$pages$perPages'),
    ));

    if (page == 1) list.clear();
    list.addAll(res.serviceList.validate());

    lastPageCallBack?.call(res.serviceList.validate().length != PER_PAGE_ITEM);
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return list;
}
//endregion

//region Category Api

Future<CategoryResponse> getCategoryList(String page) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-list?page=$page&per_page=50', method: HttpMethodType.GET)));
}

Future<List<CategoryData>> getCategoryListWithPagination(int page, {var perPage = PER_PAGE_CATEGORY_ITEM, required List<CategoryData> categoryList, Function(bool)? lastPageCallBack}) async {
  try {
    CategoryResponse res = CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-list?per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) categoryList.clear();
    categoryList.addAll(res.categoryList.validate());

    cachedCategoryList = categoryList;

    lastPageCallBack?.call(res.categoryList.validate().length != PER_PAGE_CATEGORY_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return categoryList;
}
//endregion

//region SubCategory Api
Future<CategoryResponse> getSubCategoryList({required int catId}) async {
  try {
    CategoryResponse res = CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('subcategory-list?category_id=$catId&per_page=all', method: HttpMethodType.GET)));
    appStore.setLoading(false);

    return res;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<List<CategoryData>> getSubCategoryListAPI({required int catId}) async {
  try {
    CategoryResponse res = CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('subcategory-list?category_id=$catId&per_page=all', method: HttpMethodType.GET)));

    appStore.setLoading(false);

    CategoryData allValue = CategoryData(id: -1, name: language.lblAll);
    if (!res.categoryList!.any((element) => element.id == allValue.id)) {
      res.categoryList!.insert(0, allValue);
    }

    return res.categoryList.validate();
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}
//endregion

//region Provider Api
Future<ProviderInfoResponse> getProviderDetail(int id, {int? userId}) async {
  try {
    ProviderInfoResponse res = ProviderInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id&login_user_id=$userId', method: HttpMethodType.GET)));
    appStore.setLoading(false);

    return res;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<ProviderListResponse> getProvider({String? userType = "provider"}) async {
  return ProviderListResponse.fromJson(await handleResponse(await buildHttpResponse('user-list?user_type=$userType&per_page=all', method: HttpMethodType.GET)));
}
//endregion

//region Handyman Api
Future<UserData> getHandymanDetail(int id) async {
  return UserData.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethodType.GET)));
}

Future<BaseResponseModel> handymanRating(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-handyman-rating', request: request, method: HttpMethodType.POST)));
}
//endregion

//region Booking Api
Future<List<BookingData>> getBookingList(int page, {var perPage = PER_PAGE_ITEM, String status = '', required List<BookingData> bookings, Function(bool)? lastPageCallback}) async {
  try {
    BookingListResponse res;

    if (status == BOOKING_TYPE_ALL) {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?&per_page=$perPage&page=$page', method: HttpMethodType.GET)));
    } else {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?status=$status&per_page=$perPage&page=$page', method: HttpMethodType.GET)));
    }

    if (page == 1) bookings.clear();
    bookings.addAll(res.data.validate());
    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    cachedBookingList = bookings;

    appStore.setLoading(false);

    return bookings;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<BookingDetailResponse> getBookingDetail(Map request) async {
  try {
    BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(await handleResponse(await buildHttpResponse('booking-detail', request: request, method: HttpMethodType.POST)));
    calculateTotalAmount(
      serviceDiscountPercent: bookingDetailResponse.service!.discount.validate(),
      qty: bookingDetailResponse.bookingDetail!.quantity!.toInt(),
      detail: bookingDetailResponse.service,
      servicePrice: bookingDetailResponse.service!.price.validate(),
      taxes: bookingDetailResponse.bookingDetail!.taxes.validate(),
      couponData: bookingDetailResponse.couponData,
      extraCharges: bookingDetailResponse.bookingDetail!.extraCharges,
    );

    appStore.setLoading(false);

    return bookingDetailResponse;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<BaseResponseModel> updateBooking(Map request) async {
  BaseResponseModel baseResponse = BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('booking-update', request: request, method: HttpMethodType.POST)));
  LiveStream().emit(LIVESTREAM_UPDATE_BOOKING_LIST);

  return baseResponse;
}

Future bookTheServices(Map request) async {
  return await handleResponse(await buildHttpResponse('booking-save', request: request, method: HttpMethodType.POST));
}

Future<List<BookingStatusResponse>> bookingStatus() async {
  Iterable res = await (handleResponse(await buildHttpResponse('booking-status', method: HttpMethodType.GET)));
  cachedBookingStatusDropdown = res.map((e) => BookingStatusResponse.fromJson(e)).toList();

  return cachedBookingStatusDropdown.validate();
}
//endregion

//region Payment Api
Future<BaseResponseModel> savePayment(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-payment', request: request, method: HttpMethodType.POST)));
}

Future<List<PaymentData>> getPaymentList(int page, int id, List<PaymentData> list, Function(bool)? lastPageCallback) async {
  appStore.setLoading(true);
  var res = PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?booking_id=$id', method: HttpMethodType.GET)));

  if (page == 1) list.clear();

  list.addAll(res.data.validate());
  appStore.setLoading(false);

  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  return list;
}

//endregion

//region Notification Api
Future<List<NotificationData>> getNotification({Map? request}) async {
  try {
    NotificationListResponse res = NotificationListResponse.fromJson(
      await (handleResponse(await buildHttpResponse('notification-list?customer_id=${appStore.userId}', request: request, method: HttpMethodType.POST))),
    );

    appStore.setLoading(false);
    return res.notificationData.validate();
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}
//endregion

//region Review Api
Future<BaseResponseModel> updateReview(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-booking-rating', request: request, method: HttpMethodType.POST)));
}

Future<List<RatingData>> serviceReviews(Map request) async {
  try {
    ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('service-reviews?per_page=all', request: request, method: HttpMethodType.POST)));
    appStore.setLoading(false);
    return res.ratingList.validate();
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<List<RatingData>> customerReviews() async {
  try {
    ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('get-user-ratings?per_page=all', method: HttpMethodType.GET)));
    appStore.setLoading(false);
    return res.ratingList.validate();
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<List<RatingData>> handymanReviews(Map request) async {
  try {
    ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('handyman-reviews?per_page=all', request: request, method: HttpMethodType.POST)));
    appStore.setLoading(false);
    return res.ratingList.validate();
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<BaseResponseModel> deleteReview({required int id}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-booking-rating', request: {"id": id}, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteHandymanReview({required int id}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-handyman-rating', request: {"id": id}, method: HttpMethodType.POST)));
}
//endregion

//region WishList Api
Future<List<ServiceData>> getWishlist(int page, {var perPage = PER_PAGE_ITEM, required List<ServiceData> services, Function(bool)? lastPageCallBack}) async {
  try {
    ServiceResponse serviceResponse = ServiceResponse.fromJson(await (handleResponse(await buildHttpResponse('user-favourite-service?per_page=$perPage&page=$page', method: HttpMethodType.GET))));

    if (page == 1) services.clear();
    services.addAll(serviceResponse.serviceList.validate());

    lastPageCallBack?.call(serviceResponse.serviceList.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return services;
}

Future<BaseResponseModel> addWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-favourite', method: HttpMethodType.POST, request: request)));
}

Future<BaseResponseModel> removeWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-favourite', method: HttpMethodType.POST, request: request)));
}

//endregion

//region Provider WishList Api
Future<List<UserData>> getProviderWishlist(int page, {var perPage = PER_PAGE_ITEM, required List<UserData> providers, Function(bool)? lastPageCallBack}) async {
  try {
    ProviderListResponse res = ProviderListResponse.fromJson(await (handleResponse(await buildHttpResponse('user-favourite-provider?per_page=$perPage&page=$page', method: HttpMethodType.GET))));

    if (page == 1) providers.clear();
    providers.addAll(res.providerList.validate());

    lastPageCallBack?.call(res.providerList.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return providers;
}

Future<BaseResponseModel> addProviderWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-favourite-provider', method: HttpMethodType.POST, request: request)));
}

Future<BaseResponseModel> removeProviderWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-favourite-provider', method: HttpMethodType.POST, request: request)));
}
//endregion

//region Get My Service List API
Future<ServiceResponse> getMyServiceList() async {
  return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?customer_id=${appStore.userId.validate()}', method: HttpMethodType.GET)));
}
//endregion

//region Get My post job

Future<BaseResponseModel> savePostJob(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-post-job', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deletePostRequest({required num id}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('post-job-delete/$id', request: {}, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteServiceRequest(int id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('service-delete/$id', request: {}, method: HttpMethodType.POST)));
}

Future<List<PostJobData>> getPostJobList(int page, {var perPage = PER_PAGE_ITEM, required List<PostJobData> postJobList, Function(bool)? lastPageCallBack}) async {
  try {
    var res = GetPostJobResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job?per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) postJobList.clear();
    postJobList.addAll(res.myPostJobData.validate());

    lastPageCallBack?.call(res.myPostJobData.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return postJobList;
}

Future<PostJobDetailResponse> getPostJobDetail(Map request) async {
  try {
    var res = PostJobDetailResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job-detail', request: request, method: HttpMethodType.POST)));
    appStore.setLoading(false);

    return res;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

//endregion

//region FlutterWave Verify Transaction API
Future<VerifyTransactionResponse> verifyPayment({required String transactionId, required String flutterWaveSecretKey}) async {
  return VerifyTransactionResponse.fromJson(
    await handleResponse(await buildHttpResponse("https://api.flutterwave.com/v3/transactions/$transactionId/verify", extraKeys: {
      'isFlutterWave': true,
      'flutterWaveSecretKey': flutterWaveSecretKey,
    })),
  );
}
//endregion

//region Sadad Payment Api
Future<String> sadadLogin(Map request) async {
  var res = await handleResponse(
    await buildHttpResponse('$SADAD_API_URL/api/userbusinesses/login', method: HttpMethodType.POST, request: request, extraKeys: {
      'isSadadPayment': true,
    }),
    avoidTokenError: false,
    isSadadPayment: true,
  );

  return res['accessToken'];
}

Future sadadCreateInvoice({required Map<String, dynamic> request, required String sadadToken}) async {
  return handleResponse(
    await buildHttpResponse('$SADAD_API_URL/api/invoices/createInvoice', method: HttpMethodType.POST, request: request, extraKeys: {
      'isSadadPayment': true,
      'sadadToken': sadadToken,
    }),
    avoidTokenError: false,
    isSadadPayment: true,
  );
}
//endregion

// region Send Invoice on Email
Future<BaseResponseModel> sentInvoiceOnMail(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('download-invoice', request: request, method: HttpMethodType.POST)));
}
//endregion

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<List<MultipartFile>> getMultipartImages({required List<File> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<File>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('${'$name' + i.toString()}', element.path));
  });

  return multiPartRequest;
}
//endregion

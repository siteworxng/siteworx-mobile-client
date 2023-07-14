// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  Computed<String>? _$userFullNameComputed;

  @override
  String get userFullName => (_$userFullNameComputed ??= Computed<String>(() => super.userFullName, name: '_AppStore.userFullName')).value;

  late final _$isLoggedInAtom = Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$isDarkModeAtom = Atom(name: '_AppStore.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$isLoadingAtom = Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isFavoriteAtom = Atom(name: '_AppStore.isFavorite', context: context);

  @override
  bool get isFavorite {
    _$isFavoriteAtom.reportRead();
    return super.isFavorite;
  }

  @override
  set isFavorite(bool value) {
    _$isFavoriteAtom.reportWrite(value, super.isFavorite, () {
      super.isFavorite = value;
    });
  }

  late final _$isCurrentLocationAtom = Atom(name: '_AppStore.isCurrentLocation', context: context);

  @override
  bool get isCurrentLocation {
    _$isCurrentLocationAtom.reportRead();
    return super.isCurrentLocation;
  }

  @override
  set isCurrentLocation(bool value) {
    _$isCurrentLocationAtom.reportWrite(value, super.isCurrentLocation, () {
      super.isCurrentLocation = value;
    });
  }

  late final _$isRememberMeAtom = Atom(name: '_AppStore.isRememberMe', context: context);

  @override
  bool get isRememberMe {
    _$isRememberMeAtom.reportRead();
    return super.isRememberMe;
  }

  @override
  set isRememberMe(bool value) {
    _$isRememberMeAtom.reportWrite(value, super.isRememberMe, () {
      super.isRememberMe = value;
    });
  }

  late final _$selectedLanguageCodeAtom = Atom(name: '_AppStore.selectedLanguageCode', context: context);

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode, () {
      super.selectedLanguageCode = value;
    });
  }

  late final _$userProfileImageAtom = Atom(name: '_AppStore.userProfileImage', context: context);

  @override
  String get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  late final _$privacyPolicyAtom = Atom(name: '_AppStore.privacyPolicy', context: context);

  @override
  String get privacyPolicy {
    _$privacyPolicyAtom.reportRead();
    return super.privacyPolicy;
  }

  @override
  set privacyPolicy(String value) {
    _$privacyPolicyAtom.reportWrite(value, super.privacyPolicy, () {
      super.privacyPolicy = value;
    });
  }

  late final _$loginTypeAtom = Atom(name: '_AppStore.loginType', context: context);

  @override
  String get loginType {
    _$loginTypeAtom.reportRead();
    return super.loginType;
  }

  @override
  set loginType(String value) {
    _$loginTypeAtom.reportWrite(value, super.loginType, () {
      super.loginType = value;
    });
  }

  late final _$termConditionsAtom = Atom(name: '_AppStore.termConditions', context: context);

  @override
  String get termConditions {
    _$termConditionsAtom.reportRead();
    return super.termConditions;
  }

  @override
  set termConditions(String value) {
    _$termConditionsAtom.reportWrite(value, super.termConditions, () {
      super.termConditions = value;
    });
  }

  late final _$inquiryEmailAtom = Atom(name: '_AppStore.inquiryEmail', context: context);

  @override
  String get inquiryEmail {
    _$inquiryEmailAtom.reportRead();
    return super.inquiryEmail;
  }

  @override
  set inquiryEmail(String value) {
    _$inquiryEmailAtom.reportWrite(value, super.inquiryEmail, () {
      super.inquiryEmail = value;
    });
  }

  late final _$helplineNumberAtom = Atom(name: '_AppStore.helplineNumber', context: context);

  @override
  String get helplineNumber {
    _$helplineNumberAtom.reportRead();
    return super.helplineNumber;
  }

  @override
  set helplineNumber(String value) {
    _$helplineNumberAtom.reportWrite(value, super.helplineNumber, () {
      super.helplineNumber = value;
    });
  }

  late final _$userFirstNameAtom = Atom(name: '_AppStore.userFirstName', context: context);

  @override
  String get userFirstName {
    _$userFirstNameAtom.reportRead();
    return super.userFirstName;
  }

  @override
  set userFirstName(String value) {
    _$userFirstNameAtom.reportWrite(value, super.userFirstName, () {
      super.userFirstName = value;
    });
  }

  late final _$userLastNameAtom = Atom(name: '_AppStore.userLastName', context: context);

  @override
  String get userLastName {
    _$userLastNameAtom.reportRead();
    return super.userLastName;
  }

  @override
  set userLastName(String value) {
    _$userLastNameAtom.reportWrite(value, super.userLastName, () {
      super.userLastName = value;
    });
  }

  late final _$uidAtom = Atom(name: '_AppStore.uid', context: context);

  @override
  String get uid {
    _$uidAtom.reportRead();
    return super.uid;
  }

  @override
  set uid(String value) {
    _$uidAtom.reportWrite(value, super.uid, () {
      super.uid = value;
    });
  }

  late final _$userContactNumberAtom = Atom(name: '_AppStore.userContactNumber', context: context);

  @override
  String get userContactNumber {
    _$userContactNumberAtom.reportRead();
    return super.userContactNumber;
  }

  @override
  set userContactNumber(String value) {
    _$userContactNumberAtom.reportWrite(value, super.userContactNumber, () {
      super.userContactNumber = value;
    });
  }

  late final _$userEmailAtom = Atom(name: '_AppStore.userEmail', context: context);

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$userNameAtom = Atom(name: '_AppStore.userName', context: context);

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  late final _$latitudeAtom = Atom(name: '_AppStore.latitude', context: context);

  @override
  double get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(double value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  late final _$longitudeAtom = Atom(name: '_AppStore.longitude', context: context);

  @override
  double get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(double value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  late final _$currentAddressAtom = Atom(name: '_AppStore.currentAddress', context: context);

  @override
  String get currentAddress {
    _$currentAddressAtom.reportRead();
    return super.currentAddress;
  }

  @override
  set currentAddress(String value) {
    _$currentAddressAtom.reportWrite(value, super.currentAddress, () {
      super.currentAddress = value;
    });
  }

  late final _$tokenAtom = Atom(name: '_AppStore.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$countryIdAtom = Atom(name: '_AppStore.countryId', context: context);

  @override
  int get countryId {
    _$countryIdAtom.reportRead();
    return super.countryId;
  }

  @override
  set countryId(int value) {
    _$countryIdAtom.reportWrite(value, super.countryId, () {
      super.countryId = value;
    });
  }

  late final _$stateIdAtom = Atom(name: '_AppStore.stateId', context: context);

  @override
  int get stateId {
    _$stateIdAtom.reportRead();
    return super.stateId;
  }

  @override
  set stateId(int value) {
    _$stateIdAtom.reportWrite(value, super.stateId, () {
      super.stateId = value;
    });
  }

  late final _$currencySymbolAtom = Atom(name: '_AppStore.currencySymbol', context: context);

  @override
  String get currencySymbol {
    _$currencySymbolAtom.reportRead();
    return super.currencySymbol;
  }

  @override
  set currencySymbol(String value) {
    _$currencySymbolAtom.reportWrite(value, super.currencySymbol, () {
      super.currencySymbol = value;
    });
  }

  late final _$currencyCodeAtom = Atom(name: '_AppStore.currencyCode', context: context);

  @override
  String get currencyCode {
    _$currencyCodeAtom.reportRead();
    return super.currencyCode;
  }

  @override
  set currencyCode(String value) {
    _$currencyCodeAtom.reportWrite(value, super.currencyCode, () {
      super.currencyCode = value;
    });
  }

  late final _$currencyCountryIdAtom = Atom(name: '_AppStore.currencyCountryId', context: context);

  @override
  String get currencyCountryId {
    _$currencyCountryIdAtom.reportRead();
    return super.currencyCountryId;
  }

  @override
  set currencyCountryId(String value) {
    _$currencyCountryIdAtom.reportWrite(value, super.currencyCountryId, () {
      super.currencyCountryId = value;
    });
  }

  late final _$cityIdAtom = Atom(name: '_AppStore.cityId', context: context);

  @override
  int get cityId {
    _$cityIdAtom.reportRead();
    return super.cityId;
  }

  @override
  set cityId(int value) {
    _$cityIdAtom.reportWrite(value, super.cityId, () {
      super.cityId = value;
    });
  }

  late final _$addressAtom = Atom(name: '_AppStore.address', context: context);

  @override
  String get address {
    _$addressAtom.reportRead();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.reportWrite(value, super.address, () {
      super.address = value;
    });
  }

  late final _$playerIdAtom = Atom(name: '_AppStore.playerId', context: context);

  @override
  String get playerId {
    _$playerIdAtom.reportRead();
    return super.playerId;
  }

  @override
  set playerId(String value) {
    _$playerIdAtom.reportWrite(value, super.playerId, () {
      super.playerId = value;
    });
  }

  late final _$userIdAtom = Atom(name: '_AppStore.userId', context: context);

  @override
  int? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$unreadCountAtom = Atom(name: '_AppStore.unreadCount', context: context);

  @override
  int? get unreadCount {
    _$unreadCountAtom.reportRead();
    return super.unreadCount;
  }

  @override
  set unreadCount(int? value) {
    _$unreadCountAtom.reportWrite(value, super.unreadCount, () {
      super.unreadCount = value;
    });
  }

  late final _$useMaterialYouThemeAtom = Atom(name: '_AppStore.useMaterialYouTheme', context: context);

  @override
  bool get useMaterialYouTheme {
    _$useMaterialYouThemeAtom.reportRead();
    return super.useMaterialYouTheme;
  }

  @override
  set useMaterialYouTheme(bool value) {
    _$useMaterialYouThemeAtom.reportWrite(value, super.useMaterialYouTheme, () {
      super.useMaterialYouTheme = value;
    });
  }

  late final _$isEnableUserWalletAtom = Atom(name: '_AppStore.isEnableUserWallet', context: context);

  @override
  bool get isEnableUserWallet {
    _$isEnableUserWalletAtom.reportRead();
    return super.isEnableUserWallet;
  }

  @override
  set isEnableUserWallet(bool value) {
    _$isEnableUserWalletAtom.reportWrite(value, super.isEnableUserWallet, () {
      super.isEnableUserWallet = value;
    });
  }

  late final _$userTypeAtom = Atom(name: '_AppStore.userType', context: context);

  @override
  String get userType {
    _$userTypeAtom.reportRead();
    return super.userType;
  }

  @override
  set userType(String value) {
    _$userTypeAtom.reportWrite(value, super.userType, () {
      super.userType = value;
    });
  }

  late final _$is24HourFormatAtom = Atom(name: '_AppStore.is24HourFormat', context: context);

  @override
  bool get is24HourFormat {
    _$is24HourFormatAtom.reportRead();
    return super.is24HourFormat;
  }

  @override
  set is24HourFormat(bool value) {
    _$is24HourFormatAtom.reportWrite(value, super.is24HourFormat, () {
      super.is24HourFormat = value;
    });
  }

  late final _$set24HourFormatAsyncAction = AsyncAction('_AppStore.set24HourFormat', context: context);

  @override
  Future<void> set24HourFormat(bool val, {bool isInitializing = false}) {
    return _$set24HourFormatAsyncAction.run(() => super.set24HourFormat(val, isInitializing: isInitializing));
  }

  late final _$setUseMaterialYouThemeAsyncAction = AsyncAction('_AppStore.setUseMaterialYouTheme', context: context);

  @override
  Future<void> setUseMaterialYouTheme(bool val, {bool isInitializing = false}) {
    return _$setUseMaterialYouThemeAsyncAction.run(() => super.setUseMaterialYouTheme(val, isInitializing: isInitializing));
  }

  late final _$setPlayerIdAsyncAction = AsyncAction('_AppStore.setPlayerId', context: context);

  @override
  Future<void> setPlayerId(String val, {bool isInitializing = false}) {
    return _$setPlayerIdAsyncAction.run(() => super.setPlayerId(val, isInitializing: isInitializing));
  }

  late final _$setEnableUserWalletAsyncAction = AsyncAction('_AppStore.setEnableUserWallet', context: context);

  @override
  Future<void> setEnableUserWallet(bool val, {bool isInitializing = false}) {
    return _$setEnableUserWalletAsyncAction.run(() => super.setEnableUserWallet(val, isInitializing: isInitializing));
  }

  late final _$setUserTypeAsyncAction = AsyncAction('_AppStore.setUserType', context: context);

  @override
  Future<void> setUserType(String val, {bool isInitializing = false}) {
    return _$setUserTypeAsyncAction.run(() => super.setUserType(val, isInitializing: isInitializing));
  }

  late final _$setAddressAsyncAction = AsyncAction('_AppStore.setAddress', context: context);

  @override
  Future<void> setAddress(String val, {bool isInitializing = false}) {
    return _$setAddressAsyncAction.run(() => super.setAddress(val, isInitializing: isInitializing));
  }

  late final _$setUserProfileAsyncAction = AsyncAction('_AppStore.setUserProfile', context: context);

  @override
  Future<void> setUserProfile(String val, {bool isInitializing = false}) {
    return _$setUserProfileAsyncAction.run(() => super.setUserProfile(val, isInitializing: isInitializing));
  }

  late final _$setPrivacyPolicyAsyncAction = AsyncAction('_AppStore.setPrivacyPolicy', context: context);

  @override
  Future<void> setPrivacyPolicy(String val, {bool isInitializing = false}) {
    return _$setPrivacyPolicyAsyncAction.run(() => super.setPrivacyPolicy(val, isInitializing: isInitializing));
  }

  late final _$setLoginTypeAsyncAction = AsyncAction('_AppStore.setLoginType', context: context);

  @override
  Future<void> setLoginType(String val, {bool isInitializing = false}) {
    return _$setLoginTypeAsyncAction.run(() => super.setLoginType(val, isInitializing: isInitializing));
  }

  late final _$setTermConditionsAsyncAction = AsyncAction('_AppStore.setTermConditions', context: context);

  @override
  Future<void> setTermConditions(String val, {bool isInitializing = false}) {
    return _$setTermConditionsAsyncAction.run(() => super.setTermConditions(val, isInitializing: isInitializing));
  }

  late final _$setInquiryEmailAsyncAction = AsyncAction('_AppStore.setInquiryEmail', context: context);

  @override
  Future<void> setInquiryEmail(String val, {bool isInitializing = false}) {
    return _$setInquiryEmailAsyncAction.run(() => super.setInquiryEmail(val, isInitializing: isInitializing));
  }

  late final _$setHelplineNumberAsyncAction = AsyncAction('_AppStore.setHelplineNumber', context: context);

  @override
  Future<void> setHelplineNumber(String val, {bool isInitializing = false}) {
    return _$setHelplineNumberAsyncAction.run(() => super.setHelplineNumber(val, isInitializing: isInitializing));
  }

  late final _$setTokenAsyncAction = AsyncAction('_AppStore.setToken', context: context);

  @override
  Future<void> setToken(String val, {bool isInitializing = false}) {
    return _$setTokenAsyncAction.run(() => super.setToken(val, isInitializing: isInitializing));
  }

  late final _$setCountryIdAsyncAction = AsyncAction('_AppStore.setCountryId', context: context);

  @override
  Future<void> setCountryId(int val, {bool isInitializing = false}) {
    return _$setCountryIdAsyncAction.run(() => super.setCountryId(val, isInitializing: isInitializing));
  }

  late final _$setBookingSelectedStatusAsyncAction = AsyncAction('_AppStore.setBookingSelectedStatus', context: context);

  @override
  Future<void> setBookingSelectedStatus(BookingStatusResponse val) {
    return _$setBookingSelectedStatusAsyncAction.run(() => super.setBookingSelectedStatus(val));
  }

  late final _$setStateIdAsyncAction = AsyncAction('_AppStore.setStateId', context: context);

  @override
  Future<void> setStateId(int val, {bool isInitializing = false}) {
    return _$setStateIdAsyncAction.run(() => super.setStateId(val, isInitializing: isInitializing));
  }

  late final _$setCurrencySymbolAsyncAction = AsyncAction('_AppStore.setCurrencySymbol', context: context);

  @override
  Future<void> setCurrencySymbol(String val, {bool isInitializing = false}) {
    return _$setCurrencySymbolAsyncAction.run(() => super.setCurrencySymbol(val, isInitializing: isInitializing));
  }

  late final _$setCurrencyCodeAsyncAction = AsyncAction('_AppStore.setCurrencyCode', context: context);

  @override
  Future<void> setCurrencyCode(String val, {bool isInitializing = false}) {
    return _$setCurrencyCodeAsyncAction.run(() => super.setCurrencyCode(val, isInitializing: isInitializing));
  }

  late final _$setCurrencyCountryIdAsyncAction = AsyncAction('_AppStore.setCurrencyCountryId', context: context);

  @override
  Future<void> setCurrencyCountryId(String val, {bool isInitializing = false}) {
    return _$setCurrencyCountryIdAsyncAction.run(() => super.setCurrencyCountryId(val, isInitializing: isInitializing));
  }

  late final _$setUIdAsyncAction = AsyncAction('_AppStore.setUId', context: context);

  @override
  Future<void> setUId(String val, {bool isInitializing = false}) {
    return _$setUIdAsyncAction.run(() => super.setUId(val, isInitializing: isInitializing));
  }

  late final _$setCityIdAsyncAction = AsyncAction('_AppStore.setCityId', context: context);

  @override
  Future<void> setCityId(int val, {bool isInitializing = false}) {
    return _$setCityIdAsyncAction.run(() => super.setCityId(val, isInitializing: isInitializing));
  }

  late final _$setUserIdAsyncAction = AsyncAction('_AppStore.setUserId', context: context);

  @override
  Future<void> setUserId(int val, {bool isInitializing = false}) {
    return _$setUserIdAsyncAction.run(() => super.setUserId(val, isInitializing: isInitializing));
  }

  late final _$setUserEmailAsyncAction = AsyncAction('_AppStore.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String val, {bool isInitializing = false}) {
    return _$setUserEmailAsyncAction.run(() => super.setUserEmail(val, isInitializing: isInitializing));
  }

  late final _$setFirstNameAsyncAction = AsyncAction('_AppStore.setFirstName', context: context);

  @override
  Future<void> setFirstName(String val, {bool isInitializing = false}) {
    return _$setFirstNameAsyncAction.run(() => super.setFirstName(val, isInitializing: isInitializing));
  }

  late final _$setLastNameAsyncAction = AsyncAction('_AppStore.setLastName', context: context);

  @override
  Future<void> setLastName(String val, {bool isInitializing = false}) {
    return _$setLastNameAsyncAction.run(() => super.setLastName(val, isInitializing: isInitializing));
  }

  late final _$setContactNumberAsyncAction = AsyncAction('_AppStore.setContactNumber', context: context);

  @override
  Future<void> setContactNumber(String val, {bool isInitializing = false}) {
    return _$setContactNumberAsyncAction.run(() => super.setContactNumber(val, isInitializing: isInitializing));
  }

  late final _$setUserNameAsyncAction = AsyncAction('_AppStore.setUserName', context: context);

  @override
  Future<void> setUserName(String val, {bool isInitializing = false}) {
    return _$setUserNameAsyncAction.run(() => super.setUserName(val, isInitializing: isInitializing));
  }

  late final _$setCurrentAddressAsyncAction = AsyncAction('_AppStore.setCurrentAddress', context: context);

  @override
  Future<void> setCurrentAddress(String val, {bool isInitializing = false}) {
    return _$setCurrentAddressAsyncAction.run(() => super.setCurrentAddress(val, isInitializing: isInitializing));
  }

  late final _$setLatitudeAsyncAction = AsyncAction('_AppStore.setLatitude', context: context);

  @override
  Future<void> setLatitude(double val, {bool isInitializing = false}) {
    return _$setLatitudeAsyncAction.run(() => super.setLatitude(val, isInitializing: isInitializing));
  }

  late final _$setLongitudeAsyncAction = AsyncAction('_AppStore.setLongitude', context: context);

  @override
  Future<void> setLongitude(double val, {bool isInitializing = false}) {
    return _$setLongitudeAsyncAction.run(() => super.setLongitude(val, isInitializing: isInitializing));
  }

  late final _$setLoggedInAsyncAction = AsyncAction('_AppStore.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val, isInitializing: isInitializing));
  }

  late final _$setCurrentLocationAsyncAction = AsyncAction('_AppStore.setCurrentLocation', context: context);

  @override
  Future<void> setCurrentLocation(bool val, {bool isInitializing = false}) {
    return _$setCurrentLocationAsyncAction.run(() => super.setCurrentLocation(val, isInitializing: isInitializing));
  }

  late final _$setDarkModeAsyncAction = AsyncAction('_AppStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool val) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(val));
  }

  late final _$setLanguageAsyncAction = AsyncAction('_AppStore.setLanguage', context: context);

  @override
  Future<void> setLanguage(String val) {
    return _$setLanguageAsyncAction.run(() => super.setLanguage(val));
  }

  late final _$_AppStoreActionController = ActionController(name: '_AppStore', context: context);

  @override
  void setLoading(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFavorite(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setFavorite');
    try {
      return super.setFavorite(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUnreadCount(int val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setUnreadCount');
    try {
      return super.setUnreadCount(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRemember(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(name: '_AppStore.setRemember');
    try {
      return super.setRemember(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isDarkMode: ${isDarkMode},
isLoading: ${isLoading},
isFavorite: ${isFavorite},
isCurrentLocation: ${isCurrentLocation},
isRememberMe: ${isRememberMe},
selectedLanguageCode: ${selectedLanguageCode},
userProfileImage: ${userProfileImage},
privacyPolicy: ${privacyPolicy},
loginType: ${loginType},
termConditions: ${termConditions},
inquiryEmail: ${inquiryEmail},
helplineNumber: ${helplineNumber},
userFirstName: ${userFirstName},
userLastName: ${userLastName},
uid: ${uid},
userContactNumber: ${userContactNumber},
userEmail: ${userEmail},
userName: ${userName},
latitude: ${latitude},
longitude: ${longitude},
currentAddress: ${currentAddress},
token: ${token},
countryId: ${countryId},
stateId: ${stateId},
currencySymbol: ${currencySymbol},
currencyCode: ${currencyCode},
currencyCountryId: ${currencyCountryId},
cityId: ${cityId},
address: ${address},
playerId: ${playerId},
userId: ${userId},
unreadCount: ${unreadCount},
useMaterialYouTheme: ${useMaterialYouTheme},
isEnableUserWallet: ${isEnableUserWallet},
userType: ${userType},
is24HourFormat: ${is24HourFormat},
userFullName: ${userFullName}
    ''';
  }
}

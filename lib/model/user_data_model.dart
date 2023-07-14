import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

import '../utils/constant.dart';

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  int? providerId;
  int? status;

  ///check its use
  String? description;
  String? knownLanguages;
  String? skills;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  String? providerTypeId;
  String? providerType;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? timeZone;
  String? lastNotificationSeen;
  String? uid;
  String? socialImage;
  String? loginType;
  int? serviceAddressId;
  num? providersServiceRating;
  num? handymanRating;
  int? isVerifyProvider;
  String? designation;
  String? apiToken;
  String? emailVerifiedAt;
  String? playerId;
  List<String>? userRole;
  HandymanReview? handymanReview;
  int? isUserExist;
  String? password;
  num? isFavourite;

  String? verificationId;
  String? otpCode;

  bool isSelected = false;
  int? isOnline;

  ///Local
  bool get isHandyman => userType == USER_TYPE_HANDYMAN;

  bool get isProvider => userType == USER_TYPE_PROVIDER;

  List<String> get knownLanguagesArray => buildKnownLanguages();

  List<String> get skillsArray => buildSkills();

  List<String> buildKnownLanguages() {
    List<String> array = [];
    String tempLanguages = knownLanguages.validate();
    if (tempLanguages.isNotEmpty && tempLanguages.isJson()) {
      Iterable it1 = jsonDecode(knownLanguages.validate());
      array.addAll(it1.map((e) => e.toString()).toList());
    }

    return array;
  }

  List<String> buildSkills() {
    List<String> array = [];
    String tempSkills = skills.validate();
    if (tempSkills.isNotEmpty && tempSkills.isJson()) {
      Iterable it2 = jsonDecode(skills.validate());
      array.addAll(it2.map((e) => e.toString()).toList());
    }

    return array;
  }

  UserData({
    this.address,
    this.apiToken,
    this.cityId,
    this.contactNumber,
    this.countryId,
    this.createdAt,
    this.displayName,
    this.socialImage,
    this.email,
    this.emailVerifiedAt,
    this.firstName,
    this.id,
    this.isFeatured,
    this.lastName,
    this.playerId,
    this.description,
    this.knownLanguages,
    this.skills,
    this.providerType,
    this.cityName,
    this.providerId,
    this.providerTypeId,
    this.stateId,
    this.status,
    this.updatedAt,
    this.userRole,
    this.userType,
    this.username,
    this.profileImage,
    this.uid,
    this.handymanRating,
    this.handymanReview,
    this.lastNotificationSeen,
    this.loginType,
    this.providersServiceRating,
    this.serviceAddressId,
    this.timeZone,
    this.isOnline,
    this.isVerifyProvider,
    this.isUserExist,
    this.password,
    this.isFavourite,
    this.designation,
    this.verificationId,
    this.otpCode,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      address: json['address'],
      apiToken: json['api_token'],
      cityId: json['city_id'],
      contactNumber: json['contact_number'],
      countryId: json['country_id'],
      createdAt: json['created_at'],
      displayName: json['display_name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      firstName: json['first_name'],
      id: json['id'],
      isFeatured: json['is_featured'],
      lastName: json['last_name'],
      playerId: json['player_id'],
      socialImage: json['social_image'],
      providerId: json['provider_id'],
      //providertype_id: json['providertype_id'],
      stateId: json['state_id'],
      status: json['status'],
      updatedAt: json['updated_at'],
      userRole: json['user_role'] != null ? new List<String>.from(json['user_role']) : null,
      userType: json['user_type'],
      username: json['username'],
      isOnline: json['isOnline'],
      profileImage: json['profile_image'],
      uid: json['uid'],
      password: json['password'],
      isFavourite: json['is_favourite'],
      description: json['description'],
      knownLanguages: json['known_languages'],
      skills: json['skills'],
      providerType: json['providertype'],
      cityName: json['city_name'],
      loginType: json['login_type'],
      serviceAddressId: json['service_address_id'],
      lastNotificationSeen: json['last_notification_seen'],
      providersServiceRating: json['providers_service_rating'],
      handymanRating: json['handyman_rating'],
      handymanReview: json['handyman_review'] != null ? new HandymanReview.fromJson(json['handyman_review']) : null,
      timeZone: json['time_zone'],
      isVerifyProvider: json['is_verify_provider'],
      isUserExist: json['is_user_exist'],
      verificationId: json['verificationId'],
      designation: json['designation'],
      otpCode: json['otpCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) data['address'] = this.address;
    if (this.apiToken != null) data['api_token'] = this.apiToken;
    if (this.cityId != null) data['city_id'] = this.cityId;
    if (this.password != null) data['password'] = this.password;
    if (this.contactNumber != null) data['contact_number'] = this.contactNumber;
    if (this.countryId != null) data['country_id'] = this.countryId;
    if (this.createdAt != null) data['created_at'] = this.createdAt;
    if (this.displayName != null) data['display_name'] = this.displayName;
    if (this.email != null) data['email'] = this.email;
    if (this.emailVerifiedAt != null) data['email_verified_at'] = this.emailVerifiedAt;
    if (this.firstName != null) data['first_name'] = this.firstName;
    if (this.id != null) data['id'] = this.id;
    if (this.socialImage != null) data['social_image'] = this.socialImage;
    if (this.isFeatured != null) data['is_featured'] = this.isFeatured;
    if (this.lastName != null) data['last_name'] = this.lastName;
    if (this.playerId != null) data['player_id'] = this.playerId;
    if (this.providerId != null) data['provider_id'] = this.providerId;
    if (this.providerTypeId != null) data['providertype_id'] = this.providerTypeId;
    if (this.stateId != null) data['state_id'] = this.stateId;
    if (this.status != null) data['status'] = this.status;
    if (this.updatedAt != null) data['updated_at'] = this.updatedAt;
    if (this.userType != null) data['user_type'] = this.userType;
    if (this.username != null) data['username'] = this.username;
    if (this.profileImage != null) data['profile_image'] = this.profileImage;
    if (this.uid != null) data['uid'] = this.uid;
    if (this.isOnline != null) data['isOnline'] = this.isOnline;
    if (this.description != null) data['description'] = this.description;
    if (this.knownLanguages != null) data['known_languages'] = this.knownLanguages;
    if (this.skills != null) data['skills'] = this.skills;
    if (this.providerType != null) data['providertype'] = this.providerType;
    if (this.cityName != null) data['city_name'] = this.cityName;
    if (this.timeZone != null) data['time_zone'] = this.timeZone;
    if (this.loginType != null) data['login_type'] = this.loginType;
    if (this.serviceAddressId != null) data['service_address_id'] = this.serviceAddressId;
    if (this.lastNotificationSeen != null) data['last_notification_seen'] = this.lastNotificationSeen;
    if (this.providersServiceRating != null) data['providers_service_rating'] = this.providersServiceRating;
    if (this.handymanRating != null) data['handyman_rating'] = this.handymanRating;
    if (this.isVerifyProvider != null) data['is_verify_provider'] = this.isVerifyProvider;
    if (this.isUserExist != null) data['is_user_exist'] = this.isUserExist;
    if (this.designation != null) data['designation'] = this.designation;
    if (this.verificationId != null) data['verificationId'] = this.verificationId;
    if (this.otpCode != null) data['otpCode'] = this.otpCode;
    if (this.isFavourite != null) data['is_favourite'] = this.isFavourite;
    if (this.handymanReview != null) {
      data['handyman_review'] = this.handymanReview!.toJson();
    }
    if (this.userRole != null) {
      data['user_role'] = this.userRole;
    }
    return data;
  }

  Map<String, dynamic> toFirebaseJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['id'] = this.id;
    if (this.uid != null) data['uid'] = this.uid;
    if (this.apiToken != null) data['api_token'] = this.apiToken;
    if (this.firstName != null) data['first_name'] = this.firstName;
    if (this.lastName != null) data['last_name'] = this.lastName;
    if (this.email != null) data['email'] = this.email;
    if (this.displayName != null) data['display_name'] = this.displayName;
    if (this.password != null) data['password'] = this.password;
    if (this.socialImage != null) data['social_image'] = this.socialImage;
    if (this.playerId != null) data['player_id'] = this.playerId;
    if (this.profileImage != null) data['profile_image'] = this.profileImage;
    if (this.isOnline != null) data['isOnline'] = this.isOnline;
    if (this.updatedAt != null) data['updated_at'] = this.updatedAt;
    if (this.createdAt != null) data['created_at'] = this.createdAt;
    return data;
  }
}

class HandymanReview {
  int? id;
  int? customerId;
  num? rating;
  String? review;
  int? serviceId;
  int? bookingId;
  int? handymanId;
  String? handymanName;
  String? handymanProfileImage;
  String? customerName;
  String? customerProfileImage;
  String? createdAt;

  HandymanReview({
    this.id,
    this.customerId,
    this.rating,
    this.review,
    this.serviceId,
    this.bookingId,
    this.handymanId,
    this.handymanName,
    this.handymanProfileImage,
    this.customerName,
    this.customerProfileImage,
    this.createdAt,
  });

  HandymanReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    rating = json['rating'];
    review = json['review'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    handymanId = json['handyman_id'];
    handymanName = json['handyman_name'];
    handymanProfileImage = json['handyman_profile_image'];
    customerName = json['customer_name'];
    customerProfileImage = json['customer_profile_image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['service_id'] = this.serviceId;
    data['booking_id'] = this.bookingId;
    data['handyman_id'] = this.handymanId;
    data['handyman_name'] = this.handymanName;
    data['handyman_profile_image'] = this.handymanProfileImage;
    data['customer_name'] = this.customerName;
    data['customer_profile_image'] = this.customerProfileImage;
    data['created_at'] = this.createdAt;
    return data;
  }
}

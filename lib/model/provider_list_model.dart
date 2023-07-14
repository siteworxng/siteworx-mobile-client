import 'package:client/model/pagination_model.dart';
import 'package:client/model/user_data_model.dart';

class ProviderListResponse {
  Pagination? pagination;
  List<UserData>? providerList;

  ProviderListResponse({this.pagination, this.providerList});

  ProviderListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      providerList = json['data'] != null ? (json['data'] as List).map((i) => UserData.fromJson(i)).toList() : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.providerList != null) {
      data['data'] = this.providerList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/*class Provider {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? providerId;
  int? status;
  String? description;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  int? providertypeId;
  String? providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? timeZone;
  String? lastNotificationSeen;

  Provider(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.providerId,
      this.status,
      this.description,
      this.userType,
      this.email,
      this.contactNumber,
      this.countryId,
      this.stateId,
      this.cityId,
      this.cityName,
      this.address,
      this.providertypeId,
      this.providertype,
      this.isFeatured,
      this.displayName,
      this.createdAt,
      this.updatedAt,
      this.profileImage,
      this.timeZone,
      this.lastNotificationSeen});

  Provider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
    description = json['description'];
    userType = json['user_type'];
    email = json['email'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    providertypeId = json['providertype_id'];
    providertype = json['providertype'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileImage = json['profile_image'];
    timeZone = json['time_zone'];
    lastNotificationSeen = json['last_notification_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['description'] = this.description;
    data['user_type'] = this.userType;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['address'] = this.address;
    data['providertype_id'] = this.providertypeId;
    data['providertype'] = this.providertype;
    data['is_featured'] = this.isFeatured;
    data['display_name'] = this.displayName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_image'] = this.profileImage;
    data['time_zone'] = this.timeZone;
    data['last_notification_seen'] = this.lastNotificationSeen;
    return data;
  }
}*/

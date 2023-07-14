import 'package:client/model/booking_data_model.dart';
import 'package:client/model/get_my_post_job_list_response.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/model/user_data_model.dart';
import 'package:nb_utils/nb_utils.dart';

import 'service_detail_response.dart';

class BookingDetailResponse {
  List<BookingActivity>? bookingActivity;
  BookingData? bookingDetail;
  CouponData? couponData;
  UserData? customer;
  List<UserData>? handymanData;
  UserData? providerData;
  List<RatingData>? ratingData;
  ServiceData? service;
  RatingData? customerReview;
  List<TaxData>? taxes;
  List<ServiceProof>? serviceProof;
  PostJobData? postRequestDetail;

  bool get isProviderAndHandymanSame => handymanData.validate().isNotEmpty ? handymanData.validate().first.id.validate() == providerData!.id.validate() : false;

  BookingDetailResponse({
    this.bookingActivity,
    this.bookingDetail,
    this.couponData,
    this.customer,
    this.handymanData,
    this.providerData,
    this.service,
    this.ratingData,
    this.customerReview,
    this.taxes,
    this.serviceProof,
    this.postRequestDetail,
  });

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailResponse(
      bookingActivity: json['booking_activity'] != null ? (json['booking_activity'] as List).map((i) => BookingActivity.fromJson(i)).toList() : null,
      bookingDetail: json['booking_detail'] != null ? BookingData.fromJson(json['booking_detail']) : null,
      couponData: json['coupon_data'] != null ? CouponData.fromJson(json['coupon_data']) : null,
      customer: json['customer'] != null ? UserData.fromJson(json['customer']) : null,
      handymanData: json['handyman_data'] != null ? (json['handyman_data'] as List).map((i) => UserData.fromJson(i)).toList() : null,
      ratingData: json['rating_data'] != null ? (json['rating_data'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
      providerData: json['provider_data'] != null ? UserData.fromJson(json['provider_data']) : null,
      service: json['service'] != null ? ServiceData.fromJson(json['service']) : null,
      customerReview: json['customer_review'] != null ? RatingData.fromJson(json['customer_review']) : null,
      serviceProof: json['service_proof'] != null ? (json['service_proof'] as List).map((i) => ServiceProof.fromJson(i)).toList() : null,
      postRequestDetail: json['post_request_detail'] != null ? PostJobData.fromJson(json['post_request_detail']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingActivity != null) {
      data['booking_activity'] = this.bookingActivity!.map((v) => v.toJson()).toList();
    }
    if (this.bookingDetail != null) {
      data['booking_detail'] = this.bookingDetail!.toJson();
    }
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.handymanData != null) {
      data['handyman_data'] = this.handymanData!.map((v) => v.toJson()).toList();
    }
    if (this.providerData != null) {
      data['provider_data'] = this.providerData!.toJson();
    }
    if (this.ratingData != null) {
      data['rating_data'] = this.ratingData!.map((v) => v.toJson()).toList();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.customerReview != null) {
      data['customer_review'] = this.customerReview!.toJson();
    }
    if (this.serviceProof != null) {
      data['service_proof'] = this.serviceProof!.map((v) => v.toJson()).toList();
    }
    if (postRequestDetail != null) {
      data['post_request_detail'] = postRequestDetail?.toJson();
    }
    return data;
  }
}

class BookingActivity {
  String? activityData;
  String? activityMessage;
  String? activityType;
  int? bookingId;
  String? createdAt;
  String? datetime;
  String? deletedAt;
  int? id;
  String? updatedAt;

  BookingActivity({this.activityData, this.activityMessage, this.activityType, this.bookingId, this.createdAt, this.datetime, this.deletedAt, this.id, this.updatedAt});

  factory BookingActivity.fromJson(Map<String, dynamic> json) {
    return BookingActivity(
      activityData: json['activity_data'],
      activityMessage: json['activity_message'],
      activityType: json['activity_type'],
      bookingId: json['booking_id'],
      createdAt: json['created_at'],
      datetime: json['datetime'],
      deletedAt: json['deleted_at'],
      id: json['id'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity_data'] = this.activityData;
    data['activity_message'] = this.activityMessage;
    data['activity_type'] = this.activityType;
    data['booking_id'] = this.bookingId;
    data['created_at'] = this.createdAt;
    data['datetime'] = this.datetime;
    data['deleted_at'] = this.deletedAt;
    data['id'] = this.id;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ServiceProof {
  int? id;
  String? title;
  String? description;
  int? serviceId;
  int? bookingId;
  int? userId;
  String? handymanName;
  String? serviceName;
  List<String>? attachments;

  ServiceProof({
    this.id,
    this.title,
    this.description,
    this.serviceId,
    this.bookingId,
    this.userId,
    this.handymanName,
    this.serviceName,
    this.attachments,
  });

  ServiceProof.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    userId = json['user_id'];
    handymanName = json['handyman_name'];
    serviceName = json['service_name'];
    attachments = json['attachments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['service_id'] = this.serviceId;
    data['booking_id'] = this.bookingId;
    data['user_id'] = this.userId;
    data['handyman_name'] = this.handymanName;
    data['service_name'] = this.serviceName;
    data['attachments'] = this.attachments;
    return data;
  }
}

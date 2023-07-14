import 'package:client/model/pagination_model.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/model/user_data_model.dart';

class GetPostJobResponse {
  Pagination? pagination;
  List<PostJobData>? myPostJobData;

  GetPostJobResponse({this.pagination, this.myPostJobData});

  GetPostJobResponse.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      myPostJobData = [];
      json['data'].forEach((v) {
        myPostJobData?.add(PostJobData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    if (myPostJobData != null) {
      map['data'] = myPostJobData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class PostJobData {
  num? id;
  String? title;
  String? description;
  String? reason;
  num? price;
  num? jobPrice;
  num? providerId;
  num? customerId;
  String? status;
  bool? canBid;
  List<ServiceData>? service;
  String? createdAt;

  PostJobData({
    this.id,
    this.title,
    this.description,
    this.reason,
    this.price,
    this.jobPrice,
    this.providerId,
    this.customerId,
    this.status,
    this.canBid,
    this.service,
    this.createdAt,
  });

  PostJobData.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    reason = json['reason'];
    price = json['price'];
    jobPrice = json['job_price'];
    providerId = json['provider_id'];
    customerId = json['customer_id'];
    status = json['status'];
    canBid = json['can_bid'];
    createdAt = json['created_at'];
    if (json['service'] != null) {
      service = [];
      json['service'].forEach((v) {
        service?.add(ServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['reason'] = reason;
    map['price'] = price;
    map['job_price'] = jobPrice;
    map['provider_id'] = providerId;
    map['customer_id'] = customerId;
    map['status'] = status;
    map['can_bid'] = canBid;
    if (service != null) {
      map['service'] = service?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class BidderData {
  int? id;
  int? postRequestId;
  int? providerId;
  num? price;
  String? duration;
  UserData? provider;

  BidderData({this.id, this.postRequestId, this.providerId, this.price, this.duration, this.provider});

  BidderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postRequestId = json['post_request_id'];
    providerId = json['provider_id'];
    price = json['price'];
    duration = json['duration'];
    provider = json['provider'] != null ? new UserData.fromJson(json['provider']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_request_id'] = this.postRequestId;
    data['provider_id'] = this.providerId;
    data['price'] = this.price;
    data['duration'] = this.duration;
    if (this.provider != null) {
      data['provider'] = this.provider!.toJson();
    }
    return data;
  }
}

import 'package:client/model/booking_data_model.dart';
import 'package:client/model/user_data_model.dart';

import 'pagination_model.dart';

class BookingListResponse {
  List<BookingData>? data;
  Pagination? pagination;

  BookingListResponse({this.data, this.pagination});

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => BookingData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Handyman {
  int? bookingId;
  String? createdAt;
  String? deletedAt;
  UserData? handyman;
  int? handymanId;
  int? id;
  String? updatedAt;

  Handyman({this.bookingId, this.createdAt, this.deletedAt, this.handyman, this.handymanId, this.id, this.updatedAt});

  factory Handyman.fromJson(Map<String, dynamic> json) {
    return Handyman(
      bookingId: json['booking_id'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      handyman: json['handyman'] != null ? UserData.fromJson(json['handyman']) : null,
      handymanId: json['handyman_id'],
      id: json['id'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    data['handyman_id'] = this.handymanId;
    data['id'] = this.id;
    data['updated_at'] = this.updatedAt;
    if (this.handyman != null) {
      data['handyman'] = this.handyman!.toJson();
    }
    return data;
  }
}

import 'package:client/model/service_detail_response.dart';
import 'package:client/model/user_data_model.dart';

import 'service_data_model.dart';

class ProviderInfoResponse {
  UserData? userData;
  List<ServiceData>? serviceList;
  List<RatingData>? handymanRatingReviewList;

  ProviderInfoResponse({this.userData, this.serviceList, this.handymanRatingReviewList});

  ProviderInfoResponse.fromJson(Map<String, dynamic> json) {
    userData = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    if (json['service'] != null) {
      serviceList = [];
      json['service'].forEach((v) {
        serviceList!.add(ServiceData.fromJson(v));
      });
    }
    if (json['handyman_rating_review'] != null) {
      handymanRatingReviewList = [];
      json['handyman_rating_review'].forEach((v) {
        handymanRatingReviewList!.add(new RatingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['data'] = this.userData!.toJson();
    }
    if (this.serviceList != null) {
      data['service'] = this.serviceList!.map((v) => v.toJson()).toList();
    }
    if (this.handymanRatingReviewList != null) {
      data['handyman_rating_review'] = this.handymanRatingReviewList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

import 'package:client/model/service_detail_response.dart';

class ServiceReviewResponse {
  List<RatingData>? ratingList;

  ServiceReviewResponse({this.ratingList});

  factory ServiceReviewResponse.fromJson(Map<String, dynamic> json) {
    return ServiceReviewResponse(
      ratingList: json['data'] != null ? (json['data'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ratingList != null) {
      data['data'] = this.ratingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

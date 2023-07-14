import 'package:client/model/get_my_post_job_list_response.dart';

class PostJobDetailResponse {
  PostJobData? postRequestDetail;
  List<BidderData>? biderData;

  PostJobDetailResponse({this.postRequestDetail, this.biderData});

  PostJobDetailResponse.fromJson(dynamic json) {
    postRequestDetail = json['post_request_detail'] != null ? PostJobData.fromJson(json['post_request_detail']) : null;
    if (json['bider_data'] != null) {
      biderData = [];
      json['bider_data'].forEach((v) {
        biderData?.add(BidderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (postRequestDetail != null) {
      map['post_request_detail'] = postRequestDetail?.toJson();
    }
    if (biderData != null) {
      map['bider_data'] = biderData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

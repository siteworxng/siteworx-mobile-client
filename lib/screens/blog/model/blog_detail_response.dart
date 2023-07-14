import 'package:client/screens/blog/model/blog_response_model.dart';

class BlogDetailResponse {
  BlogData? blogDetail;

  BlogDetailResponse({this.blogDetail});

  BlogDetailResponse.fromJson(Map<String, dynamic> json) {
    blogDetail = json['blog_detail'] != null ? BlogData.fromJson(json['blog_detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.blogDetail != null) {
      data['blog_detail'] = this.blogDetail!.toJson();
    }
    return data;
  }
}

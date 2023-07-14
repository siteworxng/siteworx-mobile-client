import 'package:client/model/user_data_model.dart';

class LoginResponse {
  UserData? userData;
  bool? isUserExist;
  bool? status;
  String? message;

  LoginResponse({this.userData, this.isUserExist, this.status, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userData: json['data'] != null ? UserData.fromJson(json['data']) : null,
      isUserExist: json['is_user_exist'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['data'] = this.userData!.toJson();
    }
    data['is_user_exist'] = this.isUserExist;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

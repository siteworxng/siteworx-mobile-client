class NotificationListResponse {
  List<NotificationData>? notificationData;
  int? allUnreadCount;

  NotificationListResponse({this.notificationData, this.allUnreadCount});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    if (json['notification_data'] != null) {
      notificationData = [];
      json['notification_data'].forEach((v) {
        notificationData!.add(new NotificationData.fromJson(v));
      });
    }
    allUnreadCount = json['all_unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notificationData != null) {
      data['notification_data'] = this.notificationData!.map((v) => v.toJson()).toList();
    }
    data['all_unread_count'] = this.allUnreadCount;
    return data;
  }
}

class NotificationData {
  String? id;
  String? readAt;
  String? createdAt;
  String? profileImage;
  NotificationInnerData? data;

  NotificationData({this.id, this.readAt, this.createdAt, this.data});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    profileImage = json['profile_image'];
    data = json['data'] != null ? new NotificationInnerData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['read_at'] = this.readAt;
    data['created_at'] = this.createdAt;
    data['profile_image'] = this.profileImage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NotificationInnerData {
  int? id;
  String? type;
  String? subject;
  String? message;
  String? notificationType;

  NotificationInnerData({this.id, this.type, this.subject, this.message, this.notificationType});

  NotificationInnerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    subject = json['subject'];
    message = json['message'];
    notificationType = json['notification-type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['notification-type'] = this.notificationType;
    return data;
  }
}

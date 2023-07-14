import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  String? uid;
  Timestamp? addedOn;
  int? lastMessageTime;
  int? unReadFromUser;

  ContactModel({this.uid, this.addedOn, this.lastMessageTime, this.unReadFromUser});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      uid: json['uid'],
      lastMessageTime: json['lastMessageTime'],
      unReadFromUser: json['unReadFromUser'],
      addedOn: json['addedOn'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uid != null) data['uid'] = this.uid;
    if (this.addedOn != null) data['addedOn'] = this.addedOn;
    if (this.unReadFromUser != null) data['unReadFromUser'] = this.unReadFromUser;
    if (this.lastMessageTime != null) data['lastMessageTime'] = this.lastMessageTime;

    return data;
  }
}

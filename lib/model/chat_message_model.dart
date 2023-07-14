import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  String? uid;
  String? senderId;
  String? receiverId;
  String? photoUrl;
  String? messageType;
  bool? isMe;
  bool? isMessageRead;
  String? message;
  int? createdAt;
  Timestamp? createdAtTime;
  Timestamp? updatedAtTime;
  DocumentReference? chatDocumentReference;

  ChatMessageModel({
    this.uid,
    this.senderId,
    this.createdAtTime,
    this.updatedAtTime,
    this.receiverId,
    this.createdAt,
    this.message,
    this.isMessageRead,
    this.photoUrl,
    this.messageType,
    this.chatDocumentReference,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      uid: json['uid'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      isMessageRead: json['isMessageRead'],
      photoUrl: json['photoUrl'],
      messageType: json['messageType'],
      createdAt: json['createdAt'],
      createdAtTime: json['createdAtTime'],
      updatedAtTime: json['updatedAtTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uid != null) data['uid'] = this.uid;
    if (this.createdAt != null) data['createdAt'] = this.createdAt;
    if (this.message != null) data['message'] = this.message;
    if (this.senderId != null) data['senderId'] = this.senderId;
    if (this.isMessageRead != null) data['isMessageRead'] = this.isMessageRead;
    if (this.receiverId != null) data['receiverId'] = this.receiverId;
    if (this.photoUrl != null) data['photoUrl'] = this.photoUrl;
    if (this.createdAtTime != null) data['createdAtTime'] = this.createdAtTime;
    if (this.updatedAtTime != null) data['updatedAtTime'] = this.updatedAtTime;
    if (this.messageType != null) data['messageType'] = this.messageType;
    return data;
  }
}

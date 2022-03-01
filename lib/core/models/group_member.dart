import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMember {
  String chatId;
  bool isActive;
  String objectId;
  FieldValue createdAt;
  FieldValue updatedAt;
  String userId;

  GroupMember({this.chatId, this.createdAt, this.isActive, this.objectId, this.updatedAt, this.userId});

  GroupMember.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    objectId = json['objectId'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatId'] = this.chatId;
    data['createdAt'] = this.createdAt;
    data['isActive'] = this.isActive;
    data['objectId'] = this.objectId;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    return data;
  }

  GroupMember.fromUser({String chatId, String objectId, String userId}) {
    isActive = true;
    this.userId = userId;
    this.chatId = chatId;
    this.objectId = objectId;
    createdAt = FieldValue.serverTimestamp();
    updatedAt = FieldValue.serverTimestamp();
  }
}

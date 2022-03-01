import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChat {
  String chatId;
  FieldValue createdAt;
  bool isDeleted;
  String name;
  String objectId;
  String ownerId;
  FieldValue updatedAt;

  GroupChat({this.chatId, this.createdAt, this.isDeleted, this.name, this.objectId, this.ownerId, this.updatedAt});

  GroupChat.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    createdAt = json['createdAt'];
    isDeleted = json['isDeleted'];
    name = json['name'];
    objectId = json['objectId'];
    ownerId = json['ownerId'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatId'] = this.chatId;
    data['createdAt'] = this.createdAt;
    data['isDeleted'] = this.isDeleted;
    data['name'] = this.name;
    data['objectId'] = this.objectId;
    data['ownerId'] = this.ownerId;
    data['updatedAt'] = this.updatedAt;
    return data;
  }

  GroupChat.fromUser({String chatId, String name, String ownerId}) {
    isDeleted = false;
    this.name = name;
    objectId = chatId;
    this.chatId = chatId;
    this.ownerId = ownerId;
    createdAt = FieldValue.serverTimestamp();
    updatedAt = FieldValue.serverTimestamp();
  }
}

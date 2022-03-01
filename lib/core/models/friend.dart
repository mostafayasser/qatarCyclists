import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  FieldValue createdAt;
  String friendId;
  bool isDeleted;
  String objectId;
  FieldValue updatedAt;
  String userId;

  Friend({this.createdAt, this.friendId, this.isDeleted, this.objectId, this.updatedAt, this.userId});

  Friend.fromJson(Map<String, dynamic> json) {
    isDeleted = json['isDeleted'];
    userId = json['userId'];
    friendId = json['friendId'];
    objectId = json['objectId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['friendId'] = this.friendId;
    data['isDeleted'] = this.isDeleted;
    data['objectId'] = this.objectId;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    return data;
  }

  Friend.fromUser({String objectId, String userId, String friendId}) {
    isDeleted = false;
    this.userId = userId;
    this.friendId = friendId;
    this.objectId = objectId;
    createdAt = FieldValue.serverTimestamp();
    updatedAt = FieldValue.serverTimestamp();
  }
}

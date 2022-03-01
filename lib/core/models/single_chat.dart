import 'package:cloud_firestore/cloud_firestore.dart';

class SingleChat {
  String chatId;
  FieldValue createdAt;
  String fullname1;
  String fullname2;
  String initials1;
  String initials2;
  String objectId;
  int pictureAt1;
  int pictureAt2;
  FieldValue updatedAt;
  String userId1;
  String userId2;

  SingleChat(
      {this.chatId,
      this.createdAt,
      this.fullname1,
      this.fullname2,
      this.initials1,
      this.initials2,
      this.objectId,
      this.pictureAt1,
      this.pictureAt2,
      this.updatedAt,
      this.userId1,
      this.userId2});

  SingleChat.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    createdAt = json['createdAt'];
    fullname1 = json['fullname1'];
    fullname2 = json['fullname2'];
    initials1 = json['initials1'];
    initials2 = json['initials2'];
    objectId = json['objectId'];
    pictureAt1 = json['pictureAt1'];
    pictureAt2 = json['pictureAt2'];
    updatedAt = json['updatedAt'];
    userId1 = json['userId1'];
    userId2 = json['userId2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatId'] = this.chatId;
    data['createdAt'] = this.createdAt;
    data['fullname1'] = this.fullname1;
    data['fullname2'] = this.fullname2;
    data['initials1'] = this.initials1;
    data['initials2'] = this.initials2;
    data['objectId'] = this.objectId;
    data['pictureAt1'] = this.pictureAt1;
    data['pictureAt2'] = this.pictureAt2;
    data['updatedAt'] = this.updatedAt;
    data['userId1'] = this.userId1;
    data['userId2'] = this.userId2;
    return data;
  }

  SingleChat.fromUser(
      {String chatId,
      String name1,
      String name2,
      String userId1,
      String userId2}) {
    createdAt = FieldValue.serverTimestamp();
    fullname1 = name1;
    fullname2 = name2;
    initials1 = name1;
    initials2 = name2;
    objectId = chatId;
    pictureAt1 = 0;
    pictureAt2 = 0;
    updatedAt = FieldValue.serverTimestamp();
    this.chatId = chatId;
    this.userId1 = userId1;
    this.userId2 = userId2;
  }
}

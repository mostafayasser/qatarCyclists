import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage {
  int audioDuration;
  String chatId;
  FieldValue createdAt;
  bool isDeleted;
  bool isMediaFailed;
  bool isMediaQueued;
  double latitude;
  double longitude;
  String objectId;
  int photoHeight;
  int photoWidth;
  int videoHeight;
  int videoWidth;
  String text;
  String type;
  FieldValue updatedAt;
  String userFullname;
  String userId;
  String userInitials;
  int userPictureAt;
  double videoDuration;

  ChatMessage({
    this.audioDuration,
    this.chatId,
    this.createdAt,
    this.isDeleted,
    this.isMediaFailed,
    this.isMediaQueued,
    this.latitude,
    this.longitude,
    this.objectId,
    this.photoHeight,
    this.photoWidth,
    this.videoHeight,
    this.videoWidth,
    this.text,
    this.type,
    this.updatedAt,
    this.userFullname,
    this.userId,
    this.userInitials,
    this.userPictureAt,
    this.videoDuration,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    audioDuration = json['audioDuration'];
    chatId = json['chatId'];
    createdAt = json['createdAt'];
    isDeleted = json['isDeleted'];
    isMediaFailed = json['isMediaFailed'];
    isMediaQueued = json['isMediaQueued'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    objectId = json['objectId'];
    photoHeight = json['photoHeight'];
    photoWidth = json['photoWidth'];
    videoHeight = json['videoHeight'];
    videoWidth = json['videoWidth'];
    text = json['text'];
    type = json['type'];
    updatedAt = json['updatedAt'];
    userFullname = json['userFullname'];
    userId = json['userId'];
    userInitials = json['userInitials'];
    userPictureAt = json['userPictureAt'];
    videoDuration = json['videoDuration'];
    audioDuration = json['audioDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audioDuration'] = this.audioDuration;
    data['chatId'] = this.chatId;
    data['createdAt'] = this.createdAt;
    print(this.createdAt);
    data['isDeleted'] = this.isDeleted;
    data['isMediaFailed'] = this.isMediaFailed;
    data['isMediaQueued'] = this.isMediaQueued;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['objectId'] = this.objectId;
    data['photoHeight'] = this.photoHeight;
    data['photoWidth'] = this.photoWidth;
    data['videoHeight'] = this.videoHeight;
    data['videoWidth'] = this.videoWidth;
    data['text'] = this.text;
    data['type'] = this.type;
    data['updatedAt'] = this.updatedAt;
    print(this.updatedAt);
    data['userFullname'] = this.userFullname;
    data['userId'] = this.userId;
    data['userInitials'] = this.userInitials;
    data['userPictureAt'] = this.userPictureAt;
    data['videoDuration'] = this.videoDuration;
    return data;
  }

  ChatMessage.fromText(
      {@required String chatId,
      @required String objectId,
      @required String text,
      @required String userId,
      @required String userFullname}) {
    audioDuration = 0;
    this.chatId = chatId;
    createdAt = FieldValue.serverTimestamp();
    isDeleted = false;
    isMediaFailed = false;
    isMediaQueued = false;
    latitude = 0;
    longitude = 0;
    this.objectId = objectId;
    photoHeight = 0;
    photoWidth = 0;
    videoHeight = 0;
    videoWidth = 0;
    this.text = text;
    type = 'text';
    updatedAt = FieldValue.serverTimestamp();
    this.userFullname = userFullname;
    this.userId = userId;
    userInitials = userFullname?.split("")?.first ?? '';
    userPictureAt = 0;
    videoDuration = 0;
  }

  ChatMessage.fromImage({
    @required String chatId,
    @required String objectId,
    @required String userId,
    @required String userFullname,
    int width,
    int height,
  }) {
    audioDuration = 0;
    this.chatId = chatId;
    createdAt = FieldValue.serverTimestamp();
    isDeleted = false;
    isMediaFailed = false;
    isMediaQueued = false;
    latitude = 0;
    longitude = 0;
    this.objectId = objectId;
    this.photoHeight = height;
    this.photoWidth = width;
    videoHeight = 0;
    videoWidth = 0;
    text = "";
    type = 'image';
    updatedAt = FieldValue.serverTimestamp();
    this.userFullname = userFullname;
    this.userId = userId;
    userInitials = userFullname?.split("")?.first ?? '';
    userPictureAt = 0;
    videoDuration = 0;
  }
  ChatMessage.fromVideo(
      {@required String chatId,
      @required String objectId,
      @required String userId,
      @required String userFullname,
      @required int height,
      @required int width,
      double duration}) {
    audioDuration = 0;
    this.chatId = chatId;
    createdAt = FieldValue.serverTimestamp();
    isDeleted = false;
    isMediaFailed = false;
    isMediaQueued = false;
    latitude = 0;
    longitude = 0;
    this.objectId = objectId;
    photoHeight = 0;
    photoWidth = 0;
    videoHeight = height;
    videoWidth = width;
    text = "";
    type = 'video';
    updatedAt = FieldValue.serverTimestamp();
    this.userFullname = userFullname;
    this.userId = userId;
    userInitials = userFullname?.split("")?.first ?? '';
    userPictureAt = 0;
    this.videoDuration = duration;
  }

  ChatMessage.fromAudio(
      {@required String chatId,
      @required String objectId,
      @required String userId,
      @required String userFullname,
      int duration}) {
    this.audioDuration = duration;
    this.chatId = chatId;
    createdAt = FieldValue.serverTimestamp();
    isDeleted = false;
    isMediaFailed = false;
    isMediaQueued = false;
    latitude = 0;
    longitude = 0;
    this.objectId = objectId;
    photoHeight = 0;
    photoWidth = 0;
    videoHeight = 0;
    videoWidth = 0;
    text = "";
    type = 'audio';
    updatedAt = FieldValue.serverTimestamp();
    this.userFullname = userFullname;
    this.userId = userId;
    userInitials = userFullname?.split("")?.first ?? '';
    userPictureAt = 0;
    this.videoDuration = 0;
  }
  ChatMessage.fromLocation({
    @required String chatId,
    @required String objectId,
    @required String userId,
    @required String userFullname,
    @required double lat,
    @required double long,
  }) {
    this.audioDuration = 0;
    this.chatId = chatId;
    createdAt = FieldValue.serverTimestamp();
    isDeleted = false;
    isMediaFailed = false;
    isMediaQueued = false;
    latitude = lat;
    longitude = long;
    this.objectId = objectId;
    photoHeight = 0;
    photoWidth = 0;
    videoHeight = 0;
    videoWidth = 0;
    text = "Location message";
    type = '';
    updatedAt = FieldValue.serverTimestamp();
    this.userFullname = userFullname;
    this.userId = userId;
    userInitials = userFullname?.split("")?.first ?? '';
    userPictureAt = 0;
    this.videoDuration = 0;
  }
}

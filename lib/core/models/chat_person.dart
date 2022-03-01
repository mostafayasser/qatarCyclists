import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qatarcyclists/core/models/user.dart';

class ChatPerson {
  String country;
  FieldValue createdAt;
  String email;
  String firstname;
  String fullname;
  int keepMedia;
  FieldValue lastActive;
  FieldValue lastTerminate;
  String lastname;
  String location;
  String loginMethod;
  int networkAudio;
  int networkPhoto;
  int networkVideo;
  String objectId;
  String oneSignalId;
  String phone;
  FieldValue pictureAt;
  String status;
  FieldValue updatedAt;
  String wallpaper;

  ChatPerson(
      {this.country,
      this.createdAt,
      this.email,
      this.firstname,
      this.fullname,
      this.keepMedia,
      this.lastActive,
      this.lastTerminate,
      this.lastname,
      this.location,
      this.loginMethod,
      this.networkAudio,
      this.networkPhoto,
      this.networkVideo,
      this.objectId,
      this.oneSignalId,
      this.phone,
      this.pictureAt,
      this.status,
      this.updatedAt,
      this.wallpaper});

  ChatPerson.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    createdAt = json['createdAt'];
    email = json['email'];
    firstname = json['firstname'];
    fullname = json['fullname'];
    keepMedia = json['keepMedia'];
    lastActive = json['lastActive'];
    lastTerminate = json['lastTerminate'];
    lastname = json['lastname'];
    location = json['location'];
    loginMethod = json['loginMethod'];
    networkAudio = json['networkAudio'];
    networkPhoto = json['networkPhoto'];
    networkVideo = json['networkVideo'];
    objectId = json['objectId'];
    oneSignalId = json['oneSignalId'];
    phone = json['phone'];
    pictureAt = json['pictureAt'];
    status = json['status'];
    updatedAt = json['updatedAt'];
    wallpaper = json['wallpaper'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['createdAt'] = this.createdAt;
    data['email'] = this.email;
    data['firstname'] = this.firstname;
    data['fullname'] = this.fullname;
    data['keepMedia'] = this.keepMedia;
    data['lastActive'] = this.lastActive;
    data['lastTerminate'] = this.lastTerminate;
    data['lastname'] = this.lastname;
    data['location'] = this.location;
    data['loginMethod'] = this.loginMethod;
    data['networkAudio'] = this.networkAudio;
    data['networkPhoto'] = this.networkPhoto;
    data['networkVideo'] = this.networkVideo;
    data['objectId'] = this.objectId;
    data['oneSignalId'] = this.oneSignalId;
    data['phone'] = this.phone;
    data['pictureAt'] = this.pictureAt;
    data['status'] = this.status;
    data['updatedAt'] = this.updatedAt;
    data['wallpaper'] = this.wallpaper;
    return data;
  }

  ChatPerson.fromUser(User user, String uId) {
    country = 'Qatar';
    createdAt = FieldValue.serverTimestamp();
    email = user.email;
    firstname = user.name;
    fullname = user.name;
    keepMedia = 3;
    lastActive = FieldValue.serverTimestamp();
    lastTerminate = FieldValue.serverTimestamp();
    lastname = '';
    location = 'Qatar';
    loginMethod = 'Email';
    networkAudio = 3;
    networkPhoto = 3;
    networkVideo = 3;
    objectId = uId;
    oneSignalId = '';
    phone = user.mobile;
    pictureAt = FieldValue.serverTimestamp();
    status = "Available";
    updatedAt = FieldValue.serverTimestamp();
    wallpaper = '';
  }
}

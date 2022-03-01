class UserData {
  UserResponse response;

  UserData({this.response});

  UserData.fromJson(Map<String, dynamic> json) {
    response = json['Response'] != null
        ? new UserResponse.fromJson(json['Response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['Response'] = this.response.toJson();
    }
    return data;
  }
}

class UserResponse {
  bool status;
  UserResult result;
  String message;

  UserResponse({this.status, this.result, this.message});

  UserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    result =
        json['result'] != null ? new UserResult.fromJson(json['result']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class UserResult {
  User user;

  UserResult({this.user});

  UserResult.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String mobile;
  Null emailVerifiedAt;
  String type;
  int status;
  String deviceToken;
  String osType;
  String version;
  String language;
  String createdAt;
  String updatedAt;
  String token;
  String avatar;
  List<Null> media;

  User(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.emailVerifiedAt,
      this.type,
      this.status,
      this.deviceToken,
      this.osType,
      this.version,
      this.language,
      this.createdAt,
      this.updatedAt,
      this.token,
      this.avatar,
      this.media});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    emailVerifiedAt = json['email_verified_at'];
    type = json['type'];
    status = json['status'];
    deviceToken = json['device_token'] ?? "";
    osType = json['os_type'];
    version = json['version'] ?? "";
    language = json['language'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    token = json['token'];
    avatar = json['avatar'];
    if (json['media'] != null) {
      media = new List();
      json['media'].forEach((v) {});
    }
  }

  Map<String, dynamic> toJson({bool chat = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data[chat ? 'fullname' : 'name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['type'] = this.type;
    data['status'] = this.status;
    data['device_token'] = this.deviceToken;
    data['os_type'] = this.osType;
    data['version'] = this.version;
    data['language'] = this.language;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['token'] = this.token;
    data['avatar'] = this.avatar;
    if (this.media != null) {}
    return data;
  }
}

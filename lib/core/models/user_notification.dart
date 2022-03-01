class NotificationType {
  static const String attendance = 'attendance';
  static const String instalment = 'instalment';
  static const String purchaseRequest = 'purchaseRequest';
}

class UserNotification {
  int id;
  String createdAt;
  String notificationType;
  bool deleting = false;
  Map<String, dynamic> notificationData;

  UserNotification(
      {this.id, this.createdAt, this.notificationData, this.notificationType});

  UserNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    notificationData = json['notificationData'];
    notificationType = json['notificationType'];
  }
}

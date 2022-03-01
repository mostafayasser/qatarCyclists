import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/ui/pages/chat_pages/person_chat.dart';

import '../../../main.dart';
import '../../models/user_notification.dart';
import '../auth/authentication_service.dart';
import '../firebase/fire_store_service.dart';

import '../../../ui/widgets/notification_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

//inetiated at the app start to listen to notifications..
class NotificationService {
  NotificationService({this.auth});

  bool _isSettedUp = false;
  final AuthenticationService auth;
  List<UserNotification> userNotifications;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<void> init(context) async {
    final api = HttpApi(context);
    //_firebaseMessaging.requestNotificationPermissions();
    if (!_isSettedUp) {
      _isSettedUp = true;

      String token = await _firebaseMessaging.getToken();
      print("Firebase token : $token");
      await api.updateUserFcm(fcmToken: token, context: context);

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage : $message");
          operateMessage(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onRes : $message");
          try {
            navigatorKey.currentState.push(MaterialPageRoute(
                builder: (_) => PersonChatPage(
                      chatId: message["chatId"],
                      chatName: message["title"],
                      person: message["group"] == "false",
                    )));
            print("onResume : $message");
          } catch (e) {
            print(e);
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          try {
            navigatorKey.currentState.push(MaterialPageRoute(
                builder: (_) => PersonChatPage(
                      chatId: message["data"]["chatId"],
                      chatName: message["data"]["title"],
                      person: message["data"]["group"] == "false",
                    )));
            print("onResume : $message");
          } catch (e) {
            print(e);
          }
        },
      );

      await _firebaseMessaging.getToken().then(updateToken);
    }
  }

  Future<void> updateToken(token) async {
    if (token != null) {
      try {
        /* auth.updateUserFcm(fcmToken: token);
        Preference.setString(PrefKeys.fcmToken, token); */
        FireStoreService.updateFCMToken(token);

        print('new fcm:$token');
      } catch (e) {
        print('error updating fcm');
      }
    }
  }

  Future handleNotification(context) async {
    // User user;
    // user = Provider.of<UserProvider>(context, listen: false).user;
    // List<NotificationItem> items = await Api.instance.getNotifications(page: 1, userID: user.id, token: user.accessToken, length: 100);
    // for (NotificationItem item in items) {
    //   NotificationItem temp = await DB.notificationItemDAO.findItemByID(item.id);
    //   if (temp == null) {
    //     await DB.notificationItemDAO.insertItem(item..isSeen = false);
    //   }
    // }
  }

  operateMessage(Map<String, dynamic> message,
      {bool showOverlay = true}) async {
    String body;
    String title;
    /* Map<dynamic, dynamic> data;
    final deviceInfo = DeviceInfoPlugin(); */

    /* if (Platform.isIOS &&
        int.parse((await deviceInfo.iosInfo).systemVersion.split('.')[0]) <
            13) {
      final messageData = message['aps']['alert'];
      title = messageData['title'];
      body = messageData['body'];
      data = message['data'];
    } else { */
    // final messageData = message['notification'];
    title = message['title'];
    body = message['body'];
    //data = message['data'];
    //}
    /* Preference.setInt(PrefKeys.newestNotificationId,
        (Preference.getInt(PrefKeys.newestNotificationId) ?? 0) + 1); */
    if (showOverlay) {
      showOverlayNotification((context) {
        // final theme = Provider.of<ThemeProvider>(context);
        // theme.setState();
        return Notify(title: title, body: body, data: message);
      }, duration: Duration(seconds: 4));
    }

    // try {
    //   final notificationItem = NotificationItem.fromJson(message['data']);
    //   if (notificationItem.offerId != null) navigateToOffer(notificationItem.offerId);
    // } catch (e) {
    //   print('\n\n operateMessage ERROR:' + e.toString() + '\n\n');
    // }
  }
}

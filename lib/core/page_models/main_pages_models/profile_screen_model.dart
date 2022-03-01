import 'dart:io';

import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/widgets/dialog.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/services/api/http_api.dart';
import '../../../core/services/auth/authentication_service.dart';
import '../../../ui/routes/routes.dart';

class ProfileScreenModel extends BaseNotifier {
  AuthenticationService auth;
  HttpApi api;
  AppLocalizations local;

  String image;
  String name;
  String email;
  bool isInit = false;

  File choosedImage;
  int radioValue = 1;

  ProfileScreenModel({this.auth, this.api, this.local}) {
    isInit = true;
  }

  Future<void> initializeProfileData() async {
    final user = auth.user;
    if (user == null) {
      isInit = false;
      notifyListeners();
      return;
    }
    name = user.name;
    email = user.email;
    image = user.avatar;
    isInit = false;
    notifyListeners();
  }

  logout(BuildContext context) async {
    if (!busy) {
      setBusy();

      try {
        await auth.signOut;
        if (auth.user != null) {
          CustomDialog(title: local.get('failed'), msg: "something's wrong happened");
        } else {
          UI.pushReplaceAll(context, Routes.splash);
        }
      } catch (e) {
        Logger().e(e);
      }
    }
  }

  openMyRides(BuildContext context) {
    UI.push(context, Routes.myRides);
  }

  openMyEvents(BuildContext context) {
    UI.push(context, Routes.myEvents);
  }

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile == null) {
      return;
    }
    setBusy();
    choosedImage = File(pickedFile.path);
    if (choosedImage != null) {
      final hasUpdated = await auth.updateProfileImage(image: choosedImage);
      if (!hasUpdated) {
        CustomDialog(title: local.get('failed'), msg: "Something wents wrong");
      } else {
        print("updated");
      }
    }
    await initializeProfileData();
    setIdle();
  }
}

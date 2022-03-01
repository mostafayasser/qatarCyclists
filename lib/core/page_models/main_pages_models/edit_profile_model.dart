import 'dart:io';

import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qatarcyclists/ui/widgets/dialog.dart';

import '../../../core/services/auth/authentication_service.dart';
import '../../services/localization/localization.dart';
import '../../utils/validator.dart';

class EditProfileModel extends BaseNotifier with Validator {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthenticationService auth;
  AppLocalizations local;
  bool isInit = false;

  String profileImage;
  File choosedImage;
  bool changeImage = false;
  // int radioValue = 1;

  EditProfileModel({this.auth, this.local}) {
    isInit = true;
  }

  Future<void> initializeProfileData() async {
    final user = auth.user;
    if (user == null) {
      isInit = false;
      notifyListeners();
      return;
    }
    fullName.text = user.name;
    email.text = user.email;
    profileImage = user.avatar;
    mobile.text = user.mobile;
    isInit = false;
    notifyListeners();
  }

  /// update user info
  /// if update success back to profile page
  Future<void> editProfile(BuildContext context, bool changeIamge) async {
    final isValid = formKey.currentState.validate();

    // Check if all fields is valid
    if (!isValid) {
      return;
    } else if (password.text != null &&
        password.text.isNotEmpty &&
        password.text != confirmPassword.text) {
      // check if two passwords is same
      showDialog(
        context: context,
        builder: (context) =>
            CustomDialog(title: local.get('failed'), msg: "Two passwords don't match"),
      );
    } else if (password.text != null && password.text.isNotEmpty && password.text.length < 8) {
      // check if password > 8 char
      showDialog(
        context: context,
        builder: (context) => CustomDialog(
            title: local.get('failed'), msg: "Password must be at least 8 characters."),
      );
    } else {
      // if all fields is valid try to update image & info.
      setBusy();
      if (changeImage) {
        // update profile image.
        if (choosedImage != null) {
          final hasUpdated = await auth.updateProfileImage(image: choosedImage);
          if (hasUpdated) {
            print("start");
            final success = await updateProfileInfo(context);
            success
                ? Navigator.of(context).pop()
                : CustomDialog(title: local.get('failed'), msg: "Something wents wrong");
          } else {
            CustomDialog(title: local.get('failed'), msg: "Something wents wrong");
          }
        }
      } else {
        final success = await updateProfileInfo(context);
        success
            ? Navigator.of(context).pop()
            : CustomDialog(title: local.get('failed'), msg: "Something wents wrong");
      }
    }
    setIdle();
  }

  Future<bool> updateProfileInfo(BuildContext context) async {
    await auth.updateUserProfile(
      fullName: fullName.text,
      email: email.text,
      mobile: mobile.text,
      password: password.text,
    );
    // if update fail
    if (auth.user == null) {
      return false;
      // if update success
    } else {
      return true;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile == null) {
      return;
    }
    choosedImage = File(pickedFile.path);
    changeImage = true;
    notifyListeners();
  }
}

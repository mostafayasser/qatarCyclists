import 'dart:convert';
import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/models/user.dart';
import '../../../ui/routes/routes.dart';
import '../preference/preference.dart';

class AuthenticationService extends ChangeNotifier {
  final HttpApi api;

  User _user;
  User get user => _user;

  AuthenticationService({this.api}) {
    loadUser;
  }

  /*
  * Sign up user 
  */
  Future<void> signUp(
      {String fullName, String email, String mobile, String password}) async {
    try {
      _user = await api.signUp(
          email: email, password: password, fullName: fullName, mobile: mobile);
      if (_user != null) {
        // Logger().i(_user.toJson());
        saveUser(user: _user);
        saveUserToken(token: _user.token);
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  /*
   * authenticate user by his phone number and password
   */
  Future<void> login(
      {@required String email,
      @required String password,
      String macAddress}) async {
    try {
      _user = await api.signIn(email: email, password: password);

      if (_user != null) {
        // Logger().i(_user.toJson());
        FireStoreService.userPersonId = _user.id.toString();
        saveUser(user: _user);
        saveUserToken(token: _user.token);
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  /*
   * Update user profile info
   */
  Future<void> updateUserProfile({
    @required String fullName,
    @required String email,
    @required String mobile,
    String password,
  }) async {
    try {
      print("update");
      _user = await api.updateUserProfileInfo(
          fullName: fullName, email: email, mobile: mobile, password: password);

      if (_user != null) {
        Logger().i(_user.toJson());
        saveUser(user: _user);
        notifyListeners();
      }
    } catch (e) {
      Logger().e(e);
    }
  }

/*
   * Update user profile image
   */
  Future<bool> updateProfileImage({File image}) async {
    try {
      final user = await api.updateProfileImage(image: image);
      if (user == null) {
        return false;
      } else {
        _user = user;

        saveUser(user: user);
        notifyListeners();
      }
      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  /*
   *update the user current fcmToken in the server
   */
  Future<bool> updateUserFcm({@required String fcmToken}) async {
    if (userLoged) {
      return await api.updateUserFcm(fcmToken: fcmToken);
    }
    return false;
  }

  /*
   * change authenticated user password
   * return false if not authenticated
   */
  Future<bool> changeUserPassword(
      {@required BuildContext context,
      @required String oldPassword,
      @required String newPassword}) async {
    if (user != null) {
      return false;
      // return await api.changePassword(context: context, phone: _user.username, oldPassword: oldPassword, newPassword: newPassword, token: _user.token);
    } else {
      return null;
    }
  }

  /*
   *check if user is authenticated 
   */
  bool get userLoged => Preference.getBool(PrefKeys.userLogged) ?? false;

  /*
   *save user in shared prefrences 
   */
  saveUser({User user}) {
    Preference.setBool(PrefKeys.userLogged, true);
    Preference.setString(PrefKeys.userData, json.encode(user.toJson()));
  }

  /*
   *save user token in shared prefrences 
   */
  saveUserToken({String token}) {
    Preference.setString(PrefKeys.token, token);
  }

  /*
   * load the user info from shared prefrence if existed to be used in the service   
   */
  Future<void> get loadUser async {
    if (userLoged) {
      _user =
          User.fromJson(json.decode(Preference.getString(PrefKeys.userData)));
      Logger().i(_user.toJson());
      print('\n\n\n\n');
    }
  }

  /*
   * refresh the user access token and update it in shared prefrence   
   */
  Future<bool> get refreshToken async => await api.refreshToken();

  /*
   * signout the user from the app and return to the login screen   
   */
  Future<void> get signOut async {
    await Preference.remove(PrefKeys.userData);
    await Preference.remove(PrefKeys.userLogged);
    await Preference.remove(PrefKeys.fcmToken);
    await Preference.remove(PrefKeys.token);

    // await FirebaseAuth.instance.signOut();

    _user = null;
  }

  static handleAuthExpired({@required BuildContext context}) async {
    if (context != null) {
      try {
        await Preference.clear();

        UI.pushReplaceAll(context, Routes.splash);

        Logger().v('🦄session destroyed🦄');
      } catch (e) {
        Logger().v('🦄error while destroying session $e🦄');
      }
    }
  }
}

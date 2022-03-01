import 'package:base_notifier/base_notifier.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/core/utils/validator.dart';
import 'package:qatarcyclists/ui/widgets/dialog.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../ui/routes/routes.dart';

class SignInModel extends BaseNotifier with Validator {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> signIn(BuildContext context) async {
    final local = AppLocalizations.of(context);
    setBusy();

    final isValid = formKey.currentState.validate();
    if (!isValid) {
      setIdle();
      return;
    } else {
      // try to login
      final auth = Provider.of<AuthenticationService>(context, listen: false);
      await auth.login(email: userName.text, password: password.text);

      // if login fail
      if (auth.user == null) {
        CustomDialog(title: local.get('failed'), msg: '');
        setIdle();
        UI.toast('username or password incorrect');
        return;
      } else {
        // if login success

        // var fireUser = await FireAuthService().signInWithEmailAndPassword(
        //     email: userName.text, password: password.text);

        // if (fireUser == null) {
        //   fireUser = await FireAuthService().registerWithEmailAndPassword(
        //       user: auth.user, email: userName.text, password: password.text);
        // }

        // FireStoreService.userPersonId =
        //     (await FirebaseAuth.instance.currentUser()).uid;

        //   if (fireUser == null || FireStoreService.userPersonId == null) {
        //     auth.signOut;
        //   //  await FirebaseAuth.instance.signOut();
        //     CustomDialog(title: local.get('failed'), msg: '');
        //     setIdle();
        //     return;
        //   }
        //   setIdle();
        //   await Provider.of<NotificationService>(context, listen: false)
        //       .init(context);
        UI.pushReplaceAll(context, Routes.homePageScreen);
      }
    }
  }

  signUp(BuildContext context) {
    UI.push(context, Routes.signUp);
  }

  void changeLanguage(Locale locale, BuildContext context) {
    Provider.of<AppLanguageModel>(context, listen: false)
        .changeLanguage(locale);
  }

  skipLogin(BuildContext context) {
    UI.push(context, Routes.homePageScreen);
  }
}

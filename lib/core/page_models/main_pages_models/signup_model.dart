import 'package:base_notifier/base_notifier.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/core/services/notification/notification_service.dart';
import 'package:qatarcyclists/core/utils/validator.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/widgets/dialog.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../services/auth/authentication_service.dart';
import '../../services/localization/localization.dart';

class SignUpModel extends BaseNotifier with Validator {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController retype_password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> onSubmit(BuildContext context) async {
    final locale = AppLocalizations.of(context);
    final local = AppLocalizations.of(context);
    setBusy();

    final isValid = formKey.currentState.validate();
    if (!isValid) {
      setIdle();
      return;
    } else {
      if (password.text == retype_password.text) {
        // try to signup
        final auth = Provider.of<AuthenticationService>(context, listen: false);

        try {
          await auth.signUp(
            email: email.text,
            mobile: mobile.text,
            password: password.text,
            fullName: fullName.text,
          );

          // await FireAuthService().registerWithEmailAndPassword(
          //     user: auth.user, email: email.text, password: password.text);
          // FireStoreService.userPersonId =
          //     (await FirebaseAuth.instance.currentUser()).uid;
        } catch (e) {}

        // if signup fail
        if (auth.user == null || FireStoreService.userPersonId == null) {
          // await FirebaseAuth.instance.signOut();
          await auth.signOut;

          CustomDialog(title: local.get('failed'), msg: '');
          setIdle();

          return;
        } else {
          // if signup success
          CustomDialog(
            //dismissible: true,

            title: local.get('Request sent'),
            msg: local.get('Signed up successfuly') ?? 'Signed up successfuly',
          );
          setIdle();
          FireStoreService.userPersonId = auth.user.id.toString();
          await FireStoreService.createNewUser(auth.user);
          await Provider.of<NotificationService>(context, listen: false)
              .init(context);
          UI.pushReplaceAll(context, Routes.homePageScreen);
        }
      } else {
        UI.toast(
            locale.get("Password does not match") ?? "Password does not match");

        setIdle();
      }
    }
  }
}

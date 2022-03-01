import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/core/utils/validator.dart';
import 'package:qatarcyclists/ui/widgets/buttons/normal_button.dart';
import 'package:qatarcyclists/ui/widgets/custom_text_form_field.dart';
import 'package:qatarcyclists/ui/widgets/dialog.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:ui_utils/ui_utils.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<ForgotPasswordPageModel>(
            model: ForgotPasswordPageModel(
              api: Provider.of(context),
              auth: Provider.of(context),
            ),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildHeader(context),
                    // Change language button and text.

                    _buildForm(model, context),
                    _buildSubmitButton(model, context),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          HeaderColor(hasTitle: false),
          SizedBox(height: ScreenUtil.screenHeightDp * 0.02),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildForm(ForgotPasswordPageModel model, BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: ScreenUtil.screenHeightDp * 0.02,
          horizontal: ScreenUtil.screenWidthDp * .06),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffffffff),
        border: Border.all(width: 1.0, color: const Color(0xffd9d8d8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffe7eaf0),
            offset: Offset(0, 8),
            blurRadius: 15,
          ),
        ],
      ),
      child: Form(
        key: model.formKey,
        child: Column(
          children: <Widget>[
            CustomTextFormField(
              controller: model.userName,
              hint: locale.get('EMAIL') ?? 'EMAIL',
              keyboardType: TextInputType.emailAddress,
              icon: Image.asset('assets/images/@.png', height: 27.0),
              validator: (value) => model.userNameValidator(value, context),
            ),
          ],
        ),
      ),
    );
  }

  NormalButton _buildSubmitButton(
      ForgotPasswordPageModel model, BuildContext context) {
    return NormalButton(
      text: 'Reset password',
      gradient: null,
      onPressed: () => model.reset(context),
      busy: model.busy,
    );
  }
}

class ForgotPasswordPageModel extends BaseNotifier with Validator {
  final HttpApi api;
  final AuthenticationService auth;

  ForgotPasswordPageModel({NotifierState state, this.api, this.auth})
      : super(state: state);

  TextEditingController userName = TextEditingController();

  final formKey = GlobalKey<FormState>();

  reset(context) async {
    final locale = AppLocalizations.of(context);

    setBusy();

    final isValid = formKey.currentState.validate();
    if (!isValid) {
      setIdle();
      return;
    } else {
      bool done = await api.forgotPassword(email: userName.text);
      if (done == null) {
        CustomDialog(
          title: "",
          msg: locale.get('Server error please try again later') ??
              'Server error please try again later',
        );
      } else if (done) {
        CustomDialog(
          title: "",
          msg: locale.get('A reset link has been sent to your email') ??
              'A reset link has been sent to your email',
        );
      } else {
        CustomDialog(
          title: "",
          msg: locale.get('Email is not correct') ?? 'Email is not correct',
        );
      }
    }
    setIdle();
  }
}

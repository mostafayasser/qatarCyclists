import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/pages/main_pages/forgot_password_page.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/page_models/main_pages_models/signin_model.dart';
import '../../widgets/buttons/normal_button.dart';
import '../../widgets/buttons/switch_language_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/header_color.dart';
import '../../widgets/password_text_form_field.dart';

class SigninScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<SignInModel>(
        model: SignInModel(),
        builder: (context, model, _) {
          return FocusWidget(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    // Header color and logo
                    _buildHeader(context),
                    // Change language button and text.
                    _buildLanguageButton(model, context),
                    _buildSignInForm(model, context),
                    _buildSubmitButton(model, context),
                    _createAccountText(model, context),
                    _buildSkipSignInButton(model, context),
                  ],
                ),
              ),
            ),
          );
        });
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

  Container _buildSignInForm(SignInModel model, BuildContext context) {
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
            Divider(
              color: const Color(0xffd9d8d8),
              thickness: 0.5,
              height: 0,
            ),
            PasswordTextFormFiled(
              controller: model.password,
              hint: locale.get('PASSWORD') ?? 'PASSWORD',
              secure: true,
              icon: Image.asset(
                'assets/images/password.png',
                height: 28.0,
              ),
              validator: (value) => model.passwordValidator(value, context),
            ),
          ],
        ),
      ),
    );
  }

  NormalButton _buildSubmitButton(SignInModel model, BuildContext context) {
    return NormalButton(
      text: 'SIGN IN',
      gradient: null,
      onPressed: () => model.signIn(context),
      busy: model.busy,
    );
  }

  Column _createAccountText(SignInModel model, BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Column(
      children: <Widget>[
        Text(
          locale.get('Don’t have an account?') ?? 'Don’t have an account?',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: const Color(0xff515c6f),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _textButton(locale.get('Sign up'), () => model.signUp(context)),
            Padding(
              padding: const EdgeInsets.only(left: 3.0, right: 3),
              child: Text(locale.get('or'),
                  style: TextStyle(
                      color: const Color(0xff515c6f),
                      fontWeight: FontWeight.w300)),
            ),
            _textButton(locale.get('Forgot Password?'), () {
              UI.push(context, ForgotPasswordPage());
            }),
          ],
        ),
      ],
    );
  }

  GestureDetector _textButton(String title, Function onTab) {
    return GestureDetector(
      onTap: onTab,
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.secondaryText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Padding _buildSkipSignInButton(SignInModel model, BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: GestureDetector(
        onTap: () => model.skipLogin(context),
        child: Text(
          locale.get('SKIP SIGN IN') ?? 'SKIP SIGN IN',
          style: TextStyle(
            fontFamily: 'Neusa Next Std',
            fontSize: 13,
            color: AppColors.accentText,
            letterSpacing: 0.72,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Column _buildLanguageButton(SignInModel model, BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchLanguageButton(),
        SizedBox(height: ScreenUtil.screenHeightDp * 0.02),
        Text(AppLocalizations.of(context).get('SIGN IN')),
      ],
    );
  }
}

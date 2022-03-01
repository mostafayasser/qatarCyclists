import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';

import '../../../core/page_models/main_pages_models/signup_model.dart';
import '../../widgets/buttons/normal_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/header_color.dart';
import '../../widgets/password_text_form_field.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<SignUpModel>(
        model: SignUpModel(),
        builder: (context, model, _) {
          return Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  // Header color and logo
                  buildHeader(context),
                  buildSignupForm(model, context),
                  buildProceedButton(model, context),
                  privacyText(context),
                  SizedBox(height: 20.0),
                  Text(
                    'Sponsored by: WebZone technologies',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      color: const Color(0xff788293),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Text privacyText(context) {
    final locale = AppLocalizations.of(context);

    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: const Color(0xff515c6f),
        ),
        children: [
          TextSpan(
            text: locale.get('By creating an account, you agree to our ') ??
                'By creating an account, you agree to our ' + ' ',
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          TextSpan(
            text: locale.get('Terms of Service') ?? 'Terms of Service' + ' ',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: locale.get('or') ?? 'or' + ' ',
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          TextSpan(
            text: locale.get('Privacy Policy') ?? 'Privacy Policy',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Container buildHeader(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          HeaderColor(),
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

  Container buildSignupForm(SignUpModel model, BuildContext context) {
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
        autovalidate: true,
        child: Column(
          children: <Widget>[
            CustomTextFormField(
              controller: model.fullName,
              hint: locale.get('Full Name') ?? 'Full Name',
              icon: Image.asset(
                'assets/images/profile_bar.png',
                height: 24.0,
                color: Color(0xff727C8E),
              ),
              validator: (value) => model.namelValidator(value, context),
            ),
            Divider(
              color: const Color(0xffd9d8d8),
              thickness: 0.5,
              height: 0,
            ),
            CustomTextFormField(
              controller: model.email,
              hint: locale.get('EMAIL') ?? 'EMAIL',
              keyboardType: TextInputType.emailAddress,
              icon: Image.asset(
                'assets/images/@.png',
                height: 27.0,
              ),
              validator: (value) => model.emailValidator(value, context),
            ),
            Divider(
              color: const Color(0xffd9d8d8),
              height: 0,
              thickness: 0.5,
            ),
            CustomTextFormField(
              hint: locale.get('MOBILE NUMBER') ?? 'MOBILE NUMBER',
              controller: model.mobile,
              icon: Icon(Icons.phone_in_talk),
              keyboardType: TextInputType.phone,
              validator: (value) => model.mobileValidator(value, context),
            ),
            Divider(
              color: const Color(0xffd9d8d8),
              height: 8,
              thickness: 0.5,
            ),
            PasswordTextFormFiled(
              controller: model.password,
              hint: locale.get('PASSWORD') ?? 'PASSWORD',
              secure: true,
              icon: Image.asset(
                'assets/images/password.png',
                height: 25.0,
              ),
              validator: (value) => model.passwordValidator(value, context),
            ),
            Divider(
              color: const Color(0xffd9d8d8),
              height: 8,
              thickness: 0.5,
            ),
            PasswordTextFormFiled(
              controller: model.retype_password,
              hint: locale.get('RETYPE_PASSWORD') ?? 'RETYPE_PASSWORD',
              secure: true,
              icon: Image.asset(
                'assets/images/password.png',
                height: 25.0,
              ),
              validator: (value) => model.passwordValidator(value, context),
            ),
          ],
        ),
      ),
    );
  }

  buildProceedButton(SignUpModel model, BuildContext context) {
    return NormalButton(
      localize: true,
      text: 'PROCEED TO SIGNUP',
      gradient: null,
      onPressed: () => model.onSubmit(context),
      busy: model.busy,
    );
  }
}

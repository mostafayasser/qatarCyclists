import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/core/utils/validator.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/buttons/normal_button.dart';
import 'package:qatarcyclists/ui/widgets/custom_text_form_field.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:ui_utils/ui_utils.dart';

class JoinRidePage extends StatelessWidget {
  final EventData eventData;

  const JoinRidePage({Key key, this.eventData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<JoinRidePageModel>(
            model: JoinRidePageModel(
                api: Provider.of(context),
                auth: Provider.of(context),
                eventData: eventData),
            builder: (context, model, child) {
              return Column(children: <Widget>[
                // Header color and logo
                buildHeader(context),
                Expanded(
                  child: CustomAnimatedCrossFade(
                    fisrt: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: ScreenUtil.screenHeightDp * 0.02),
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    const AssetImage('assets/images/logo.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          buildSignupForm(model, context),
                          privacyText(model),
                          buildProceedButton(model, context),
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
                    secound: buildSucessAlert(context),
                    isCenter: true,
                    showFirst: !model.success,
                  ),
                ),
              ]);
            }),
      ),
    );
  }

  Widget privacyText(JoinRidePageModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            onChanged: (agree) => model.switchAgree(agree),
            value: model.agree,
            activeColor: AppColors.secondaryText),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xff515c6f),
            ),
            children: [
              TextSpan(
                text: 'By checking box, I agree to the full\n',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: 'Terms and Conditions',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: ' and ',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return HeaderColor(
      title: locale.get('Register for this event') ?? 'Register for this event',
      hasBack: true,
      hasTitle: true,
    );
  }

  Container buildSignupForm(JoinRidePageModel model, BuildContext context) {
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
              hint: 'Full Name',
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
              hint: 'EMAIL',
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
              hint: 'MOBILE NUMBER',
              controller: model.mobile,
              icon: Icon(Icons.phone_in_talk),
              keyboardType: TextInputType.phone,
              validator: (value) => model.mobileValidator(value, context),
            ),
          ],
        ),
      ),
    );
  }

  buildProceedButton(JoinRidePageModel model, BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        NormalButton(
          localize: false,
          color: Colors.grey,
          showArrow: false,
          text: locale.get('CANCEL') ?? 'CANCEL',
          width: ScreenUtil.screenWidthDp / 2.5,
          gradient: null,
          onPressed: () => Navigator.pop(context),
          busy: model.busy,
        ),
        NormalButton(
          localize: false,
          width: ScreenUtil.screenWidthDp / 2.5,
          text: locale.get('JOIN') ?? 'JOIN',
          gradient: null,
          onPressed: () => model.onSubmit(context),
          busy: model.busy,
        ),
      ],
    );
  }

  buildSucessAlert(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 35, horizontal: 50),
      decoration: BoxDecoration(
          color: Color(0xFFFFC100), borderRadius: BorderRadius.circular(25)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 60,
            child: Icon(
              Icons.check,
              color: AppColors.primaryElement,
              size: 65,
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              AppLocalizations.of(context)
                  .get('You have successfully registered for this event'),
              maxLines: 3,
              style: TextStyle(
                  color: AppColors.primaryElement,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class JoinRidePageModel extends BaseNotifier with Validator {
  final HttpApi api;
  final AuthenticationService auth;
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // bool trainingSessoing;
  bool agree = false;
  bool success = false;
  final EventData eventData;

  JoinRidePageModel({this.eventData, this.api, this.auth}) {
    // trainingSessoing=eventData.type
    fullName.text = auth.user.name;
    email.text = auth.user.email;
    mobile.text = auth.user.mobile;
  }

  onSubmit(BuildContext context) async {
    final locale = AppLocalizations.of(context);
    String msg = '';
    var registered = false;

    if (formKey.currentState.validate() && agree) {
      try {
        registered = await api.joinRide(
            eventId: eventData.id,
            email: email.text,
            mobile: mobile.text,
            name: fullName.text);

        if (registered == null) {
          msg = locale.get('invalid data, try again');
        } else {
          msg = locale.get(registered ? 'registered' : 'Already registered');
        }
      } catch (e) {
        msg = locale.get('failed');
        UI.toast(msg);
      }
      if (registered != null && registered) {
        successAlert(context, registered);
      } else {
        UI.toast(msg);

        if (mounted) Navigator.pop(context, registered);
      }
    } else {
      msg = locale.get('invalid data, try again');
      UI.toast(msg);
    }
  }

  void successAlert(BuildContext context, bool registered) async {
    success = true;
    setState();
    await Future.delayed(Duration(milliseconds: 3000));
    if (mounted) Navigator.pop(context, registered);
  }

  switchAgree(bool agree) {
    this.agree = agree;
    setState();
  }
}

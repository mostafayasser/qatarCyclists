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

class RegisterTrainingPage extends StatelessWidget {
  final EventData eventData;

  const RegisterTrainingPage({Key key, this.eventData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<RegisterTrainingPageModel>(
            model: RegisterTrainingPageModel(
                api: Provider.of(context),
                auth: Provider.of(context),
                eventData: eventData),
            builder: (context, model, child) {
              return Column(
                children: <Widget>[
                  // Header color and logo
                  buildHeader(context),
                  Expanded(
                      child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: CustomAnimatedCrossFade(
                      fisrt: Column(
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
                      secound: buildSucessAlert(context),
                      isCenter: true,
                      showFirst: !model.success,
                    ),
                  ))
                ],
              );
            }),
      ),
    );
  }

  Widget privacyText(RegisterTrainingPageModel model) {
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
      title: locale.get('Register for this training') ??
          'Register for this training',
      hasBack: true,
      hasTitle: true,
    );
  }

  Container buildSignupForm(
      RegisterTrainingPageModel model, BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Do you need a Bicycle?'),
                  Checkbox(
                      onChanged: (need) => model.switchNeedBicycle(need),
                      value: model.needbycicle,
                      activeColor: AppColors.secondaryText),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(locale.get('Gender') ?? 'Gender'),
                  SizedBox(width: 7),
                  DropdownButton<String>(
                    value: model.gender,
                    items: <String>['male', 'female']
                        .map((String gender) => DropdownMenuItem<String>(
                            value: gender, child: Text(gender)))
                        .toList(),
                    onChanged: (gender) => model.setGender(gender),
                  ),

                  //
                  SizedBox(width: 7),
                  Text(locale.get('Height') ?? 'Height'),
                  SizedBox(width: 7),

                  Container(
                    width: ScreenUtil.screenWidthDp / 4,
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton(
                        isExpanded: true,
                        value: model.height,
                        items: model.heights
                            .map((e) =>
                                DropdownMenuItem(child: Text(e), value: e))
                            .toList(),
                        onChanged: model.changeHeight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildProceedButton(RegisterTrainingPageModel model, BuildContext context) {
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
          text: locale.get('REGISTER') ?? 'REGISTER',
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

class RegisterTrainingPageModel extends BaseNotifier with Validator {
  final HttpApi api;
  final AuthenticationService auth;

  String gender = 'male';
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  String height;
  List<String> heights =
      List<String>.generate(91, (int index) => '${index + 130}');
  TextEditingController fullName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool success = false;

  bool agree = false;
  bool needbycicle = false;
  final EventData eventData;

  RegisterTrainingPageModel(
      {this.eventData, NotifierState state, this.api, this.auth})
      : super(state: state) {
    fullName.text = auth.user.name;
    email.text = auth.user.email;
    mobile.text = auth.user.mobile;
  }

  changeHeight(value) {
    height = value;
    notifyListeners();
  }

  onSubmit(BuildContext context) async {
    final locale = AppLocalizations.of(context);
    String msg = '';
    var registered;

    if (formKey.currentState.validate() && agree) {
      try {
        registered = await api.registerTraining(
            trainingId: eventData.id,
            email: email.text,
            mobile: mobile.text,
            name: fullName.text,
            needCycle: needbycicle,
            gender: gender,
            height: height);

        if (registered == null) {
          msg = locale.get('invalid data, try again');
        } else {
          msg = locale.get(registered ? 'registered' : 'Already registered');
        }
      } catch (e) {
        msg = locale.get('failed');
        UI.toast(msg);
      }
    } else {
      msg = locale.get('invalid data, try again');
      UI.toast(msg);
    }

    if (registered != null && registered) {
      successAlert(context, registered);
    } else {
      UI.toast(msg);

      if (mounted) Navigator.pop(context, registered);
    }
  }

  switchAgree(bool agree) {
    this.agree = agree;
    setState();
  }

  switchNeedBicycle(bool need) {
    this.needbycicle = need;
    setState();
  }

  void successAlert(BuildContext context, bool registered) async {
    success = true;
    setState();
    await Future.delayed(Duration(milliseconds: 3000));
    if (mounted) Navigator.pop(context, registered);
  }

  setGender(String gender) {
    this.gender = gender;
    setState();
  }
}

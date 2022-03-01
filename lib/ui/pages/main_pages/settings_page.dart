import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/pages/main_pages/about_us_page.dart';
import 'package:qatarcyclists/ui/pages/main_pages/contact_us_page.dart';
import 'package:qatarcyclists/ui/pages/main_pages/terms_and_conditions_page.dart';
import 'package:qatarcyclists/ui/styles/styles.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../widgets/header_color.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BaseWidget<SettingsScreenModel>(
            model: SettingsScreenModel(
              api: Provider.of(context),
              auth: Provider.of(context),
              local: AppLocalizations.of(context),
            ),
            builder: (context, model, _) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    // app bar.
                    buildHeaderColor(context),

                    // My events & my products
                    buildBody(context, model),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Container buildLoadingScreen(context) {
    return Container(
      width: ScreenUtil.screenWidthDp,
      height: ScreenUtil.screenHeightDp,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              buildHeaderColor(context),
            ],
          ),
          Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  // Header color & icon.
  HeaderColor buildHeaderColor(context) {
    final locale = AppLocalizations.of(context);

    return HeaderColor(
      hasTitle: true,
      hasBack: true,
      title: locale.get('Settings') ?? 'Settings',
      titleImage: 'settings.png',
      titleImageColor: AppColors.accentElement,
    );
  }

  Column buildBody(BuildContext context, SettingsScreenModel model) {
    final locale = AppLocalizations.of(context);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil.screenWidthDp * 0.05,
              vertical: ScreenUtil.screenHeightDp * 0.02),
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil.screenWidthDp * 0.05,
              vertical: ScreenUtil.screenHeightDp * 0.02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffe7eaf0),
                offset: Offset(0, 8),
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              _buildRowItem(
                  'settings_notification.png',
                  locale.get('Notification Settings') ??
                      'Notification Settings',
                  false,
                  notification: true),
              Divider(),
              _buildRowItem(
                  'settings_privacy.png',
                  locale.get('Terms and Conditions') ?? 'Terms and Conditions',
                  false,
                  onTap: () => UI.push(context, TermsAndConditionsPage())),
              Divider(),
              _buildRowItem('settings_faq.png',
                  locale.get('About Us') ?? 'About Us', false,
                  onTap: () => UI.push(context, AboutUsPage())),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil.screenWidthDp * 0.05,
              vertical: ScreenUtil.screenHeightDp * 0.02),
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil.screenWidthDp * 0.05,
              vertical: ScreenUtil.screenHeightDp * 0.02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: const Color(0xffe7eaf0),
                offset: Offset(0, 8),
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              /* _buildRowItem('settings_rate.png',
                  locale.get('Rate Our App') ?? 'Rate Our App', true,
                  onTap: () => model.launchURL(context)),
              Divider(), */
              _buildRowItem('settings_contract.png',
                  locale.get('Contact Us') ?? 'Contact Us', true,
                  onTap: () => UI.push(context, ContactUsPage())),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRowItem(String imagePath, String title, bool hasIcon,
      {Function onTap, bool notification}) {
    return Material(
      child: InkWell(
        hoverColor: Colors.black,
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3),
          child: Row(
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.centerStart,
                width: 40,
                child: Image.asset(
                  'assets/images/$imagePath',
                  height: 20,
                ),
              ),
              SizedBox(width: ScreenUtil.screenWidthDp * 0.02),
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xff788293),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              if (hasIcon)
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: const Color(0xffE6E6E6),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.0,
                    color: const Color(0xff727C8E),
                  ),
                ),
              if (notification ?? false)
                ToggleNotificationButton(
                  height: 25,
                  width: 80,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreenModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final AppLocalizations local;
  bool notificationOff = true;
  SettingsScreenModel({NotifierState state, this.api, this.auth, this.local})
      : super(state: state);

  toggleNotification() {
    notificationOff = !notificationOff;
    notifyListeners();
  }

  launchURL(BuildContext context) async {
    final locale = AppLocalizations.of(context);

    UI.toast(locale.get('soon'));
    // const url = 'https://www.google.com';
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }
}

class ToggleNotificationButton extends StatelessWidget {
  final double width;
  final double height;

  ToggleNotificationButton({this.width = 90, this.height = 30});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Consumer<SettingsScreenModel>(builder: (context, settingsModel, _) {
      return Container(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () => settingsModel.toggleNotification(),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  decoration: BoxDecoration(
                    color: !settingsModel.notificationOff
                        ? AppColors.primaryElement
                        : Colors.white,
                    border:
                        Border.all(color: AppColors.primaryElement, width: 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  child: Text(
                    locale.get('On') ?? 'On',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: !settingsModel.notificationOff
                          ? Colors.white
                          : AppColors.primaryElement,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => settingsModel.toggleNotification(),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  decoration: BoxDecoration(
                    color: !settingsModel.notificationOff
                        ? Colors.white
                        : AppColors.primaryElement,
                    border:
                        Border.all(color: AppColors.primaryElement, width: 1),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(9),
                        bottomRight: Radius.circular(9)),
                  ),
                  child: Text(
                    locale.get('Off') ?? 'Off',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: !settingsModel.notificationOff
                            ? AppColors.primaryElement
                            : Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

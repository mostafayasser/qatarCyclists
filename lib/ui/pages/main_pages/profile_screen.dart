import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/pages/main_pages/settings_page.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/styles/styles.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/page_models/main_pages_models/profile_screen_model.dart';
import '../../widgets/buttons/switch_language_button.dart';
import '../../widgets/buttons/transparent_button.dart';
import '../../widgets/header_color.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BaseWidget<ProfileScreenModel>(
            initState: (m) => WidgetsBinding.instance
                .addPostFrameCallback((_) => m.initializeProfileData()),
            model: ProfileScreenModel(
              api: Provider.of(context),
              auth: Provider.of(context),
              local: AppLocalizations.of(context),
            ),
            builder: (context, model, _) {
              return model.isInit
                  ? buildLoadingScreen(context)
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          // app bar.
                          buildHeaderColor(context),
                          // Change Language & settings row.
                          buildLanguageAndSettingsRow(context),

                          // personal image & info
                          buildPersonalInfo(context, model),

                          // My events & my products
                          buildBody(context, model),

                          // sign out button
                          buildSignOut(model, context),
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
          buildHeaderColor(context),
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
      title: locale.get('PROFILE') ?? 'PROFILE',
      titleImage: 'profile_bar.png',
      titleImageColor: AppColors.accentElement,
    );
  }

  Container buildLanguageAndSettingsRow(context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.screenWidthDp * 0.05,
          vertical: ScreenUtil.screenHeightDp * 0.015),
      width: ScreenUtil.screenWidthDp,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SwitchLanguageButton(
            height: 25,
            width: 80,
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              UI.push(context, SettingsScreen());
            },
            child: Image.asset(
              'assets/images/settings.png',
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPersonalInfo(BuildContext context, ProfileScreenModel model) {
    String profileImage = model.image;
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.screenWidthDp * 0.05,
          vertical: ScreenUtil.screenHeightDp * 0.02),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => model.busy ? () {} : _showImageDialog(context, model),
            child: Container(
              alignment: Alignment.center,
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
                image: profileImage == null || profileImage.isEmpty
                    ? null
                    : DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(
                            HttpApi.imageBaseUrl + (profileImage ?? '')),
                      ),
              ),
              child:
                  (profileImage == null || profileImage.isEmpty) && !model.busy
                      ? Text(locale.get('Upload image') ?? 'Upload image',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black45))
                      : model.busy ? LoadingIndicator() : null,
            ),
          ),
          SizedBox(
            width: ScreenUtil.screenWidthDp * 0.05,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  model.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: ScreenUtil.screenWidthDp * 0.015),
                Text(
                  model.email,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xff515c6f),
                    letterSpacing: 0.77,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil.screenWidthDp * 0.02,
                ),
                TransparentButton(
                  onPressed: () => UI.push(context, Routes.editProfileScreen),
                  text: 'EDIT PROFILE',
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildBody(BuildContext context, ProfileScreenModel model) {
    final locale = AppLocalizations.of(context);

    return Container(
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
          _buildRowItem('profile_events.png', locale.get('Registered Events'),
              onTap: () => model.openMyEvents(context)),
          Divider(),
          _buildRowItem('profile_rides.png', locale.get('My Rides'),
              onTap: () => model.openMyRides(context)),
          /* Divider(),
          _buildRowItem('profile_products.png', locale.get('My Products'),
              onTap: () => UI.toast(locale.get('soon'))),
          Divider(),
          _buildRowItem('profile_orders.png', locale.get('Orders'),
              onTap: () => UI.toast(locale.get('soon'))), */
        ],
      ),
    );
  }

  Widget _buildRowItem(String imagePath, String title, {Function onTap}) {
    return Material(
      child: InkWell(
        hoverColor: Colors.black,
        onTap: () => onTap == null ? {} : onTap(),
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
              SizedBox(width: ScreenUtil.screenWidthDp * 0.05),
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
            ],
          ),
        ),
      ),
    );
  }

  Padding buildSignOut(ProfileScreenModel model, BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil.screenHeightDp * 0.02),
      child: model.busy
          ? CircularProgressIndicator()
          : FlatButton.icon(
              textColor: AppColors.primaryElement,
              onPressed: () => model.logout(context),
              icon: Icon(Icons.exit_to_app),
              label: Text(locale.get('Sign out'))),
    );
  }

  Future<void> _showImageDialog(
      BuildContext context, ProfileScreenModel model) async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              'Choose From',
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Camera'),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await model.pickImage(ImageSource.camera, ctx);
                },
              ),
              SimpleDialogOption(
                child: Text('Gallery'),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await model.pickImage(ImageSource.gallery, ctx);
                },
              ),
            ],
          );
        });
  }
}

import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/buttons/normal_button.dart';
import 'package:qatarcyclists/ui/widgets/custom_text_form_field.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:qatarcyclists/ui/widgets/password_text_form_field.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/page_models/main_pages_models/edit_profile_model.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BaseWidget<EditProfileModel>(
          initState: (m) => WidgetsBinding.instance
              .addPostFrameCallback((_) => m.initializeProfileData()),
          model: EditProfileModel(
              local: AppLocalizations.of(context), auth: Provider.of(context)),
          builder: (context, model, _) {
            return model.isInit
                ? buildLoadingScreen(context)
                : FocusWidget(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          // app bar.
                          buildHeaderColor(context),
                          // image & title
                          buildPersonalImage(context, model),
                          // edit profile form
                          buildEditProfileForm(model, context),
                          // apply button
                          buildProceedButton(model, context),
                        ],
                      ),
                    ),
                  );
          }),
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
      hasBack: true,
    );
  }

  Padding buildPersonalImage(BuildContext context, EditProfileModel model) {
    final locale = AppLocalizations.of(context);

    String profileImage = model.profileImage;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.screenWidthDp * 0.05,
          vertical: ScreenUtil.screenHeightDp * 0.02),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => _showImageDialog(context, model),
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
            ),
          ),
          SizedBox(
            height: ScreenUtil.screenHeight * 0.01,
          ),
          Text(
            locale.get('Edit Profile') ?? 'Edit Profile',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Container buildEditProfileForm(EditProfileModel model, BuildContext context) {
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
              hint: locale.get('Email') ?? 'Email',
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
              controller: model.mobile,
              hint: locale.get('Mobile Number') ?? 'Mobile Number',
              keyboardType: TextInputType.phone,
              icon: Image.asset(
                'assets/images/phone.png',
                height: 25.0,
              ),
              validator: (value) => model.mobileValidator(value, context),
            ),
            Divider(
              color: const Color(0xffd9d8d8),
              height: 8,
              thickness: 0.5,
            ),
            PasswordTextFormFiled(
              controller: model.password,
              hint: locale.get('Change Password') ?? 'Change Password',
              secure: true,
              icon: Image.asset(
                'assets/images/password.png',
                height: 25.0,
              ),
            ),
            Divider(
              color: const Color(0xffd9d8d8),
              height: 0,
              thickness: 0.5,
            ),
            PasswordTextFormFiled(
              controller: model.confirmPassword,
              hint: locale.get('Confirm Password') ?? 'Confirm Password',
              secure: true,
              icon: Image.asset(
                'assets/images/password.png',
                height: 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildProceedButton(EditProfileModel model, BuildContext context) {
    return NormalButton(
      width: ScreenUtil.screenWidthDp / 2,
      textColor: AppColors.accentText,
      localize: true,
      text: 'APPLY',
      gradient: null,
      onPressed: () => model.editProfile(context, model.changeImage),
      busy: model.busy,
    );
  }

  Future<void> _showImageDialog(
      BuildContext context, EditProfileModel model) async {
    final locale = AppLocalizations.of(context);

    //model.changeImageBool(true);
    return showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              locale.get('Choose From') ?? 'Choose From',
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  locale.get('Camera') ?? 'Camera',
                ),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await model.pickImage(ImageSource.camera);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  locale.get('Gallery') ?? 'Gallery',
                ),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await model.pickImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }
}

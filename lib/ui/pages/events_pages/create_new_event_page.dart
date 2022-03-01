import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/core/utils/validator.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/buttons/normal_button.dart';
import 'package:qatarcyclists/ui/widgets/custom_text_form_field.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:ui_utils/ui_utils.dart';

class CreateNewEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<CreateNewEventPageModel>(
            model: CreateNewEventPageModel(
                api: Provider.of(context), auth: Provider.of(context)),
            builder: (context, model, child) {
              return Column(
                children: <Widget>[
                  // Header color and logo
                  buildHeader(context),
                  Expanded(
                    child: CustomAnimatedCrossFade(
                      fisrt: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: ScreenUtil.screenHeightDp * 0.02),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 10),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  AppLocalizations.of(context)
                                          .get('Add new ride') ??
                                      'Add new ride',
                                  style: TextStyle(
                                      color: AppColors.secondaryText,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            buildSignupForm(model, context),
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
                  )
                ],
              );
            }),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return HeaderColor(
      title: locale.get('MY Rides') ?? 'Register for this event',
      hasBack: true,
      titleAtStart: true,
      hasTitle: true,
    );
  }

  Container buildSignupForm(
      CreateNewEventPageModel model, BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: ScreenUtil.screenHeightDp * 0.02,
          horizontal: ScreenUtil.screenWidthDp * .06),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffffffff),
        border: Border.all(width: 1.0, color: const Color(0xffd9d8d8)),
        boxShadow: [
          BoxShadow(
              color: const Color(0xffe7eaf0),
              offset: Offset(0, 8),
              blurRadius: 15)
        ],
      ),
      child: Form(
        key: model.formKey,
        autovalidate: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              locale.get('Title') ?? 'Title',
              style: TextStyle(color: Colors.grey, fontSize: 17),
            ),
            CustomTextFormField(
              padding: EdgeInsets.all(0),
              controller: model.title,
              validator: (value) => model.namelValidator(value, context),
            ),
            Divider(color: const Color(0xffd9d8d8), thickness: 0.5, height: 0),
            SizedBox(height: 10),
            //
            Text(
              locale.get('Description') ?? 'Description',
              style: TextStyle(color: Colors.grey, fontSize: 17),
            ),
            CustomTextFormField(
              padding: EdgeInsets.all(0),
              lines: 3,
              controller: model.describtion,
              validator: (value) => model.textFieldValidator(value, context),
            ),
            Divider(color: const Color(0xffd9d8d8), thickness: 0.5, height: 0),

            SizedBox(height: 20),

            //
            buildDateField(context, model, locale),
            SizedBox(height: 20),
            Divider(color: const Color(0xffd9d8d8), thickness: 0.5, height: 0),
            SizedBox(height: 10),
            buildLocationField(locale, model, context),
          ],
        ),
      ),
    );
  }

  buildDateField(BuildContext context, CreateNewEventPageModel model,
      AppLocalizations locale) {
    final formatter = DateFormat('yyyy-MM-dd');
    // final formatter2 = DateFormat('HH:mm');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(locale.get('Date') ?? 'Date',
            style: TextStyle(color: Colors.grey, fontSize: 15)),
        FlatButton(
          padding: EdgeInsets.all(4),
          onPressed: () => model.openDatePicker(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            child: Text(
              formatter.format(model.selectedDate),
            ),
          ),
        ),
        Text(locale.get('Time') ?? 'Time',
            style: TextStyle(color: Colors.grey, fontSize: 17)),
        FlatButton(
          padding: EdgeInsets.all(4),
          onPressed: () => model.openTimePicker(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
            child: Text(model.selectedTime.format(context)),
          ),
        ),
      ],
    );
  }

  Container buildLocationField(AppLocalizations locale,
      CreateNewEventPageModel model, BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.get('Location') ?? 'Location',
                    style: TextStyle(color: Colors.grey, fontSize: 17)),
                CustomTextFormField(
                  controller: model.location,
                  padding: EdgeInsets.all(0),
                  validator: (value) => model.namelValidator(value, context),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: RoundedWidget(
              child: Container(
                //height: ScreenUtil.screenHeightDp / 7,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,

                      ///prioritizing gesture detection GoogleMap and not ListView
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },

                      mapToolbarEnabled: false,
                      onCameraMove: (cp) => model.getLatLng(cp),
                      zoomControlsEnabled: false,
                      compassEnabled: false,

                      initialCameraPosition: CameraPosition(
                        zoom: 14,
                        tilt: 10,
                        target: LatLng(
                          model?.latLng?.latitude ?? 25.2854,
                          model?.latLng?.longitude ?? 51.5310,
                        ),
                      ),
                    ),
                    Icon(Icons.location_on, color: AppColors.primaryElement)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildProceedButton(CreateNewEventPageModel model, BuildContext context) {
    final locale = AppLocalizations.of(context);

    return NormalButton(
      localize: false,
      // width: ScreenUtil.screenWidthDp / 2.5,
      text: locale.get('SUBMIT') ?? 'SUBMIT',
      gradient: null,
      onPressed: () => model.onSubmit(context),
      busy: model.busy,
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
                  .get('Your ride has been submitted successfully'),
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

class CreateNewEventPageModel extends BaseNotifier with Validator {
  LatLng latLng;
  bool success = false;
  final HttpApi api;
  final AuthenticationService auth;
  final title = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final location = TextEditingController();
  final describtion = TextEditingController();

  CreateNewEventPageModel({NotifierState state, this.api, this.auth})
      : super(state: state);

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 0);

  Future<void> openDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setState();
    }
  }

  openTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: 12, minute: 0));
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      setState();
    }
  }

  onSubmit(BuildContext context) async {
    if (latLng == null) {
      UI.toast(AppLocalizations.of(context).get('choose location'));
      return;
    }
    if (formKey.currentState.validate()) {
      setBusy();
      final formatter = DateFormat('yyyy-MM-dd');
      final date = formatter.format(selectedDate) +
          ' ${selectedTime.hour}:${selectedTime.minute}';
      try {
        final created = await api.createUserRide(
            date: date,
            description: describtion.text,
            title: title.text,
            venue: location.text,
            latLng: latLng);
        if (created) {
          successAlert(context);
          // UI.toast(AppLocalizations.of(context).get('done'));
        } else {
          UI.toast(AppLocalizations.of(context).get('failed'));
        }
      } catch (e) {}
      setIdle();
    }
  }

  getLatLng(CameraPosition cp) {
    latLng = cp.target;
  }

  void successAlert(BuildContext context) async {
    success = true;
    setState();
    await Future.delayed(Duration(milliseconds: 2000));
    Navigator.pop(context);
  }
}

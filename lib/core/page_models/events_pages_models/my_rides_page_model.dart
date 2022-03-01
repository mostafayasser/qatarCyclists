import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';

class MyRidesPageModel extends BaseNotifier {
  int index = 0;
  MyRides myRides;
  final HttpApi api;
  final AuthenticationService auth;

  MyRidesPageModel({NotifierState state, this.api, this.auth})
      : super(state: state);

  getMyEvents(BuildContext context) async {
    setBusy();
    try {
      myRides = await api.getMyRides(context);
      setState();
    } catch (e) {
      setError();
    }
    setIdle();
  }

  changeTap({int index, context}) async {
    this.index = index;
    /* if (index == 0) {
      await getRigesteredEvents(context);
    } else {
      await getMyEvents(context);
    } */
    setState();
  }
}

import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/models/my_events.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';

class MyEventsPageModel extends BaseNotifier {
  int index = 0;
  MyEventsTrainings myEventsTrainings;
  final HttpApi api;
  final AuthenticationService auth;

  MyEventsPageModel({NotifierState state, this.api, this.auth})
      : super(state: state);

  getMyEvents(BuildContext context) async {
    try {
      myEventsTrainings = await api.getMyEventsTrainigns(context);
    } catch (e) {
      setError();
    }
    setIdle();
  }

  changeTap({int index}) {
    this.index = index;
    setState();
  }
}

import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:ui_utils/ui_utils.dart';

class HomePageModel extends BaseNotifier {
  int pageIndex = 0;
  final AuthenticationService auth;
  PageController pageController = PageController(keepPage: true);

  HomePageModel({this.auth});

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  void onPageChanged(int pageIndex) {
    this.pageIndex = pageIndex;
    setState();
  }

  void onChangeTab(BuildContext context, int index) async {
    if ((index == 2) && !auth.userLoged) {
      UI.push(context, Routes.signIn);
    } else if (index == 4) {
      key.currentState.openEndDrawer();
    } else {
      pageController.jumpToPage(index);
    }
  }
}

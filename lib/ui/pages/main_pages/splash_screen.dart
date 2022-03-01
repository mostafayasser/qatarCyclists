import 'dart:async';
import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/core/services/notification/notification_service.dart';
import 'package:qatarcyclists/core/services/preference/preference.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/page_models/theme_provider.dart';
import '../../../core/services/auth/authentication_service.dart';
import '../../../core/services/connectivity/connectivity_service.dart';
import '../../../core/services/localization/localization.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool navigating = false;
  bool offline = false;
  AuthenticationService auth;
  ConnectivityService connectivity;
  StreamSubscription connectivitySubscription;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final locale = AppLocalizations.of(context);
      await Provider.of<AppLanguageModel>(context, listen: false).fetchLocale();
      connectivity = Provider.of<ConnectivityService>(context, listen: false);
      auth = Provider.of<AuthenticationService>(context, listen: false);

      connectivitySubscription =
          connectivity.connectionChange.listen((isOnline) async {
        if (isOnline) {
          offline = false;
          navigate(context);
        } else {
          UI.toast(locale.get("Check your internet connection") ??
              "Check your internet connection");
        }
        setState(() {});
      });

      if (connectivity.connected ||
          (Platform.isIOS && await _connectionValid)) {
        navigate(context);
      }

      Future.delayed(Duration(seconds: 10), () {
        if (mounted) {
          navigating = false;
          setState(() {});
        }
      });
    });
  }

  Future<bool> get _connectionValid async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  navigate(context) async {
    if (navigating || !mounted) {
      return;
    }

    if (mounted) {
      setState(() {
        navigating = true;
        offline = false;
      });
    }

    if (!connectivity.connected &&
        (Platform.isIOS && !await _connectionValid)) {
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        navigating = false;
        offline = true;
        setState(() {
          //
        });
      }
      return;
    }

    try {
      if (auth.userLoged) {
        await auth.loadUser;
        try {
          FireStoreService.userPersonId = auth.user.id.toString();
          await Provider.of<NotificationService>(context, listen: false)
              .init(context);
        } catch (e) {
          //
        }

        UI.push(context, Routes.homePageScreen, replace: true);
      } else {
        if (Preference.sb.getBool("firstLaunch") == null) {
          Preference.sb.setBool("firstLaunch", true);
          await Future.delayed(Duration(seconds: 2));
          UI.push(context, Routes.slider, replace: true);
        } else {
          await Future.delayed(Duration(seconds: 2));
          UI.push(context, Routes.signIn, replace: true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          navigating = false;
          offline = true;
        });
      }
    }
    setState(() {
      offline = true;
      navigating = false;
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final locale = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CustomAnimatedCrossFade(
          showFirst: !offline,
          fisrt: loadingWidget(theme),
          secound: offlineWidget(context, locale, theme),
        ),
      ),
    );
  }

  offlineWidget(
      BuildContext context, AppLocalizations locale, ThemeProvider theme) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingWidget(
          child:
              Icon(Icons.portable_wifi_off, size: 80, color: Colors.grey[800]),
        ),
        Text(
          locale.get('Error connecting to the network'),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[800], fontSize: 20),
        ),
        SizedBox(height: 10),
        RaisedButton(
            child: Text('try again'), onPressed: () => navigate(context)),
      ],
    );
  }

  loadingWidget(ThemeProvider theme) {
    return Image.asset(
      "assets/images/logo.png",
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.4,
      color: theme.isDark ? null : Colors.grey,
    );
  }
}

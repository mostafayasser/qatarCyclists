import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';

import '../services/preference/preference.dart';

class ThemeProvider extends BaseNotifier {
  bool isDark;
  ThemeProvider() {
    isDark = Preference.getBool(PrefKeys.isDark) ?? true;
  }
  ThemeData dark = ThemeData(
    primaryColor: Color(0xffab351c),
    // textTheme: TextTheme().apply(bodyColor: Colors.white),
    iconTheme: IconThemeData(color: Colors.black),
    buttonTheme: ButtonThemeData(buttonColor: Color(0xffab351c)),
    scaffoldBackgroundColor: Colors.white,
    accentColor: Color(0xffab351c),
  );

  ThemeData light = ThemeData(
    primaryColor: AppColors.primaryElement,
    // textTheme: TextTheme(body1: TextStyle(color: Colors.white).apply()),
    // textTheme: TextTheme().apply(bodyColor: Colors.orange, displayColor: Colors.orange),

    iconTheme: IconThemeData(color: Colors.black),
    buttonTheme: ButtonThemeData(buttonColor: Colors.blueAccent),
    scaffoldBackgroundColor: Colors.white,
    accentColor: AppColors.accentElement,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 11.181839942932129,
        color: Color(0xff939598),
      ),
      hintStyle: TextStyle(
        fontFamily: "Montserrat",
        fontSize: 10.358949661254883,
        color: Color(0xff758091),
      ),
    ),
  );

  get switchTheme {
    isDark = !isDark;
    Preference.setBool(PrefKeys.isDark, isDark);
    setState();
  }
}

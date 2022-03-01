import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/page_models/theme_provider.dart';

Widget customTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
  return Builder(builder: (context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Provider.of<ThemeProvider>(context).isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
          icon: Icon(icon, color: Color(0xff939598)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: label,
          labelStyle: TextStyle(
              color: Provider.of<ThemeProvider>(context).isDark ? Color(0xff939598) : Color(0xff939598),
              fontSize: 18,
              fontWeight: FontWeight.w400)),
    );
  });
}

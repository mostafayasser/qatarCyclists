import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final EdgeInsets padding;
  final int lines;
  final double textHeight;
  final double textHintHeight;
  final bool secure;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget icon;
  final String Function(String) validator;
  const CustomTextFormField(
      {Key key,
      this.secure = false,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 5.0),
      this.controller,
      this.hint,
      this.lines = 1,
      this.keyboardType = TextInputType.text,
      this.icon,
      this.validator,
      this.textHeight,
      this.textHintHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        validator: validator,
        maxLines: lines,
        keyboardType: keyboardType,
        obscureText: secure,
        controller: controller,
        style: TextStyle(fontSize: 15, color: Colors.grey[800], height: textHeight),
        decoration: InputDecoration(
          errorStyle: TextStyle(height: textHintHeight),
          icon: icon,
          labelText: hint,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

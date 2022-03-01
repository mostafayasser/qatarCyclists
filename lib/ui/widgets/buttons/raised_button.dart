import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onClicked;
  final Color color;
  final String text;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;

  const Button(
      {Key key,
      this.onClicked,
      this.color = Colors.black,
      this.text,
      this.borderRadius = 10,
      this.textColor = Colors.white,
      this.borderColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onClicked,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: ScreenUtil.screenWidthDp * 0.75,
        height: ScreenUtil.portrait
            ? ScreenUtil.screenHeightDp * 0.075
            : ScreenUtil.screenHeightDp * 0.12,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            border: new Border.all(color: borderColor)
            // gradient: dark ? Gradients.darkGradient : Gradients.lightGradient,
            ),
        child: Text(
          text,
          style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';

import '../../../ui/styles/styles.dart';

class TransparentButton extends StatelessWidget {
  final bool localize;
  final double width;
  final double height;
  final String text;
  final Function onPressed;
  const TransparentButton({Key key, this.localize = true, this.onPressed, this.text, this.width = 84, this.height = 28}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FlatButton(
      onPressed: onPressed,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      textColor: Color(0xff707070),
      child: Text(
        localize ? locale.get(text) ?? text : text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: const Color(0xff707070),
          letterSpacing: 0.6599999999999999,
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(side: Borders.primaryBorder, borderRadius: BorderRadius.all(Radius.circular(24))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';

import '../../../ui/styles/colors.dart';
import '../loading_widget.dart';

class NormalButton extends StatelessWidget {
  final bool localize;
  final bool busy;
  final bool showArrow;
  final double width;
  final double height;
  final String text;
  final Color color;
  final Gradient gradient;
  final EdgeInsets margin;
  final Function onPressed;
  final Color textColor;
  const NormalButton(
      {Key key,
      this.busy = false,
      this.gradient,
      this.localize = true,
      this.onPressed,
      this.text = 'ok',
      this.width = 322,
      this.height = 46,
      this.margin = const EdgeInsets.only(top: 22),
      this.textColor = Colors.white,
      this.color = AppColors.primaryElement,
      this.showArrow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    // final theme = Provider.of<ThemeProvider>(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      width: busy ? (width / 2) : width,
      height: height,
      margin: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(34),
        // border: Border.all(
        //     color: theme.isDark ? Colors.white12 : Colors.lightBlue[700],
        //     width: 2),
        // gradient: gradient == null
        //     ? (theme.isDark
        //         ? Gradients.fireGradient
        //         : LinearGradient(
        //             colors: [Color(0xff82A2FE), Color(0xff6285FD)]))
        //     : gradient,
      ),
      child: busy
          ? Center(child: LoadingIndicator())
          : FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34)),
              onPressed: () => onPressed == null ? {} : onPressed(),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        width: width,
                        height: height,
                        alignment: Alignment.center,
                        child: Text(localize ? locale.get(text) ?? text : text,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                color: gradient == null
                                    ? textColor
                                    : Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal))),
                  ),
                  if (showArrow)
                    Container(
                      width: 28.8,
                      height: 29.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: const Color(0xffffffff),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.0,
                        color: Color(0xffFFB900),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

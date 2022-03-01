import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';

class HeaderColor extends StatelessWidget {
  final bool hasTitle;
  final bool titleAtStart;
  final String titleImage;
  final Color titleImageColor;
  final String title;
  final Widget trailingWidget;
  final bool hasBack;

  const HeaderColor({
    this.hasTitle = false,
    this.titleAtStart = false,
    this.titleImage,
    this.title,
    this.trailingWidget,
    this.titleImageColor,
    this.hasBack = false,
  });
  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppLanguageModel>(context, listen: false).appLocal == Locale('en');
    return Container(
      height: ScreenUtil.portrait ? ScreenUtil.screenHeightDp * 0.16 : ScreenUtil.screenHeightDp * 0.3,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              height: ScreenUtil.portrait ? ScreenUtil.screenHeightDp * 0.16 : ScreenUtil.screenHeightDp * 0.3,
              color: const Color(0xff91143b),
            ),
          ),
          // title
          if (hasTitle)
            Row(
              mainAxisAlignment: titleAtStart ? MainAxisAlignment.start : MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (titleImage != null)
                  Image.asset(
                    'assets/images/$titleImage',
                    height: 22,
                    color: titleImageColor,
                  ),
                if (titleImage != null) SizedBox(width: 8.0),
                if (titleAtStart) SizedBox(width: 65),
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21.0),
                ),
              ],
            ),
          // traling widget
          if (trailingWidget != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Align(
                alignment: isEnglish ? Alignment.centerRight : Alignment.centerLeft,
                child: trailingWidget,
              ),
            ),
          if (hasBack)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Align(
                alignment: isEnglish ? Alignment.centerLeft : Alignment.centerRight,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
            )
        ],
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - size.height * 0.3);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

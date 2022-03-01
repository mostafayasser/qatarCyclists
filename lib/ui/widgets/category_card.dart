import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/models/events.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';

class CategoryCard extends StatelessWidget {
  final Categories category;
  final Function onTap;
  const CategoryCard({Key key, @required this.category, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedWidget(
        raduis: 24,
        child: Container(
          height: ScreenUtil.screenHeightDp / 10,
          width: ScreenUtil.screenWidthDp,
          child: InkWell(
            onTap: () => onTap(),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset('assets/images/header1.jpg', fit: BoxFit.cover),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            locale.locale.languageCode == 'en'
                                ? category.title.toUpperCase()
                                : locale.get(category.title) ?? category.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                        Container(
                          width: ScreenUtil.screenWidthDp / 14,
                          height: ScreenUtil.screenWidthDp / 14,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(55), color: Colors.white),
                          child: Icon(Icons.arrow_forward_ios, color: AppColors.secondaryText, size: 15),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

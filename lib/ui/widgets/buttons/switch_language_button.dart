import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';

import '../../../ui/styles/colors.dart';

class SwitchLanguageButton extends StatelessWidget {
  final double width;
  final double height;

  SwitchLanguageButton({this.width = 90, this.height = 30});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageModel>(builder: (context, languageModel, _) {
      bool isEnglish = languageModel.appLocal == Locale('en');
      return Container(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () => languageModel.changeLanguage(Locale('en')),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  decoration: BoxDecoration(
                    color: isEnglish ? AppColors.primaryElement : Colors.white,
                    border: Border.all(color: AppColors.primaryElement, width: 1),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  ),
                  child: Text(
                    'EN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isEnglish ? Colors.white : AppColors.primaryElement,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => languageModel.changeLanguage(Locale('ar')),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  decoration: BoxDecoration(
                    color: isEnglish ? Colors.white : AppColors.primaryElement,
                    border: Border.all(color: AppColors.primaryElement, width: 1),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(9), bottomRight: Radius.circular(9)),
                  ),
                  child: Text(
                    'عـر',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isEnglish ? AppColors.primaryElement : Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

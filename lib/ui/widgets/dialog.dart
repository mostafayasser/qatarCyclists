import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';

class CustomDialog extends StatelessWidget {
  final msg;
  final title;

  const CustomDialog({Key key, this.msg, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 50),
        decoration: BoxDecoration(
            color: Color(0xFFFFC100), borderRadius: BorderRadius.circular(25)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                title,
                maxLines: 3,
                style: TextStyle(
                    color: AppColors.primaryElement,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                msg,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: TextStyle(
                    color: AppColors.primaryElement,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

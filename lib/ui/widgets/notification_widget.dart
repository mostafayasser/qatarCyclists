import 'dart:io';

import 'package:qatarcyclists/ui/pages/chat_pages/person_chat.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../core/page_models/theme_provider.dart';

import '../styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class Notify extends StatelessWidget {
  final String title;
  final String body;
  final Map<dynamic, dynamic> data;

  Notify({Key key, this.title, this.body, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final grad = Provider.of<ThemeProvider>(context).isDark
        ? LinearGradient(colors: [Color(0xff191A1D), Color(0xff353B3F)])
        : Gradients.secandaryGradient;
    final textColor = Provider.of<ThemeProvider>(context).isDark
        ? Color(0xffffffff)
        : Color(0xff5C6470);

    //final english = AppLocalizations.of(context).locale.languageCode == 'en';

    /* final title = (this.title ?? '  -  ')?.split('-')[english ? 0 : 1] ?? '';
    final body = (this.body ?? '  -  ')?.split('-')[english ? 0 : 1] ?? ''; */

    return SafeArea(
        child: GestureDetector(
      onHorizontalDragEnd: (_) => OverlaySupportEntry.of(context).dismiss(),
      child: Card(
        margin: EdgeInsets.all(7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Container(
          decoration: BoxDecoration(
            gradient: grad,
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListTile(
            leading: SizedBox(
                width: 35,
                height: 35,
                child: Image.asset("assets/images/logo.png", color: textColor)),
            onTap: () {
              OverlaySupportEntry.of(context).dismiss();
              UI.push(
                context,
                PersonChatPage(
                  chatId: Platform.isAndroid
                      ? data["data"]["chatId"]
                      : data["chatId"],
                  chatName: Platform.isAndroid ? data["data"]["title"] : title,
                  person: Platform.isAndroid
                      ? data["data"]["group"] == "false"
                      : data["group"] == "false",
                ),
              );
            },
            title: Text(
                Platform.isAndroid ? data["data"]["title"] : title ?? '',
                style: TextStyle(fontSize: 15, color: textColor)),
            subtitle: Text(
                Platform.isAndroid ? data["data"]["body"] : body ?? '',
                style: TextStyle(fontSize: 10, color: textColor)),
            trailing: IconButton(
                color: textColor,
                icon: Icon(Icons.close),
                onPressed: () => OverlaySupportEntry.of(context).dismiss()),
          ),
        ),
      ),
    ));
  }
}

import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';

class ChatMessage extends StatelessWidget {
  final String msg;
  final String time;
  final bool sent;
  final String senderName;
  final String id;

  const ChatMessage(
      {Key key, this.msg, this.time, this.sent, this.senderName, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        if (sent) {
          final res = await UI.dialog(
            context: context,
            title: "Delete this message",
            msg: "Are you sure you want to delete this message?",
            accept: true,
            acceptMsg: "Delete",
            cancelMsg: "Cancel",
          );
          if (res != null && res) {
            FireStoreService.deleteMessage(id);
          }
        }
      },
      child: Align(
        alignment:
            sent ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
        child: Container(
          width: ScreenUtil.screenWidthDp / 1.2,
          // height: 66,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          alignment: AlignmentDirectional.topStart,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(17),
                topEnd: Radius.circular(17),
                bottomEnd: !sent ? Radius.circular(17) : Radius.circular(0),
                bottomStart: sent ? Radius.circular(17) : Radius.circular(0),
              ),
              color: sent ? Colors.grey[400] : AppColors.primaryElement),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!sent)
                Text(
                  senderName,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              Text(msg,
                  style: TextStyle(
                    color: Colors.white,
                  )),
              Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Text(time, style: TextStyle(color: Colors.white)))
            ],
          ),
        ),
      ),
    );
  }
}

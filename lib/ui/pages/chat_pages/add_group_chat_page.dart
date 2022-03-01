import 'package:base_notifier/base_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/buttons/normal_button.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:ui_utils/ui_utils.dart';

class AddGroupChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<AddGroupChatPageModel>.staticBuilder(
            model: AddGroupChatPageModel(auth: Provider.of(context)),
            staticBuilder: (context, model) {
              return Container(
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp,
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  buildHeaderColor(context),
                  buildGroupNameField(context, model),
                  buildPersonsData(context, model),
                  buildCreateButton(context, model),
                ]),
              );
            }),
      ),
    );
  }

  // Header color & icon.
  Widget buildHeaderColor(context) {
    final locale = AppLocalizations.of(context);
    return HeaderColor(
        hasBack: true,
        hasTitle: true,
        titleImage: 'chat.png',
        title: locale.get("Chat"));
  }

  Widget buildLoadingData(BuildContext context) =>
      Center(child: LoadingIndicator());

  buildPersonsData(BuildContext context, AddGroupChatPageModel model) {
    final locale = AppLocalizations.of(context);

    return Expanded(
        child: StreamProvider<QuerySnapshot>(
      create: (c) => FireStoreService.getPersons(),
      updateShouldNotify: (a, b) => true,
      builder: (c, s) => Consumer<QuerySnapshot>(
        builder: (context, snap, _) {
          return BaseWidget<AddGroupChatPageModel>.cosnume(
            builder: (context, model, child) {
              if (snap != null) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snap.documents.length,
                  itemBuilder: (context, index) {
                    final person = snap.documents[index].data;

                    return ListTile(
                      onTap: () =>
                          model.switchSelection(context, person['objectId']),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: AppColors.primaryElement,
                        child: Text(
                            ((person['fullname'] ??
                                    person['name'] ??
                                    'Qatar Cyclists User')
                                .toString()
                                .split("")[0]),
                            style:
                                TextStyle(fontSize: 27, color: Colors.white)),
                      ),
                      title: Text(
                          person['fullname'] ??
                              person['name'] ??
                              'Qatar Cyclists User',
                          style: TextStyle(color: AppColors.secondaryText)),
                      contentPadding: EdgeInsets.all(6),
                      trailing: person['objectId'] ==
                              FireStoreService.userPersonId
                          ? RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                              onPressed: null,
                              child: Text(
                                locale.get('you') ?? 'you',
                                style:
                                    TextStyle(color: AppColors.accentElement),
                              ))
                          : Checkbox(
                              value: model.selectedUserIds
                                  .contains(person['objectId']),
                              onChanged: model.busy
                                  ? null
                                  : (v) => model.switchSelection(
                                      context, person['objectId']),
                            ),
                    );
                  },
                );
              } else {
                return buildLoadingData(context);
              }
            },
          );
        },
      ),
    ));
  }

  buildCreateButton(BuildContext context, AddGroupChatPageModel model) {
    return BaseWidget<AddGroupChatPageModel>.cosnume(
        builder: (context, model, child) {
      return NormalButton(
        gradient: null,
        width: ScreenUtil.screenWidthDp / 2,
        textColor: AppColors.accentText,
        localize: false,
        text: AppLocalizations.of(context).get('Create Group'),
        onPressed: () => model.busy ? {} : model.createGroup(context),
        busy: model.busy,
      );
    });
  }

  buildGroupNameField(BuildContext context, AddGroupChatPageModel model) {
    final locale = AppLocalizations.of(context);

    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.get('Group Name'),
              style: TextStyle(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0),
            ),
            Container(
              width: ScreenUtil.screenWidthDp,
              height: 35,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]),
                  color: Colors.grey[200]),
              child: TextField(
                controller: model.groupNameControlelr,
                decoration: InputDecoration(
                    hintText: locale.get('Group Name'),
                    border: InputBorder.none,
                    disabledBorder: null,
                    enabledBorder: null,
                    focusedBorder: null,
                    focusedErrorBorder: null),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddGroupChatPageModel extends BaseNotifier {
  final AuthenticationService auth;
  List<String> selectedUserIds = [];
  final groupNameControlelr = TextEditingController();

  AddGroupChatPageModel({this.auth});

  switchSelection(BuildContext context, String userId) async {
    final exist = selectedUserIds.contains(userId);
    if (exist) {
      selectedUserIds.remove(userId);
    } else {
      selectedUserIds.add(userId);
    }
    setState();
  }

  createGroup(BuildContext context) async {
    final locale = AppLocalizations.of(context);

    if (selectedUserIds.isNotEmpty && groupNameControlelr.text.isNotEmpty) {
      setBusy();

      try {
        await FireStoreService.createUserGroup(
            groupName: groupNameControlelr.text, membersIds: selectedUserIds);

        UI.toast(locale.get('Group Created'));

        Navigator.pop(context);
      } catch (e) {
        Logger().e('error in  method $e');
        UI.toast(locale.get('please try again'));
      }
      setIdle();
    } else {
      UI.toast(locale.get('empty') ?? 'empty');
    }
  }
}

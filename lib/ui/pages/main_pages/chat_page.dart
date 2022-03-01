import 'package:base_notifier/base_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/core/services/preference/preference.dart';
import 'package:qatarcyclists/ui/pages/chat_pages/person_chat.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/styles/styles.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:ui_utils/ui_utils.dart';

class ChatPage extends StatelessWidget {
  static int count = 0;
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<ChatPageModel>(
            model: ChatPageModel(
                api: Provider.of(context), auth: Provider.of(context)),
            builder: (context, model, _) {
              return Container(
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    buildHeaderColor(context),
                    if (model.busy) buildLoadingData(context),
                    if (!model.busy) ...buildChatssData(context, model),
                  ],
                ),
              );
            }),
      ),
    );
  }

  buildLoadingData(BuildContext context) => Center(child: LoadingIndicator());

  // Header color & icon.
  Widget buildHeaderColor(context) {
    final locale = AppLocalizations.of(context);
    return HeaderColor(
        hasBack: false,
        hasTitle: true,
        titleImage: 'chat.png',
        title: locale.get("Chat"));
  }

  List<Widget> buildChatssData(BuildContext context, ChatPageModel model) {
    final locale = AppLocalizations.of(context);

    return [
      buildChatTypeRow(context, model),
      buildSearch(locale, model, context),
      model.chatType == 0
          ? buildPersonChatList(context, model)
          : buildGroupChatList(context, model),
    ];
  }

  Align buildSearch(
      AppLocalizations locale, ChatPageModel model, BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.get(model.chatType == 0 ? 'Users list' : 'Groups list'),
              style: TextStyle(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0),
            ),
            InkWell(
              onTap: () => UI.push(context,
                  model.chatType == 0 ? Routes.addChat : Routes.addGroupChat),
              child: Container(
                width: ScreenUtil.screenWidthDp,
                height: 35,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]),
                    color: Colors.grey[200]),
                child: Text(
                  // onChanged: (s) => model.search(s, context),
                  // decoration: InputDecoration(
                  locale.get(
                      model.chatType == 0 ? 'Search user' : 'Create New Group'),
                  // border: InputBorder.none,
                  // disabledBorder: null,
                  // enabledBorder: null,
                  // focusedBorder: null,
                  // focusedErrorBorder: null),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildChatTypeRow(BuildContext context, ChatPageModel model) {
    final locale = AppLocalizations.of(context);
    final isEnglish =
        Provider.of<AppLanguageModel>(context, listen: false).appLocal ==
            Locale('en');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Opacity(
          opacity: model.chatType == 0 ? 1 : .4,
          child: InkWell(
            onTap: () =>
                model.chatType == 1 ? model.changeChatType(chatType: 0) : {},
            child: Container(
              width: ScreenUtil.screenWidthDp / 4,
              height: 28,
              padding: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                      left: isEnglish ? Radius.circular(8) : Radius.circular(0),
                      right:
                          isEnglish ? Radius.circular(0) : Radius.circular(8)),
                  border: Border.all(color: Colors.grey),
                  color: model.chatType == 0 ? Colors.grey[400] : Colors.white),
              child: Text(
                locale.get('PERSONAL') ?? 'PERSONAL',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xff1d2022)),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: model.chatType == 1 ? 1 : .4,
          child: InkWell(
            onTap: () =>
                model.chatType == 0 ? model.changeChatType(chatType: 1) : {},
            child: Container(
              width: ScreenUtil.screenWidthDp / 4,
              height: 28,
              padding: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(!isEnglish ? 8 : 0),
                      right: Radius.circular(!isEnglish ? 0 : 8)),
                  border: Border.all(color: Colors.grey),
                  color: model.chatType == 1 ? Colors.grey[400] : Colors.white),
              child: Text(
                locale.get('GROUPS') ?? 'GROUPS',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xff1d2022)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPersonChatList(BuildContext context, ChatPageModel model) {
    return Expanded(
      child: StreamProvider<QuerySnapshot>(
        create: (c) => FireStoreService.getUserCreatedChats(),
        updateShouldNotify: (a, b) => true,
        builder: (c, s) => Consumer<QuerySnapshot>(
          builder: (context, snap1, _) {
            return StreamProvider<QuerySnapshot>(
              create: (c) => FireStoreService.getUserChats(),
              updateShouldNotify: (a, b) => true,
              builder: (c, s) => Consumer<QuerySnapshot>(
                builder: (context, snap2, _) {
                  if (snap1 != null && snap2 != null) {
                    final List<DocumentSnapshot> allSnaps = []
                      ..addAll(snap1.documents)
                      ..addAll(snap2.documents);
                    /* allSnaps.sort((s1, s2) {
                      print(s2['updatedAt']);
                      print(s1['updatedAt']);
                      return (s2['updatedAt'] as Timestamp)
                          .toDate()
                          .millisecondsSinceEpoch
                          .compareTo((s1['updatedAt'] as Timestamp)
                              .toDate()
                              .millisecondsSinceEpoch);
                    }); */

                    return allSnaps.length > 0
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: allSnaps.length,
                            itemBuilder: (context, index) {
                              final chat = allSnaps[index].data ?? {};
                              final updatedAt = chat['updatedAt'] as Timestamp;
                              final createdBy = chat['userId1'] ==
                                  FireStoreService.userPersonId;
                              final lastSeen =
                                  Preference.getInt(chat['chatId']);
                              count++;
                              bool bullet = (lastSeen != null &&
                                          ((updatedAt
                                                      ?.toDate()
                                                      ?.millisecondsSinceEpoch ??
                                                  -1) >
                                              lastSeen) ||
                                      (updatedAt
                                                  ?.toDate()
                                                  ?.millisecondsSinceEpoch !=
                                              null &&
                                          lastSeen == null)) &&
                                  count == 1;
                              print('show bullet $bullet');
                              // print(
                              //     'document  updated at ${updatedAt?.toDate()?.millisecondsSinceEpoch}');
                              // print(
                              //     'prefrence updated at ${Preference.getInt(chat['chatId'])}\n\n\n\n');

                              return StatefulBuilder(
                                builder: (ctx, setStater) => ListTile(
                                  onTap: () async {
                                    Preference.setInt(chat['chatId'],
                                        DateTime.now().millisecondsSinceEpoch);

                                    await UI.push(
                                      context,
                                      PersonChatPage(
                                          person: true,
                                          chatId: chat['chatId'],
                                          chatName: chat[!createdBy
                                                  ? 'fullname1'
                                                  : 'fullname2'] ??
                                              'User'),
                                    );
                                    Preference.setInt(chat['chatId'],
                                        DateTime.now().millisecondsSinceEpoch);
                                    setStater(() {
                                      bullet = false;
                                      count = 0;
                                    });
                                    print('show bullet inn $bullet');
                                  },
                                  leading: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            AppColors.primaryElement,
                                        maxRadius: 30,
                                        child: Text(
                                            chat[!createdBy
                                                    ? 'initials1'
                                                    : 'initials2'] ??
                                                'U',
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.white)),
                                      ),
                                      if (bullet)
                                        Positioned(
                                          right: 4,
                                          bottom: 0,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.yellow,
                                            radius: 8,
                                          ),
                                        )
                                    ],
                                  ),
                                  title: Text(
                                      chat[!createdBy ? 'name' : 'fullname2'] ??
                                          'Full user name',
                                      style: TextStyle(
                                          color: AppColors.secondaryText)),
                                  contentPadding: EdgeInsets.all(6),
                                  // subtitle: Text(
                                  //   index >= snap1.documents.length
                                  //       ? snap2.documents[index - snap1.documents.length].data['data']
                                  //       : snap1.documents[index].data['data'],
                                  //   style: TextStyle(color: Colors.grey),
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                  trailing: Text(
                                      buildChatTime(context, updatedAt),
                                      style: TextStyle(color: Colors.grey)),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_pin,
                                    color: AppColors.primaryElement, size: 50),
                                Text(
                                  AppLocalizations.of(context).get(
                                          'no chats available! start adding now') ??
                                      'no chats available! start adding now',
                                ),
                              ],
                            ),
                          );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGroupChatList(BuildContext context, ChatPageModel model) {
    return Expanded(
      child: StreamBuilder(
        stream: model.getUserMemberGroup,
        builder: (c, snap1) {
          if (!snap1.hasData || snap1?.data?.documents == null) {
            return LoadingIndicator();
          } else {
            final List<String> groupIds = snap1.data.documents
                .map<String>((o) => (o['chatId'] as String))
                .toList();
            print('groupIds' + ' $groupIds');
            return (groupIds == null || groupIds.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_pin,
                            color: AppColors.primaryElement, size: 50),
                        Text(
                          AppLocalizations.of(context).get(
                                  'no chats available! start adding now') ??
                              'no chats available! start adding now',
                        ),
                      ],
                    ),
                  )
                : StreamBuilder(
                    stream: FireStoreService.getUserGroups(groupIds),
                    builder: (c, snap2) {
                      if (snap2 != null && snap2?.data?.documents != null) {
                        print(snap2?.data?.documents ?? '');
                        snap2.data.documents.sort((s1, s2) {
                          return (s2['updatedAt'] as Timestamp)
                              .toDate()
                              .millisecondsSinceEpoch
                              .compareTo((s1['updatedAt'] as Timestamp)
                                  .toDate()
                                  .millisecondsSinceEpoch);
                        });
                        return snap2.data.documents.length > 0
                            ? ListView.separated(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                separatorBuilder: (context, index) => Divider(),
                                itemCount: snap2.data.documents.length,
                                itemBuilder: (context, index) {
                                  final group = snap2.data.documents[index];
                                  final updatedAt =
                                      group['updatedAt'] as Timestamp;

                                  bool bullet = (Preference.getInt(
                                              group['chatId']) !=
                                          null &&
                                      (updatedAt
                                                  ?.toDate()
                                                  ?.millisecondsSinceEpoch ??
                                              -1) >
                                          Preference.getInt(group['chatId']));
                                  // print('show bullet $bullet');
                                  // print(
                                  //     'document  updated at ${updatedAt?.toDate()?.millisecondsSinceEpoch}');
                                  // print(
                                  //     'prefrence updated at ${Preference.getInt(group['chatId'])}\n\n\n\n');

                                  return StatefulBuilder(
                                      builder: (ctx, setStater) => ListTile(
                                          onTap: () async {
                                            Preference.setInt(
                                                group['chatId'],
                                                updatedAt
                                                    ?.toDate()
                                                    ?.millisecondsSinceEpoch);

                                            await UI.push(
                                              context,
                                              PersonChatPage(
                                                  person: false,
                                                  chatId: group['chatId'],
                                                  chatName:
                                                      group['name'] ?? 'group'),
                                            );
                                            setStater(() {
                                              bullet = false;
                                            });
                                          },
                                          leading: Stack(
                                            children: [
                                              RoundedWidget(
                                                raduis: 40,
                                                child: Container(
                                                  color:
                                                      AppColors.primaryElement,
                                                  child: Icon(Icons.person,
                                                      color: Colors.white),
                                                  width: 55,
                                                  height: 55,
                                                ),
                                              ),
                                              if (bullet)
                                                Positioned(
                                                  right: 4,
                                                  bottom: 0,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.yellow,
                                                    radius: 8,
                                                  ),
                                                )
                                            ],
                                          ),
                                          title: Text(group['name'] ?? '',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.secondaryText)),
                                          contentPadding: EdgeInsets.all(6),
                                          trailing: Text(
                                              buildChatTime(context, updatedAt),
                                              style: TextStyle(
                                                  color: Colors.grey))));
                                })
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person_pin,
                                        color: AppColors.primaryElement,
                                        size: 50),
                                    Text(
                                      AppLocalizations.of(context).get(
                                              'no chats available! start adding now') ??
                                          'no chats available! start adding now',
                                    ),
                                  ],
                                ),
                              );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  );
          }
        },
      ),
    );
  }

  String buildChatTime(BuildContext context, Timestamp updatedAt) {
    final locale = AppLocalizations.of(context);
    String time = '..';

    if (updatedAt?.microsecondsSinceEpoch != null) {
      final diff = updatedAt.toDate().difference(DateTime.now()).inDays;
      if (diff == 0) {
        time = DateFormat('HH:mm').format(updatedAt.toDate());
      } else if (diff == 1) {
        time = locale.get('yesterday');
      } else {
        print(updatedAt.toDate());
        time = updatedAt.toDate().toString().split(" ")[0];
        print(time);
      }
    }

    return time;
  }
}

class ChatPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final getUserMemberGroup = FireStoreService.getUserMemberGroup();
  int chatType = 0;
  ChatPageModel({NotifierState state, this.api, this.auth})
      : super(state: state);

  changeChatType({int chatType}) {
    this.chatType = chatType;
    setState();
  }

  search(String s, BuildContext context) {}
}

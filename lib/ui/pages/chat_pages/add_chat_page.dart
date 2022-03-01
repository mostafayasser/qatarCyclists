import 'package:base_notifier/base_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:ui_utils/ui_utils.dart';

class AddChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<AddChatPageModel>.staticBuilder(
            model: AddChatPageModel(auth: Provider.of(context)),
            staticBuilder: (context, model) {
              return Container(
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp,
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  buildHeaderColor(context),
                  buildPersonsData(context, model),
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

  buildPersonsData(BuildContext context, AddChatPageModel model) {
    final locale = AppLocalizations.of(context);

    return Expanded(
        child: StreamProvider<QuerySnapshot>(
      create: (c) => FireStoreService.getPersons(),
      updateShouldNotify: (a, b) => true,
      builder: (c, s) => Consumer<QuerySnapshot>(
        builder: (context, snap, _) {
          return BaseWidget<AddChatPageModel>.cosnume(
            builder: (context, model, child) {
              if (snap != null && model.friendsList != null) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snap.documents.length,
                  itemBuilder: (context, index) {
                    final person = snap.documents[index].data;
                    final you =
                        person['objectId'] == FireStoreService.userPersonId;
                    final added = model.friendsList.any(
                        (o) => model.friendsList.contains(person['objectId']));

                    return ListTile(
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
                          person['name'] ??
                              person['fullname'] ??
                              'Qatar Cyclists User',
                          style: TextStyle(color: AppColors.secondaryText)),
                      contentPadding: EdgeInsets.all(6),
                      trailing: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        onPressed: model.busy || you || added
                            ? null
                            : () => model.addPerson(context, person),
                        child: model.busy
                            ? Container(
                                height: 20,
                                width: 20,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : Text(
                                locale.get(you
                                    ? 'you'
                                    : added
                                        ? 'friend'
                                        : 'add'),
                                style:
                                    TextStyle(color: AppColors.accentElement),
                              ),
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
}

class AddChatPageModel extends BaseNotifier {
  final AuthenticationService auth;
  var friendsList = [];
  AddChatPageModel({this.auth}) {
    setState(notifyListener: false, state: NotifierState.busy);
    loadFriends();
  }

  addPerson(BuildContext context, Map person) async {
    final locale = AppLocalizations.of(context);
    setBusy();

    final exist = friendsList.contains(person['objectId']);

    if (exist) {
      UI.toast((person['fullname'] ?? 'person') +
          ' ' +
          locale.get('is Already a friend'));
      setIdle();
      return;
    } else {
      try {
        await FireStoreService.createSingleChat(
            name1: auth.user.name,
            name2: person['fullname'],
            userId1: FireStoreService.userPersonId,
            userId2: person['objectId']);
        await FireStoreService.addFriend(
            userId1: FireStoreService.userPersonId,
            userId2: person['objectId']);
        friendsList.add(person['objectId']);

        UI.toast(locale.get('added to chat list'));
      } catch (e) {
        Logger().e('error in  method $e');
        UI.toast(locale.get('please try again'));
      }
    }
    setIdle();
  }

  loadFriends() async {
    final friendsList = await FireStoreService.friendsList();
    for (var friend in friendsList) {
      this.friendsList.add(friend.data['friendId']);
      this.friendsList.add(friend.data['userId']);
    }
    this.friendsList = this.friendsList.toSet().toList();
    setIdle();
  }
}

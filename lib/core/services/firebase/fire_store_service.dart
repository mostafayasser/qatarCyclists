import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:qatarcyclists/core/models/chat_message.dart';
import 'package:qatarcyclists/core/models/chat_person.dart';
import 'package:qatarcyclists/core/models/friend.dart';
import 'package:qatarcyclists/core/models/group_chat.dart';
import 'package:qatarcyclists/core/models/group_member.dart';
import 'package:qatarcyclists/core/models/single_chat.dart';
import 'package:qatarcyclists/core/models/user.dart';

class FireStoreService {
  static String userPersonId;

  // Collection reference
  static final CollectionReference detailCollection =
      Firestore.instance.collection('Detail');
  static final CollectionReference friendCollection =
      Firestore.instance.collection('Friend');
  static final CollectionReference groupCollection =
      Firestore.instance.collection('Group');
  static final CollectionReference memberCollection =
      Firestore.instance.collection('Member');
  static final CollectionReference messageCollection =
      Firestore.instance.collection('Message');
  static final CollectionReference personCollection =
      Firestore.instance.collection('Person');
  static final CollectionReference singleCollection =
      Firestore.instance.collection('Single');

  static updateUserChatTime(String chatID) async {
    await singleCollection
        .document(chatID)
        .updateData({'updatedAt': FieldValue.serverTimestamp()});
    // final chat = await singleCollection.document(chatID).get();
  }

  static updateGroupChatTime(String chatID) async {
    await groupCollection
        .document(chatID)
        .updateData({'updatedAt': FieldValue.serverTimestamp()});
    // final chat = await groupCollection.document(chatID).get();
    // if (chat.data['updatedAt'] != null) {
    //   final timeStamp = (chat.data['updatedAt'] as Timestamp).toDate().millisecondsSinceEpoch;
    //   Preference.setInt(chatID, timeStamp + 20000);
    // }
  }

  static createNewUser(User user) async {
    return await personCollection
        .document(user.id.toString())
        .setData(user.toJson(chat: true));
  }

  // update userdata
  static Future updateUserData(ChatPerson chatPerson) async {
    print('userPersonId:$userPersonId');
    try {
      print(chatPerson.toJson());
      return await personCollection
          .document(userPersonId)
          .setData(chatPerson.toJson());
    } catch (e) {
      print(e);
    }
  }

  static void updateFCMToken(token) async {
    return await personCollection
        .document(userPersonId)
        .updateData({"fcmToken": token});
  }

  static Stream<QuerySnapshot> getUserCreatedChats() {
    return singleCollection
        .where('userId1', isEqualTo: userPersonId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getUserChats() {
    print(userPersonId);
    return singleCollection
        .where('userId2', isEqualTo: userPersonId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getUserFriends() {
    return friendCollection
        .where('userId', isEqualTo: userPersonId)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getPersons() {
    return personCollection.snapshots();
  }

  static Future<bool> chatAlreadyExist({String userId1, String userId2}) async {
    final chats = await singleCollection
        .where('userId1', isEqualTo: userId1)
        .where('userId2', isEqualTo: userId2)
        .getDocuments();
    final chats2 = await singleCollection
        .where('userId2', isEqualTo: userId1)
        .where('userId1', isEqualTo: userId2)
        .getDocuments();

    print(chats.documents.length);
    print(chats2.documents.length);

    return chats.documents.isNotEmpty || chats2.documents.isNotEmpty;
  }

  static Future<List<String>> getFriendToken(String chatId) async {
    var chatDoc = await singleCollection.document(chatId).get();
    var id1 = chatDoc.data["userId1"];
    var id2 = chatDoc.data["userId2"];
    print(userPersonId);
    var friendDoc;
    List<String> tokens = [];

    if (id1 == userPersonId) {
      friendDoc = await personCollection.document(id2).get();
      tokens.add(friendDoc.data["fcmToken"]);
    } else {
      friendDoc = await personCollection.document(id1).get();
      tokens.add(friendDoc.data["fcmToken"]);
    }

    return tokens;
  }

  static Future<List<String>> getGroupMembersTokens(String chatId) async {
    List<String> tokens = [];
    var docs = await memberCollection
        .where("chatId", isEqualTo: chatId)
        .getDocuments();
    for (int i = 0; i < docs.documents.length; i++) {
      if (docs.documents[i].data["userId"] != userPersonId) {
        var doc = await personCollection
            .document(docs.documents[i].data["userId"])
            .get();
        tokens.add(doc.data["fcmToken"]);
      }
    }

    return tokens;
  }

  static Future createSingleChat(
      {@required String name1,
      @required String name2,
      @required String userId1,
      @required String userId2}) async {
    final dr = singleCollection.document();

    final singleChat = SingleChat.fromUser(
        chatId: dr.documentID,
        name1: name1,
        name2: name2,
        userId1: userId1,
        userId2: userId2);

    await dr.setData(singleChat.toJson());
  }

  static Stream<QuerySnapshot> getChatMessages({@required String chatId}) {
    return messageCollection
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt', descending: true)
        .snapshots();

    //TODo paginate
    //   List<DocumentSnapshot> newDocumentList = (await Firestore.instance
    //         .collection("movies")
    //         .orderBy("rank")
    //         .startAfterDocument(documentList[documentList.length - 1])
    //         .limit(10)
    //         .snapshots())
    //     .documents;
    // documentList.addAll(newDocumentList);
    // movieController.sink.add(documentList);
  }

  static StreamSubscription<QuerySnapshot> getChatMessagesList(
      {@required String chatId, Function(QuerySnapshot) onData}) {
    return messageCollection
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt')
        .snapshots()
        .listen((data) => onData(data));
  }

  // search groups
  static Future createChatMessage(
      {@required String text,
      @required String chatId,
      @required String userFullname}) async {
    final dr = messageCollection.document();

    final singleChat = ChatMessage.fromText(
      text: text,
      chatId: chatId,
      userId: userPersonId,
      objectId: dr.documentID,
      userFullname: userFullname,
    );

    await dr.setData(singleChat.toJson());
  }

  static void shareLocationMessage({
    @required String chatId,
    @required String userFullname,
    @required double lat,
    @required double long,
  }) async {
    final dr = messageCollection.document();
    final singleChat = ChatMessage.fromLocation(
      chatId: chatId,
      userId: userPersonId,
      objectId: dr.documentID,
      userFullname: userFullname,
      lat: lat,
      long: long,
    );

    await dr.setData(singleChat.toJson());
  }

  static Future<DocumentReference> createChatMedia(
      {@required String chatId,
      @required String userFullname,
      @required String fileType,
      int width,
      int height,
      var duration}) async {
    final dr = messageCollection.document();

    if (fileType == "video") {
      final singleChat = ChatMessage.fromVideo(
          chatId: chatId,
          userId: userPersonId,
          objectId: dr.documentID,
          userFullname: userFullname,
          height: height,
          width: width,
          duration: duration);

      await dr.setData(singleChat.toJson());
    } else if (fileType == "image") {
      final singleChat = ChatMessage.fromImage(
        chatId: chatId,
        userId: userPersonId,
        objectId: dr.documentID,
        userFullname: userFullname,
        width: width,
        height: height,
      );
      //Logger().i(singleChat.toJson());
      await dr.setData(singleChat.toJson());
    } else {
      final singleChat = ChatMessage.fromAudio(
          chatId: chatId,
          userId: userPersonId,
          objectId: dr.documentID,
          userFullname: userFullname,
          duration: duration);
      await dr.setData(singleChat.toJson());
    }
    return dr;
  }

  static void deleteMessage(String id) {
    messageCollection.document(id).delete();
  }

  static Stream<QuerySnapshot> getUserMemberGroup() {
    return memberCollection
        .where('userId', isEqualTo: userPersonId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getUserGroups(List<String> groupIds) {
    return Firestore.instance
        .collection('Group')
        .where('chatId', whereIn: groupIds ?? [])
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  static Future createUserGroup(
      {@required String groupName, @required List<String> membersIds}) async {
    final dr = groupCollection.document();
    final groupChat = GroupChat.fromUser(
        chatId: dr.documentID, name: groupName, ownerId: userPersonId);

    await dr.setData(groupChat.toJson());

    membersIds.add(userPersonId);

    //add selected users to group
    for (String memberId in membersIds) {
      final memberDR = memberCollection.document();
      final groupMember = GroupMember.fromUser(
          chatId: groupChat.chatId,
          userId: memberId,
          objectId: memberDR.documentID);
      await memberDR.setData(groupMember.toJson());
    }
    return;
  }

  static Future<List<DocumentSnapshot>> friendsList() async {
    var doc = await friendCollection
        .where('userId', isEqualTo: userPersonId)
        .getDocuments();
    var doc1 = await friendCollection
        .where('friendId', isEqualTo: userPersonId)
        .getDocuments();

    final List<DocumentSnapshot> friends = []
      ..addAll(doc.documents)
      ..addAll(doc1.documents);
    return friends;
  }

  static addFriend({@required String userId1, @required String userId2}) async {
    final dr = friendCollection.document();
    final friend = Friend.fromUser(
        userId: userId1, friendId: userId2, objectId: dr.documentID);
    await dr.setData(friend.toJson());

    await dr.get().then((value) => print(value.data));
  }
}

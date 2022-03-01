import 'dart:async';
import 'dart:io';

import 'package:base_notifier/base_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/core/services/permession/permessions.dart';
import 'package:qatarcyclists/core/services/preference/preference.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/chat_image.dart';
import 'package:qatarcyclists/ui/widgets/chat_message.dart';
import 'package:qatarcyclists/ui/widgets/chat_video.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:qatarcyclists/ui/widgets/location_message.dart';
import 'package:qatarcyclists/ui/widgets/record_widget.dart';
import 'package:qatarcyclists/ui/widgets/voice_message.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/services/firebase/fire_storage_service.dart';

class PersonChatPage extends StatelessWidget {
  final String chatId;
  final String chatName;
  final bool person;
  const PersonChatPage(
      {Key key, @required this.chatId, @required this.chatName, this.person})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("chatId: $chatId");
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<PersonChatPageModel>.staticBuilder(
            model: PersonChatPageModel(
                person: person,
                api: Provider.of(context),
                auth: Provider.of(context),
                chatId: chatId),
            staticBuilder: (context, model) {
              return Container(
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    buildHeaderColor(context),
                    if (model.busy) buildLoadingData(context),
                    if (!model.busy) buildChatDataNew(context, model),
                    buildChatActioins(context, model, person),
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
    return HeaderColor(
        hasBack: true,
        hasTitle: true,
        titleImage: 'chat.png',
        title: chatName ?? '');
  }

  Widget buildChatDataNew(BuildContext context, PersonChatPageModel model) {
    return Expanded(child: BaseWidget<PersonChatPageModel>.cosnume(
      builder: (context, model, child) {
        if (model.chatMessages != null) {
          return model.chatMessages.length > 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  itemCount: model.chatMessages.length,
                  itemBuilder: (context, index) {
                    final timeFormatter = DateFormat('HH:mm');
                    final message = model.chatMessages.toList()[index].data;
                    final createdAt = message['createdAt'] as Timestamp;
                    final id = message['objectId'];

                    return message["type"] == "text"
                        ? ChatMessage(
                            id: id,
                            key: Key(id),
                            senderName: message['userFullname'],
                            msg: message['text'] ?? '',
                            sent: message['userId'] ==
                                FireStoreService.userPersonId,
                            time: createdAt?.microsecondsSinceEpoch != null
                                ? timeFormatter.format(createdAt.toDate())
                                : '..',
                          )
                        : message["type"] == 'image'
                            ? ChatImageMessage(
                                id: id,
                                key: Key(id),
                                senderName: message['userFullname'],
                                url: message["mediaUrl"],
                                sent: message['userId'] ==
                                    FireStoreService.userPersonId,
                                time: createdAt?.microsecondsSinceEpoch != null
                                    ? timeFormatter.format(createdAt.toDate())
                                    : '..',
                              )
                            : message["type"] == 'video'
                                ? ChatVideoMessage(
                                    id: id,
                                    key: Key(id),
                                    documentID: id,
                                    senderName: message['userFullname'],
                                    url: message["mediaUrl"],
                                    sent: message['userId'] ==
                                        FireStoreService.userPersonId,
                                    width: message["videoWidth"],
                                    height: message["videoHeight"],
                                    time: createdAt?.microsecondsSinceEpoch !=
                                            null
                                        ? timeFormatter
                                            .format(createdAt.toDate())
                                        : '..',
                                  )
                                : message["type"] == 'audio'
                                    ? VoiceMessage(
                                        id: id,
                                        documentID: id,
                                        key: Key(id),
                                        audioLength:
                                            "${message["audioDuration"]}",
                                        senderName: message['userFullname'],
                                        mediaUrl: message["mediaUrl"],
                                        sent: message['userId'] ==
                                            FireStoreService.userPersonId,
                                        time:
                                            createdAt?.microsecondsSinceEpoch !=
                                                    null
                                                ? timeFormatter
                                                    .format(createdAt.toDate())
                                                : '..',
                                      )
                                    : message["text"] == 'Location message'
                                        ? LocationMessage(
                                            id: id,
                                            key: Key(id),
                                            lat: message["latitude"],
                                            long: message["longitude"],
                                            senderName: message['userFullname'],
                                            sent: message['userId'] ==
                                                FireStoreService.userPersonId,
                                            time: createdAt
                                                        ?.microsecondsSinceEpoch !=
                                                    null
                                                ? timeFormatter
                                                    .format(createdAt.toDate())
                                                : '..',
                                          )
                                        : Container();
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
                                'this is the start of your conversation') ??
                            'this is the start of your conversation',
                      ),
                    ],
                  ),
                );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingIndicator(),
              ],
            ),
          );
        }
      },
    ));
  }

  buildChatActioins(
      BuildContext context, PersonChatPageModel model, bool person) {
    final locale = AppLocalizations.of(context);

    return BaseWidget<PersonChatPageModel>.cosnume(
        builder: (context, model, child) {
      return Container(
        height: MediaQuery.of(context).size.height > 890 ? 120 : 80,
        margin: EdgeInsets.all(10),
        child: model.recording
            ? RecordWidget(
                onSend: (time) => model.sendRecording(context, chatId, person),
                onCancel: () => model.cancelRecord())
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.grey),
                      onPressed: () =>
                          model.sendMedia(context, chatId, person)),
                  IconButton(
                      icon: Icon(Icons.add_location, color: Colors.grey),
                      onPressed: () =>
                          model.shareLocation(context, chatId, person)),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            width: 2,
                            color: Colors.grey[300],
                            style: BorderStyle.solid)),
                    child: TextField(
                      controller: model.messageController,
                      onChanged: (s) => model.setState(),
                      decoration: InputDecoration(
                          hintText:
                              locale.get('enter message') ?? 'enter message',
                          border: InputBorder.none,
                          disabledBorder: null,
                          enabledBorder: null,
                          focusedBorder: null,
                          focusedErrorBorder: null),
                    ),
                  )),
                  model.messageController.text.isEmpty
                      ? IconButton(
                          onPressed: () => model.startRecording(context),
                          icon: Icon(Icons.mic,
                              color: model.recording
                                  ? AppColors.primaryElement
                                  : Colors.grey),
                        )
                      : IconButton(
                          hoverColor: Colors.black,
                          icon: Icon(Icons.send,
                              size: 20,
                              color: model.messageController.text.isEmpty
                                  ? Colors.grey
                                  : AppColors.primaryElement),
                          onPressed: () =>
                              model.sendMessage(context, chatId, person),
                        )
                ],
              ),
      );
    });
  }
}

class PersonChatPageModel extends BaseNotifier {
  final HttpApi api;
  final String chatId;
  final bool person;
  final AuthenticationService auth;
  List<DocumentSnapshot> chatMessages;
  Recording record;
  FlutterAudioRecorder recorder;
  RecordingStatus recordingStatus = RecordingStatus.Unset;
  bool sending = false;
  bool uploading = false;
  bool recording = false;
  StreamSubscription chatUpdate;
  List<String> tokens;

  final messageController = TextEditingController();

  final supportedFileTypes = ['image', 'video'];

  PersonChatPageModel({this.person, this.chatId, this.api, this.auth}) {
    initChat();
  }

  initChat() async {
    chatUpdate = FireStoreService.getChatMessagesList(
        chatId: chatId,
        onData: (data) {
          if (data.documentChanges.isNotEmpty) {
            for (DocumentChange change in data.documentChanges) {
              if (chatMessages == null) {
                chatMessages = [];
              }
              try {
                if (change.type == DocumentChangeType.added) {
                  chatMessages.insert(0, change.document);
                  if (change.document.data['updatedAt'] != null) {
                    final timeStamp =
                        (change.document.data['updatedAt'] as Timestamp)
                            .toDate()
                            .millisecondsSinceEpoch;
                    Preference.setInt(chatId, timeStamp + 54259);
                  }
                } else if (change.type == DocumentChangeType.modified) {
                  DocumentSnapshot doc = chatMessages.firstWhere(
                      (o) => o.documentID == change.document.documentID,
                      orElse: () => null);
                  if (doc != null) {
                    final index = chatMessages.indexOf(doc);
                    chatMessages[index] = change.document;
                    if (change.document.data['updatedAt'] != null) {
                      final timeStamp =
                          (change.document.data['updatedAt'] as Timestamp)
                              .toDate()
                              .millisecondsSinceEpoch;
                      Preference.setInt(chatId, timeStamp + 54259);
                    }
                  }
                } else if (change.type == DocumentChangeType.removed) {
                  chatMessages.removeWhere(
                    (o) => o.documentID == change.document.documentID,
                  );
                }

                setState();
              } catch (e) {
                print(e);
              }
            }
          } else if (chatMessages == null) {
            chatMessages = [];
            setState();
          }
        });
  }

  Future<List<String>> get getTokens async {
    if (tokens == null) {
      tokens = person
          ? await FireStoreService.getFriendToken(chatId)
          : await FireStoreService.getGroupMembersTokens(chatId);
    }
    return tokens;
  }

  sendMessage(BuildContext context, String chatId, person) async {
    if (messageController.text.isNotEmpty) {
      try {
        if (person) {
          FireStoreService.updateUserChatTime(chatId);
        } else {
          FireStoreService.updateGroupChatTime(chatId);
        }
        FireStoreService.createChatMessage(
            text: messageController.text,
            chatId: chatId,
            userFullname: auth.user.name);
        final mess = messageController.text;
        messageController.clear();
        api.sendNotification(
            chatId: chatId,
            group: !person,
            tokens: await getTokens,
            body: mess,
            title: auth.user.name);
      } catch (e) {}
      // setState();
    }
  }

  sendMedia(BuildContext context, String chatId, person) async {
    File file;
    final locale = AppLocalizations.of(context);

    try {
      final source = await _showMediaDialog(context);

      if (source == null) {
        return;
      }

      if (source == ImageSource.gallery) {
        file = await FilePicker.getFile(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'mp4'],
        );
      } else {
        final pickedFile = await ImagePicker().getImage(source: source);
        if (pickedFile == null) return;

        file = File(pickedFile.path);
      }

      if (file == null) {
        UI.toast(locale.get('canceled'));
        uploading = false;
        return;
      }

      //check file type
      final fileType = checkFileType(file);

      //check file type supported
      if (!supportedFileTypes.contains(fileType)) {
        UI.toast(locale.get('unsupported file type'));
        uploading = false;
        return;
      }

      //if video get video lenth
      double duration;
      int videoHeight, videoWidth;
      var decodedImage;
      if (fileType == "video") {
        final videoInfo = FlutterVideoInfo();

        var info = await videoInfo.getVideoInfo(file.absolute.path);
        duration = info.duration;
        videoHeight = info.height;
        videoWidth = info.width;
      } else {
        decodedImage = await decodeImageFromList(file.readAsBytesSync());
        print(decodedImage.width);
        print(decodedImage.height);
      }

      //create message document wtih required data
      final message = await FireStoreService.createChatMedia(
          chatId: chatId,
          userFullname: auth.user.name,
          fileType: fileType,
          width: (fileType == "video") ? videoWidth : decodedImage.width,
          height: (fileType == "video") ? videoHeight : decodedImage.height,
          duration: (fileType == "image") ? null : duration);

      //upload file and get url

      // update document with the new file url
      final fileUploadTask = FireStorageService().uploadFileToStorage(
          fileId: message.documentID, file: file, directories: ['media']);

      final fileUrl =
          await (await fileUploadTask.onComplete).ref.getDownloadURL();

      message.updateData({"mediaUrl": fileUrl});
      if (person) {
        await FireStoreService.updateUserChatTime(chatId);
      } else {
        await FireStoreService.updateGroupChatTime(chatId);
      }

      api.sendNotification(
          chatId: chatId,
          group: !person,
          tokens: await getTokens,
          body: "media message",
          title: auth.user.name);

      setState();
    } catch (e) {
      print(e);
      UI.toast(locale.get('failed'));
    }
  }

  Future<ImageSource> _showMediaDialog(BuildContext context) async {
    return await showDialog<ImageSource>(
        context: context,
        builder: (ctx) {
          final locale = AppLocalizations.of(context);

          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              locale.get('Choose From') ?? 'Choose From',
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(locale.get('Camera') ?? 'Camera'),
                onPressed: () async {
                  Navigator.of(ctx).pop(ImageSource.camera);
                },
              ),
              SimpleDialogOption(
                child: Text(locale.get('Gallery') ?? 'Gallery'),
                onPressed: () async {
                  Navigator.of(ctx).pop(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  shareLocation(context, chatId, person) async {
    double lat = 25.3548, long = 51.1839;

    final sent = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      padding: EdgeInsets.only(top: 25),
                      mapToolbarEnabled: false,
                      onCameraMove: (cp) {
                        lat = cp.target.latitude;
                        long = cp.target.longitude;
                      },
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      initialCameraPosition: CameraPosition(
                        zoom: 10,
                        tilt: 10,
                        target: LatLng(
                          lat ?? 29.2,
                          long ?? 29.2,
                        ),
                      ),
                    ),
                    Icon(Icons.location_on, color: AppColors.primaryElement)
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  print("$lat andddd $long ");
                  if (lat == null || long == null) {
                    UI.toast('getting location please wait');
                    return;
                  }
                  FireStoreService.shareLocationMessage(
                      chatId: chatId,
                      userFullname: auth.user.name,
                      lat: lat,
                      long: long);

                  Navigator.of(context).pop(true);
                },
                child: Text("Send location"),
              )
            ],
          ),
        ),
      ),
    );

    if (sent != null && sent) {
      api.sendNotification(
          chatId: chatId,
          group: !person,
          tokens: await getTokens,
          body: "media message",
          title: auth.user.name);

      if (person) {
        FireStoreService.updateUserChatTime(chatId);
      } else {
        FireStoreService.updateGroupChatTime(chatId);
      }
    }
  }

  String checkFileType(File file) {
    String mimeStr = lookupMimeType(file.path);
    var fileFromat = mimeStr.split('/');

    final fileType =
        fileFromat.firstWhere((o) => supportedFileTypes.contains(o));
    print('file type $fileType');
    return fileType;
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await recorder.initialized;
        // after initialization
        var current = await recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        record = current;
      } else {
        print("elseeee");
      }
    } catch (e) {
      print(e);
    }
  }

  sendRecording(BuildContext context, String chatId, bool person) async {
    print(record.duration);
    if (record == null) return;
    print("innnnn");
    File file;

    try {
      await stopRecording(context);

      file = File(record.path);

      //create message document wtih required data
      final message = await FireStoreService.createChatMedia(
          fileType: 'audio',
          chatId: chatId,
          userFullname: auth.user.name,
          duration: record.duration.inSeconds);

      //upload file and get url

      // update document with the new file url
      final fileUploadTask = FireStorageService().uploadFileToStorage(
          fileId: message.documentID, file: file, directories: ['media']);
      final fileUrl =
          await (await fileUploadTask.onComplete).ref.getDownloadURL();

      message.updateData({"mediaUrl": fileUrl});
      api.sendNotification(
          chatId: chatId,
          group: !person,
          tokens: await getTokens,
          body: "media message",
          title: auth.user.name);

      if (person) {
        FireStoreService.updateUserChatTime(chatId);
      } else {
        FireStoreService.updateGroupChatTime(chatId);
      }
    } catch (e) {
      print(e);
      UI.toast(
          AppLocalizations.of(context).get('error occured') ?? 'error occured');
    }
    record = null;
  }

  startRecording(BuildContext context) async {
    if (recording) return;
    await _init();
    try {
      final allowed = await Permessions.getAudioPermession(context);
      final gotPermession = await FlutterAudioRecorder.hasPermissions;

      if (allowed && gotPermession) {
        await recorder.start();
        record = await recorder.current(channel: 0);

        recording = true;
        setState();
      }
    } catch (e) {
      UI.toast(
          AppLocalizations.of(context).get('error occured') ?? 'error occured');
      recording = false;
      setState();
    }
  }

  stopRecording(BuildContext context) async {
    if (!recording) return;

    try {
      record = await recorder.stop();
      print("Stop recording: ${record.path}");
      print("Stop recording: ${record.duration}");
    } catch (e) {
      UI.toast(
          AppLocalizations.of(context).get('error occured') ?? 'error occured');
    }

    recording = false;
    setState();
  }

  cancelRecord() async {
    recording = false;
    record = null;
    try {
      if (recordingStatus == RecordingStatus.Recording) {
        await recorder.stop();
      }
    } catch (e) {}
    setState();
  }

  @override
  void dispose() {
    cancelRecord();

    chatUpdate?.cancel();

    super.dispose();
  }
}

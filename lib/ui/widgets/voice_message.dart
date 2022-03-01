import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/firebase/fire_storage_service.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:ui_utils/ui_utils.dart';

class VoiceMessage extends StatelessWidget {
  final String audioLength;
  final String mediaUrl;
  final String time;
  final bool sent;
  final String documentID;

  final String senderName;
  final String id;

  const VoiceMessage({Key key, this.audioLength, this.mediaUrl, this.time, this.sent, this.id, this.senderName, this.documentID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: BaseWidget<VoiceMessageWidgetModel>(
          model: VoiceMessageWidgetModel(mediaUrl: mediaUrl, documentID: documentID),
          builder: (context, model, child) {
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
                    FireStorageService().deleteFileFromUrl(mediaUrl);
                    FireStoreService.deleteMessage(id);
                  }
                }
              },
              child: Align(
                alignment: sent ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
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
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          model.mediaUrl == null
                              ? LoadingIndicator()
                              : IconButton(
                                  icon: Icon(
                                    !model.playing ? Icons.play_arrow : Icons.pause,
                                    color: AppColors.accentElement,
                                    size: 35,
                                  ),
                                  onPressed: model.advancedPlayer == null || model.advancedPlayer.state != AudioPlayerState.PLAYING
                                      ? model.playRecord
                                      : model.advancedPlayer.state == AudioPlayerState.PLAYING ? model.pauseRecord : model.resumeAudio),
                          StreamBuilder<Duration>(
                            stream: model?.advancedPlayer?.onAudioPositionChanged,
                            initialData: Duration(),
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return LoadingIndicator();
                              }

                              return Row(
                                children: [
                                  Slider(
                                      value: snap.data.inSeconds.toDouble(),
                                      min: 0.0,
                                      inactiveColor: AppColors.accentElement.withOpacity(.2),
                                      activeColor: AppColors.accentElement,
                                      max: double.parse(audioLength),
                                      onChanged: (double value) {
                                        model.seekToSecond(value.toInt());
                                        if (value == double.parse(audioLength)) {
                                          model.atTheEnd();
                                        }
                                      }),
                                  Text(
                                    (model.advancedPlayer == null ||
                                            (model.advancedPlayer.state != AudioPlayerState.PLAYING &&
                                                model.advancedPlayer.state != AudioPlayerState.PAUSED))
                                        ? "${int.parse(audioLength) ~/ 60}:${int.parse(audioLength) % 60}"
                                        : "${snap.data.inMinutes}:${snap.data.inSeconds % 60}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Text(time, style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class VoiceMessageWidgetModel extends BaseNotifier {
  String mediaUrl;
  final String documentID;
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  var file;
  bool playing = false;
  Duration currentDuration = new Duration();
  Duration currentPosition = new Duration();
  DocumentReference voiceMessageRefrence;
  StreamSubscription<DocumentSnapshot> documentStream;
  VoiceMessageWidgetModel({this.documentID, @required this.mediaUrl}) {
    listenOnMessage();
  }

  listenOnMessage() {
    voiceMessageRefrence = FireStoreService.messageCollection.document(documentID);
    documentStream = voiceMessageRefrence.snapshots().listen((event) {
      if (event?.data['mediaUrl'] != null) {
        mediaUrl = event?.data['mediaUrl'];
        setState();
      }
    });
  }

  @override
  void dispose() {
    documentStream?.cancel();
    advancedPlayer?.stop();
    advancedPlayer?.release();
    super.dispose();
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
    notifyListeners();
  }

  atTheEnd() async {
    advancedPlayer.seek(Duration(seconds: 0));
    await advancedPlayer.release();
    playing = false;
    notifyListeners();
  }

  playRecord() async {
    if (advancedPlayer == null) {
      advancedPlayer = AudioPlayer(playerId: mediaUrl);
      audioCache = AudioCache(fixedPlayer: advancedPlayer);
    }

    advancedPlayer.onPlayerCompletion.listen((event) {
      atTheEnd();
    });
    // await advancedPlayer.release();
    if (advancedPlayer.state != AudioPlayerState.PLAYING) {
      await advancedPlayer.play(mediaUrl);

      playing = !playing;
      setState();

      // audioPlayer.onPlayerStateChanged
    }
  }

  pauseRecord() async {
    if (advancedPlayer.state == AudioPlayerState.PLAYING) {
      int result = await advancedPlayer.pause();
      print(result);
      playing = !playing;
      setState();
    }
  }

  resumeAudio() async {
    if (advancedPlayer.state == AudioPlayerState.PAUSED) {
      int result = await advancedPlayer.resume();
      print(result);
      playing = !playing;
      setState();
    }
  }
}

import 'dart:async';

import 'package:base_notifier/base_notifier.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/firebase/fire_storage_service.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:ui_utils/ui_utils.dart';

class ChatVideoMessage extends StatefulWidget {
  final String url;
  final String documentID;
  final String time;
  final bool sent;
  final String senderName;
  final String id;
  final int width;
  final int height;

  ChatVideoMessage(
      {Key key,
      this.url,
      this.time,
      this.sent,
      this.senderName,
      this.id,
      this.height,
      this.width,
      this.documentID})
      : super(key: key);

  @override
  _ChatVideoMessageState createState() => _ChatVideoMessageState();
}

class _ChatVideoMessageState extends State<ChatVideoMessage> {
  CachedVideoPlayerController _videoPlayerController;
  bool showIcon = true;
  String mediaUrl;
  bool play = true;
  DocumentReference videoMessageRefrence;
  StreamSubscription<DocumentSnapshot> documentStream;

  void intializeVideo() async {
    if (mediaUrl != null) {
      _videoPlayerController = CachedVideoPlayerController.network(mediaUrl);
      await _videoPlayerController.initialize();

      _videoPlayerController.setLooping(true);
      if (mounted) {
        setState(() {
          print('initialiazed video');
        });
      }
    }
  }

  listenOnMessage() {
    videoMessageRefrence =
        FireStoreService.messageCollection.document(widget.documentID);
    documentStream = videoMessageRefrence.snapshots().listen((event) {
      if (event?.data['mediaUrl'] != null) {
        mediaUrl = event?.data['mediaUrl'];
        intializeVideo();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.url == null) {
      listenOnMessage();
    } else {
      mediaUrl = widget.url;
    }
    intializeVideo();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    documentStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            showIcon = !showIcon;
          });
        }
      },
      onLongPress: () async {
        if (widget.sent) {
          final res = await UI.dialog(
            accept: true,
            context: context,
            title: "Delete this message",
            msg: "Are you sure you want to delete this message?",
            acceptMsg: "Delete",
            cancelMsg: "Cancel",
          );
          if (res != null && res) {
            FireStorageService().deleteFileFromUrl(mediaUrl);
            FireStoreService.deleteMessage(widget.id);
          }
        }
      },
      child: Align(
        alignment: widget.sent
            ? AlignmentDirectional.topEnd
            : AlignmentDirectional.topStart,
        child: Container(
          width: ScreenUtil.screenWidthDp / 1.2,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          alignment: AlignmentDirectional.topStart,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(17),
                topEnd: Radius.circular(17),
                bottomEnd:
                    !widget.sent ? Radius.circular(17) : Radius.circular(0),
                bottomStart:
                    widget.sent ? Radius.circular(17) : Radius.circular(0),
              ),
              color: widget.sent ? Colors.grey[400] : AppColors.primaryElement),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.sent)
                    Text(
                      widget.senderName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  AspectRatio(
                    aspectRatio: (_videoPlayerController != null)
                        ? _videoPlayerController.value.aspectRatio
                        : (widget.width ?? 16.0) / (widget.height ?? 9.0),
                    child: AnimatedCrossFade(
                      firstChild: Center(child: LoadingIndicator()),
                      secondChild: Stack(
                        alignment: Alignment.center,
                        children: _videoPlayerController != null &&
                                _videoPlayerController.value.initialized
                            ? <Widget>[
                                CachedVideoPlayer(_videoPlayerController),
                                if (showIcon && mediaUrl != null)
                                  IconButton(
                                      icon: Icon(
                                        play ? Icons.play_arrow : Icons.pause,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        play
                                            ? _videoPlayerController.play()
                                            : _videoPlayerController.pause();

                                        if (mounted) {
                                          setState(() {
                                            play = !play;
                                          });
                                        }
                                      }),
                                if (mediaUrl == null) LoadingIndicator()
                              ]
                            : [Container()],
                      ),
                      crossFadeState: _videoPlayerController == null ||
                              !(_videoPlayerController.value.initialized ??
                                  false)
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 400),
                    ),
                  ),
                  /* widget.url == null
                      ? LoadingIndicator()
                      : AspectRatio(
                          child: CachedVideoPlayer(_videoPlayerController),
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                        ), */
                  Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Text(widget.time,
                          style: TextStyle(color: Colors.white)))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class RecordWidget extends StatefulWidget {
  final Function(int) onSend;
  final Function onCancel;
  const RecordWidget({Key key, this.onSend, this.onCancel}) : super(key: key);
  @override
  _RecordWidgetState createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  int value;
  String displayTime;
  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      BlinkWidget(children: [
                        Icon(Icons.mic, color: AppColors.primaryElement),
                        Icon(Icons.mic, color: Colors.transparent),
                      ]),
                      SizedBox(width: 10),
                      StreamBuilder<int>(
                        stream: _stopWatchTimer.rawTime,
                        initialData: _stopWatchTimer.rawTime.value,
                        builder: (context, snap) {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                          value = snap.data;
                          displayTime = StopWatchTimer.getDisplayTime(value,
                              milliSecond: false, hours: false);

                          return Text(displayTime);
                        },
                      ),
                    ],
                  ),
                  FlatButton(
                      onPressed: () {
                        if (widget.onCancel != null) {
                          widget.onCancel();
                        }
                        setState(() {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                        });
                      },
                      child: Text("cancel"))
                ],
              ),
            ),
          ),
          IconButton(
            color: Colors.grey,
            icon: Icon(
              Icons.send,
              size: 25,
            ),
            onPressed: () {
              if (widget.onSend != null) {
                widget.onSend(value);
              }
              setState(() {
                _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
              });
            },
          )
        ],
      ),
    );
  }
}

class BlinkWidget extends StatefulWidget {
  final List<Widget> children;
  final int interval;

  BlinkWidget({@required this.children, this.interval = 500, Key key})
      : super(key: key);

  @override
  _BlinkWidgetState createState() => _BlinkWidgetState();
}

class _BlinkWidgetState extends State<BlinkWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  int _currentWidget = 0;

  initState() {
    super.initState();

    _controller = new AnimationController(
      duration: Duration(milliseconds: widget.interval),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (++_currentWidget == widget.children.length) {
            _currentWidget = 0;
          }
        });

        _controller.forward(from: 0.0);
      }
    });

    _controller.forward();
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.children[_currentWidget],
    );
  }
}

class RecordWidgetModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;

  RecordWidgetModel({NotifierState state, this.api, this.auth})
      : super(state: state);
}

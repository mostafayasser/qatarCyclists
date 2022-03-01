/* import 'package:audio_recorder/audio_recorder.dart';

class RecordService {
  recordAudio() async {
    // Check permissions before starting
    // bool hasPermissions = await AudioRecorder.hasPermissions;

// Get the state of the recorder
    // bool isRecording = await AudioRecorder.isRecording;

// Start recording
// await AudioRecorder.start(path: _controller.text, audioOutputFormat: AudioOutputFormat.AAC);

// Stop recording
    Recording recording = await AudioRecorder.stop();
    print(
        "Path : ${recording.path},  Format : ${recording.audioOutputFormat},  Duration : ${recording.duration},  Extension : ${recording.extension},");
  }
}
 */
// start() async {
//   try {
//     if (await AudioRecorder.hasPermissions) {
// if (_controller.text != null && _controller.text != "") {
//   String path = _controller.text;
//   if (!_controller.text.contains('/')) {
//     io.Directory appDocDirectory =
//         await getApplicationDocumentsDirectory();
//     path = appDocDirectory.path + '/' + _controller.text;
//   }
//   print("Start recording: $path");
//   await AudioRecorder.start(
//       path: path, audioOutputFormat: AudioOutputFormat.AAC);
// } else {
//         await AudioRecorder.start();
//       }
//       bool isRecording = await AudioRecorder.isRecording;
//       setState(() {
//         _recording = new Recording(duration: new Duration(), path: "");
//         _isRecording = isRecording;
//       });
//     } else {
//       Scaffold.of(context).showSnackBar(
//           new SnackBar(content: new Text("You must accept permissions")));
//     }
//   } catch (e) {
//     print(e);
//   }
// }

// _stop() async {
//   var recording = await AudioRecorder.stop();
//   print("Stop recording: ${recording.path}");
//   bool isRecording = await AudioRecorder.isRecording;
//   File file = widget.localFileSystem.file(recording.path);
//   print("  File length: ${await file.length()}");
//   setState(() {
//     _recording = recording;
//     _isRecording = isRecording;
//   });
//   _controller.text = recording.path;
// }

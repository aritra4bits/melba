import 'package:flutter/material.dart';
import 'package:melba/constants.dart';
import 'package:melba/screens/video_stream.dart';
import 'package:melba/widgets/app_buttons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';

class LiveStream extends StatelessWidget {
  final ClientRole role;
  final String label;
  const LiveStream({Key key, @required this.role, @required this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Live Streaming'),
        ),
        body: Center(
          child: AppButton(
            label: label,
            onPressed: (){
              onJoin(context);
            },
          ),
        )
      ),
    );
  }
  Future<void> onJoin(context) async {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(context);
      // push video page with given channel name
  }

  Future<void> _handleCameraAndMic(context) async {
    if (await Permission.camera.request().isGranted && await Permission.microphone.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamScreen(
            role: role,
          ),
        ),
      );
    }
  }
}

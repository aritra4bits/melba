import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart' as Rtc;
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:melba/data_models/live_stream_data_model.dart';
import 'package:melba/service/live_stream_api_call.dart';

import '../utils/video_stream_settings.dart';

class StreamScreen extends StatefulWidget {

  /// non-modifiable client role of the page
  final Rtc.ClientRole role;

  /// Creates a call page with given channel name.
  const StreamScreen({Key key, this.role}) : super(key: key);

  @override
  _StreamScreenState createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  Rtc.RtcEngine _engine;

  bool isStreaming = true;
  bool hasVideo = false;

  bool isDisposed = false;
  LiveStreamData accessInfo;
  LiveStreamAccessToken _liveStreamAccessToken = LiveStreamAccessToken();

  @override
  void dispose() {
    // clear users
    isDisposed = true;
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getAccessToken();
  }

  Future getAccessToken() async {
    LiveStreamData response = await _liveStreamAccessToken.getLiveStreamTokens();
    setState(() {
      accessInfo = response;
      // initialize agora sdk
      initialize();
    });
  }

  Future<void> initialize() async {
    if (accessInfo.appId == null && accessInfo.appId.isEmpty) {
      print('APP_ID missing, please provide your APP_ID in video_stream_settings.dart');
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in video_stream_settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    Rtc.VideoEncoderConfiguration configuration = Rtc.VideoEncoderConfiguration();
    configuration.dimensions = Rtc.VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(accessInfo.token, accessInfo.channelId, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await Rtc.RtcEngine.create(accessInfo.appId);
    await _engine.setChannelProfile(Rtc.ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
    await _engine.enableVideo();
    await _engine.enableAudio();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(Rtc.RtcEngineEventHandler(error: (code) {
      if(!isDisposed){
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      }
    }, joinChannelSuccess: (channel, uid, elapsed) {
      if(!isDisposed){
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      }
    }, leaveChannel: (stats) {
      if(!isDisposed){
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      }
    }, userJoined: (uid, elapsed) {
      if(!isDisposed){
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
        });
      }
    }, userOffline: (uid, elapsed) {
      if(!isDisposed){
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
          hasVideo = false;
        });
      }
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      if(!isDisposed){
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
          hasVideo = true;
        });
      }
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == Rtc.ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == Rtc.ClientRole.Audience) return Container();
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: _onSwitchCamera,
              child: Icon(
                Icons.flip_camera_ios_outlined,
                color: Colors.white,
                size: 30.0,
              ),
              shape: CircleBorder(),
              color: Colors.transparent,
            ),
          ),
          Spacer(),
          Container(
            width: 60,
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () async {
                if(isStreaming){
                  await _engine.disableVideo();
                  await _engine.disableAudio();
                  setState(() {
                    isStreaming = !isStreaming;
                  });
                }else{
                  await _engine.enableVideo();
                  await _engine.enableAudio();
                  setState(() {
                    isStreaming = !isStreaming;
                  });
                }
              },
              child: Icon(
                isStreaming ? Icons.videocam_outlined : Icons.videocam_off_outlined,
                color: Colors.white,
                size: 30.0,
              ),
              color: Colors.transparent,
              shape: CircleBorder(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 15.0),
            width: 60,
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: _onToggleMute,
              child: Icon(
                muted ? Icons.mic_off_outlined : Icons.mic_none_rounded,
                color: Colors.white,
                size: 30.0,
              ),
              shape: CircleBorder(),
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topPanel(){
    return Positioned(
      top: 40,
      left: 10,
      right: 10,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black54,
            ),
            height: 50,
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Container(
                  child: Image.asset('assets/images/logo.png'),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xfff1df39),
                  ),
                  height: 50,
                  width: 50,
                ),
                SizedBox(width: 10,),
                Center(
                  child: Text(accessInfo.channelId??'', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 40,
            width: 40,
            child: FlatButton(
              shape: CircleBorder(),
              color: Colors.red,
              padding: EdgeInsets.all(0.0),
              child: Image.asset('assets/images/back.png', fit: BoxFit.contain,),
              onPressed: (){
                _onCallEnd(context);
              },
            ),
          ),
        ],
      ),
    );
  }
  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    if(accessInfo == null || accessInfo.appId == null || accessInfo.appId.isEmpty){
      return Scaffold(
        backgroundColor: widget.role == Rtc.ClientRole.Audience ? Color(0xffdfdedf) : Colors.black,
        body: Center(
          child: SpinKitRipple(
            color: widget.role == Rtc.ClientRole.Audience ? Colors.black : Colors.white,
            size: 100,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: widget.role == Rtc.ClientRole.Audience ? Color(0xffdfdedf) : Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            // _panel(),
            _toolbar(),
            _topPanel(),
            widget.role == Rtc.ClientRole.Audience ? !hasVideo ? Center(
              child: Image.asset('assets/images/logo.png', height: 150, width: 150,),
            ) : Container() : Container(),
          ],
        ),
      ),
    );
  }
}

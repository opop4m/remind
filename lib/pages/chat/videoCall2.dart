import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/provider/service/webRtcCtr.dart';
import 'package:client/provider/service/webrtc.dart';
import 'package:client/tools/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:logging/logging.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter_audio_manager/flutter_audio_manager.dart';

final _log = Logger("VideoCallView");

class VideoCallView extends StatefulWidget {
  VideoCallView(this.peerInfo,
      {this.session, this.callType = msgTypeVideoCall});
  final RtcSession? session;
  final int callType;
  final ChatUser peerInfo;

  static bool inCalling = false;

  _VideoCall createState() => _VideoCall();
}

const int callStatusWasCalling = 1;
const int callStatusDoCalling = 2;
const int callStatusInVoiceCalling = 3;
const int callStatusInVideoCalling = 4;

class _VideoCall extends State<VideoCallView> {
  WebRtcCtr chat = WebRtcCtr.get();
  late String _target;
  String _selfId = Global.get().curUser.id;
  int curCallStatus = 0;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool isMuteMic = false;
  bool isSpeaker = false;
  bool isWasCall = false;
  bool isPeerHandup = false;
  int startSecond = 0;

  RtcSession? session;

  @override
  void initState() {
    super.initState();
    VideoCallView.inCalling = true;
    if (widget.session == null) {
      curCallStatus = callStatusDoCalling;
    } else {
      curCallStatus = callStatusWasCalling;
      isWasCall = true;
    }
    if (PlatformUtils.isMobile) {
      FlutterAudioManager.changeToSpeaker();
    }
    _target = widget.peerInfo.id;
    chat.onCallStateChange = (session, state) {
      if (state == CallState.CallStateBye) {
        //被挂掉
        isPeerHandup = true;
        _log.info("peer handup.");
        session = session;
        session.clearListenr();
        chat.onCallStateChange = null;
        Navigator.of(context).pop();
      }
    };
    initRenderers().then((value) {
      bool useVideo = true;
      if (widget.callType == msgTypeVoiceCall) {
        useVideo = false;
        _subProximity = ProximitySensor.events.listen((event) {
          bool _isNear = (event > 0) ? true : false;
          if (_isNear) {
            FlutterAudioManager.changeToReceiver();
          } else {
            FlutterAudioManager.changeToSpeaker();
          }
        });
      }
      if (widget.session != null &&
          widget.session!.type == WebRtcCtr.typeVoice) {
        useVideo = false;
      }
      _log.info(widget.session?.type);
      chat.createStream(false, useVideo).then((steam) async {
        _log.info("createStream");

        _localRenderer.onResize = () {
          int w = _localRenderer.videoWidth;
          int h = _localRenderer.videoWidth;
          _log.info("onResize  w: $w,h: $h");
        };
        _localStream = steam;
        if (widget.session != null) {
          widget.session!.onIceConnectionState = onIceConnectionState;
        } else {
          curCallStatus = callStatusDoCalling;

          String type = WebRtcCtr.typeVoice;
          if (widget.callType == msgTypeVideoCall) {
            type = WebRtcCtr.typeVedio;
            _localRenderer.srcObject = steam;
          }
          var session = await chat.callTarget(_target, type, steam,
              (session, remoteSteam) {
            _log.info("onAddRemoteStream callTarget");
            try {
              _remoteRenderer.srcObject = remoteSteam;
            } catch (e, s) {
              print(e.toString());
              print(s);
            }
            setState(() {});
          });
          session.onIceConnectionState = onIceConnectionState;
        }
        setState(() {});
      });
    });
  }

  StreamSubscription<int>? _subProximity;
  void onIceConnectionState(RTCIceConnectionState state) {
    if (state == RTCIceConnectionState.RTCIceConnectionStateFailed && mounted) {
      showToast(context, "Connection State Failed");
      _hangUp();
    } else if (state == RTCIceConnectionState.RTCIceConnectionStateConnected &&
        mounted) {
      if (widget.callType == msgTypeVideoCall) {
        curCallStatus = callStatusInVideoCalling;
      } else {
        curCallStatus = callStatusInVoiceCalling;
      }
      startTimer();
    }
  }

  void acceptCall() {
    widget.session!.onAddRemoteStream = (session, remoteSteam) {
      _log.info("onAddRemoteStream $remoteSteam");
      try {
        _localRenderer.srcObject = _localStream;
        _remoteRenderer.srcObject = remoteSteam;
      } catch (e, s) {
        print(e.toString());
        print(s);
      }
      setState(() {});
    };
    widget.session!.addMediaSteam(_localStream!);
    chat.agreeAndSendAnswer(widget.session!);
    // if (widget.session!.type == WebRtcCtr.typeVedio) {
    //   curCallStatus = callStatusInVideoCalling;
    // } else {
    //   curCallStatus = callStatusInVoiceCalling;
    // }
    if (mounted) setState(() {});
  }

  Future initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void dispose() async {
    super.dispose();
    if (!isWasCall) {
      sendCallMsg();
    }
    VideoCallView.inCalling = false;
    _log.info("deactivate perrid: $_target");
    chat.onCallStateChange = null;
    chat.disconnectSession(_target);
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await _localStream?.dispose();
    _localStream = null;
    timer?.cancel();
    _subProximity?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (curCallStatus) {
      // case callStatusDoCalling:
      //   break;
      // case callStatusWasCalling:
      //   break;
      // case callStatusInVoiceCalling:
      //   break;
      case callStatusInVideoCalling:
        body = bodyInVideoCall();
        break;
      default:
        body = bodyDoCall();
      // body = bodyInVideoCall();
    }
    return body;
  }

  buildButton() {
    Widget buttons;
    if (curCallStatus == callStatusDoCalling) {
      buttons = SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: _hangUp,
              tooltip: 'Hangup',
              child: Icon(Icons.call_end),
              backgroundColor: Colors.pink,
            ),
          ],
        ),
      );
    } else if (curCallStatus == callStatusWasCalling) {
      buttons = SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: _hangUp,
              tooltip: 'Hangup',
              child: Icon(Icons.call_end),
              backgroundColor: Colors.pink,
            ),
            FloatingActionButton(
              heroTag: UniqueKey(),
              child: const Icon(Icons.check),
              onPressed: () {
                acceptCall();
              },
            ),
          ],
        ),
      );
    } else if (curCallStatus == callStatusInVoiceCalling) {
      buttons = SizedBox(
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: _muteMic,
              tooltip: 'MuteMic',
              child: Icon(
                Icons.mic_off,
                color: isMuteMic ? Colors.black : Colors.white,
              ),
              backgroundColor: isMuteMic ? Colors.white : Colors.black,
            ),
            FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: _hangUp,
              tooltip: 'Hangup',
              child: Icon(Icons.call_end),
              backgroundColor: Colors.pink,
            ),
            PlatformUtils.isMobile
                ? FloatingActionButton(
                    heroTag: UniqueKey(),
                    onPressed: _switchSpeaker,
                    tooltip: 'MuteMic',
                    child: Icon(
                      Icons.volume_up,
                      color: isSpeaker ? Colors.black : Colors.white,
                    ),
                    backgroundColor: isSpeaker ? Colors.white : Colors.black,
                  )
                : Space(),
          ],
        ),
      );
    } else {
      //callStatusInVideoCalling
      buttons = SizedBox(
        width: 200.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Utils.showMediaTime(startSecond)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: UniqueKey(),
                  child: const Icon(Icons.switch_camera),
                  onPressed: _switchCamera,
                ),
                FloatingActionButton(
                  heroTag: UniqueKey(),
                  onPressed: _hangUp,
                  tooltip: 'Hangup',
                  child: Icon(Icons.call_end),
                  backgroundColor: Colors.pink,
                ),
                FloatingActionButton(
                  heroTag: UniqueKey(),
                  child: const Icon(Icons.mic_off),
                  onPressed: _muteMic,
                )
              ],
            )
          ],
        ),
      );
    }
    return buttons;
  }

  bodyDoCall() {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildButton(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          ImageProvider img = widget.peerInfo.avatar == null
              ? AssetImage(defIcon)
              : NetworkImage(getAvatarUrl(widget.peerInfo.avatar!))
                  as ImageProvider;
          var tips = "正在呼叫...";
          if (curCallStatus == callStatusDoCalling) {
            tips = "正在等待对方接受邀请";
          } else if (curCallStatus == callStatusInVoiceCalling) {
            tips = Utils.showMediaTime(startSecond);
          }
          return Container(
            alignment: Alignment(-1, -1),
            padding:
                EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 20),
            width: winWidth(context),
            height: winHeight(context),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.5),
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.15), BlendMode.dstATop),
                image: img,
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                ImageView(
                    img: getAvatarUrl(widget.peerInfo.avatar),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover),
                Space(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.peerInfo.name,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Space(
                      height: 10,
                    ),
                    Text(
                      tips,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  bodyInVideoCall() {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildButton(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            child: Stack(children: <Widget>[
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RTCVideoView(_remoteRenderer),
                    decoration: BoxDecoration(color: Colors.black54),
                  )),
              Positioned(
                  left: 20.0,
                  top: 20.0,
                  child: Container(
                    // width: orientation == Orientation.portrait ? 90.0 : 120.0,
                    // height: orientation == Orientation.portrait ? 120.0 : 90.0,
                    width: 90,
                    height: 120,
                    child: RTCVideoView(_localRenderer, mirror: true),
                    decoration: BoxDecoration(color: Colors.black54),
                  )),
            ]),
          );
        },
      ),
    );
  }

  _switchSpeaker() {
    isSpeaker = !isSpeaker;
    setState(() {});
  }

  _hangUp() {
    _log.info("_hangUp");
    Navigator.of(context).pop();
  }

  _switchCamera() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  _muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
    }
    isMuteMic = !isMuteMic;
    setState(() {});
  }

  Timer? timer;

  void startTimer() {
    _log.info("startTimer $startSecond");
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      startSecond++;
      if (mounted) setState(() {});
    });
  }

  void sendCallMsg() {
    //cancel, busy,
    int? status;
    if (curCallStatus == callStatusInVideoCalling ||
        curCallStatus == callStatusInVoiceCalling) {
      status = msgStateReaded;
    }
    var msg = Im.newMsg(
      typePerson,
      widget.callType,
      widget.peerInfo.id,
      ext: "$startSecond,$curCallStatus",
      status: status,
    );
    Im.get().sendChatMsg(msg);
  }
}

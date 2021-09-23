import 'package:client/provider/service/webRtcCtr.dart';
import 'package:client/provider/service/webrtc.dart';
import 'package:client/tools/library.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:logging/logging.dart';

final _log = Logger("VideoCallView");

class VideoCallView extends StatefulWidget {
  VideoCallView(this._target, {this.session});
  final String _target;
  final RtcSession? session;
  _VideoCall createState() => _VideoCall();
}

class _VideoCall extends State<VideoCallView> {
  WebRtcCtr chat = WebRtcCtr.get();

  String _selfId = Global.get().curUser.id;
  bool _inCalling = false;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  // Map<String, double?> _localVideoWH = Map();

  @override
  void initState() {
    super.initState();
    chat.onCallStateChange = (session, state) {
      if (state == CallState.CallStateBye) {
        _log.info("bye bye.");
        chat.onCallStateChange = null;
        session.clearListenr();
        Navigator.of(context).pop();
      }
    };
    initRenderers().then((value) {
      chat.createStream(false).then((steam) {
        _log.info("createStream");

        _localRenderer.srcObject = steam;
        _localRenderer.onResize = () {
          int w = _localRenderer.videoWidth;
          int h = _localRenderer.videoWidth;
          _log.info("onResize  w: $w,h: $h");
        };
        _localStream = steam;
        if (widget.session != null) {
          widget.session!.onAddRemoteStream = (session, remoteSteam) {
            _log.info("onAddRemoteStream $remoteSteam");
            try {
              _remoteRenderer.srcObject = remoteSteam;
            } catch (e, s) {
              print(e.toString());
              print(s);
            }

            setState(() {
              _inCalling = true;
            });
          };
          widget.session!.addMediaSteam(steam);
          chat.agreeAndSendAnswer(widget.session!);
        } else {
          chat.callTarget(widget._target, steam, (session, remoteSteam) {
            _log.info("onAddRemoteStream callTarget");
            try {
              _remoteRenderer.srcObject = remoteSteam;
            } catch (e, s) {
              print(e.toString());
              print(s);
            }
            setState(() {
              _inCalling = true;
            });
          });
        }
        setState(() {
          _inCalling = true;
        });
      });
    });
  }

  _test() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };
    _localRenderer.onResize = () {
      int w = _localRenderer.videoWidth;
      int h = _localRenderer.videoWidth;
      _log.info("onResize  w: $w,h: $h");
    };
    try {
      MediaStream stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = stream;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _inCalling = true;
    });
  }

  Future initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() async {
    super.deactivate();
    _log.info("deactivate perrid: ${widget._target}");
    chat.onCallStateChange = null;
    chat.disconnectSession(widget._target);
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await _localStream?.dispose();
    _localStream = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2my account: $_selfId'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.flash_off),
            onPressed: () {
              _test();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: null,
            tooltip: 'setup',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _inCalling
          ? SizedBox(
              width: 200.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      child: const Icon(Icons.switch_camera),
                      onPressed: _switchCamera,
                    ),
                    FloatingActionButton(
                      onPressed: _hangUp,
                      tooltip: 'Hangup',
                      child: Icon(Icons.call_end),
                      backgroundColor: Colors.pink,
                    ),
                    FloatingActionButton(
                      child: const Icon(Icons.mic_off),
                      onPressed: _muteMic,
                    )
                  ]))
          : null,
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
                    decoration: BoxDecoration(color: Colors.red),
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

  _hangUp() {}
  _switchCamera() {}
  _muteMic() {}
}

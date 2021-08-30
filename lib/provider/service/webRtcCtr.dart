import 'dart:convert';

import 'package:client/provider/global_cache.dart';
import 'package:client/provider/service/im.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:client/provider/service/webrtc.dart';
import 'package:client/provider/service/mqttLib.dart';
import 'package:logging/logging.dart';

final _log = Logger("ChatCtr");

const String actOffer = "offer";
const String actCandidate = "candidate";
const String actAnswer = "answer";
const String actBye = "bye";

typedef void OnCallState(RtcSession session, CallState state);

class WebRtcCtr {
  static WebRtcCtr? _instance;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  WebRtcCtr._internal();
  factory WebRtcCtr.get() => _getInstance();
  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = WebRtcCtr._internal();
    }
    return _instance;
  }

  OnCallState? onCallStateChange;
  static final String typeVoice = "voice";
  static final String typeVedio = "vedio";
  static final String typeData = "data";

  late MqttLib mqtt;
  String _selfId = GlobalCache.get().user.id;
  late Webrtc _rtc = Webrtc(_selfId, iceService);
  // Map<String, RtcSession> _sessions = {};
  //被呼叫时触发
  OnOffer? onReceiveOffer;

  init() {
    Im.get().setListenner("webRtc", (topic, res) {
      onMessageFromSocket(topic, res);
    });
  }

  Map<String, dynamic> iceService = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      /*
       * turn server configuration example.
        */
      {
        'url': 'turn:18.162.124.212:3478',
        'username': 'username',
        'credential': 'password'
      },
    ]
  };

  Future<RtcSession> inviteTarget(
      String targetId, String type, DataChannelCallback? cb) async {
    var session = await _rtc.createSession(targetId, type, null);
    session.onSelfCandidate = (session, iceCandidate) {
      _sendCandidate(session, iceCandidate);
    };
    if (type == typeData) {
      session.onDataChannel = cb;
    }

    RTCSessionDescription? sd = await session.invite();
    _sendOffer(session, sd);
    return session;
  }

  disconnectSession(String targetId) {
    var session = _rtc.findSession(targetId);
    session?.closeSession();
  }

  _sendCandidate(RtcSession session, RTCIceCandidate candidate) {
    Map<String, dynamic> data = {
      'to': session.peerId,
      'from': _selfId,
      'candidate': {
        'sdpMLineIndex': candidate.sdpMlineIndex,
        'sdpMid': candidate.sdpMid,
        'candidate': candidate.candidate,
      },
      'session_id': session.sessionId,
    };
    _send(session.peerId, actCandidate, data);
  }

  _sendOffer(RtcSession session, RTCSessionDescription? sd) {
    if (sd == null) {
      _log.warning("create offer failed.");
      return;
    }
    Map<String, dynamic> data = {
      'to': session.peerId,
      'from': _selfId,
      'description': {'sdp': sd.sdp, 'type': sd.type},
      'session_id': session.sessionId,
      'type': session.type
    };
    _send(session.peerId, actOffer, data);
  }

  _sendBye(RtcSession session) {
    Map<String, dynamic> data = {
      'to': session.peerId,
      'from': _selfId,
    };
    _send(session.peerId, actBye, data);
  }

  _sendAnswer(RtcSession session, RTCSessionDescription sd) {
    Map<String, dynamic> data = {
      'to': session.peerId,
      'from': _selfId,
      'description': {'sdp': sd.sdp, 'type': sd.type},
      'session_id': session.sessionId,
    };
    _send(session.peerId, actAnswer, data);
  }

  _send(String targetId, String act, Map<String, dynamic> data) {
    Map<String, dynamic> send = Map();
    send["act"] = act;
    send["data"] = data;
    String msg = json.encode(send);
    _log.info("send msg: $act");
    Im.get().sendMsg(targetId, msg);
  }

  _onCandidate(Map<String, dynamic> data) async {
    var peerId = data['from'];
    var candidateMap = data['candidate'];
    var sessionId = data['session_id'];
    _rtc.receiveCandidate(peerId, candidateMap, sessionId);
  }

  _onAnswer(Map<String, dynamic> data) async {
    var description = data['description'];
    var sessionId = data['session_id'];
    _rtc.receiveAnswer(sessionId, description);
  }

  _onOffer(Map<String, dynamic> data) async {
    var peerId = data['from'];
    var description = data['description'];
    var type = data['type'];
    var sessionId = data['session_id'];
    // var rtc = Webrtc(_selfId, iceService);
    var session = await _rtc.createSession(peerId, type, sessionId);
    session.onSelfCandidate =
        (session, candidate) => _sendCandidate(session, candidate);
    session.cacheRemoteDescription = description;
    onReceiveOffer?.call(session);
  }

  agreeAndSendAnswer(RtcSession session) async {
    if (session.type != typeData) {
      session.onCallStateChange = (session, state) {
        onCallStateChange?.call(session, state);
        if (state == CallState.CallStateBye) {
          _sendBye(session);
        }
      };
    }
    RTCSessionDescription? sd =
        await _rtc.getAnswer(session, session.cacheRemoteDescription!);
    if (sd != null) {
      _sendAnswer(session, sd);
    }
  }

  onMessageFromSocket(String topic, Map<String, dynamic> res) {
    Map<String, dynamic> data = res['data'];
    _log.info("on msg arrive: ${res['act']}");
    switch (res["act"]) {
      case actOffer:
        _log.warning("actOffer");
        _onOffer(data);
        break;
      case actCandidate:
        _onCandidate(data);
        break;
      case actAnswer:
        _onAnswer(data);
        break;
      case actBye:
        RtcSession? session = _rtc.findSession(data['to']);
        if (session != null)
          onCallStateChange?.call(session, CallState.CallStateBye);
        break;
    }
  }

  deactivate() {
    _rtc.cleanAllSessions();
  }

  Future<MediaStream> createStream(bool userScreen) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
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

    MediaStream stream = userScreen
        ? await navigator.mediaDevices.getDisplayMedia(mediaConstraints)
        : await navigator.mediaDevices.getUserMedia(mediaConstraints);
    return stream;
  }

  void callTarget(String target, MediaStream localStream,
      void Function(RtcSession, MediaStream) onAddRemoteStream) async {
    // String sid = _selfId + "_" + target;
    var session = await _rtc.createSession(target, typeVedio, null);
    session.onSelfCandidate = (session, candidate) {
      _sendCandidate(session, candidate);
    };
    session.onCallStateChange = (session, state) {
      if (state == CallState.CallStateBye) {
        _sendBye(session);
      }
    };
    session.onAddRemoteStream = onAddRemoteStream;
    await session.addMediaSteam(localStream);
    var offer = await session.createOffer();
    _sendOffer(session, offer);
  }

  late RtcSession session;
  void test1(String target) async {}

  void test2() async {}
}

typedef void OnOffer(RtcSession session);

import 'dart:convert';

import 'package:client/provider/global_cache.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:client/provider/service/webrtc.dart';
import 'package:client/provider/service/mqttLib.dart';
import 'package:logging/logging.dart';

final _log = Logger("WebRtcCtr");

const String actOffer = "offer";
const String actCandidate = "candidate";
const String actAnswer = "answer";
const String actBye = "bye";

typedef void OnCallState(RtcSession session, CallState state);

class WebRtcCtr {
  static WebRtcCtr? _instance;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  WebRtcCtr._internal() {
    _rtc = Webrtc();
  }
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
  String _selfId = Global.get().curUser.id;
  late Webrtc _rtc;
  // Map<String, RtcSession> _sessions = {};
  //被呼叫时触发
  OnOffer? onReceiveOffer;

  init() {
    Map<String, dynamic> iceService = {
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
        {'url': Global.get().chatConf.stun},
        /*
       * turn server configuration example.
        */
        {
          'url': Global.get().chatConf.stun,
          'username': _selfId,
          'credential': Global.get().curUser.accessToken
        },
      ]
    };
    _log.info("cur iceServers: $iceService");
    _rtc.setInfo(_selfId, iceService);
    MqttLib.get().messageStream.listen((mqMsg) {
      // _log.info("msg: ${mqMsg.pt}");
      var res = jsonDecode(mqMsg.pt);
      if (res is Map) onMessageFromSocket(mqMsg.topic, res);
    });
  }

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
    // Map<String, dynamic> send = Map();
    // send["act"] = act;
    // send["data"] = data;
    String msg = json.encode(data);
    // _log.info("send msg: $act");
    Im.get().sendMsg(targetId, act, msg);
  }

  _onCandidate(Map data) async {
    var peerId = data['from'];
    var candidateMap = data['candidate'];
    var sessionId = data['session_id'];
    _rtc.receiveCandidate(peerId, candidateMap, sessionId, intoQueue: true);
  }

  _onAnswer(Map data) async {
    var description = data['description'];
    var sessionId = data['session_id'];
    _rtc.receiveAnswer(sessionId, description);
  }

  _onOffer(Map data) async {
    var peerId = data['from'];
    var description = data['description'];
    var type = data['type'];
    var sessionId = data['session_id'];
    // var rtc = Webrtc(_selfId, iceService);
    var session = await _rtc.createSession(peerId, type, sessionId);
    session.onSelfCandidate =
        (session, candidate) => _sendCandidate(session, candidate);
    session.cacheRemoteDescription = description;
    if (session.type != typeData) {
      session.onSessionStateChange = (session, state) {
        onCallStateChange?.call(session, state);
        if (state == CallState.CallStateBye) {
          _sendBye(session);
        }
      };
    }
    onReceiveOffer?.call(session);
  }

  agreeAndSendAnswer(RtcSession session) async {
    RTCSessionDescription? sd =
        await _rtc.getAnswer(session, session.cacheRemoteDescription!);
    if (sd != null) {
      _sendAnswer(session, sd);
    }
  }

  onMessageFromSocket(String topic, Map res) {
    // Map<String, dynamic> data = res['data'];
    var tb = ImData.parserTopic(topic);
    _log.info("webrtc act: ${tb.act}");

    switch (tb.act) {
      case actOffer:
        _log.warning("actOffer");
        _onOffer(res);
        break;
      case actCandidate:
        _onCandidate(res);
        break;
      case actAnswer:
        _onAnswer(res);
        break;
      case actBye:
        RtcSession? session = _rtc.findSession(res['to']);
        if (session != null)
          onCallStateChange?.call(session, CallState.CallStateBye);
        break;
    }
  }

  deactivate() {
    _rtc.cleanAllSessions();
  }

  Future<MediaStream> createStream(bool userScreen, bool useVideo) async {
    _log.info("userScreen: $userScreen, useVideo:$useVideo");
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': false,
    };
    if (useVideo) {
      mediaConstraints['video'] = {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      };
    }

    MediaStream stream = userScreen
        ? await navigator.mediaDevices.getDisplayMedia(mediaConstraints)
        : await navigator.mediaDevices.getUserMedia(mediaConstraints);
    return stream;
  }

  Future<RtcSession> callTarget(
      String target,
      String type,
      MediaStream localStream,
      void Function(RtcSession, MediaStream) onAddRemoteStream) async {
    // String sid = _selfId + "_" + target;
    var session = await _rtc.createSession(target, type, null);
    session.onSelfCandidate = (session, candidate) {
      _sendCandidate(session, candidate);
    };
    session.onSessionStateChange = (session, state) {
      //session close
      if (state == CallState.CallStateBye) {
        _sendBye(session);
      }
    };
    session.onAddRemoteStream = onAddRemoteStream;
    await session.addMediaSteam(localStream);
    var offer = await session.createOffer();
    _sendOffer(session, offer);
    return session;
  }

  late RtcSession session;
  void test1(String target) async {}

  void test2() async {}
}

typedef void OnOffer(RtcSession session);

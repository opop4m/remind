import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logging/logging.dart';

final _log = Logger("Webrtc");

// typedef void SignalingStateCallback(SignalingState state);
typedef void CallStateCallback(RtcSession session, CallState state);
typedef void StreamStateCallback(RtcSession session, MediaStream stream);
typedef void OtherEventCallback(dynamic event);
typedef void DataChannelMessageCallback(
    RtcSession session, RTCDataChannel dc, RTCDataChannelMessage data);
typedef void DataChannelCallback(RtcSession session, RTCDataChannel dc);

typedef void OnOffer(RtcSession session, RTCSessionDescription? sd);
typedef void OnSelfCandidate(RtcSession session, RTCIceCandidate candidate);

Map<String, List<RTCIceCandidate>> _cacheRemoteCandidate = Map();
Map<String, RtcSession> _cacheSessions = Map();

final Map<String, dynamic> _dcConstraints = {
  'mandatory': {
    'OfferToReceiveAudio': false,
    'OfferToReceiveVideo': false,
  },
  'optional': [],
};
String get sdpSemantics => WebRTC.platformIsWindows ? 'plan-b' : 'unified-plan';

class Webrtc {
  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ]
  };
  Webrtc();
  late Map<String, dynamic> _iceServers;
  late String _selfId;

  void setInfo(String selfId, Map<String, dynamic> iceServers) {
    _selfId = selfId;
    _iceServers = iceServers;
  }

  Future<RtcSession> createSession(
      String peerId, String type, String? sessionId) async {
    var sid = sessionId == null ? _selfId + "_" + peerId : sessionId;
    _log.info("create session id $sid");
    var rtcSession = RtcSession(peerId: peerId, sessionId: sid, type: type);
    RTCPeerConnection pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    }, _config);
    rtcSession.pc = pc;

    _cacheSessions[sid] = rtcSession;

    pc.onIceCandidate = (candidate) {
      print("onIceCandidate:" + candidate.toString());
      rtcSession.onSelfCandidate?.call(rtcSession, candidate);
    };

    pc.onIceConnectionState = (state) {
      print("onIceConnectionState:" + state.toString());
    };

    pc.onRemoveStream = (stream) {
      // onRemoveRemoteStream?.call(newSession, stream);
      // _remoteStreams.removeWhere((it) {
      //   return (it.id == stream.id);
      // });
    };

    pc.onDataChannel = (channel) {
      rtcSession.addDataChannel(channel);
    };

    return rtcSession;
  }

  Future<RTCSessionDescription?> getAnswer(
      RtcSession session, Map<String, dynamic> description) async {
    await session.pc!.setRemoteDescription(
        RTCSessionDescription(description['sdp'], description['type']));
    var res = _createAnswer(session, session.type);
    List<RTCIceCandidate>? remoteInfo =
        _cacheRemoteCandidate[session.sessionId];
    for (var i = 0; i < (remoteInfo?.length ?? 0); i++) {
      var candidate = remoteInfo![i];
      try {
        await session.pc!.addCandidate(candidate);
      } catch (e, s) {
        print(e.toString());
        print(s);
      }
    }
    remoteInfo?.clear();
    remoteInfo != null ? _cacheRemoteCandidate.remove(session.sessionId) : '';
    return res;
  }

  receiveCandidate(
      String peerId, Map<String, dynamic> candidateMap, String sessionId,
      {bool intoQueue = false}) async {
    RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
        candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
    RtcSession? session = _cacheSessions[sessionId];
    if (!intoQueue &&
        session != null &&
        session.pc != null &&
        (await session.pc!.getRemoteDescription())?.type != null) {
      _log.info("receiveCandidate already call add");
      try {
        await session.pc!.addCandidate(candidate);
      } catch (e, s) {
        print(e.toString());
        print(s);
      }
    } else {
      List<RTCIceCandidate>? list = _cacheRemoteCandidate[sessionId];
      if (list == null) {
        list = List.empty(growable: true);
      }
      _cacheRemoteCandidate[sessionId] = list..add(candidate);
      _log.info("receiveCandidate put it in queue.");
    }
  }

  receiveAnswer(String sessionId, description) {
    var session = _cacheSessions[sessionId];
    session?.pc?.setRemoteDescription(
        RTCSessionDescription(description['sdp'], description['type']));
  }

  Future<RTCSessionDescription?> _createAnswer(
      RtcSession session, String type) async {
    try {
      RTCSessionDescription s =
          await session.pc!.createAnswer(type == 'data' ? _dcConstraints : {});
      await session.pc!.setLocalDescription(s);
      return s;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> cleanAllSessions() async {
    _cacheSessions.forEach((key, sess) async {
      sess.clearListenr();
      await sess.pc?.close();
      await sess.dc?.close();
    });
    _cacheSessions.clear();
  }

  void closeSessionByPeerId(String peerId) {
    RtcSession? session = findSession(peerId);
    session?.closeSession();
  }

  RtcSession? findSession(String peerId) {
    RtcSession? session;
    _cacheSessions.removeWhere((String key, RtcSession sess) {
      var ids = key.split('_');
      session = sess;
      // if (ids.length != 2) {
      //   _log.warning("key: $key");
      // }
      return peerId == ids[0] || peerId == ids[1];
    });
    return session;
  }
}

class RtcSession {
  RtcSession(
      {required this.peerId, required this.sessionId, required this.type});
  String peerId;
  String sessionId;
  String type;
  // RTCIceConnectionState iceState = RTCIceConnectionState.RTCIceConnectionStateNew;
  RTCPeerConnection? pc;
  RTCDataChannel? dc;
  // List<RTCIceCandidate> remoteCandidates = [];
  DataChannelMessageCallback? onDataChannelMessage;
  DataChannelCallback? onDataChannel;
  StreamStateCallback? onAddRemoteStream;
  StreamStateCallback? onRemoveRemoteStream;
  Map<String, dynamic>? cacheRemoteDescription;
  OnSelfCandidate? onSelfCandidate;
  CallStateCallback? onCallStateChange;

  clearListenr() {
    dc?.onDataChannelState = null;
    dc?.onMessage = null;
    this.onCallStateChange = null;
  }

  Future<void> closeSession() async {
    this.onCallStateChange?.call(this, CallState.CallStateBye);
    this.clearListenr();
    await this.pc?.close();
    await this.dc?.close();
  }

  Future<RTCSessionDescription?> invite() async {
    if (this.type == "data") {
      createDataChannel();
    }
    return createOffer();
  }

  Future<void> createDataChannel({label: 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
      ..maxRetransmits = 30;
    RTCDataChannel channel =
        await this.pc!.createDataChannel(label, dataChannelDict);
    addDataChannel(channel);
  }

  Future<RTCSessionDescription?> createOffer() async {
    try {
      RTCSessionDescription s =
          await this.pc!.createOffer(this.type == 'data' ? _dcConstraints : {});
      await this.pc!.setLocalDescription(s);
      return s;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  addDataChannel(RTCDataChannel channel) {
    channel.onDataChannelState = (e) {
      _log.info("onDataChannelState: $e");
    };
    channel.onMessage = (RTCDataChannelMessage data) {
      this.onDataChannelMessage?.call(this, channel, data);
    };
    this.dc = channel;
    this.onDataChannel?.call(this, channel);
  }

  addMediaSteam(MediaStream localStream) async {
    // final com = Completer<MediaStream>();
    // final future = com.future;
    _log.info("addMediaSteam call");
    switch (sdpSemantics) {
      case 'plan-b':
        this.pc!.onAddStream = (MediaStream stream) {
          _log.info("onAddStream");
          onAddRemoteStream?.call(this, stream);
          // _remoteStreams.add(stream);
        };
        await this.pc!.addStream(localStream);
        break;
      case 'unified-plan':
        // Unified-Plan
        this.pc!.onTrack = (event) {
          if (event.track.kind == 'video') {
            _log.info("onAddStream");

            onAddRemoteStream?.call(this, event.streams[0]);
          }
        };
        localStream.getTracks().forEach((track) {
          this.pc!.addTrack(track, localStream);
        });
        break;
    }
    // return future;
  }
}

enum CallState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
}

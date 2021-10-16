import 'dart:convert';
import 'dart:typed_data';

import 'package:client/http/api.dart';
import 'package:client/pages/navigation.dart';
import 'package:client/provider/model/chatBean.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imApi.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
export 'package:client/provider/service/mqttLib.dart';
import 'package:client/provider/service/mqttLib.dart';
import 'package:client/tools/library.dart';
import 'package:client/tools/mimeType.dart';
import 'package:mime/mime.dart';
import 'package:mqtt_client/mqtt_client.dart';

typedef OnMsgListener(String topic, dynamic res);

final _log = Logger("im");

class Im {
  static Im? _instance;

  factory Im.get() => _getInstance();
  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = Im._internal();
    }
    return _instance;
  }

  Im._internal() {
    _stateStreamC = StreamController.broadcast(
      onListen: () {
        _stateStreamC.add(currentState);
      },
    );
  }

  static final String topicSystem = "im/system";
  static final String topicP2P = "im/p2p/";
  static final String topicGroup = "im/group/";

  late String selfId;
  late String topicMe;

  // OnStateListener? stateListener;
  ConnectState currentState = ConnectState.disconnect;
  ConnectivityResult currentNetwork = ConnectivityResult.none;
  Map<String, OnMsgListener?> msgArrive = {}; //tag,cb
  bool reconnect = false;

  init(
    String selfId,
    String uuid, {
    String host = "ws://127.0.0.1/mqtt",
    String port = "4083",
    String account = "",
    String passwd = "",
  }) async {
    var mqttConf = MqttConf();
    mqttConf.host = host;
    mqttConf.port = int.parse(port);
    mqttConf.clientId = uuid;
    mqttConf.account = account;
    mqttConf.passwd = passwd;
    MqttLib.get().init(mqttConf);

    this.selfId = selfId;
    topicMe = topicP2P + selfId;

    MqttLib.get().mqLibState = onStateListenerForLib;

    initListenNetwork();
  }

  void initListenNetwork() {
    subscription.checkConnectivity().then((state) {
      currentNetwork = state;
    });
    subscription.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      currentNetwork = result;
      // if (result == ConnectivityResult.mobile ||
      //     result == ConnectivityResult.wifi) {
      // }
    });
  }

  late StreamController<ConnectState> _stateStreamC;
  Stream<ConnectState> get statusStream => _stateStreamC.stream;

  void onStateChange(ConnectState state) {
    _log.info("onStateChange: $state");
    currentState = state;
    _stateStreamC.add(state);
  }

  void onStateListenerForLib(ConnectState state) {
    onStateChange(state);
    if (state != ConnectState.notAuthorized &&
        reconnect &&
        Global.get().hasLogin) {
      int time = 5;
      _log.info("reconnect afet $time s");
      Future.delayed(Duration(seconds: time), () {
        if (state != ConnectState.notAuthorized &&
            reconnect &&
            Global.get().hasLogin) {
          Im.get().connect();
        }
      });
    }
  }

  void connect() async {
    reconnect = true;
    var connectStatus = await MqttLib.get().connect();
    // _log.info("after connect: ${connectStatus?.returnCode}");
    if (connectStatus!.returnCode != null &&
        connectStatus.returnCode == MqttConnectReturnCode.notAuthorized) {
      onStateChange(ConnectState.notAuthorized);
    } else if (connectStatus.state == MqttConnectionState.connected) {
      reconnect = true;
      // MqttLib.get().subscribe("im/p2p/test");
      Im.get().requestSystem(actOnline, {}, msgId: UcNavigation.curPage);
      ImData.get().initSub();
    } else if (connectStatus.state == MqttConnectionState.connecting) {
      onStateChange(ConnectState.connecting);
    } else if (connectStatus.state == MqttConnectionState.faulted) {
      onStateListenerForLib(ConnectState.networkErr);
    }
  }

  void sendMsg(String peerId, String act, String msg) {
    String topic = topicP2P + peerId + "/$act";
    MqttLib.get().publish(topic, msg);
  }

  Future requestSystem(String act, Object? params, {String? msgId}) {
    var fromId = Global.get().curUser.id;
    String topic = topicSystem + "/$fromId/$act";
    if (msgId != null) {
      topic += "/" + msgId;
    }
    // String msg = jsonEncode({"act": act, "data": params});
    _log.info("requestSystem topic: $topic");
    String msg = jsonEncode(params);
    return MqttLib.get().publish(topic, msg);
  }

  void sendChatMsg(ChatMsg msg) {
    String topic = topicP2P + msg.peerId + "/$actChat/${msg.msgId}";
    if (msg.type == typeGroup) {
      topic = topicGroup + msg.peerId + "/$actChat/${msg.msgId}";
    }
    // ImData.get().onNewRecent(msg);
    // var data = {"act": "chat", "data": msg};
    var msgStr = json.encode(msg);
    _log.info(msgStr);
    // ImDb.g().db.chatMsgDao.insertChatMsgData(msg.toCompanion(true));
    ImData.get().onChatMsg(msg.toJson());
    MqttLib.get().publish(topic, msgStr);
  }

  static sendMediaMsg(int type, int msgType, String peerId, Uint8List bytes,
      {Size? size}) async {
    _log.info("sendMediaMsg bytes len: ${bytes.length}");
    var mime = lookupMimeType('', headerBytes: bytes.sublist(0, 10));
    if (mime == null) {
      _log.info("unknow file type");
      return;
    }
    var ext = findExtFromMime(mime);
    var filePath = await uploadMediaApi(bytes, ext, "chat");
    _log.info("imgPath: $filePath");
    if (strNoEmpty(filePath)) {
      var ext = filePath;
      if (size != null) {
        ext = ext + ",${size.width},${size.height}";
      }
      var msg = Im.newMsg(type, msgTypeImage, peerId, ext: ext);
      Im.get().sendChatMsg(msg);
    }
  }

  static ChatMsg newMsg(int type, int msgType, String peerId,
      {String content = "", String ext = "", int? status}) {
    var msg = ChatMsg(
      msgId: newMsgId(peerId),
      peerId: peerId,
      fromId: Global.get().curUser.id,
      type: type,
      msgType: msgType,
      tipsType: 0,
      content: content,
      status: status ?? msgStateSending,
      ext: ext,
      createTime: Utils.getTimestampSecond(),
    );
    return msg;
  }

  void disConnect() {
    print("disConnect");
    hasInit = reconnect = false;
    MqttLib.get().disconnect();
  }

  static String newMsgId(String peerId) {
    // uid + peerId + time
    var t = DateTime.now().millisecondsSinceEpoch;
    var newId = Im.get().selfId + "-" + peerId + "-" + t.toString();
    return newId;
  }

  bool hasInit = false;
  void initData() async {
    if (hasInit) return;
    hasInit = true;
    Im.get().requestSystem(actAllriendRequest, {});
    Im.get().requestSystem(actChatAllPop, {});
    //1, 最近的聊天列表。 2，检查列表的聊天记录。
    List<ChatRecent> list = await ImApi.requestRecentList();
    SyncChat chatReq = SyncChat();
    for (var i = 0; i < list.length; i++) {
      ChatRecent recent = list[i];
      var query = await ImDb.g()
          .db
          .chatMsgDao
          .queryMsgList(recent.peerId, recent.type, 1, 0);
      if (recent.type == typePerson || recent.type == typeGroup) {
        SyncChatPage chat;
        if (query.length == 1) {
          chat = SyncChatPage(recent.peerId, recent.type, query[0].createTime);
        } else {
          chat = SyncChatPage(recent.peerId, recent.type, 0);
        }
        chatReq.chatList.add(chat);
      }
    }
    if (chatReq.chatList.length > 0)
      Im.get().requestSystem(actSyncChat, chatReq.toJson());
  }

  static String routeKey(String targetId, int type) {
    String key = type.toString() + "-" + targetId;
    return key;
  }

  void onResume() {
    if (currentState != ConnectState.connected) {
      connect();
    }
  }
}

import 'dart:convert';

import 'package:client/provider/model/chatList.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/imDb.dart';
export 'package:client/provider/service/mqttLib.dart';
import 'package:client/provider/service/mqttLib.dart';
import 'package:client/tools/library.dart';
import 'package:mqtt_client/mqtt_client.dart';

typedef OnMsgListener(String topic, Map<String, dynamic> res);

final _log = Logger("im");

class Im {
  static Im? _instance;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  Im._internal();
  factory Im.get() => _getInstance();
  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = Im._internal();
    }
    return _instance;
  }

  static final String topicP2P = "im/p2p/";
  static final String topicGroup = "im/group/";

  late String selfId;
  late String topicMe;

  OnStateListener? stateListener;
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
    mqttConf.host = "ws://127.0.0.1/mqtt";
    mqttConf.port = int.parse(port);
    mqttConf.clientId = uuid;
    mqttConf.account = account;
    mqttConf.passwd = passwd;
    MqttLib.get().init(mqttConf);

    this.selfId = selfId;
    topicMe = topicP2P + selfId;

    MqttLib.get()
      ..setMsgListener(topicMe, (topic, msg) {
        Map<String, dynamic> res = json.decode(msg);
        msgArrive.forEach((String tag, OnMsgListener? cb) {
          cb?.call(topic, res);
        });
      });
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

  void onStateChange(ConnectState state) {
    _log.info("onStateChange: $state");
    currentState = state;
    stateListener?.call(state);
  }

  void onStateListenerForLib(ConnectState state) {
    onStateChange(state);
    if (state != ConnectState.notAuthorized && reconnect) {
      int time = 5;
      _log.info("reconnect afet $time s");
      Future.delayed(Duration(seconds: time), () {
        Im.get().connect();
      });
    }
  }

  void connect() async {
    var connectStatus = await MqttLib.get().connect();
    // _log.info("after connect: ${connectStatus?.returnCode}");
    if (connectStatus!.returnCode != null &&
        connectStatus.returnCode == MqttConnectReturnCode.notAuthorized) {
      onStateChange(ConnectState.notAuthorized);
    } else if (connectStatus.state == MqttConnectionState.connected) {
      reconnect = true;
      // MqttLib.get().subscribe("im/p2p/test");
    } else if (connectStatus.state == MqttConnectionState.connecting) {
      onStateChange(ConnectState.connecting);
    } else if (connectStatus.state == MqttConnectionState.faulted) {
      onStateListenerForLib(ConnectState.networkErr);
    }
  }

  void setListenner(String tag, OnMsgListener? cb) {
    if (cb == null) {
      msgArrive.remove(tag);
    } else {
      msgArrive[tag] = cb;
    }
  }

  void sendMsg(String peerId, String msg) {
    String topic = topicP2P + peerId;
    MqttLib.get().publish(topic, msg);
  }

  void sendChatMsg(ChatMsg msg) {
    String topic = topicP2P + msg.peerId;
    if (msg.type == typeGroup) {
      topic = topicGroup + msg.peerId;
    }
    var data = {"act": "chat", "data": msg};
    var msgStr = json.encode(data);
    MqttLib.get().publish(topic, msgStr);
  }

  void disConnect() {
    print("disConnect");
    reconnect = false;
    MqttLib.get().disconnect();
  }

  static String newMsgId(String peerId) {
    // uid + peerId + time
    var t = DateTime.now().millisecondsSinceEpoch;
    var newId = Im.get().selfId + "-" + peerId + "-" + t.toString();
    return newId;
  }

  static int newMsgTime() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
}

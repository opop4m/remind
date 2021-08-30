import 'dart:convert';

import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/mqttLib.dart';
import 'package:mqtt_client/mqtt_client.dart';

typedef OnMsgListener(String topic, Map<String, dynamic> res);

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

  static final String topicIm = "im/p2p/";

  late MqttLib mqtt;
  late String _selfId;
  late String topicMe;
  // OnMsgCallBack? msgArrive;
  Map<String, OnMsgListener?> msgArrive = {}; //tag,cb
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

    _selfId = selfId;
    topicMe = topicIm + _selfId;

    mqtt = MqttLib.get()
      ..setMsgListener(topicMe, (topic, msg) {
        Map<String, dynamic> res = json.decode(msg);
        msgArrive.forEach((String tag, OnMsgListener? cb) {
          cb?.call(topic, res);
        });
      });
  }

  void connect() async {
    var connectStatus = await MqttLib.get().connect();
    if (connectStatus?.state == MqttConnectionState.connected) {
      //todo
      mqtt.subscribe(topicMe);
    }
  }

  void setListenner(String tag, OnMsgListener? cb) {
    if (cb == null) {
      msgArrive.remove(tag);
    } else {
      msgArrive[tag] = cb;
    }
  }

  void sendMsg(String peer, String msg) {
    String topic = topicIm + peer;
    MqttLib.get().publish(topic, msg);
  }
}

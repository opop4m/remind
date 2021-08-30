import 'package:client/tools/wechat_flutter.dart';
import 'package:logging/logging.dart';
import 'package:client/tools/utils/mqtt_client.dart'
    if (dart.library.js) 'package:client/tools/utils/mqtt_client_web.dart';
import 'package:mqtt_client/mqtt_client.dart';
// import '../utils/utils.dart';
import 'package:typed_data/typed_data.dart';

class MqttConf {
  String host = "";
  int port = 4083;
  String clientId = "";
  String account = "";
  String passwd = "";
}

final _log = Logger("MqttLib");

typedef OnMsgCallBack(String topic, String msg);

class MqttLib {
  static MqttLib? _instance;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  MqttLib._internal();
  factory MqttLib.get() => _getInstance();
  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = MqttLib._internal();
    }
    return _instance;
  }

  Map<String, OnMsgCallBack> _map = Map();

  setMsgListener(String topic, OnMsgCallBack? cb) {
    if (cb == null) {
      _map.remove(topic);
    } else {
      _map[topic] = cb;
    }
  }

  late MqttClient client;
  init(MqttConf conf) {
    client = MqttClientImpl.withPort(conf.host, conf.clientId, conf.port);
    client.setProtocolV311();
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 60;
    _log.info("accout: ${conf.account},passwd: ${conf.passwd}");
    final connMessage = MqttConnectMessage()
        .authenticateAs(conf.account, conf.passwd)
        // .authenticateAs("emqx", "public")
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        // .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;
  }

  bool isConnect() {
    return client.connectionStatus?.state == MqttConnectionState.connected;
  }

  bool isConnecting() {
    return client.connectionStatus?.state == MqttConnectionState.connecting;
  }

  MqttClientConnectionStatus status = MqttClientConnectionStatus();
  Future<MqttClientConnectionStatus?> connect() async {
    var completer = Completer();
    if (isConnect() || isConnecting()) {
      if (isConnect()) {
        status.state = MqttConnectionState.connected;
      } else if (isConnecting()) {
        status.state = MqttConnectionState.connecting;
      }
      return new Future<MqttClientConnectionStatus?>(() => status);
    }

    var res;
    try {
      _log.info("go connect...");
      // res = client.connect();
      client.connect().then((value) {
        completer.complete(value);
      }).catchError((obj) {
        _log.info("tttttt:");
      });
      _log.info("1.0");
    } catch (e) {
      _log.warning('connect err: $e');
      return new Future<MqttClientConnectionStatus?>(() => status);
    }
    // client.updates!.listen(onMessageArrive);
    return res;
  }

  void onMessageArrive(List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    // _log.info(
    //     'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    // _log.info('');
    String topic = c[0].topic;
    // Map<String, dynamic> res = json.decode(pt);
    if (_map.containsKey(topic)) {
      var cb = _map[topic];
      cb!(topic, pt);
    }
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publish(String topic, String msg) {
    Uint8Buffer uint8buffer = Uint8Buffer();

    ///字符串转成int数组 类似于java的String.getBytes?
    var codeUnits = msg.codeUnits;
    //uint8buffer.add()
    uint8buffer.addAll(codeUnits);
    client.publishMessage(topic, MqttQos.atLeastOnce, uint8buffer);
  }

  // connection succeeded
  void onConnected() {
    _log.info('Connected');
  }

// unconnected
  void onDisconnected() {
    _log.info('Disconnected');
  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    // _log.info('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    // _log.info('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String? topic) {
    // _log.info('Unsubscribed topic: $topic');
  }

// PING response received
  void pong() {
    // _log.info('Ping response client callback invoked');
  }
}

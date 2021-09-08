import 'package:mqtt_client/mqtt_browser_client.dart';

class MqttClientImpl extends MqttBrowserClient {
  MqttClientImpl.withPort(String server, String clientIdentifier, int port)
      : super.withPort(server, clientIdentifier, port);
}

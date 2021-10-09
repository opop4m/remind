import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttClientImpl extends MqttServerClient {
  MqttClientImpl.withPort(String server, String clientIdentifier, int port)
      : super.withPort(server, clientIdentifier, port) {
    this.useWebSocket = true;
  }
}

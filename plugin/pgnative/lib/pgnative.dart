import 'dart:async';

import 'package:flutter/services.dart';

class Pgnative {
  static const MethodChannel _channel = MethodChannel('pgnative');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get uuid async {
    final String? version = await _channel.invokeMethod('uuid');
    return version;
  }
}

import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pgnative/jsApi.dart';

/// A web implementation of the Pgnative2 plugin.
class PgnativeWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'pgnative',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = PgnativeWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
      case "uuid":
        return getUuid();
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'pgnative2 for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    // promiseToFuture()
    return Future.value(version);
  }

  Future<String> getUuid() async {
    var _promiss = uuid();
    var _uuid = await promiseToFuture(_promiss);
    // return Future.value("web uuid");
    return _uuid;
  }
}

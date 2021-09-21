import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Utils {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static Random _rnd = Random();
  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static Uint8List encodeToList(String s) {
    var encodedString = utf8.encode(s);
    var encodedLength = encodedString.length;
    var data = ByteData(encodedLength + 4);
    data.setUint32(0, encodedLength, Endian.big);
    var bytes = data.buffer.asUint8List();
    bytes.setRange(4, encodedLength + 4, encodedString);
    return bytes;
  }

  static String generateMd5(String str) {
    var content = new Utf8Encoder().convert(str);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  /*
  * Base64加密
  */
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /*
  * Base64解密
  */
  static String decodeBase64(String data) {
    List<int> bytes = base64Decode(data);
    String result = utf8.decode(bytes);
    return result;
  }

  static String formatTimeHM(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    String hourParse = "0${dateTime.hour}";
    String minuteParse = "0${dateTime.minute}";

    String hour = dateTime.hour.toString().length == 1
        ? hourParse
        : dateTime.hour.toString();
    String minute = dateTime.minute.toString().length == 1
        ? minuteParse
        : dateTime.minute.toString();

    String timeStr = '$hour:$minute';
    return timeStr;
  }

  static int getTimestampSecond() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
}

class PlatformUtils {
  static bool _isWeb() {
    return kIsWeb == true;
  }

  static bool _isAndroid() {
    return _isWeb() ? false : Platform.isAndroid;
  }

  static bool _isIOS() {
    return _isWeb() ? false : Platform.isIOS;
  }

  static bool _isMacOS() {
    return _isWeb() ? false : Platform.isMacOS;
  }

  static bool _isWindows() {
    return _isWeb() ? false : Platform.isWindows;
  }

  static bool _isFuchsia() {
    return _isWeb() ? false : Platform.isFuchsia;
  }

  static bool _isLinux() {
    return _isWeb() ? false : Platform.isLinux;
  }

  static bool _isMobile() {
    return _isWeb() ? false : (Platform.isAndroid || Platform.isIOS);
  }

  // static String h5 = "h5";
  static const android = "android";
  static const ios = "ios";
  static const web = "web";
  static String platform() {
    if (_isWeb()) {
      return web;
    } else if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    } else {
      return "unknow";
    }
  }

  static bool get isWeb => _isWeb();

  static bool get isAndroid => _isAndroid();

  static bool get isIOS => _isIOS();

  static bool get isMobile => _isMobile();

  static bool get isMacOS => _isMacOS();

  static bool get isWindows => _isWindows();

  static bool get isFuchsia => _isFuchsia();

  static bool get isLinux => _isLinux();
}

import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:client/tools/library.dart';
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

  static String showMediaTime(int startSecond) {
    var s = startSecond % 60;
    var m = startSecond ~/ 60;
    var h = startSecond ~/ 3600;
    var ss = s < 10 ? "0$s" : s.toString();
    var mm = s < 10 ? "0$m" : m.toString();
    if (h == 0) {
      return "$mm:$ss";
    } else {
      var hh = h < 10 ? "0$h" : h.toString();
      return "$hh:$mm:$ss";
    }
  }

  static List removeEmptyItem(List list) {
    List newList = [];
    list.forEach((e) {
      if (e is String && strNoEmpty(e)) {
        newList.add(e);
      } else if ((e is int || e is double) && e != 0) {
        newList.add(e);
      }
    });
    return newList;
  }
}

class PlatformUtils {
  PlatformUtils._();
  static String userAgent = "";
  static bool isH5android = false;
  static bool isH5ios = false;

  static initWebPlatform() {
    if (userAgent.indexOf("Android") > -1 || userAgent.indexOf("Linux") > -1) {
      isH5android = true;
    } else {
      RegExp exp = new RegExp(r"\(i[^;]+;( U;)? CPU.+Mac OS X");
      if (exp.hasMatch(userAgent)) {
        isH5ios = true;
      }
    }
  }

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

  static String h5_android = "h5_android";
  static String h5_ios = "h5_ios";
  static const android = "android";
  static const ios = "ios";
  static const web = "web";
  static String platform() {
    if (_isWeb()) {
      if (isH5android) {
        return h5_android;
      } else if (isH5ios) {
        return h5_ios;
      }
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

import 'dart:math';

import 'package:client/config/api.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/tools/utils.dart';
import 'package:logging/logging.dart';

final _log = Logger("UnicornHttp");
//for dart web is 2^32:
const int intMaxValue = 2 ^ 32;

class UnicornHttp {
  static String getHeaderFormat() {
    Map header = getHeader();
    // _log.info(header);
    var str = "";
    header.forEach((key, value) {
      str += key + "=" + value.toString() + ";";
    });
    return str.substring(0, str.length - 1);
  }

  static Map<String, dynamic> getHeader() {
    var rng = new Random();
    Map<String, dynamic> header = {
      "accessToken": Global.get().curUser.accessToken,
      "appKey": API.appKey,
      "platform": PlatformUtils.platform(),
      "channel": Global.get().getChannel(),
      "uuid": Global.get().getUuid(),
      "timestamp": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "n": rng.nextInt(intMaxValue),
    };
    header['sign'] = getSign(header, API.appClientSecret);
    return header;
  }

  static String getSign(Map<String, dynamic> params, String secret) {
    var keys = params.keys.toList()..sort();
    String str = "";
    keys.forEach((k) {
      // _log.info("k:$k, v:${params[k]}");
      str += k + "=" + params[k].toString() + "&";
    });
    str += "secret=" + secret;
    // _log.info("sign str: $str");
    return Utils.generateMd5(str);
  }
}

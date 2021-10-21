import 'package:client/provider/model/user.dart';
import 'package:client/tools/library.dart';
import 'package:pgnative/pgnative.dart';

final _log = Logger("Global");

class Global {
  static Global? _instance;

  factory Global.get() {
    if (_instance == null) {
      _instance = Global._();
    }
    return _instance!;
  }

  Global._();

  String getChannel() {
    return "unicorn";
  }

  ///是否已登陆
  bool _hasLogin = false;
  set hasLogin(bool b) {
    _log.info("set hasLogin: $b");
    _hasLogin = b;
  }

  bool get hasLogin => _hasLogin;

  String pushToken = "";
  // String accessToken = "";
  User curUser = User();
  ChatConf chatConf = ChatConf();

  late String uuid;

  bool _hasInit = false;
  Future init() async {
    if (_hasInit) return;
    uuid = (await Pgnative.uuid)!;
    if (PlatformUtils.isWeb) {
      PlatformUtils.userAgent = (await Pgnative.platformVersion)!;
      PlatformUtils.initWebPlatform();
    }
    _log.info("init....uuid: ${uuid},platform: ${PlatformUtils.platform()}");
    _hasInit = true;
  }
}

import 'package:client/provider/model/user.dart';

class Global {
  static Global? _instance;

  static Global get() {
    if (_instance == null) {
      _instance = Global._();
    }
    return _instance!;
  }

  Global._();

  String getChannel() {
    return "unicorn";
  }

  String getUuid() {
    return curUser.showId.toString();
  }

  ///是否已登陆
  bool hasLogin = false;
  // String accessToken = "";
  User curUser = User();
  ChatConf chatConf = ChatConf();
}

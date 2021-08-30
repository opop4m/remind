import 'package:client/provider/model/user.dart';

class GlobalCache {
  static GlobalCache? _instance;

  static GlobalCache get() {
    if (_instance == null) {
      _instance = GlobalCache._();
    }
    return _instance!;
  }

  GlobalCache._();

  String getChannel() {
    return "unicorn";
  }

  String getUuid() {
    return user.showId.toString();
  }

  ///是否已登陆
  bool hasLogin = false;
  // String accessToken = "";
  User user = User();
  ChatConf chatConf = ChatConf();
}

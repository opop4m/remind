import 'package:client/provider/model/user.dart';
import 'package:client/tools/library.dart';
import 'package:flutter/material.dart';
// import 'package:wechat_flutter/im/info_handle.dart';
import 'package:client/provider/loginc/global_loginc.dart';

class GlobalModel extends ChangeNotifier {
  BuildContext? context;

  ///app的名字
  String appName = "微信flutter";

  /// 用户信息
  // String account = '';
  // String email = "";
  // int showId = 0;
  // String nickName = 'nickName';
  // String avatar = '';
  // int gender = 0;

  User user = User();

  ///当前语言
  // List<String> currentLanguageCode = ["zh", "CN"];
  // String currentLanguage = "中文";
  Locale? currentLocale;

  late GlobalLogic logic;

  GlobalModel() {
    logic = GlobalLogic(this);
    currentLocale = AppLocalizations.supportedLocales[1];
  }

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
      Future.wait([
        logic.init(),
      ]).then((value) {
        refresh();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("GlobalModel销毁了");
  }

  void refresh() {
    // if (!hasLogin) logic.saveInfo();
    notifyListeners();
  }

  void saveInfo() {
    logic.saveInfo();
  }
}

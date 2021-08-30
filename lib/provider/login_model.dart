import 'package:flutter/material.dart';
import 'package:client/provider/loginc/login_loginc.dart';

class LoginModel extends ChangeNotifier {
  late BuildContext context;

  late LoginLogic logic;

  String area = '中国大陆（+86）';

  LoginModel() {
    logic = LoginLogic(this);
    Future.wait([
      logic.getArea(),
    ]).then((value) {
      refresh();
    });
  }

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("LoginLogic销毁了");
  }

  void refresh() {
    notifyListeners();
  }
}

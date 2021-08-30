import 'package:client/config/api.dart';
import 'package:client/http/req.dart';
import 'package:client/pages/login/login_begin_page.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/global_model.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/tools/shared_util.dart';
import 'package:client/tools/wechat_flutter.dart';
import 'dart:convert';

import 'package:logging/logging.dart';

final _log = Logger("GlobalLogic");

class GlobalLogic {
  final GlobalModel _model;

  GlobalLogic(this._model);

  Future<Rsp<LoginRsp>> register(dynamic params) async {
    var rsp = await Req.g().post(API.userRegister, params);
    Rsp<LoginRsp> res = new Rsp<LoginRsp>();
    if (rsp.data != null) {
      res.fromJson(rsp.data, new LoginRsp());
      if (res.data != null) {
        onLogin(res.data!);
      }
    }
    return res;
  }

  void onLogin(LoginRsp rsp) {
    _model.user = rsp.user;
    GlobalCache.get().user = rsp.user;
    GlobalCache.get().chatConf = rsp.chatConf;
    _model.saveInfo();
    _model.refresh();
  }

  Future<Rsp<LoginRsp>> login(dynamic params) async {
    var rsp = await Req.g().post(API.userLogin, params);
    Rsp<LoginRsp> res = new Rsp<LoginRsp>();
    if (rsp.data != null) {
      res.fromJson(rsp.data, new LoginRsp());
      if (res.data != null) {
        onLogin(res.data!);
      }
    }
    return res;
  }

  Future init() async {
    _model.appName = await SharedUtil.instance.getString(Keys.appName);
    GlobalCache.get().hasLogin =
        await SharedUtil.instance.getBoolean(Keys.hasLogged);
    var userStr = await SharedUtil.instance.getString(Keys.user);
    if (strNoEmpty(userStr)) {
      _model.user = GlobalCache.get().user.fromJson(jsonDecode(userStr));
    }
    var chatConfStr = await SharedUtil.instance.getString(Keys.chatConf);
    if (strNoEmpty(chatConfStr)) {
      GlobalCache.get().chatConf.fromJson(jsonDecode(chatConfStr));
    }

    var lcode = await SharedUtil.instance.getString(Keys.currentLanguageCode);
    if (lcode != "") {
      _model.currentLocale = Locale(lcode);
    }
    _log.info(
        "user: ${userStr} \n chatConf: ${chatConfStr} \n has login: ${GlobalCache.get().hasLogin}");
  }

  void saveInfo() async {
    if (_model.user.id != "") {
      String userStr = jsonEncode(_model.user);
      String chatConfStr = jsonEncode(GlobalCache.get().chatConf);
      // _log.info("save user str: $userStr");
      SharedUtil.instance.saveString(Keys.chatConf, chatConfStr);
      SharedUtil.instance.saveString(Keys.user, userStr);
      SharedUtil.instance.saveString(Keys.account, _model.user.account);
      SharedUtil.instance.saveBoolean(Keys.hasLogged, true);
    }
  }
}

void logout() async {
  GlobalCache.get().hasLogin = false;
  try {
    await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    Im.get().disConnect();
    await routePushAndRemove(new LoginBeginPage());
  } on PlatformException {
    await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    await routePushAndRemove(new LoginBeginPage());
  }
}

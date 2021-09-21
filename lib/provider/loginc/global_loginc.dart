import 'package:client/config/api.dart';
import 'package:client/http/req.dart';
import 'package:client/pages/login/login_begin_page.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/global_model.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/tools/shared_util.dart';
import 'package:client/tools/library.dart';
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
    Global.get().curUser = rsp.user;
    Global.get().chatConf = rsp.chatConf;
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

  Future userInfo() async {
    var rsp = await Req.g().get(API.userInfo);
    Rsp<LoginRsp> res = new Rsp<LoginRsp>();
    if (rsp.data != null) {
      res.fromJson(rsp.data, new LoginRsp());
      if (res.data != null) {
        onLogin(res.data!);
      }
    }
  }

  Future updateUser(params) async {
    var rsp = await Req.g().post(API.userUpdate, params);
    Rsp<LoginRsp> res = new Rsp<LoginRsp>();
    if (rsp.data != null) {
      res.fromJson(rsp.data, new LoginRsp());
      if (res.data != null) {
        onLogin(res.data!);
      }
    }
  }

  Future<bool> init() async {
    bool hasLogin = true;
    _model.appName = await SharedUtil.instance.getString(Keys.appName);
    // Global.get().hasLogin =
    //     await SharedUtil.instance.getBoolean(Keys.hasLogged);
    var userStr = await SharedUtil.instance.getString(Keys.user);
    if (strNoEmpty(userStr)) {
      Global.get().curUser.fromJson(jsonDecode(userStr));
    } else {
      hasLogin = false;
    }
    var chatConfStr = await SharedUtil.instance.getString(Keys.chatConf);
    if (strNoEmpty(chatConfStr)) {
      Global.get().chatConf.fromJson(jsonDecode(chatConfStr));
    } else {
      hasLogin = false;
    }
    API.fileHost = Global.get().chatConf.fileHost;
    API.uploadHost = Global.get().chatConf.uploadHost;
    var lcode = await SharedUtil.instance.getString(Keys.currentLanguageCode);
    if (lcode != "") {
      _model.currentLocale = Locale(lcode);
    }
    if (hasLogin) {
      userInfo();
    }
    _log.info(
        "user: ${userStr} \n chatConf: ${chatConfStr} \n has login: ${Global.get().hasLogin}");
    return hasLogin;
  }

  void saveInfo() async {
    if (Global.get().curUser.id != "") {
      String userStr = jsonEncode(Global.get().curUser);
      String chatConfStr = jsonEncode(Global.get().chatConf);
      // _log.info("save user str: $userStr");
      SharedUtil.instance.saveString(Keys.chatConf, chatConfStr);
      SharedUtil.instance.saveString(Keys.user, userStr);
      SharedUtil.instance.saveString(Keys.account, Global.get().curUser.id);
      SharedUtil.instance.saveBoolean(Keys.hasLogged, true);
      SharedUtil.instance.saveInt(Keys.loggedTime, Utils.getTimestampSecond());
      API.fileHost = Global.get().chatConf.fileHost;
      API.uploadHost = Global.get().chatConf.uploadHost;
    }
  }
}

void logout() async {
  Global.get().hasLogin = false;
  try {
    await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    Im.get().disConnect();
    await routePushAndRemove(new LoginBeginPage());
  } on PlatformException {
    await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    await routePushAndRemove(new LoginBeginPage());
  }
}

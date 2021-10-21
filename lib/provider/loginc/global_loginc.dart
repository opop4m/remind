import 'package:client/config/api.dart';
import 'package:client/http/req.dart';
import 'package:client/pages/login/login_begin_page.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/global_model.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imApi.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/shared_util.dart';
import 'package:client/tools/library.dart';
import 'dart:convert';

import 'package:logging/logging.dart';

final _log = Logger("GlobalLogic");

class GlobalLogic {
  final GlobalModel _model;

  GlobalLogic(this._model);

  Future<Rsp<LoginRsp>> register(dynamic params) async {
    showLoading();
    var rsp = await Req.g().post(API.userRegister, params);

    Rsp<LoginRsp> res = new Rsp<LoginRsp>();
    if (rsp.data != null) {
      res.fromJson(rsp.data, new LoginRsp());
      if (res.data != null) {
        await ImDb.g().init(res.data!.user.id);
        await onLogin(res.data!);
      }
    }
    dismissLoading();
    return res;
  }

  Future onLogin(LoginRsp rsp) async {
    Global.get().curUser = rsp.user;
    Global.get().chatConf = rsp.chatConf;
    await Future.wait([
      ImApi.appStart(),
      _model.saveInfo(),
    ]);
    _model.refresh();
  }

  Future<Rsp<LoginRsp>> login(dynamic params) async {
    showLoading();
    var rsp = await Req.g().post(API.userLogin, params);
    dismissLoading();
    Rsp<LoginRsp> res = new Rsp<LoginRsp>();
    if (rsp.data != null) {
      res.fromJson(rsp.data, new LoginRsp());
      if (res.data != null) {
        ImDb.g().init(res.data!.user.id);
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

  bool initializing = false;
  Future<bool> init() async {
    initializing = true;
    bool hasLogin = true;
    _model.appName = await SharedUtil.instance.getString(Keys.appName);
    // Global.get().hasLogin =
    //     await SharedUtil.instance.getBoolean(Keys.hasLogged);
    var userStr = await SharedUtil.instance.getString(Keys.user);
    if (strNoEmpty(userStr)) {
      Global.get().curUser.fromJson(jsonDecode(userStr));
      ImDb.g().init(Global.get().curUser.id);
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
    var lcode =
        await SharedUtil.instance.getStringList(Keys.currentLanguageCode);
    if (lcode.length > 0) {
      _model.currentLocale = Locale(lcode[0]);
    }
    await Global.get().init();
    if (hasLogin) {
      userInfo();
    }
    initializing = false;
    _log.info(
        "cache user: ${userStr} \n chatConf: ${chatConfStr} \n has login: ${Global.get().hasLogin}");
    return hasLogin;
  }

  Future saveInfo() async {
    if (Global.get().curUser.id != "") {
      await SharedUtil.instance
          .saveString(Keys.account, Global.get().curUser.id);
      Global.get().hasLogin = true;
      String userStr = jsonEncode(Global.get().curUser);
      String chatConfStr = jsonEncode(Global.get().chatConf);
      _log.info("save user str: $userStr");
      await Future.wait([
        SharedUtil.instance.saveString(Keys.chatConf, chatConfStr),
        SharedUtil.instance.saveString(Keys.user, userStr),
        SharedUtil.instance.saveInt(Keys.loggedTime, Utils.getTimestampSecond())
      ]);
      API.fileHost = Global.get().chatConf.fileHost;
      API.uploadHost = Global.get().chatConf.uploadHost;
    }
  }

  void saveDeviceLocale(Locale? deviceLocale) async {
    if (deviceLocale != null) {
      var q = await SharedUtil.instance.getStringList(Keys.devicesLanguageCode);
      if (q.length == 0) {
        SharedUtil.instance.saveStringList(Keys.devicesLanguageCode,
            [deviceLocale.languageCode, deviceLocale.countryCode ?? ""]);
      }
    }
  }
}

void logout() async {
  Global.get().hasLogin = false;
  try {
    // await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    await SharedUtil.instance.saveString(Keys.user, "");
    Im.get().disConnect();
    await routePushAndRemove(new LoginBeginPage());
  } on PlatformException {
    // await SharedUtil.instance.saveBoolean(Keys.hasLogged, false);
    await routePushAndRemove(new LoginBeginPage());
  }
}

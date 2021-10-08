import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/tools/bus/notice2.dart';
import 'package:client/tools/library.dart';
import 'package:flutter/material.dart';

final _log = Logger("UcNavigation");

class UcNavigation extends NavigatorObserver {
  static String curPage = "RootPage";

  static final String chatPage = "ChatPage";
  static final String callPage = "VideoCallView";

  @override
  void didPop(Route route, Route? pre) {
    super.didPop(route, pre);
    _log.info(
        "route didPop ${route.settings.name}  from: ${pre?.settings.name},hasLogin:${Global.get().hasLogin}");
    if (!Global.get().hasLogin) {
      return;
    }
    if (pre?.settings.name == null) {
      return;
    }
    var name = pre!.settings.name!;
    if (name == "/" && Global.get().hasLogin) {
      name = "RootPage";
    }
    if (name == chatPage) {
      name += "-" + (pre.settings.arguments.toString());
    }
    curPage = name;
    // _log.info("didPop curPage: $curPage");
    Im.get().requestSystem(actOnline, {}, msgId: name);
    Notice.send(UcActions.routePop(), name);
    UcNotice.send(UcActions.routePop(), name);
  }

  @override
  void didPush(Route route, Route? pre) {
    super.didPush(route, pre);
    _log.info(
        "route didPush ${route.settings.name}  from: ${pre?.settings.name},hasLogin:${Global.get().hasLogin}");
    if (!Global.get().hasLogin) {
      return;
    }
    if (route.settings.name == null) {
      return;
    }
    var name = route.settings.name!;
    if (name == "/" && Global.get().hasLogin) {
      name = "RootPage";
    }
    if (name == chatPage || name == callPage) {
      name += "-" + route.settings.arguments.toString();
    }
    curPage = name;
    // _log.info("didPush curPage: $curPage");
    Im.get().requestSystem(actOnline, {}, msgId: name);
  }
}

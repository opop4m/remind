import 'package:client/ui/route/fade_route.dart';
import 'package:client/ui/route/rotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef VoidCallbackWithType = void Function(String type);
typedef VoidCallbackConfirm = void Function(bool isOk);
typedef VoidCallbackWithMap = void Function(Map item);

final navGK = new GlobalKey<NavigatorState>();
GlobalKey<ScaffoldState>? scaffoldGK;

Future<dynamic> routePush(Widget widget, {Object? arguments}) {
  final route = new CupertinoPageRoute(
    builder: (BuildContext context) => widget,
    settings: new RouteSettings(
      name: widget.toStringShort(),
      arguments: arguments,
    ),
  );
  return navGK.currentState!.push(route);
}

Future<dynamic> routePushReplace(Widget widget, {Object? arguments}) {
  final route = new CupertinoPageRoute(
    builder: (BuildContext context) => widget,
    settings: new RouteSettings(
      name: widget.toStringShort(),
      arguments: arguments,
    ),
  );
  return navGK.currentState!.pushReplacement(route);
}

Future<dynamic> routeMaterialPush(Widget widget) {
  final route = new MaterialPageRoute(
    builder: (BuildContext context) => widget,
    settings: new RouteSettings(
      name: widget.toStringShort(),
    ),
  );
  return navGK.currentState!.push(route);
}

Future<dynamic> routeFadePush(Widget widget) {
  final route = new FadeRoute(widget);
  return navGK.currentState!.push(route);
}

Future<dynamic> routeRotationPush(Widget widget) {
  final route = new RotationRoute(widget);
  return navGK.currentState!.push(route);
}

Future<dynamic> routePushAndRemove(Widget widget) {
  final route = new CupertinoPageRoute(
    builder: (BuildContext context) => widget,
    settings: new RouteSettings(
      name: widget.toStringShort(),
    ),
  );
  return navGK.currentState!.pushAndRemoveUntil(route, (Route route) {
    //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
    // if (route.settings.name == "/") {
    //   return true; //停止关闭
    // }
    return false;
    //return route==null; //一直关闭页面，直到全部Route都关闭，效果就是整个应用，只剩下当前页面，按返回键会直接回系统桌面
  });
}

pushAndRemoveUntilPage(Widget page) {
  navGK.currentState!.pushAndRemoveUntil(new MaterialPageRoute<dynamic>(
    builder: (BuildContext context) {
      return page;
    },
  ), (Route<dynamic> route) => false);
}

pushReplacement(Widget page) {
  navGK.currentState!.pushReplacement(new MaterialPageRoute<dynamic>(
    builder: (BuildContext context) {
      return page;
    },
  ));
}

popToRootPage() {
  // navGK.currentState!.popUntil(ModalRoute.withName('/'));
  navGK.currentState!.popUntil((Route<dynamic> route) {
    return !route.willHandlePopInternally &&
        route is ModalRoute &&
        (route.settings.name == "/" || route.settings.name == "RootPage");
  });
}

popToTimes(int times) {
  int pop = 0;
  navGK.currentState!.popUntil((Route<dynamic> route) {
    pop++;
    // print("popToTimes: $pop, name: ${route.settings.name}");
    return !route.willHandlePopInternally &&
        route is ModalRoute &&
        (pop == times + 1);
  });
}

popToPage(Widget page) {
  try {
    navGK.currentState!.popUntil(ModalRoute.withName(page.toStringShort()));
  } catch (e) {
    print('pop路由出现错误:::${e.toString()}');
  }
}

popToHomePage() {
  navGK.currentState!.maybePop();
  navGK.currentState!.maybePop();
  navGK.currentState!.maybePop();
}

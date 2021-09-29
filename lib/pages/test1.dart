import 'dart:math';

import 'package:client/provider/service/im.dart';
import 'package:client/tools/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:proximity_sensor/proximity_sensor.dart';
// import 'package:wakelock/wakelock.dart';

final _log = Logger("Test");

class Test extends StatefulWidget {
  @override
  _test createState() => _test();
}

class _test extends State<Test> {
  TextEditingController inputC = TextEditingController();

  bool _isNear = false;
  late StreamSubscription<int> _streamSubscription;

  @override
  void initState() {
    super.initState();
    // listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    // _streamSubscription.cancel();
  }

  StreamSubscription<int> listenSensor() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (API.debug) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    // _streamSubscription = ProximitySensor.events.listen((int event) {
    //   _isNear = (event > 0) ? true : false;
    //   _log.info("_isNear: $_isNear");
    //   setState(() {});
    // });
    return _streamSubscription;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: inputC,
          onChanged: (String text) {},
          decoration: InputDecoration(
              border: UnderlineInputBorder(), labelText: 'Enter your uid'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => event("test"),
              child: Text("test"),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => event("badge"),
              child: Text("badge"),
            ),
            ElevatedButton(
              onPressed: () => event("showLoading"),
              child: Text("showLoading"),
            ),
            ElevatedButton(
              onPressed: () => event("dismissLoading"),
              child: Text("dismissLoading"),
            ),
          ],
        ),
        Text('proximity sensor, is near ?  $_isNear\n'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => event("start"),
              child: Text("start ProximitySensor"),
            ),
            ElevatedButton(
              onPressed: () => event("end"),
              child: Text("end ProximitySensor"),
            ),
          ],
        ),
      ],
    );
  }

  void event(String act) {
    _log.info("act: $act");
    switch (act) {
      case 'start':
        listenSensor();
        break;
      case 'end':
        _streamSubscription.cancel();
        break;
      case "test":
        Im.get().requestSystem(API.actChatUser, {
          "uids": [inputC.text]
        });
        break;
      case "badge":
        if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
          var t = Random().nextInt(10);
          _log.info("badge: $t");
          FlutterAppBadger.updateBadgeCount(t);
        }
        break;
      case "showLoading":
        EasyLoading.show(
            status: 'loading...', maskType: EasyLoadingMaskType.black);
        Future.delayed(Duration(seconds: 3), () {
          EasyLoading.dismiss();
        });
        break;
      case "dismissLoading":
        break;
    }
  }
}

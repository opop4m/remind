import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

showToast(String msg, {int duration = 1, int? gravity}) {
  // Toast.show(msg, context, duration: duration, gravity: gravity);
  EasyLoading.instance.userInteractions = null;
  EasyLoading.showToast(msg);
}

showLoading() {
  EasyLoading.instance.userInteractions = false;
  EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
}

dismissLoading() {
  EasyLoading.dismiss();
}

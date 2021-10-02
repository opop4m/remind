import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

showToast(String msg, {int duration = 1, int? gravity}) {
  // Toast.show(msg, context, duration: duration, gravity: gravity);
  EasyLoading.showToast(msg);
  // FToast fToast = FToast();
  // fToast.init(context);
  // Widget toast = Container(
  //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  //   decoration: BoxDecoration(
  //     borderRadius: BorderRadius.circular(25.0),
  //     color: Colors.greenAccent,
  //   ),
  //   child: Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(Icons.check),
  //       SizedBox(
  //         width: 12.0,
  //       ),
  //       Text(msg),
  //     ],
  //   ),
  // );

  // fToast.showToast(
  //   child: toast,
  //   gravity: ToastGravity.BOTTOM,
  //   toastDuration: Duration(seconds: 2),
  // );
}

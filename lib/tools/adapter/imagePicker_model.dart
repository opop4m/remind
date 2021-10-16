import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class PickerResult {
  Size size = Size(0, 0);
  Uint8List? bytes;

  PickerResult(this.bytes, this.size);
}

class PickerPath {
  Size size = Size(0, 0);
  String? path;

  PickerPath(this.path, this.size);
}

Future<PickerResult> getImageSizeFromMem(Uint8List bytes) {
  var completer = Completer<PickerResult>();
  Image image = Image.memory(bytes);
  image.image
      .resolve(ImageConfiguration())
      .addListener(new ImageStreamListener((ImageInfo info, bool _) {
    //      = info.image.width;
    // m.height = info.image.height;
    // this.sendMsg(m);
    var size = Size(info.image.width.toDouble(), info.image.height.toDouble());
    var res = PickerResult(bytes, size);
    completer.complete(res);
  }));
  return completer.future;
}

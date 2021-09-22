import 'dart:typed_data';

import 'package:flutter/material.dart';
import './imagePicker.dart' if (dart.library.js) './imagePicker_web.dart';

class UcImagePicker {
  static Future<List<Uint8List>> multiImages(BuildContext ctx) {
    return getMultiImages(ctx);
  }

  static Future<Uint8List?> image() {
    return getImage();
  }

  static Future<String?> imagePath() {
    return getImagePath();
  }
}

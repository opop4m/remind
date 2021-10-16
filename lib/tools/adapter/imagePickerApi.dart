import 'package:flutter/material.dart';
import './imagePicker.dart' if (dart.library.js) './imagePicker_web.dart';
import 'imagePicker_model.dart';

class UcImagePicker {
  static Future<List<PickerResult>> multiImages(BuildContext ctx) {
    return getMultiImages(ctx);
  }

  static Future<PickerResult?> image() {
    return getImage();
  }

  static Future<String?> imagePath() {
    return getImagePath();
  }
}

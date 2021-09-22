import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:html' as html;
import '../utils.dart';

Future<List<Uint8List>> getMultiImages(BuildContext ctx) async {
  List<Uint8List> list =
      await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes)
          as List<Uint8List>;
  return list;
}

Future<Uint8List?> getImage() async {
  Uint8List? imgBytes;
  if (!PlatformUtils.isWeb) {
    final ImagePicker _picker = ImagePicker();
    XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      imgBytes = await img.readAsBytes();
    }
  } else {
    Uint8List? _imgBytes =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes)
            as Uint8List?;

    if (_imgBytes != null) {
      imgBytes = _imgBytes;
    }
  }
  return imgBytes;
}

Future<String?> getImagePath() async {
  String? imgPath;
  if (!PlatformUtils.isWeb) {
    final ImagePicker _picker = ImagePicker();
    XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      imgPath = await img.path;
    }
  } else {
    html.File? imageFile =
        await ImagePickerWeb.getImage(outputType: ImageType.file) as html.File?;
    if (imageFile != null) {
      imgPath = imageFile.relativePath;
    }
  }
  return imgPath;
}

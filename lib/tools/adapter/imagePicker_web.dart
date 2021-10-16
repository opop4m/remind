import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:html' as html;
import '../utils.dart';
import 'imagePicker_model.dart';

Future<List<PickerResult>> getMultiImages(BuildContext ctx) async {
  List<PickerResult> list = [];
  List<Uint8List> bytesList =
      await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes)
          as List<Uint8List>;
  for (var i = 0; i < bytesList.length; i++) {
    var bytes = bytesList[i];
    var res = await getImageSizeFromMem(bytes);
    list.add(res);
  }
  return list;
}

Future<PickerResult?> getImage() async {
  PickerResult? result;
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
  if (imgBytes != null) {
    result = await getImageSizeFromMem(imgBytes);
  }
  return result;
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

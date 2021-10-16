import 'dart:typed_data';

import 'package:client/tools/library.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'imagePicker_model.dart';

final _log = Logger("imgPicker");

Future<List<PickerResult>> getMultiImages(BuildContext ctx) async {
  List<PickerResult> list = [];
  List<AssetEntity> assets = <AssetEntity>[];
  var result = await AssetPicker.pickAssets(
    ctx,
    maxAssets: 9,
    pageSize: 320,
    pathThumbSize: 80,
    gridCount: 4,
    selectedAssets: assets,
    themeColor: Colors.green,
    // textDelegate: DefaultAssetsPickerTextDelegate(),
    routeCurve: Curves.easeIn,
    routeDuration: const Duration(milliseconds: 500),
  );
  if (result == null) {
    return [];
  }
  List<AssetEntity> _list = result;
  _log.info("choose result : ${_list.length}");
  for (var i = 0; i < _list.length; i++) {
    var element = _list[i];
    var f = await element.file;
    var bytes = await f?.readAsBytes();
    if (bytes != null) {
      var res = await getImageSizeFromMem(bytes);
      list.add(res);
    }
    _log.info("get bytes: ${bytes?.length}");
  }

  return list;
}

Future<PickerResult?> getImage() async {
  PickerResult? result;
  Uint8List? imgBytes;
  final ImagePicker _picker = ImagePicker();
  XFile? img = await _picker.pickImage(source: ImageSource.gallery);
  if (img != null) {
    imgBytes = await img.readAsBytes();
    result = await getImageSizeFromMem(imgBytes);
  }
  return result;
}

Future<String?> getImagePath() async {
  String? imgPath;
  final ImagePicker _picker = ImagePicker();
  XFile? img = await _picker.pickImage(source: ImageSource.gallery);
  if (img != null) {
    imgPath = img.path;
  }
  return imgPath;
}

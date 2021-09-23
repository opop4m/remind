import 'dart:convert';
import 'dart:typed_data';

import 'package:client/http/req.dart';
import 'package:client/provider/global_model.dart';
import 'package:client/tools/library.dart';
import 'package:client/tools/mimeType.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

final _log = Logger("API");

/// 随机头像 [Random avatar]
void postSuggestionWithAvatar(BuildContext context) async {
  final model = Provider.of<GlobalModel>(context);

  // Req.getInstance().get(
  //   API.cat,
  //   (v) async {
  //     String avatarUrl = v['url'];
  //     final data = await setUsersProfileMethod(
  //       context,
  //       avatarStr: avatarUrl,
  //       nickNameStr: model.nickName,
  //       callback: (data) {},
  //     );
  //
  //     if (data.toString().contains('ucc')) {
  //       showToast(context, '设置头像成功');
  //       model.avatar = avatarUrl;
  //       model.refresh();
  //       await SharedUtil.instance.saveString(Keys.faceUrl, avatarUrl);
  //     } else {
  //       showToast(context, '设置头像失败');
  //     }
  //   },
  // );
}

/// 检查更新 [check update]
void updateApi(BuildContext context) async {
  // if (Platform.isIOS) return;
  // Req.getInstance().get(
  //   API.update,
  //   (v) async {
  //     final packageInfo = await PackageInfo.fromPlatform();
  //     UpdateEntity model = UpdateEntity.fromJson(v);
  //     int currentVersion = int.parse(removeDot(packageInfo.version));
  //     int netVersion = int.parse(removeDot(model.appVersion));
  //     if (currentVersion >= netVersion) {
  //       debugPrint('当前版本是最新版本');
  //       return;
  //     }
  //     showDialog(
  //         context: context,
  //         builder: (ctx2) {
  //           return UpdateDialog(
  //             version: model.appVersion,
  //             updateUrl: model.downloadUrl,
  //             updateInfo: model.updateInfo,
  //           );
  //         });
  //   },
  // );
}

/// 上传头像 [uploadImg]
Future<String> uploadMediaApi(
  Uint8List mediaBytes,
  String ext,
  String scene,
) async {
  var path = "";
  var avatarF = MultipartFile.fromBytes(
    mediaBytes,
    filename: "img.jpeg",
    contentType: MediaType('application', 'image/jpeg'),
  );
  var digest = md5.convert(mediaBytes);
  // 这里其实就是 digest.toString()
  var md = hex.encode(digest.bytes);
  var url = API.uploadHost + "/group1/upload";
  var params = <String, dynamic>{
    "md5": md,
    "output": "json2",
    "auth_token": Global.get().curUser.accessToken,
  };
  var rsp = await Req.g().get(url, params: params);
  if (rsp.data != null) {
    var json = jsonDecode(rsp.data!);
    // _log.info("upload res: ${rsp.data}");
    if (json["status"] == "ok") {
      path = json["data"]["path"];
      return path;
    }
  }

  params = {
    "scene": scene,
    "filename": md + ext,
    "output": "json2",
    "auth_token": Global.get().curUser.accessToken,
    "file": avatarF,
  };

  rsp = await Req.g().post(url, params);
  if (rsp.data != null) {
    var json = jsonDecode(rsp.data!);
    if (json["status"] == "ok") {
      path = json["data"]["path"];
    }
    // _log.info("upload res: ${rsp.data}");
  }
  return path;
}

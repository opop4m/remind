import 'package:camera/camera.dart';
import 'package:client/http/api.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'package:client/pages/chat/shoot_page.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/tools/adapter/imagePicker.dart';
// import 'package:client/tools/handle_util.dart';
import 'package:client/tools/library.dart';
import 'package:client/tools/mimeType.dart';
import 'package:client/ui/card/more_item_card.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
// import 'package:photo_manager/photo_manager.dart';

final _log = Logger("ChatMorePage");

class ChatMorePage extends StatefulWidget {
  final int index;
  final String? id;
  final int? type;
  final double? keyboardHeight;

  ChatMorePage({this.index = 0, this.id, this.type, this.keyboardHeight});

  @override
  _ChatMorePageState createState() => _ChatMorePageState();
}

class _ChatMorePageState extends State<ChatMorePage> {
  List data = [
    {"name": "相册", "icon": "assets/images/chat/ic_details_photo.webp"},
    {"name": "拍摄", "icon": "assets/images/chat/ic_details_camera.webp"},
    {"name": "视频通话", "icon": "assets/images/chat/ic_details_media.webp"},
    {"name": "位置", "icon": "assets/images/chat/ic_details_localtion.webp"},
    {"name": "红包", "icon": "assets/images/chat/ic_details_red.webp"},
    {"name": "转账", "icon": "assets/images/chat/ic_details_transfer.webp"},
    {"name": "语音输入", "icon": "assets/images/chat/ic_chat_voice.webp"},
    {"name": "我的收藏", "icon": "assets/images/chat/ic_details_favorite.webp"},
  ];

  List dataS = [
    {"name": "名片", "icon": "assets/images/chat/ic_details_card.webp"},
    {"name": "文件", "icon": "assets/images/chat/ic_details_file.webp"},
  ];

  List<AssetEntity> assets = <AssetEntity>[];

  action(String name) async {
    if (name == '相册') {
      if (PlatformUtils.isWeb) {
        var list = await UcImagePicker.getMultiImages();
        list.forEach((bytes) async {
          var mime = lookupMimeType('', headerBytes: bytes.sublist(0, 10));
          if (mime == null) {
            _log.info("unknow file type");
            return;
          }
          var ext = findExtFromMime(mime);
          var imgPath = await uploadImgApi(bytes, ext, "avatar");
          if (strNoEmpty(imgPath)) {
            var msg = Im.newMsg(
                widget.type ?? typePerson, msgTypeImage, widget.id!,
                ext: imgPath);
            Im.get().sendChatMsg(msg);
          }
        });
      } else {
        AssetPicker.pickAssets(
          context,
          maxAssets: 9,
          pageSize: 320,
          pathThumbSize: 80,
          gridCount: 4,
          selectedAssets: assets,
          themeColor: Colors.green,
          // textDelegate: DefaultAssetsPickerTextDelegate(),
          routeCurve: Curves.easeIn,
          routeDuration: const Duration(milliseconds: 500),
        ).then((List<AssetEntity>? result) {
          result?.forEach((AssetEntity element) async {
            // sendImageMsg(widget.id, widget.type, file: await element.file,
            //     callback: (v) {
            //   if (v == null) return;
            //   Notice.send(WeChatActions.msg(), v ?? '');
            // });
            var f = await element.file;
          });
        });
      }
    } else if (name == '拍摄') {
      try {
        List<CameraDescription> cameras;

        WidgetsFlutterBinding.ensureInitialized();
        cameras = await availableCameras();

        routePush(new ShootPage(cameras));
      } on CameraException catch (e) {
        _log.info(e.code, e.description);
      }
    } else {
      showToast(context, '敬请期待$name');
    }
  }

  itemBuild(data) {
    return new Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.only(bottom: 20.0),
      child: new Wrap(
        runSpacing: 10.0,
        spacing: 10,
        children: List.generate(data.length, (index) {
          String name = data[index]['name'];
          String icon = data[index]['icon'];
          return new MoreItemCard(
            name: name,
            icon: icon,
            keyboardHeight: widget.keyboardHeight,
            onPressed: () => action(name),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == 0) {
      return itemBuild(data);
    } else {
      return itemBuild(dataS);
    }
  }
}

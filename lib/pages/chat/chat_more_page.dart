import 'package:camera/camera.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'package:client/pages/chat/shoot_page.dart';
import 'package:client/pages/chat/videoCall2.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/tools/adapter/imagePickerApi.dart';
// import 'package:client/tools/handle_util.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/card/more_item_card.dart';
import 'package:flutter/material.dart';
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
    {"name": "语音通话", "icon": "assets/images/chat/ic_details_voice.webp"},
    {"name": "视频通话", "icon": "assets/images/chat/ic_details_media.webp"},
    {"name": "位置", "icon": "assets/images/chat/ic_details_localtion.webp"},
    {"name": "红包", "icon": "assets/images/chat/ic_details_red.webp"},
    {"name": "转账", "icon": "assets/images/chat/ic_details_transfer.webp"},
    {"name": "我的收藏", "icon": "assets/images/chat/ic_details_favorite.webp"},
  ];

  List dataS = [
    {"name": "名片", "icon": "assets/images/chat/ic_details_card.webp"},
    {"name": "文件", "icon": "assets/images/chat/ic_details_file.webp"},
  ];

  List<AssetEntity> assets = <AssetEntity>[];

  action(String name) async {
    if (name == '相册') {
      var list = await UcImagePicker.multiImages(context);
      _log.info("choose list len: ${list.length}");

      for (var i = 0; i < list.length; i++) {
        var bytes = list[i];
        _log.info("choose 1111");
        Im.sendMediaMsg(
            widget.type ?? typePerson, msgTypeImage, widget.id!, bytes);
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
    } else if (name == '语音通话') {
      var user = await ImData.get().getChatUser(widget.id!);
      routePush(VideoCallView(
        user,
        callType: msgTypeVoiceCall,
      ));
    } else if (name == '视频通话') {
      var user = await ImData.get().getChatUser(widget.id!);
      routePush(VideoCallView(
        user,
        callType: msgTypeVideoCall,
      ));
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

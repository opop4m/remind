import 'dart:convert';

import 'package:client/provider/global_cache.dart';
import 'package:client/provider/model/chat_data.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:client/tools/wechat_flutter.dart';

import '../../provider/global_model.dart';

class ImgMsg extends StatelessWidget {
  // final msg;

  final ChatMsg msg;
  final ChatUser user;

  ImgMsg(this.msg, this.user);

  @override
  Widget build(BuildContext context) {
    if (msg.status == msgStateSending) return Text('发送中');
    var my = GlobalCache.get().user;
    List<MsgImg> list = jsonDecode(msg.ext!);
    var msgInfo = list[1];
    var _height = msgInfo.height;
    var resultH = _height > 200.0 ? 200.0 : _height;
    var url = msgInfo.url;
    var isFile = File(url).existsSync();
    final globalModel = Provider.of<GlobalModel>(context);
    var body = [
      new MsgAvatar(model: msg, user: user),
      new Space(width: mainSpace),
      new Expanded(
        child: new GestureDetector(
          child: new Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: new ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: isFile
                  ? new Image.file(File(url))
                  : new CachedNetworkImage(
                      imageUrl: url, height: resultH, fit: BoxFit.cover),
            ),
          ),
          onTap: () {
            ImageProvider image;
            if (isFile) {
              image = FileImage(File(url));
            } else {
              image = NetworkImage(url);
            }
            routePush(
              new PhotoView(
                imageProvider: image,
                // imageProvider: FileImage(File(url)),
                onTapUp: (c, f, s) => Navigator.of(context).pop(),
                maxScale: 3.0,
                minScale: 1.0,
              ),
            );
          },
        ),
      ),
      new Spacer(),
    ];
    if (user.id == my.id) {
      body = body.reversed.toList();
    } else {
      body = body;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(children: body),
    );
  }
}

class MsgImg {
  double height = 0;
  String url = "";
}

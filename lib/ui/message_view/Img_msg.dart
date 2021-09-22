import 'dart:convert';

import 'package:client/provider/global_cache.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:client/tools/library.dart';

class ImgMsg extends StatelessWidget {
  // final msg;

  final ChatMsg msg;
  final ChatUser user;

  ImgMsg(this.msg, this.user);

  @override
  Widget build(BuildContext context) {
    // if (msg.status == msgStateSending) return Text('发送中');
    var my = Global.get().curUser;
    var url = getImgUrl(msg.ext)!;
    var isFile = false;
    if (!PlatformUtils.isWeb && url.startsWith("http")) {
      isFile = File(url).existsSync();
    }

    // final globalModel = Provider.of<GlobalModel>(context);
    var body = [
      new MsgAvatar(model: msg, user: user),
      new Space(width: mainSpace),
      new Expanded(
        child: new GestureDetector(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200, minHeight: 100),
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
                        imageUrl: url, height: null, fit: BoxFit.cover),
              ),
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
                loadingBuilder: (context, ImageChunkEvent? event) {
                  return SizedBox();
                },
                onTapUp: (c, f, s) => Navigator.of(context).pop(),
                maxScale: 3.0,
                minScale: PhotoViewComputedScale.contained,
              ),
            );
          },
        ),
      ),
      new Spacer(),
    ];
    if (msg.fromId == my.id) {
      body = body.reversed.toList();
    } else {
      body = body;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: body,
      ),
    );
  }
}

class MsgImg {
  double height = 0;
  String url = "";
}

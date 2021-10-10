import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:client/ui/message_view/Img_msg.dart';
import 'package:client/ui/message_view/join_message.dart';
import 'package:client/ui/message_view/modify_groupInfo_message.dart';
import 'package:client/ui/message_view/modify_notification_message.dart';
import 'package:client/ui/message_view/sound_msg.dart';
import 'package:client/ui/message_view/text_msg.dart';

class SendMessageView2 extends StatelessWidget {
  final ChatMsg model;
  final ChatUser user;

  SendMessageView2(this.model, this.user);

  @override
  Widget build(BuildContext context) {
    var _msg = model;
    var isGroup = (model.type == typeGroup);
    var isSelf = _msg.fromId == Global.get().curUser.id;
    if (_msg.msgType == msgTypeText ||
        _msg.msgType == msgTypeVoiceCall ||
        _msg.msgType == msgTypeVideoCall) {
      if (isGroup && !isSelf) {
        var u = user;
        return FutureBuilder(
          future: ImData.getUserInfo(_msg.fromId, (data) {
            u = data;
          }),
          builder: (ctx, snapshot) {
            return TextMsg(_msg.content ?? "", model, u);
          },
        );
      }
      return new TextMsg(_msg.content ?? "", model, user);
    } else if (_msg.msgType == msgTypeImage) {
      return new ImgMsg(_msg, user);
    } else if (_msg.msgType == msgTypeVoice) {
      return new SoundMsg(_msg, user);
    } else if (_msg.tipsType == tipsTypeJoin || _msg.tipsType == tipsTypeQuit) {
      return JoinMessage(_msg);
    } else if (_msg.tipsType == tipsTypeGroupNotice) {
      return ModifyNotificationMessage(_msg, user);
    } else if (_msg.tipsType == tipsTypeGroupNameChange) {
      return ModifyGroupInfoMessage(_msg);
    } else {
      return new Text('未知消息');
    }
  }
}

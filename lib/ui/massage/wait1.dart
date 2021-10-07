import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:client/ui/message_view/Img_msg.dart';
import 'package:client/ui/message_view/join_message.dart';
import 'package:client/ui/message_view/modify_groupInfo_message.dart';
import 'package:client/ui/message_view/modify_notification_message.dart';
import 'package:client/ui/message_view/quit_message.dart';
import 'package:client/ui/message_view/sound_msg.dart';
import 'package:client/ui/message_view/text_msg.dart';

class SendMessageView2 extends StatelessWidget {
  final ChatMsg model;
  final ChatUser user;

  SendMessageView2(this.model, this.user);

  @override
  Widget build(BuildContext context) {
    var _msg = model;
    if (_msg.msgType == msgTypeText ||
        _msg.msgType == msgTypeVoiceCall ||
        _msg.msgType == msgTypeVideoCall) {
      return new TextMsg(_msg.content ?? "", model, user);
    } else if (_msg.msgType == msgTypeImage) {
      return new ImgMsg(_msg, user);
    } else if (_msg.msgType == msgTypeVoice) {
      return new SoundMsg(_msg, user);
    } else if (_msg.tipsType == tipsTypeJoin || _msg.tipsType == tipsTypeQuit) {
      return JoinMessage(_msg);
    } else if (_msg.tipsType == tipsTypeGroupNotice) {
      return ModifyNotificationMessage(_msg);
    } else if (_msg.tipsType == tipsTypeGroupNameChange) {
      return ModifyGroupInfoMessage(_msg);
    } else {
      return new Text('未知消息');
    }
  }
}

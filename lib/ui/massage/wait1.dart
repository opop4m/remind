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

class SendMessageView extends StatefulWidget {
  final ChatMsg model;
  final ChatUser user;

  SendMessageView(this.model, this.user);

  @override
  _SendMessageViewState createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  @override
  Widget build(BuildContext context) {
    // Map msg = widget.model.msg;
    // String msgType = msg['type'];
    // String msgStr = msg.toString();

    var _msg = widget.model;

    // bool isI = PlatformUtils.isIOS;
    // bool iosText = isI && msgStr.contains('text:');
    // bool iosImg = isI && msgStr.contains('imageList:');
    // var iosS = msgStr.contains('downloadFlag:') && msgStr.contains('second:');
    // bool iosSound = isI && iosS;
    if (_msg.msgType == msgTypeText) {
      return new TextMsg(_msg.content, widget.model, widget.user);
    } else if (_msg.msgType == msgTypeImage) {
      return new ImgMsg(_msg, widget.user);
    } else if (_msg.msgType == msgTypeVoice) {
      return new SoundMsg(_msg, widget.user);
//    } else if (msg.toString().contains('snapshotPath') &&
//        msg.toString().contains('videoPath')) {
//      return VideoMessage(msg, msgType, widget.data);
    } else if (_msg.tipsType == tipsTypeJoin) {
      return JoinMessage(_msg);
    } else if (_msg.tipsType == tipsTypeQuit) {
      return QuitMessage(_msg);
    } else if (_msg.tipsType == tipsTypeGroupNotice) {
      return ModifyNotificationMessage(_msg);
    } else if (_msg.tipsType == tipsTypeGroupNameChange) {
      return ModifyGroupInfoMessage(_msg);
    } else {
      return new Text('未知消息');
    }
  }
}

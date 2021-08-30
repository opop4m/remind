import 'dart:io';

import 'package:client/provider/model/chat_data.dart';
import 'package:client/tools/utils/utils.dart';
import 'package:client/tools/wechat_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/provider/global_model.dart';

import 'package:client/ui/message_view/Img_msg.dart';
import 'package:client/ui/message_view/join_message.dart';
import 'package:client/ui/message_view/modify_groupInfo_message.dart';
import 'package:client/ui/message_view/modify_notification_message.dart';
import 'package:client/ui/message_view/quit_message.dart';
import 'package:client/ui/message_view/sound_msg.dart';
import 'package:client/ui/message_view/tem_message.dart';
import 'package:client/ui/message_view/text_msg.dart';
import 'package:client/ui/message_view/video_message.dart';

class SendMessageView extends StatefulWidget {
  final ChatData model;

  SendMessageView(this.model);

  @override
  _SendMessageViewState createState() => _SendMessageViewState();
}

class _SendMessageViewState extends State<SendMessageView> {
  @override
  Widget build(BuildContext context) {
    Map msg = widget.model.msg;
    String msgType = msg['type'];
    String msgStr = msg.toString();

    bool isI = PlatformUtils.isIOS;
    bool iosText = isI && msgStr.contains('text:');
    bool iosImg = isI && msgStr.contains('imageList:');
    var iosS = msgStr.contains('downloadFlag:') && msgStr.contains('second:');
    bool iosSound = isI && iosS;
    if (msgType == "Text" || iosText) {
      return new TextMsg(msg['text'], widget.model);
    } else if (msgType == "Image" || iosImg) {
      return new ImgMsg(msg, widget.model);
    } else if (msgType == 'Sound' || iosSound) {
      return new SoundMsg(widget.model);
//    } else if (msg.toString().contains('snapshotPath') &&
//        msg.toString().contains('videoPath')) {
//      return VideoMessage(msg, msgType, widget.data);
    } else if (msg['tipsType'] == 'Join') {
      return JoinMessage(msg);
    } else if (msg['tipsType'] == 'Quit') {
      return QuitMessage(msg);
    } else if (msg['groupInfoList'][0]['type'] == 'ModifyIntroduction') {
      return ModifyNotificationMessage(msg);
    } else if (msg['groupInfoList'][0]['type'] == 'ModifyName') {
      return ModifyGroupInfoMessage(msg);
    } else {
      return new Text('未知消息');
    }
  }
}

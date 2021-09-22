import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';

import 'package:client/tools/library.dart';
import 'package:client/ui/edit/text_span_builder.dart';

class ContentMsg extends StatefulWidget {
  // final Map msg;
  final ChatRecent msg;

  ContentMsg(this.msg);

  @override
  _ContentMsgState createState() => _ContentMsgState();
}

class _ContentMsgState extends State<ContentMsg> {
  late String str;

  TextStyle _style = TextStyle(color: mainTextColor, fontSize: 14.0);

  @override
  Widget build(BuildContext context) {
    if (widget.msg == null) return new Text('未知消息', style: _style);
    ChatRecent msg = widget.msg;

    // String msgType = msg['type'];
    // String msgStr = msg.toString();

    // bool isI = PlatformUtils.isIOS;
    // bool iosText = isI && msgStr.contains('text:');
    // bool iosImg = isI && msgStr.contains('imageList:');
    // var iosS = msgStr.contains('downloadFlag:') && msgStr.contains('second:');
    // bool iosSound = isI && iosS;
    if (msg.msgType == msgTypeText) {
      str = msg.content ?? "";
    } else if (msg.msgType == msgTypeImage) {
      str = '[图片]';
    } else if (msg.msgType == msgTypeVoice) {
      str = '[语音消息]';
    } else if (msg.msgType == msgTypeVideo) {
      str = '[视频]';
    } else if (msg.tipsType == tipsTypeJoin) {
      str = '[系统消息] 新人入群';
    } else if (msg.tipsType == tipsTypeQuit) {
      str = '[系统消息] 有人退出群聊';
    } else if (msg.tipsType == tipsTypeGroupNotice) {
      str = '[系统消息] 群公告';
    } else if (msg.tipsType == tipsTypeGroupNameChange) {
      str = '[系统消息] 群名修改';
    } else {
      str = '[未知消息]';
    }

    return new ExtendedText(
      str,
      specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _style,
    );
  }
}

import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imData.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.msg == null) return new Text('未知消息', style: _style);
    ChatRecent msg = widget.msg;
    if (msg.msgType == msgTypeText) {
      str = msg.content ?? "";
    } else if (msg.msgType == msgTypeImage) {
      str = '[图片]';
    } else if (msg.msgType == msgTypeVoice) {
      str = '[语音消息]';
    } else if (msg.msgType == msgTypeVideo) {
      str = '[视频]';
    } else if (msg.msgType == msgTypeVideoCall) {
      str = '[视频电话]';
    } else if (msg.msgType == msgTypeVoiceCall) {
      str = '[语音电话]';
    } else if (msg.tipsType == tipsTypeJoin) {
      var arr = msg.ext!.split(",");
      var uName = arr[0];
      // var inviteName = arr[1];
      str = '[系统] $uName 加入此群';
    } else if (msg.tipsType == tipsTypeQuit) {
      var arr = msg.ext!.split(",");
      var uName = arr[0];
      str = '[系统] $uName 退出此群';
    } else if (msg.tipsType == tipsTypeGroupNotice) {
      str = '[系统消息] 群公告';
    } else if (msg.tipsType == tipsTypeGroupNameChange) {
      str = '[系统消息] 群名修改';
    } else {
      str = '[未知消息]';
    }
    var fb = FutureBuilder(
      future: _getGroupStr(msg),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError &&
            msg.type == typeGroup) {
          str = snapshot.data.toString();
        }

        return ExtendedText(
          str,
          specialTextSpanBuilder: TextSpanBuilder(showAtBackground: true),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _style,
        );
      },
    );
    return fb;
  }

  Future<String> _getGroupStr(ChatRecent msg) async {
    if (msg.type == typeGroup) {
      ChatUser user = await ImData.get().getChatUser(msg.fromId);
      var groupContent = user.name + " : " + (msg.content ?? "");
      return groupContent;
    }
    return "";
  }

  Future<String> _getContent() async {
    ChatRecent msg = widget.msg;

    var str;
    if (msg.msgType == msgTypeText) {
      if (msg.type == typeGroup) {
        ChatUser user = await ImData.get().getChatUser(msg.fromId);
      } else {
        str = msg.content ?? "";
      }
    } else if (msg.msgType == msgTypeImage) {
      str = '[图片]';
    } else if (msg.msgType == msgTypeVoice) {
      str = '[语音消息]';
    } else if (msg.msgType == msgTypeVideo) {
      str = '[视频]';
    } else if (msg.msgType == msgTypeVideoCall) {
      str = '[视频电话]';
    } else if (msg.msgType == msgTypeVoiceCall) {
      str = '[语音电话]';
    } else if (msg.tipsType == tipsTypeJoin) {
      var arr = msg.ext!.split(",");
      var uName = arr[0];
      // var inviteName = arr[1];
      str = '[系统] $uName 加入此群';
    } else if (msg.tipsType == tipsTypeQuit) {
      var arr = msg.ext!.split(",");
      var uName = arr[0];
      str = '[系统] $uName 退出此群';
    } else if (msg.tipsType == tipsTypeGroupNotice) {
      str = '[系统消息] 群公告';
    } else if (msg.tipsType == tipsTypeGroupNameChange) {
      str = '[系统消息] 群名修改';
    } else {
      str = '[未知消息]';
    }
    return str;
  }
}

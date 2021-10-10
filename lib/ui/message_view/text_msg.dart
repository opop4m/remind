import 'package:client/provider/global_cache.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/utils.dart';
import 'package:client/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/message_view/text_item_container.dart';

class TextMsg extends StatelessWidget {
  final String text;
  final ChatMsg msg;
  final ChatUser user;

  TextMsg(this.text, this.msg, this.user);

  @override
  Widget build(BuildContext context) {
    // final globalModel = Provider.of<GlobalModel>(context);
    var my = Global.get().curUser;
    bool isSelf = msg.fromId == my.id;
    var isGroup = (msg.type == typeGroup);
    Widget content;
    // if (msg.msgType == msgTypeVideoCall || msg.msgType == msgTypeVoiceCall) {
    //   content = Text("data");
    // } else {
    content = TextItemContainer2(
      text: text,
      isMyself: isSelf,
      isGroup: isGroup,
      msg: msg,
      userName: user.name,
    );
    // }

    var body = [
      new MsgAvatar(model: msg, user: user),
      content,
      new Spacer(),
    ];
    if (isSelf) {
      body = body.reversed.toList();
    } else {
      body = body;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: body,
      ),
    );
  }
}

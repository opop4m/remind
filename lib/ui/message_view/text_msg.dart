import 'package:client/provider/global_cache.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/utils.dart';
import 'package:client/ui/message_view/msg_avatar.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/message_view/text_item_container.dart';

class TextMsg extends StatelessWidget {
  final String text;
  final ChatMsg model;
  final ChatUser user;

  TextMsg(this.text, this.model, this.user);

  @override
  Widget build(BuildContext context) {
    // final globalModel = Provider.of<GlobalModel>(context);
    var my = Global.get().curUser;
    bool isSelf = model.fromId == my.id;

    var body = [
      new MsgAvatar(model: model, user: user),
      new TextItemContainer2(
        text: text,
        action: '',
        isMyself: isSelf,
        timeStr: Utils.formatTimeHM(model.createTime),
        status: model.type == typeGroup || !isSelf ? -2 : model.status ?? 0,
      ),
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

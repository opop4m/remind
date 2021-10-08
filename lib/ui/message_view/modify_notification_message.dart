import 'dart:convert';

import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:flutter/material.dart';
import 'package:client/tools/library.dart';

class ModifyNotificationMessage extends StatefulWidget {
  final ChatMsg data;
  final ChatUser user;

  ModifyNotificationMessage(this.data, this.user);

  ModifyNotificationMessageState createState() =>
      ModifyNotificationMessageState();
}

class ModifyNotificationMessageState extends State<ModifyNotificationMessage> {
  String name = "";

  @override
  void initState() {
    super.initState();
    // String user = widget.data['opGroupMemberInfo']['user'];
    getCardName();
  }

  getCardName() async {
    if (widget.data.fromId == Global.get().curUser.id) {
      name = "你";
    } else {
      var user = await ImData.get().getChatUser(widget.data.fromId);
      name = user.name;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: new Text(
        '${name} 修改了群公告',
        style:
            TextStyle(color: Color.fromRGBO(108, 108, 108, 0.8), fontSize: 11),
      ),
    );
  }
}

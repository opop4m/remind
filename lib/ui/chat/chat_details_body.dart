// import 'package:client/im/model/chat_data.dart';
import 'dart:convert';

import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/massage/wait1.dart';
import 'package:client/ui/view/indicator_page_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final _log = Logger("ChatDetailsBody");

class ChatDetailsBody extends StatelessWidget {
  final ScrollController? sC;
  final List<ChatMsg> chatData;
  ChatUser user;
  ChatDetailsBody({this.sC, required this.chatData, required this.user});

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      child: new ScrollConfiguration(
        behavior: MyBehavior(),
        child: Container(
          color: Colors.grey[100],
          child: ListView.builder(
            controller: sC,
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (context, int index) {
              ChatMsg msg = chatData[index];
              return new SendMessageView2(msg, user);
            },
            itemCount: chatData.length,
            dragStartBehavior: DragStartBehavior.down,
          ),
        ),
      ),
    );
  }
}

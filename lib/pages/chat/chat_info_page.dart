import 'dart:convert';

import 'package:client/pages/home/search_page.dart';
import 'package:client/pages/settings/chat_background_page.dart';
import 'package:client/ui/dialog/confirm_alert.dart';
import 'package:client/ui/item/chat_mamber.dart';
import 'package:client/ui/orther/label_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:client/tools/library.dart';

class ChatInfoPage extends StatefulWidget {
  final String id;

  ChatInfoPage(this.id);

  @override
  _ChatInfoPageState createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  var model;

  bool isRemind = false;
  bool isTop = false;
  bool isDoNotDisturb = true;

  Widget buildSwitch(item) {
    return new LabelRow(
      label: item['label'],
      margin: item['label'] == '消息免打扰' ? EdgeInsets.only(top: 10.0) : null,
      isLine: item['label'] != '强提醒',
      isRight: false,
      rightW: new SizedBox(
        height: 25.0,
        child: new CupertinoSwitch(
          value: item['value'],
          onChanged: (v) {},
        ),
      ),
      onPressed: () {},
    );
  }

  List<Widget> body() {
    List switchItems = [
      {"label": '消息免打扰', 'value': isDoNotDisturb},
      {"label": '置顶聊天', 'value': isTop},
      {"label": '强提醒', 'value': isRemind},
    ];

    return [
      new ChatMamBer(model: model),
      new LabelRow(
        label: '查找聊天记录',
        margin: EdgeInsets.only(top: 10.0),
        onPressed: () => routePush(new SearchPage()),
      ),
      new Column(
        children: switchItems.map(buildSwitch).toList(),
      ),
      new LabelRow(
        label: '设置当前聊天背景',
        margin: EdgeInsets.only(top: 10.0),
        onPressed: () => routePush(new ChatBackgroundPage()),
      ),
      new LabelRow(
        label: '清空聊天记录',
        margin: EdgeInsets.only(top: 10.0),
        onPressed: () {
          confirmAlert(
            context,
            (isOK) {
              if (isOK) showToast('敬请期待');
            },
            title: '确定删除群的聊天记录吗？',
            okBtn: '清空',
          );
        },
      ),
      new LabelRow(
        label: '投诉',
        margin: EdgeInsets.only(top: 10.0),
        onPressed: () => routePush(new WebViewPage(helpUrl, '投诉')),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    // final info = await getUsersProfile([widget.id]);
    // List infoList = json.decode(info);
    // setState(() {
    //   if (Platform.isIOS) {
    //     model = IPersonInfoEntity.fromJson(infoList[0]);
    //   } else {
    //     model = PersonInfoEntity.fromJson(infoList[0]);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(title: '聊天信息'),
      body: new SingleChildScrollView(
        child: new Column(children: body()),
      ),
    );
  }
}

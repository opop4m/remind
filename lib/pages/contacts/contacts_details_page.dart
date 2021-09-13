import 'package:client/pages/chat/chat_page.dart';
import 'package:client/pages/chat/more_info_page.dart';
import 'package:client/pages/chat/set_remark_page.dart';
import 'package:client/pages/wechat_friends/page/wechat_friends_circle.dart';
import 'package:client/provider/global_model.dart';
import 'package:client/ui/dialog/friend_item_dialog.dart';
import 'package:client/ui/item/contact_card.dart';
import 'package:client/ui/orther/button_row.dart';
import 'package:client/ui/orther/label_row.dart';
import 'package:flutter/material.dart';

import 'package:client/tools/library.dart';
import 'package:provider/provider.dart';

class ContactsDetailsPage extends StatefulWidget {
  final String? title, id;
  final String avatar;

  ContactsDetailsPage({required this.avatar, this.title, this.id});

  @override
  _ContactsDetailsPageState createState() => _ContactsDetailsPageState();
}

class _ContactsDetailsPageState extends State<ContactsDetailsPage> {
  List<Widget> body(bool isSelf) {
    return [
      new ContactCard(
        img: widget.avatar,
        id: widget.id,
        title: widget.title,
        nickName: widget.title,
        area: '北京 海淀',
        isBorder: true,
      ),
      new Visibility(
        visible: !isSelf,
        child: new LabelRow(
          label: '设置备注和标签',
          onPressed: () => routePush(new SetRemarkPage()),
        ),
      ),
      new Space(),
      new LabelRow(
        label: '朋友圈',
        isLine: true,
        lineWidth: 0.3,
        onPressed: () => routePush(new WeChatFriendsCircle()),
      ),
      new LabelRow(
        label: '更多信息',
        onPressed: () => routePush(new MoreInfoPage()),
      ),
      new ButtonRow(
        margin: EdgeInsets.only(top: 10.0),
        text: '发消息',
        isBorder: true,
        // onPressed: () => routePushReplace(
        //     new ChatPage(id: widget.id, title: widget.title, type: 1)),
      ),
      new Visibility(
        visible: !isSelf,
        child: new ButtonRow(
          text: '音视频通话',
          onPressed: () => showToast(context, '敬请期待'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);
    bool isSelf = globalModel.user.account == widget.id;

    var rWidget = [
      new SizedBox(
        width: 60,
        child: new FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          //     friendItemDialog(context, userId: widget.id, suCc: (v) {
          //   if (v) Navigator.of(context).maybePop();
          // }
          // ),
          child: new Image.asset(contactAssets + 'ic_contacts_details.png'),
        ),
      )
    ];

    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(
          title: '',
          backgroundColor: Colors.white,
          rightDMActions: isSelf ? [] : rWidget),
      body: new SingleChildScrollView(
        child: new Column(children: body(isSelf)),
      ),
    );
  }
}

import 'package:client/pages/chat/chat_page.dart';
import 'package:client/pages/chat/more_info_page.dart';
import 'package:client/pages/chat/set_remark_page.dart';
import 'package:client/pages/more/add_friend_details.dart';
import 'package:client/pages/more/verification_page.dart';
import 'package:client/pages/wechat_friends/page/wechat_friends_circle.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/ui/dialog/confirm_alert.dart';
import 'package:client/ui/item/contact_card.dart';
import 'package:client/ui/orther/button_row.dart';
import 'package:client/ui/orther/label_row.dart';
import 'package:flutter/material.dart';

import 'package:client/tools/library.dart';

class ContactsDetailsPage extends StatefulWidget {
  final String title, id;
  final String avatar;
  final int gender;

  ContactsDetailsPage(
      {required this.avatar,
      required this.title,
      required this.id,
      required this.gender});

  @override
  _ContactsDetailsPageState createState() => _ContactsDetailsPageState();
}

class _ContactsDetailsPageState extends State<ContactsDetailsPage> {
  List<Widget> body(bool isSelf, bool isFriend) {
    return [
      new ContactCard(
        img: widget.avatar,
        id: widget.id,
        title: widget.title,
        nickName: widget.title,
        gender: widget.gender,
        area: '北京 海淀',
        isBorder: true,
      ),
      new Visibility(
        visible: !isSelf && isFriend,
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
        // onPressed: () => routePush(new WeChatFriendsCircle()),
        onPressed: () => showToast("敬请期待"),
      ),
      new LabelRow(
        label: '更多信息',
        // onPressed: () => routePush(new MoreInfoPage()),
        onPressed: () => showToast("敬请期待"),
      ),
      Visibility(
        visible: !isSelf && !isFriend,
        child: ButtonRow(
          margin: EdgeInsets.only(top: 10.0),
          text: '添加好友',
          isBorder: !(!isSelf && isFriend),
          onPressed: () {
            routePush(VerificationPage(nickName: widget.title, id: widget.id));
          },
        ),
      ),
      new Visibility(
        visible: !isSelf && isFriend,
        child: Column(
          children: [
            ButtonRow(
              margin: EdgeInsets.only(top: 10.0),
              text: '发消息',
              isBorder: true,
              onPressed: () {
                String key = Im.routeKey(widget.id, typePerson);
                routePushReplace(
                    new ChatPage(
                        id: widget.id, title: widget.title, type: typePerson),
                    arguments: key);
              },
            ),
            Divider(
              height: 1,
              thickness: 0.1,
              color: appBarColor,
            ),
            ButtonRow(
              text: '音频通话',
              onPressed: () => showToast('敬请期待'),
            ),
            Divider(
              height: 1,
              thickness: 0.1,
              color: appBarColor,
            ),
            ButtonRow(
              text: '视频频通话',
              onPressed: () => showToast('敬请期待'),
            ),
            Space(height: 20),
            ButtonRow(
              text: '删除好友',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w600, fontSize: 16),
              onPressed: () {
                _deleteFriend();
              },
            ),
          ],
        ),
      ),
    ];
  }

  void _deleteFriend() {
    confirmAlert(
      context,
      (state) {
        if (state) {
          Im.get().requestSystem(actFriendDelete, {}, msgId: widget.id);
          ImData.get().onFriendDelete(widget.id);
          Navigator.of(context).pop();
        }
      },
      title: "确定删除该好友吗？",
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSelf = Global.get().curUser.id == widget.id;
    print(
        "isSelf: $isSelf, widget.id: ${widget.id}, myId: ${Global.get().curUser.id}");
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
    var isFriend = false;
    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(
          title: '',
          backgroundColor: Colors.white,
          rightDMActions: isSelf ? [] : rWidget),
      body: new SingleChildScrollView(
        child: FutureBuilder(
          future: _queryFiend((state) {
            if (state != null) {
              isFriend = true;
            }
          }),
          builder: (ctx, snapshot) {
            return Column(children: body(isSelf, isFriend));
          },
        ),
      ),
    );
  }

  Future _queryFiend(Callback cb) async {
    var f = await ImDb.g().db.friendDao.queryFriend(widget.id);
    cb(f);
  }
}

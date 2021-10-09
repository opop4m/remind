import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/provider/service/imGroupData.dart';
import 'package:client/ui/item/contact_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/tools/library.dart';
import 'package:lpinyin/lpinyin.dart';

class SelectMembersPage extends StatefulWidget {
  SelectMembersPage(this.groupMems, this.groupId, this.title,
      {this.isDelete = false});

  final List<String> groupMems;
  final String groupId;
  final String title;
  final bool isDelete;

  @override
  State<StatefulWidget> createState() {
    return new _SelectMembersPageState();
  }
}

class _SelectMembersPageState extends State<SelectMembersPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _subFriend?.cancel();
  }

  // List selects = [];
  List<Friend> _contacts = [];
  StreamSubscription? _subFriend, _subMem;

  void loadData() async {
    var my = Global.get().curUser;
    if (widget.isDelete) {
      var users = await ImGroupData.getMembersUser(widget.groupId);
      users.forEach((key, user) {
        if (user.id == my.id) return;
        var nameIndex = PinyinHelper.getFirstWordPinyin(user.name);
        var f = Friend(
            id: user.id,
            nickname: user.name,
            nameIndex: nameIndex,
            name: user.name);
        _contacts.add(f);
      });
      _contacts.sort((a, b) => a.nameIndex.compareTo(b.nameIndex));
      if (mounted) setState(() {});
    } else {
      _subFriend = ImDb.g()
          .db
          .friendDao
          .watchFriendList(widget.groupMems)
          .listen((list) {
        _contacts = list;
        _contacts.sort((a, b) => a.nameIndex.compareTo(b.nameIndex));
        if (mounted) setState(() {});
      });
    }
  }

  ScrollController sC = ScrollController();
  List<String> selectData = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(
        title: widget.title,
        rightDMActions: <Widget>[
          new CommonButton(
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            onTap: () {
              if (!listNoEmpty(selectData)) {
                showToast('请选择成员');
              }
              if (widget.isDelete) {
                Im.get().requestSystem(actGroupMemDel, selectData,
                    msgId: widget.groupId);
              } else {
                Im.get().requestSystem(actGroupInvite, selectData,
                    msgId: widget.groupId);
              }
              popToTimes(2);
            },
            text: '确定',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _contacts.length == 0
              ? Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(widget.isDelete ? "loading..." : "当前没有朋友可以邀请"),
                )
              : Space(),
          Expanded(
            child: new ContactView(
              sC: sC,
              contacts: _contacts,
              isDelete: widget.isDelete,
              type: ClickType.select,
              callback: (v) {
                selectData = v;
              },
            ),
          )
        ],
      ),
    );
  }
}

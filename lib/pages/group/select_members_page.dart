import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/ui/item/contact_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:azlistview/azlistview.dart';
import 'package:client/tools/library.dart';

class SelectMembersPage extends StatefulWidget {
  SelectMembersPage(this.groupMems, this.groupId);

  final List<String> groupMems;
  final String groupId;

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
  StreamSubscription? _subFriend;

  void loadData() async {
    _subFriend =
        ImDb.g().db.friendDao.watchFriendList(widget.groupMems).listen((list) {
      _contacts = list;
      _contacts.sort((a, b) => a.nameIndex.compareTo(b.nameIndex));
      if (mounted) setState(() {});
    });
  }

  ScrollController sC = ScrollController();
  List<String> selectData = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(
        title: '选择联系人',
        rightDMActions: <Widget>[
          new CommonButton(
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
            onTap: () {
              if (!listNoEmpty(selectData)) {
                showToast('请选择要添加的成员');
              }
              Im.get().requestSystem(actGroupInvite, selectData,
                  msgId: widget.groupId);
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
                  child: Text("当前没有朋友可以邀请"),
                )
              : Space(),
          Expanded(
            child: new ContactView(
              sC: sC,
              contacts: _contacts,
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

import 'package:client/config/dictionary.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/ui/item/contact_item.dart';
import 'package:client/ui/item/contact_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/tools/library.dart';

class GroupLaunchPage extends StatefulWidget {
  @override
  _GroupLaunchPageState createState() => new _GroupLaunchPageState();
}

class _GroupLaunchPageState extends State<GroupLaunchPage> {
  // bool isSearch = false;
  // bool showBtn = false;
  // bool isResult = false;

  // List defItems = ['选择一个群', '面对面建群'];
  List<Friend> _contacts = [];
  List<String> selectData = [];

  // FocusNode searchF = new FocusNode();
  // TextEditingController searchC = new TextEditingController();
  late ScrollController sC;

  final Map _letterPosMap = {INDEX_BAR_WORDS[0]: 0.0};

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  late StreamSubscription<List<Friend>> _sub;
  Future getContacts() async {
    _sub = ImData.get().friendList().listen((event) {
      _contacts.clear();
      _contacts..addAll(event);
      _contacts.sort((a, b) => a.nameIndex.compareTo(b.nameIndex));

      /// 计算用于 IndexBar 进行定位的关键通讯录列表项的位置
      var _totalPos = ContactItemState.heightItem(false);
      for (int i = 0; i < _contacts.length; i++) {
        bool _hasGroupTitle = true;
        if (i > 0 &&
            _contacts[i].nameIndex.compareTo(_contacts[i - 1].nameIndex) == 0)
          _hasGroupTitle = false;

        if (_hasGroupTitle) _letterPosMap[_contacts[i].nameIndex] = _totalPos;

        _totalPos += ContactItemState.heightItem(_hasGroupTitle);
      }
      if (mounted) setState(() {});
    });

    sC = new ScrollController();
  }

  TextEditingController groupNameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> body() {
      return [
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: TextFormField(
            controller: groupNameC,
            // onChanged: (String text) {},
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: '群名称',
              labelStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        new Expanded(
          child: new ContactView(
            sC: sC,
            contacts: _contacts,
            type: ClickType.select,
            callback: (v) {
              selectData = v;
            },
          ),
        )
      ];
    }

    var rWidget = new CommonButton(
      text: '确定',
      style: TextStyle(color: Colors.white),
      width: 45.0,
      margin: EdgeInsets.all(10.0),
      radius: 4.0,
      onTap: () {
        // createGroupChat(selectData, name: selectData.join(),
        //     callback: (callBack) {
        //   if (callBack.toString().contains('succ')) {
        //     showToast(context, '创建群组成功');
        //     if (Navigator.of(context).canPop()) {
        //       Navigator.of(context).pop();
        //     }
        //   }
        // });
        var name = groupNameC.text;
        if (!strNoEmpty(name)) {
          showToast("群名称不可为空");
          return;
        }

        // showToast('当前ID：${selectData.toString()}');

        var params = {
          "name": name,
          "uids": selectData,
        };
        Im.get().requestSystem(actCreateGroup, params);
        Navigator.of(context).pop();
      },
    );

    return WillPopScope(
      child: new Scaffold(
        backgroundColor: appBarColor,
        appBar: new ComMomBar(title: '发起群聊', rightDMActions: <Widget>[rWidget]),
        body: new Column(
          children: body(),
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
    );
  }
}

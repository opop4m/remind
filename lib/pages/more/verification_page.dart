import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imApi.dart';
import 'package:client/provider/service/imData.dart';
import 'package:flutter/material.dart';

import 'package:client/tools/library.dart';
import 'package:client/ui/orther/verify_input.dart';
import 'package:client/ui/orther/verify_switch.dart';

class VerificationPage extends StatefulWidget {
  final String nickName;
  final String id;

  VerificationPage({this.nickName = '', required this.id});

  @override
  _VerificationPageState createState() => new _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController infoC = new TextEditingController();
  TextEditingController remarksC = new TextEditingController();

  FocusNode infoF = new FocusNode();
  FocusNode remarksF = new FocusNode();

  bool switcher = false;

  Widget body() {
    var content = [
      new VerifyInput(
        title: '你需要发送验证申请，等对方通过',
        defStr: '你好，我是**',
        controller: infoC,
        focusNode: infoF,
      ),
      new Padding(
        padding: EdgeInsets.symmetric(vertical: mainSpace),
        child: new VerifyInput(
          title: '为朋友设置备注',
          defStr: widget.nickName,
          controller: remarksC,
          focusNode: remarksF,
        ),
      ),
      new VerifySwitch(
        title: '设置朋友圈和视频动态权限',
        onChanged: (value) => switcher = value,
      ),
    ];

    return new Column(children: content);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new ComMomBar(
        title: '验证申请',
        rightDMActions: <Widget>[
          new CommonButton(
            text: '发送',
            style: TextStyle(color: Colors.white),
            width: 55.0,
            margin: EdgeInsets.only(right: 15.0, top: 10.0, bottom: 10.0),
            radius: 4.0,
            onTap: () => _addFriend(),
            // onTap: () => addFriend(widget.id, context),
          ),
        ],
      ),
      body: new MainInputBody(
        child: body(),
        onTap: () {
          setState(() {});
        },
      ),
    );
  }

  _addFriend() {
    var my = Global.get().curUser;
    if (widget.id == my.id) {
      showToast("不可以添加自己");
      return;
    }
    var params = {
      "friendUid": widget.id,
      "msg": infoC.text,
      "alias": remarksC.text,
      "postAuth": switcher,
    };
    // ImApi.requestAddFriend(params);
    Im.get().requestSystem(actFriendRequest, params);
    popToRootPage();
  }
}

import 'dart:ui';

// import 'package:dim/commom/win_media.dart';
import 'package:client/config/keys.dart';
import 'package:client/pages/root/root_page.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/global_model.dart';
import 'package:client/tools/shared_util.dart';
import 'package:client/ui/view/edit_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:wechat_flutter/im/login_handle.dart';
// import 'package:wechat_flutter/pages/login/select_location_page.dart';
import 'package:client/provider/login_model.dart';
import 'package:client/tools/library.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    emailC.text = Global.get().curUser.email;
    print(Global.get().curUser.toJson());
  }

  Widget bottomItem(item) {
    return new Row(
      children: <Widget>[
        new InkWell(
          child: new Text(item, style: TextStyle(color: tipColor)),
          onTap: () {
            showToast(context, S.of(context).notOpen + item);
          },
        ),
        item == S.of(context).weChatSecurityCenter
            ? new Container()
            : new Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: new VerticalLine(height: 15.0),
              )
      ],
    );
  }

  FocusNode emailF = new FocusNode();
  TextEditingController emailC = new TextEditingController();
  FocusNode pWF = new FocusNode();
  TextEditingController pWC = new TextEditingController();
  String actType = "email";

  Widget bodyEmail(GlobalModel gModel) {
    var column = [
      new Padding(
        padding: EdgeInsets.only(
            left: 5.0, top: mainSpace * 3, bottom: mainSpace * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            new Text(
              S.of(context).emailLogin,
              style: TextStyle(fontSize: 25.0),
            ),
            // SizedBox(width: 10),
            // GestureDetector(
            //     child: Text(
            //       S.of(context).numberRegister,
            //       style: TextStyle(fontSize: 15.0),
            //     ),
            //     onTap: () {
            //       setState(() {
            //         actType = "phone";
            //       });
            //     }),
          ],
        ),
      ),
      new EditView(
        label: S.of(context).email,
        hint: S.of(context).emailHint,
        controller: emailC,
        focusNode: emailF,
        onTap: () => setState(() {}),
      ),
      new EditView(
        label: S.of(context).passWord,
        hint: S.of(context).pwTip,
        controller: pWC,
        focusNode: pWF,
        bottomLineColor:
            pWF.hasFocus ? Colors.green : lineColor.withOpacity(0.5),
        onTap: () => setState(() {}),
        onChanged: (str) {
          setState(() {});
        },
      ),
      new Space(height: mainSpace * 2),
      new CommonButton(
        text: S.of(context).login,
        style: TextStyle(
            color:
                pWC.text == '' ? Colors.grey.withOpacity(0.8) : Colors.white),
        margin: EdgeInsets.only(top: 20.0),
        color: pWC.text == ''
            ? Color.fromRGBO(226, 226, 226, 1.0)
            : Color.fromRGBO(8, 191, 98, 1.0),
        onTap: () {
          _goLogin(gModel);
        },
      ),
    ];

    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: column),
    );
  }

  _goLogin(GlobalModel gModel) async {
    if (!strNoEmpty(pWC.text)) return;
    if (actType == "email") {
      if (!isEmail(emailC.text)) {
        showToast(context, '请输入正确的邮箱');
        return;
      }
      ;
    }
    var params = {"email": emailC.text, "passwd": pWC.text, "type": actType};
    var u = await gModel.logic.login(params);
    if (u.code == 0) {
      showToast(context, '登陆成功');
      routePushAndRemove(new RootPage());
    } else {
      showToast(context, u.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final model = Provider.of<LoginModel>(context);
    final gModel = Provider.of<GlobalModel>(context);

    List btItem = [
      S.of(context).retrievePW,
      S.of(context).emergencyFreeze,
      S.of(context).weChatSecurityCenter,
    ];

    return new Scaffold(
      appBar:
          new ComMomBar(title: '', leadingImg: 'assets/images/bar_close.png'),
      body: new MainInputBody(
        color: appBarColor,
        child: new Stack(
          children: <Widget>[
            new SingleChildScrollView(child: bodyEmail(gModel)),
            new Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: btItem.map(bottomItem).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

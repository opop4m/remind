import 'package:client/app.dart';
import 'package:client/provider/loginc/global_loginc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:client/pages/mine/personal_info_page.dart';
import 'package:client/pages/settings/language_page.dart';
import 'package:client/pages/wallet/pay_home_page.dart';
import 'package:client/provider/global_model.dart';

import 'package:client/tools/library.dart';
import 'package:client/ui/view/list_tile_view.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => new _MinePageState();
}

class _MinePageState extends State<MinePage> {
  void action(name) {
    switch (name) {
      case '退出':
        logout();
        break;
      case '支付':
        // routePush(new PayHomePage());
        break;
      default:
        routePush(new LanguagePage());
        break;
    }
  }

  Widget buildContent(item) {
    return new ListTileView(
      border: item['label'] == '银行卡' ||
              item['label'] == '退出' ||
              item['label'] == '语言'
          ? null
          : Border(bottom: BorderSide(color: Colors.grey[400]!, width: 0.5)),
      title: item['label'],
      titleStyle: TextStyle(fontSize: 15.0),
      isLabel: false,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      icon: item['icon'],
      margin: item['label'] == '余额'
          ? EdgeInsets.only(top: 10)
          : EdgeInsets.symmetric(
              vertical:
                  item['label'] == '退出' || item['label'] == '语言' ? 10.0 : 0.0),
      onPressed: item['label'] == '余额' ? null : () => action(item['label']),
      // onPressed: null,
      width: 25.0,
      fit: BoxFit.cover,
      horizontal: 15.0,
    );
  }

  Widget dynamicAvatar(avatar, {size}) {
    return new ImageView(
        img: API.fileHost + avatar,
        width: size ?? null,
        height: size ?? null,
        fit: BoxFit.fill);
  }

  Widget body(GlobalModel model) {
    List data = [
      {'label': '余额', 'icon': 'assets/images/mine/ic_pay.png'},
      {'label': '充值', 'icon': 'assets/images/favorite.webp'},
      {'label': '提现', 'icon': 'assets/images/mine/ic_card_package.png'},
      {'label': '银行卡', 'icon': 'assets/images/mine/ic_card_package.png'},
      {'label': '语言', 'icon': 'assets/images/mine/ic_emoji.png'},
      {'label': '退出', 'icon': 'assets/images/mine/ic_setting.png'},
    ];

    var row = [
      new SizedBox(
        width: 60.0,
        height: 60.0,
        child: new ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: strNoEmpty(Global.get().curUser.avatar)
              ? dynamicAvatar(Global.get().curUser.avatar)
              : new Image.asset(defIcon, fit: BoxFit.cover),
        ),
      ),
      new Container(
        margin: EdgeInsets.only(left: 15.0),
        height: 60.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              Global.get().curUser.nickName,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
            new Text(
              Global.get().curUser.email,
              style: TextStyle(color: mainTextColor),
            ),
          ],
        ),
      ),
      new Spacer(),
      new Container(
        width: 13.0,
        margin: EdgeInsets.only(right: 12.0),
        child: new Image.asset('assets/images/mine/ic_small_code.png',
            color: mainTextColor.withOpacity(0.5), fit: BoxFit.cover),
      ),
      new Image.asset('assets/images/ic_right_arrow_grey.webp',
          width: 7.0, fit: BoxFit.cover)
    ];

    return new Column(
      children: <Widget>[
        new InkWell(
          child: new Container(
            color: Colors.white,
            height: (topBarHeight(context) * 2.5) - 10,
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
            child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center, children: row),
          ),
          onTap: () => routePush(new PersonalInfoPage()),
        ),
        new Column(children: data.map(buildContent).toList()),
      ],
    );
  }

  late GlobalModel _model;

  @override
  Widget build(BuildContext context) {
    _model = Provider.of<GlobalModel>(context);

    return new Container(
      color: appBarColor,
      child: new SingleChildScrollView(child: body(_model)),
    );
  }
}

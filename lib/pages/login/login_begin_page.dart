import 'package:client/provider/service/imApi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/config/provider_config.dart';
// import 'package:client/im/login_handle.dart';
import 'package:client/pages/login/register_page.dart';
// import 'package:client/pages/settings/language_page.dart';
import 'package:client/provider/global_model.dart';

import 'package:client/tools/library.dart';

import 'login_page.dart';

final _log = Logger("LoginBeginPage");

class LoginBeginPage extends StatefulWidget {
  @override
  _LoginBeginPageState createState() => new _LoginBeginPageState();
}

class _LoginBeginPageState extends State<LoginBeginPage> {
  Widget body(GlobalModel model) {
    var buttons = [
      new CommonButton(
        text: S.of(context).login,
        margin: EdgeInsets.only(left: 10.0),
        width: 100.0,
        onTap: () => routePush(
            ProviderConfig.getInstance().getLoginPage(new LoginPage())),
      ),
      new CommonButton(
          text: S.of(context).register,
          color: bgColor,
          style:
              TextStyle(fontSize: 15.0, color: Color.fromRGBO(8, 191, 98, 1.0)),
          margin: EdgeInsets.only(right: 10.0),
          onTap: () => routePush(
              ProviderConfig.getInstance().getLoginPage(new RegisterPage())),
          width: 100.0),
    ];

    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Container(
          alignment: Alignment.topRight,
          child: new InkWell(
            child: new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Text(S.of(context).language,
                  style: TextStyle(color: Colors.white)),
            ),
            // onTap: () => routePush(new LanguagePage()),
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: model.logic.initializing ? [] : buttons,
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initListenNetwork();
  }

  @override
  void dispose() {
    super.dispose();
    _subNetwork?.cancel();
  }

  StreamSubscription<ConnectivityResult>? _subNetwork;
  void initListenNetwork() {
    networkSubscription.checkConnectivity().then((result) {
      onCheckConnect(result);
    });
    _subNetwork = networkSubscription.onConnectivityChanged
        .listen((ConnectivityResult result) {
      onCheckConnect(result);
    });
  }

  void onCheckConnect(ConnectivityResult state) async {
    _log.info("network: $state");
    if (state == ConnectivityResult.mobile ||
        state == ConnectivityResult.wifi) {
      ImApi.appStart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context);

    var bodyMain = new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bsc.webp'), fit: BoxFit.cover)),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: body(model),
    );

    return new Scaffold(body: bodyMain);
  }
}

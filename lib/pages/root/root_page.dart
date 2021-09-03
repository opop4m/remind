import 'package:client/http/api.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/loginc/global_loginc.dart';
import 'package:client/provider/service/im.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/contacts/contacts_page.dart';
import 'package:client/pages/discover/discover_page.dart';
import 'package:client/pages/home/home_page.dart';
import 'package:client/pages/mine/mine_page.dart';
import 'package:client/pages/root/root_tabbar.dart';
import 'package:client/tools/wechat_flutter.dart';

final _log = Logger("RootPage");

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    // ifBrokenNetwork();
    initChat();
    updateApi(context);
  }

  initChat() async {
    var chatConf = GlobalCache.get().chatConf;
    var user = GlobalCache.get().user;
    _log.info("go connect: ${chatConf.toJson()}");
    await Im.get().init(
      user.id,
      GlobalCache.get().getUuid(),
      host: chatConf.host,
      port: chatConf.port,
      account: user.id,
      passwd: user.accessToken,
      // passwd: "useraccessToken",
    );
    Im.get().stateListener = (state) {
      switch (state) {
        case ConnectState.connected:
          break;
        case ConnectState.connecting:
          break;
        case ConnectState.disconnect:
          break;
        case ConnectState.notAuthorized:
          logout();
          break;
        case ConnectState.networkErr:
          break;
      }
    };

    Im.get().connect();
  }

  @override
  Widget build(BuildContext context) {
    List<TabBarModel> pages = <TabBarModel>[
      new TabBarModel(
          title: S.of(context).message,
          icon: new LoadImage("assets/images/tabbar_chat_c.webp"),
          selectIcon: new LoadImage("assets/images/tabbar_chat_s.webp"),
          page: new HomePage()),
      new TabBarModel(
        title: S.of(context).contacts,
        icon: new LoadImage("assets/images/tabbar_contacts_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_contacts_s.webp"),
        page: new ContactsPage(),
      ),
      new TabBarModel(
        title: S.of(context).discover,
        icon: new LoadImage("assets/images/tabbar_discover_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_discover_s.webp"),
        page: new DiscoverPage(),
      ),
      new TabBarModel(
        title: S.of(context).me,
        icon: new LoadImage("assets/images/tabbar_me_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_me_s.webp"),
        page: new MinePage(),
      ),
    ];
    return new Scaffold(
      key: scaffoldGK,
      body: new RootTabBar(pages: pages, currentIndex: 0),
    );
  }
}

class LoadImage extends StatelessWidget {
  final String img;

  LoadImage(this.img);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 2.0),
      child: new Image.asset(img, fit: BoxFit.cover, gaplessPlayback: true),
    );
  }
}

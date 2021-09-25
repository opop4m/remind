import 'package:client/pages/WidgetsBinding.dart';
import 'package:client/pages/chat/chat_page.dart';
import 'package:client/pages/chat/videoCall.dart';
import 'package:client/pages/navigation.dart';
import 'package:client/pages/test1.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/loginc/global_loginc.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/provider/service/webRtcCtr.dart';
import 'package:client/ui/dialog/confirm_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/contacts/contacts_page.dart';
import 'package:client/pages/home/home_page.dart';
import 'package:client/pages/mine/mine_page.dart';
import 'package:client/pages/root/root_tabbar.dart';
import 'package:client/tools/library.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'dart:js' as js;

UcNavigation routeObserver = UcNavigation();

final _log = Logger("RootPage");

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with RouteAware {
  WidgetsBind bind = WidgetsBind();

  late StreamSubscription<int?> _popSub;
  late StreamSubscription<ConnectState> _connectSub;

  int chatPopSum = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(bind);
    // ifBrokenNetwork();
    initChat().then((value) {
      _popSub = ImDb.g().db.popsDao.queryChatPopSum().listen((event) {
        _log.info("imdb update pop: $event");
        chatPopSum = event ?? 0;
        if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
          FlutterAppBadger.updateBadgeCount(chatPopSum);
        }
        if (mounted) setState(() {});
      });
    });
    // checkupdate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initChat() async {
    var chatConf = Global.get().chatConf;
    var user = Global.get().curUser;
    _log.info("go connect: ${chatConf.toJson()}");
    await Im.get().init(
      user.id,
      Global.get().uuid,
      host: chatConf.host,
      port: chatConf.port,
      account: user.id,
      passwd: user.accessToken,
      // passwd: "useraccessToken",
    );
    _connectSub = Im.get().statusStream.listen((state) {
      if (state == ConnectState.notAuthorized) {
        logout();
      } else if (state == ConnectState.connected) {
        setupInteractedMessage();
        initWebRtc();
      }
    });
    Im.get().connect();
  }

  Future<void> setupInteractedMessage() async {
    // if (PlatformUtils.isWeb) {
    //   _log.info("init onFCMbackground");
    //   js.context["onFCMbackground"] = onFCMbackground; //can not work in web workers
    // }
    _log.info("setupInteractedMessage");
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onBackgroundMessage((message) async {
      _log.info("_handle onBackgroundMessage ${message.data}");
    });
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void onFCMbackground(message) {
    _log.info("onFCMbackground");
    _log.info(message);
  }

  void _handleMessage(RemoteMessage message) async {
    String push = "_handle push Message ${message.data}";

    _log.info(push);

    if (message.data['act'] == actChat) {
      String peerId = message.data['peer'];
      int type = int.parse(message.data['type']);
      var peerInfo = await ImData.get().getChatUser(peerId);
      routePush(new ChatPage(id: peerInfo.id, title: peerInfo.name, type: type),
          arguments: peerInfo.id);
    }
  }

  BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    List<TabBarModel> pages = <TabBarModel>[
      new TabBarModel(
        title: S.of(context).message,
        icon: LoadImage("assets/images/tabbar_chat_c.webp"),
        selectIcon: new LoadImage("assets/images/tabbar_chat_s.webp"),
        page: new HomePage(),
        pop: chatPopSum,
      ),
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
        // page: new DiscoverPage(),
        page: new Test(),
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

  @override
  void dispose() {
    super.dispose();
    _log.info("dispose");
    _popSub.cancel();
    _connectSub.cancel();
    WebRtcCtr.get().onReceiveOffer = null;
    WidgetsBinding.instance?.removeObserver(bind); //添加观察者
  }

  void initWebRtc() {
    WebRtcCtr.get().init();
    WebRtcCtr.get().onReceiveOffer = (session) {
      confirmAlert(_context!, (act) {
        if (act) {
          routePush(new VideoCallView(session.peerId, session: session));
        } else {}
      }, title: "是否接受电话？");
    };
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

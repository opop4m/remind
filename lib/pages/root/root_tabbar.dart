import 'dart:io';

import 'package:badges/badges.dart';
import 'package:client/pages/contacts/group_launch_page.dart';
import 'package:client/pages/home/search_page.dart';
import 'package:client/pages/settings/language_page.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/tools/utils.dart';
import 'package:client/ui/view/indicator_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/more/add_friend_page.dart';

import 'package:client/tools/library.dart';
import 'package:client/ui/w_pop/w_popup_menu.dart';

typedef CheckLogin(index);

class RootTabBar extends StatefulWidget {
  RootTabBar({required this.pages, this.checkLogin, this.currentIndex = 0});

  final List pages;
  final CheckLogin? checkLogin;
  final int currentIndex;

  @override
  State<StatefulWidget> createState() => new RootTabBarState();
}

class RootTabBarState extends State<RootTabBar> {
  // List<BottomNavigationBarItem> pages = [];
  late int currentIndex;
  List<Offstage> contents = [];
  late PageController pageController;
  late StreamSubscription<ConnectState> _connectSub;

  String connectTips = "";
  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    pageController = PageController(initialPage: currentIndex);

    _connectSub = Im.get().statusStream.listen((state) {
      if (state == ConnectState.networkErr ||
          state == ConnectState.disconnect) {
        connectTips = "(未连接)";
      } else if (state == ConnectState.connecting) {
        connectTips = "(连接中)";
      } else {
        connectTips = "";
      }
      // print("tabbar connect: $state");
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectSub.cancel();
  }

  List<BottomNavigationBarItem> getBottomNavigationBarItem() {
    List<BottomNavigationBarItem> pages = [];
    for (int i = 0; i < widget.pages.length; i++) {
      TabBarModel model = widget.pages[i];
      pages.add(
        new BottomNavigationBarItem(
          // icon: model.icon,
          icon: Badge(
            showBadge: model.pop > 0,
            badgeContent: Text(""),
            child: model.icon,
          ),
          activeIcon: Badge(
            showBadge: model.pop > 0,
            badgeContent: Text(""),
            child: model.selectIcon,
          ),
          title: new Text(model.title, style: new TextStyle(fontSize: 12.0)),
        ),
      );
    }
    return pages;
  }

  actionsHandle(v) {
    if (v == '添加朋友') {
      routePush(new AddFriendPage());
    } else if (v == '发起群聊') {
      routePush(new GroupLaunchPage());
    } else if (v == '帮助与反馈') {
      routePush(new WebViewPage(helpUrl, '帮助与反馈'));
    } else {
      // routePush(new LanguagePage());
      showToast("敬请期待");
    }
  }

  @override
  Widget build(BuildContext context) {
    var pages = getBottomNavigationBarItem();
    final List actions = [
      {"title": '发起群聊', 'icon': 'assets/images/contacts_add_newmessage.png'},
      {"title": '添加朋友', 'icon': 'assets/images/ic_add_friend.webp'},
      {"title": '扫一扫', 'icon': ''},
      // {"title": '收付款', 'icon': ''},
      // {"title": '帮助与反馈', 'icon': ''},
    ];

    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
      items: pages,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      fixedColor: Colors.green,
      unselectedItemColor: mainTextColor,
      onTap: (int index) {
        setState(() => currentIndex = index);
        pageController.jumpToPage(currentIndex);
      },
      unselectedFontSize: 18.0,
      selectedFontSize: 18.0,
      elevation: 0,
    );

    String appTitle = widget.pages[currentIndex].title;
    if (currentIndex == 0) {
      appTitle = appTitle + connectTips;
    }
    var appBar = new ComMomBar(
      title: appTitle,
      showShadow: false,
      rightDMActions: <Widget>[
        // new InkWell(
        //   child: new Container(
        //     width: 60.0,
        //     child: new Image.asset('assets/images/search_black.webp'),
        //   ),
        //   onTap: () => routeFadePush(new SearchPage()),
        // ),
        new WPopupMenu(
          menuWidth: winWidth(context) / 2.5,
          menuHeight: actions.length * 50,
          // menuHeight: 250,
          alignment: Alignment.center,
          onValueChanged: (String value) {
            if (!strNoEmpty(value)) return;
            actionsHandle(value);
          },
          actions: actions,
          child: new Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: new Image.asset('assets/images/add_addressicon.png',
                color: Colors.black, width: 22.0, fit: BoxFit.fitWidth),
          ),
        )
      ],
    );

    return new Scaffold(
      bottomNavigationBar: new Theme(
        data: new ThemeData(
          canvasColor: Colors.grey[50],
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: new Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: lineColor, width: 0.2))),
          child: bottomNavigationBar,
        ),
      ),
      appBar:
          widget.pages[currentIndex].title != S.of(context).me ? appBar : null,
      body: new ScrollConfiguration(
        behavior: MyBehavior(),
        child: new PageView.builder(
          itemBuilder: (BuildContext context, int index) =>
              widget.pages[index].page,
          controller: pageController,
          itemCount: pages.length,
          physics: PlatformUtils.isAndroid
              ? new ClampingScrollPhysics()
              : new NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            setState(() => currentIndex = index);
          },
        ),
      ),
    );
  }
}

class TabBarModel {
  const TabBarModel(
      {this.pop = 0,
      required this.title,
      this.page,
      required this.icon,
      this.selectIcon});

  final String title;
  final int pop;
  final Widget icon;
  final Widget? selectIcon;
  final Widget? page;
}

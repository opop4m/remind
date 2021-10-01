import 'package:client/pages/more/add_friend_page.dart';
import 'package:client/provider/global_cache.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/bus/notice2.dart';
import 'package:client/ui/orther/label_row.dart';
import 'package:client/ui/view/friend_request_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:client/tools/library.dart';
import 'package:client/ui/view/list_tile_view.dart';
import 'package:client/ui/view/search_main_view.dart';
import 'package:client/ui/view/search_tile_view.dart';

class NewFriendPage extends StatefulWidget {
  @override
  _NewFriendPageState createState() => new _NewFriendPageState();
}

final _log = Logger("NewFriendPage");

class _NewFriendPageState extends State<NewFriendPage> {
  bool isSearch = false;
  bool showBtn = false;
  bool isResult = false;
  List<FriendReqeust> _list = [];
  Map<String, ChatUser> _users = {};
  late StreamSubscription _subData;
  late StreamSubscription _subUsers;

  late String currentUser;

  FocusNode searchF = new FocusNode();
  TextEditingController searchC = new TextEditingController();

  Widget buildItem(item) {
    return new ListTileView(
      border: item['title'] == '雷达加朋友'
          ? null
          : Border(top: BorderSide(color: lineColor, width: 0.2)),
      title: item['title'],
      label: item['label'],
    );
  }

  Widget body() {
    List<Widget> content = [];
    for (var i = 0; i < _list.length; i++) {
      var fr = _list[i];
      var user = _users[fr.requestUid]!;
      var item = FriendRequestItemView(
        border: i == 0
            ? null
            : Border(top: BorderSide(color: lineColor, width: 0.2)),
        title: user.name,
        label: fr.msg,
        icon: getAvatarUrl(user.avatar),
        fit: BoxFit.cover,
        id: user.id,
        onPressedA: (id) {
          _act(statusAgree, id);
        },
        onPressedB: (id) {
          _act(statusRefuse, id);
        },
        status: fr.status,
      );
      content.add(item);
    }
    return new Column(children: content);
  }

  void _act(int agreeStatus, String id) {
    ImData.get().replyFriendRequest(id, agreeStatus).then((value) {
      if (mounted) setState(() {});
    });
  }

  List<Widget> searchBody() {
    if (isResult) {
      return [
        new Container(
          color: Colors.white,
          width: winWidth(context),
          height: 110.0,
          alignment: Alignment.center,
          child: new Text(
            '该用户不存在',
            style: TextStyle(color: mainTextColor),
          ),
        ),
        new Space(height: mainSpace),
        new SearchTileView(searchC.text, type: 1),
        new Container(
          color: Colors.white,
          width: winWidth(context),
          height: (winHeight(context) - 185 * 1.38),
        )
      ];
    } else {
      return [
        new SearchTileView(
          searchC.text,
          onPressed: () => search(searchC.text),
        ),
        new Container(
          color: strNoEmpty(searchC.text) ? Colors.white : appBarColor,
          width: winWidth(context),
          height: strNoEmpty(searchC.text)
              ? (winHeight(context) - 65 * 2.1) - winKeyHeight(context)
              : winHeight(context),
        )
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getNewFriendList();
  }

  getNewFriendList() async {
    _subUsers = UcNotice.addListener(UcActions.chatUsersMap()).listen((event) {
      _users = event;
      _log.info("UcActions.chatUsersMap");
      if (mounted) setState(() {});
    });
    _subData = ImDb.g().db.friendReqeustsDao.queryAll().listen((data) async {
      _list = data;
      List<String> uids = [];
      for (var i = 0; i < _list.length; i++) {
        var u = _list[i];
        uids.add(u.requestUid);
      }
      _users = await ImData.get().getChatUsers(uids);
      // _log.info("getNewFriendList: $_list");
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _log.info("dispose");
    super.dispose();
    _subData.cancel();
    _subUsers.cancel();
  }

  getUser() async {
    currentUser = Global.get().curUser.id;
    setState(() {});
  }

  unFocusMethod() {
    searchF.unfocus();
    isSearch = false;
    if (isResult) isResult = !isResult;
    setState(() {});
  }

  /// 搜索好友
  Future search(String userName) async {
    // final data = await getUsersProfile([userName]);
    // List<dynamic> dataMap = json.decode(data);
    // Map map = dataMap[0];
    // if (strNoEmpty(map['allowType'])) {
    //   routePush(new AddFriendsDetails('search', map['identifier'],
    //       map['faceUrl'], map['nickName'], map['gender']));
    // } else {
    //   isResult = true;
    //   setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
    var leading = new InkWell(
      child: new Container(
        width: 15,
        height: 28,
        child: new Icon(CupertinoIcons.back, color: Colors.black),
      ),
      onTap: () => unFocusMethod(),
    );

    // ignore: unused_element
    List<Widget> searchView() {
      return [
        new Expanded(
          child: new TextField(
            style: TextStyle(textBaseline: TextBaseline.alphabetic),
            focusNode: searchF,
            controller: searchC,
            decoration:
                InputDecoration(hintText: '微信号/手机号', border: InputBorder.none),
            onChanged: (txt) {
              if (strNoEmpty(searchC.text))
                showBtn = true;
              else
                showBtn = false;
              if (isResult) isResult = false;

              setState(() {});
            },
            textInputAction: TextInputAction.search,
            onSubmitted: (txt) => search(txt),
          ),
        ),
        strNoEmpty(searchC.text)
            ? new InkWell(
                child: new Image.asset('assets/images/ic_delete.webp'),
                onTap: () {
                  searchC.text = '';
                  setState(() {});
                },
              )
            : new Container()
      ];
    }

    var bodyView = new SingleChildScrollView(
      child: isSearch
          ? new GestureDetector(
              child: new Column(children: searchBody()),
              onTap: () => unFocusMethod(),
            )
          : Container(
              child: body(),
              color: Colors.white,
            ),
    );

    var rWidget = new FlatButton(
      onPressed: () => routePush(new AddFriendPage()),
      child: new Text('添加朋友'),
    );

    return WillPopScope(
      child: new Scaffold(
        backgroundColor: appBarColor,
        appBar: new ComMomBar(
          leadingW: isSearch ? leading : null,
          title: '新的朋友',
          titleW: isSearch ? new Row(children: searchView()) : null,
          rightDMActions: !isSearch ? [rWidget] : [],
        ),
        body: bodyView,
      ),
      onWillPop: () async {
        if (isSearch) {
          unFocusMethod();
        } else {
          Navigator.pop(context);
        }
        return true;
      },
    );
  }
}

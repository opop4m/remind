import 'dart:convert';

import 'package:client/pages/chat/chat_page.dart';
import 'package:client/provider/loginc/global_loginc.dart';
import 'package:client/provider/model/chatBean.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/im.dart';
// import 'package:client/provider/model/chatList.dart';
// import 'package:client/provider/model/chat_list.dart';

import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/utils.dart';
import 'package:client/tools/library.dart';
import 'package:client/ui/view/indicator_page_view.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/edit/text_span_builder.dart';
import 'package:client/ui/chat/my_conversation_view.dart';
import 'package:client/ui/view/pop_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final _log = Logger("HomePage");

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<ChatRecentBean> _chatData = [];
  Map<String, int> _pop = {};
  StreamSubscription? _popSub;
  // Map<String, ChatUser> _chatUsers = {};

  var tapPos;
  TextSpanBuilder _builder = TextSpanBuilder();
  StreamSubscription<dynamic>? _messageStreamSubscription;
  StreamSubscription? _subRecent;

  @override
  void initState() {
    super.initState();
    _log.info("initState");
    initPlatformState();
    getChatData();
    Notice.addListener(UcActions.logout(), (data) => logout());
  }

  Future getChatData() async {
    _subRecent = ImData.get().watchRecentList().listen((futrue) async {
      _chatData = await futrue;
      if (_chatData.length == 0) return;
      if (mounted) setState(() {});
    });

    _popSub = ImData.get().getUnread().listen((event) {
      _pop = event;
      _log.info("getUnread: " + jsonEncode(event));
      if (mounted) setState(() {});
    });

    // await initChatUsers(_chatData);
    if (mounted) setState(() {});
  }

  _showMenu(BuildContext context, Offset tapPos, int type, String id) {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(tapPos.dx, tapPos.dy,
        overlay.size.width - tapPos.dx, overlay.size.height - tapPos.dy);
    showMenu<String>(
        context: context,
        position: position,
        items: <MyPopupMenuItem<String>>[
          new MyPopupMenuItem(child: Text('标为已读'), value: '标为已读'),
          new MyPopupMenuItem(child: Text('置顶聊天'), value: '置顶聊天'),
          new MyPopupMenuItem(child: Text('删除该聊天'), value: '删除该聊天'),
          // ignore: missing_return
        ]).then<String>((String? selected) {
      switch (selected) {
        case '删除该聊天':
          // deleteConversationAndLocalMsgModel(type, id, callback: (str) {
          //   debugPrint('deleteConversationAndLocalMsgModel' + str.toString());
          // });
          // delConversationModel(id, type, callback: (str) {
          //   debugPrint('deleteConversationModel' + str.toString());
          // });
          getChatData();
          break;
        case '标为已读':
          // getUnreadMessageNumModel(type, id, callback: (str) {
          //   int num = int.parse(str.toString());
          //   if (num != 0) {
          //     setReadMessageModel(type, id);
          //     setState(() {});
          //   }
          // });
          break;
      }
      return "";
    });
  }

  void canCelListener() {
    _popSub?.cancel();
    _subRecent?.cancel();
    _messageStreamSubscription?.cancel();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    if (_messageStreamSubscription == null) {
      // _messageStreamSubscription =
      //     im.onMessage.listen((dynamic onData) => getChatData());
    }
  }

  @override
  bool get wantKeepAlive => true;

  Widget timeView(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    String hourParse = "0${dateTime.hour}";
    String minuteParse = "0${dateTime.minute}";

    String hour = dateTime.hour.toString().length == 1
        ? hourParse
        : dateTime.hour.toString();
    String minute = dateTime.minute.toString().length == 1
        ? minuteParse
        : dateTime.minute.toString();

    String timeStr = '$hour:$minute';

    return new SizedBox(
      // width: 35.0,
      child: new Text(
        timeStr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: mainTextColor, fontSize: 14.0),
      ),
    );
  }

  int _c = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!listNoEmpty(_chatData)) return new HomeNullView();
    _c++;
    _log.info("build count: $_c");
    return new Container(
      color: Color(AppColors.BackgroundColor),
      child: new ScrollConfiguration(
        behavior: MyBehavior(),
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            ChatRecentBean bean = _chatData[index];
            ChatRecent msg = bean.recent;
            String imageUrl, name;
            String targetId = bean.recent.peerId;
            if (msg.type == typePerson) {
              ChatUser u = bean.user!;
              imageUrl = getAvatarUrl(u.avatar);
              name = u.name;
              if (targetId == Global.get().curUser.id) {
                targetId = bean.recent.fromId;
              }
            } else {
              Group group = bean.group!;
              imageUrl = getGroupAvatarUrl(group.avatar);
              name = group.name;
            }
            String key = Im.routeKey(targetId, msg.type);
            int unread = _pop[key] ?? 0;
            // _log.info("key: $key");
            return InkWell(
              onTap: () {
                routePush(
                    new ChatPage(id: targetId, title: name, type: msg.type),
                    arguments: key);
              },
              onTapDown: (TapDownDetails details) {
                tapPos = details.globalPosition;
              },
              onLongPress: () {
                if (PlatformUtils.isAndroid) {
                  _showMenu(context, tapPos, msg.type, bean.recent.targetId);
                } else {
                  debugPrint("IOS聊天长按选项功能开发中");
                }
              },
              child: new MyConversationView(
                imageUrl: imageUrl,
                title: name,
                msg: msg,
                time: timeView(msg.createTime),
                isBorder: msg.msgId != _chatData[0].recent.msgId,
                unread: unread,
              ),
            );
          },
          itemCount: _chatData.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _log.info("dispose");
    // Notice.removeListenerByEvent(UcActions.chatUser());
    // Notice.removeListenerByEvent(UcActions.recentList());
    canCelListener();
  }
}

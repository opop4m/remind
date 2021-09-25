import 'package:client/pages/chat/chat_page.dart';
import 'package:client/provider/loginc/global_loginc.dart';
import 'package:client/provider/model/chatBean.dart';
// import 'package:client/provider/model/chatList.dart';
// import 'package:client/provider/model/chat_list.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imApi.dart';
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
  // Map<String, ChatUser> _chatUsers = {};

  var tapPos;
  TextSpanBuilder _builder = TextSpanBuilder();
  StreamSubscription<dynamic>? _messageStreamSubscription;

  @override
  void initState() {
    super.initState();
    _log.info("initState");
    initPlatformState();
    getChatData();
    Notice.addListener(UcActions.logout(), (data) => logout());
  }

  Future getChatData() async {
    _chatData = await ImData.get().getRecentList(update: true);
    _pop = await ImData.get().getUnread();
    Notice.addListener(UcActions.recentList(), (data) {
      // _log.info("notice recentList");
      ImData.get().getRecentList().then((value) async {
        _chatData = await ImData.get().getRecentList();
        if (mounted) setState(() {});
      });
    });
    Notice.addListener(UcActions.chatUser(), (data) async {
      // _log.info("notice chatUser");
      _chatData = await ImData.get().getRecentList();
      if (mounted) setState(() {});
    });
    Notice.addListener(UcActions.chatPop(), (data) async {
      _pop = await ImData.get().getUnread();
      // _log.info("chatPop: $_pop");
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
    if (_messageStreamSubscription != null) {
      _messageStreamSubscription?.cancel();
    }
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!listNoEmpty(_chatData)) return new HomeNullView();
    return new Container(
      color: Color(AppColors.BackgroundColor),
      child: new ScrollConfiguration(
        behavior: MyBehavior(),
        child: new ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            ChatRecentBean bean = _chatData[index];
            ChatRecent msg = bean.recent;
            ChatUser u = bean.user;
            var key = u.id + "_" + msg.type.toString();
            int unread = _pop[key] ?? 0;
            return InkWell(
              onTap: () {
                String key = "${msg.type}-" + u.id;
                routePush(new ChatPage(id: u.id, title: u.name, type: msg.type),
                    arguments: key);
              },
              onTapDown: (TapDownDetails details) {
                tapPos = details.globalPosition;
              },
              onLongPress: () {
                if (PlatformUtils.isAndroid) {
                  _showMenu(context, tapPos, msg.type, u.id);
                } else {
                  debugPrint("IOS聊天长按选项功能开发中");
                }
              },
              child: new MyConversationView(
                imageUrl: getAvatarUrl(u.avatar),
                title: u.name,
                msg: msg,
                time: timeView(msg.createTime),
                isBorder: u.id != _chatData[0].recent.fromId,
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
    Notice.removeListenerByEvent(UcActions.chatUser());
    Notice.removeListenerByEvent(UcActions.recentList());
    canCelListener();
  }
}

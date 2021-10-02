import 'dart:convert';

import 'package:client/pages/navigation.dart';
import 'package:client/provider/model/chatBean.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/provider/service/imApi.dart';
import 'package:client/tools/bus/notice2.dart';
import 'package:client/tools/library.dart';
import 'package:client/tools/utils.dart';

final _log = Logger("ImData");

const actChatUser = "chatUser";
const actChat = "chat";
const actChatRead = "chatRead";
const actChatDelivered = "chatDelivered";
const actChatPop = "chatPop";
const actChatAllPop = "chatAllPop";
const actOnline = "online";
const actFriendRequest = "friendReqeust";
const actAllriendRequest = "allFriendReqeust";
const actReplyFriendRequest = "replyFriendRequest";
const actSyncChat = "syncChat";

class ImData {
  static ImData? _instance;

  factory ImData.get() => _getInstance();
  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = ImData._internal();
    }
    return _instance;
  }

  late StreamSubscription<MqMsg> _subMsg;
  ImData._internal() {
    _subMsg = MqttLib.get().messageStream.listen((mqMsg) {
      var res = jsonDecode(mqMsg.pt);
      dispatch(mqMsg.topic, res);
    });
  }

  void initSub() {
    MqttLib.get().published?.listen((message) {
      String? topic = message.variableHeader?.topicName;
      if (topic == null) return;
      // _log.info("published topic: $topic");
      var tb = parserTopic(topic);
      if (tb.act == actChat) {
        ImDb.g().db.chatMsgDao.updateArrived(tb.msgId);
      }
    });
  }

  void dispatch(String topic, res) {
    var tb = parserTopic(topic);
    _log.info("act: ${tb.act},dispatch message: $res");
    // var data = res["data"];
    switch (tb.act) {
      case actChat:
        onChatMsg(res);
        break;
      case actChatUser:
        onChatUser(res);
        break;
      case actChatRead:
        onChatRead(res);
        break;
      case actChatDelivered:
        onChatDelivered(tb);
        break;
      case actChatPop:
        onChatPop(res);
        break;
      case actOnline:
        Im.get().requestSystem(actOnline, {}, msgId: UcNavigation.curPage);
        break;
      case actFriendRequest:
        onFriendRequest(tb, res);
        break;
      case actAllriendRequest:
        onAllFriendRequest(tb, res);
        break;
      case actChatAllPop:
        onChatAllPop(tb, res);
        break;
      case actSyncChat:
        onSyncChatLog(tb, res);
        break;
    }
  }

  void onSyncChatLog(TopicBean tb, data) async {
    var syncChat = SyncChat.fromJson(data);
    syncChat.chatList.forEach((chatPageData) async {
      if (chatPageData.msgList!.length == syncChat.limit) {
        if (chatPageData.type == typePerson) {
          await ImDb.g().db.chatMsgDao.delP2PMsgList(chatPageData.peerId);
        } else if (chatPageData.type == typeGroup) {
          await ImDb.g().db.chatMsgDao.delGroupMsgList(chatPageData.peerId);
        }
      }
      chatPageData.msgList!.forEach((msg) {
        ImDb.g().db.chatMsgDao.insertChatMsgData(msg.toCompanion(true));
      });
    });
  }

  void onChatAllPop(TopicBean tb, data) async {
    List list = data;
    await ImDb.g().db.popsDao.delAll();
    for (var i = 0; i < list.length; i++) {
      var pop = Pop.fromJson(list[i]);
      await ImDb.g().db.popsDao.insertPop(pop.toCompanion(true));
    }
  }

  void onAllFriendRequest(TopicBean tb, res) async {
    await ImDb.g().db.friendReqeustsDao.delAll();
    onFriendRequest(tb, res);
  }

  void onFriendRequest(TopicBean tb, res) async {
    List list = res;
    for (var i = 0; i < list.length; i++) {
      FriendReqeust fr = FriendReqeust.fromJson(list[i]);
      ImDb.g().db.friendReqeustsDao.insertFriendRequest(fr.toCompanion(true));
    }
  }

  Future replyFriendRequest(String requestUid, int status) async {
    var params = <String, dynamic>{
      "status": status,
      "requestUid": requestUid,
    };
    Im.get().requestSystem(actReplyFriendRequest, params);
    await ImDb.g().db.friendReqeustsDao.updateStatus(requestUid, status);
    return;
  }

  Future onChatPop(data) async {
    List list = data;
    if (list.length > 1) {
      await ImDb.g().db.popsDao.delAll();
    }
    List<Pop> res = [];
    for (var i = 0; i < list.length; i++) {
      var pop = Pop.fromJson(list[i]);
      await ImDb.g().db.popsDao.insertPop(pop.toCompanion(true));
      res.add(pop);
    }
    Notice.send(UcActions.chatPop());
    return res;
  }

  void onChatDelivered(TopicBean tb) async {
    await ImDb.g().db.chatMsgDao.updateArrived(tb.msgId);
    // Notice.send(UcActions.msg());
  }

  void onChatRead(data) async {
    Map<String, dynamic> res = data;
    String fUid = res["friendUid"];
    int readTime = res["readTime"];
    var changeRow = await ImDb.g().db.friendDao.updateReadTime(fUid, readTime);
    if (changeRow == 0) {
      await ImApi.friendList();
      changeRow = await ImDb.g().db.friendDao.updateReadTime(fUid, readTime);
      if (changeRow == 0) {
        _log.info("error: not found fUid: $fUid");
      }
    }
    await ImDb.g().db.chatMsgDao.updateReaded(fUid, readTime);
    Notice.send(UcActions.chatRead(), res);
  }

  void onChatUser(data) {
    List list = data;
    for (var i = 0; i < list.length; i++) {
      var user = ChatUser.fromJson(list[i]);
      ImDb.g().db.chatUserDao.insertChatUser(user.toCompanion(false));
    }
    Notice.send(UcActions.chatUser());
  }

  void onChatMsg(data) {
    ChatMsg msg = ChatMsg.fromJson(data);
    ImDb.g().db.chatMsgDao.insertChatMsgData(msg.toCompanion(true));
    onNewRecent(msg);
    if (msg.type == typePerson) {
      String pageKey = "${typePerson}-" + msg.fromId;
      if (UcNavigation.curPage.endsWith(pageKey)) {
        readMsg(msg.fromId, Utils.getTimestampSecond());
      }
    }

    // Notice.send(UcActions.newMsg(), msg);
  }

  void onNewRecent(ChatMsg msg) {
    var jsonMsg = msg.toJson();
    var my = Global.get().curUser;
    jsonMsg["targetId"] = msg.peerId;
    if (my.id == msg.peerId) {
      jsonMsg["targetId"] = msg.fromId;
    }
    var recent = ChatRecent.fromJson(jsonMsg);
    ImDb.g()
        .db
        .chatRecentDao
        .insertChat(recent.toCompanion(true))
        .then((value) => Notice.send(UcActions.recentList()));
    ImDb.g().db.chatUserDao.getChatUsers([jsonMsg["targetId"]]).then((value) {
      if (value.length == 0) {
        Im.get().requestSystem(API.actChatUser, {
          "uids": [jsonMsg["targetId"]]
        });
      }
    });
  }

  Stream<List<ChatMsg>> getChatList(String peerId, int type, int offset) {
    Stream<List<ChatMsg>> res;
    if (type == typePerson)
      res = ImDb.g().db.chatMsgDao.getP2PMsgList(peerId, 100, offset);
    else
      res = ImDb.g().db.chatMsgDao.getGroupMsgList(peerId, 100, offset);
    // var json = jsonEncode(res);
    // _log.info("getChatList: $json");
    return res;
  }

  Future<List<ChatRecentBean>> getRecentList({bool update = false}) async {
    List<ChatRecentBean> res = [];
    List<ChatRecent> list =
        await ImDb.g().db.chatRecentDao.getRecentList(100, 0);

    List<String> reqList = [];
    if (list.length > 0) {
      list.forEach((recent) {
        // addUnique2list(reqList, recent.fromId);
        addUnique2list(reqList, recent.targetId);
      });
      var uMap = await getChatUsers(reqList);
      list.forEach((recent) {
        var bean = ChatRecentBean(recent, uMap[recent.targetId]!);
        res.add(bean);
      });
    }

    if (update)
      ImApi.requestRecentList()
          .then((value) => {Notice.send(UcActions.recentList())});
    return res;
  }

  Future<Map<String, ChatUser>> getChatUsers(List<String> uids,
      {bool update = false}) async {
    List<ChatUser> list = await ImDb.g().db.chatUserDao.getChatUsers(uids);
    var res = Map<String, ChatUser>();
    res = _converCharUsers(list);
    bool needUpdate = false;
    for (var i = 0; i < uids.length; i++) {
      var uid = uids[i];
      if (res[uid] == null) {
        needUpdate = true;
        res[uid] = ChatUser(id: uid, name: "loading...");
      }
    }
    if (update || needUpdate)
      ImApi.getChatUser(uids).then((value) {
        Notice.send(UcActions.chatUser());
        UcNotice.send(UcActions.chatUsersMap(), _converCharUsers(value));
      });
    return res;
  }

  Map<String, ChatUser> _converCharUsers(List<ChatUser> list) {
    var res = Map<String, ChatUser>();
    for (var i = 0; i < list.length; i++) {
      var u = list[i];
      res[u.id] = u;
    }

    return res;
  }

  Future<ChatUser> getChatUser(String uid, {bool update = false}) async {
    ChatUser res = ChatUser(id: uid, name: "loading...");
    List<ChatUser> list = await ImDb.g().db.chatUserDao.getChatUsers([uid]);
    if (list.length == 0) {
      var rsp = await ImApi.getChatUser([uid]);
      if (rsp.length != 0) {
        res = rsp[0];
      }
    } else {
      res = list[0];
    }
    return res;
  }

  Future<RspDb<ChatUser>> searchUser(String search) async {
    return await ImApi.searchUser(search);
  }

  Stream<List<Friend>> friendList() {
    var res = ImDb.g().db.friendDao.getAllFriend();
    ImApi.friendList();
    // .then((value) => Notice.send(UcActions.friendList(), value.res));
    return res;
  }

  Stream getUnread() {
    Stream s = ImDb.g().db.popsDao.queryAll().map((list) {
      var res = Map<String, int>();
      for (var i = 0; i < list.length; i++) {
        var pop = list[i];
        var key = pop.type.toString();
        if (pop.type == PopTypeGroup) {
          key = pop.targetId + "_" + typeGroup.toString();
        } else if (pop.type == PopTypeP2P) {
          key = pop.targetId + "_" + typePerson.toString();
        }
        res[key] = pop.count;
      }
      return res;
    });
    return s;
  }

  void readMsg(String fUid, int readTime) {
    var params = {"friendUid": fUid, "readTime": readTime};
    Im.get().requestSystem(actChatRead, params);
    int t = PopTypeP2P;
    ImDb.g().db.popsDao.delPop(fUid, t);
    Notice.send(UcActions.chatPop());
  }

  static TopicBean parserTopic(String topic) {
    var tb = TopicBean();
    var arr = topic.split("/");
    if (arr.length > 3) {
      tb.type = arr[1];
      tb.targetId = arr[2];
      tb.act = arr[3];
      if (arr.length > 4) {
        tb.msgId = arr[4];
      }
    }
    return tb;
  }
}

class TopicBean {
  String type = "";
  String targetId = "";
  String act = "";
  String msgId = "";
}

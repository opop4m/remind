import 'dart:convert';

import 'package:client/pages/navigation.dart';
import 'package:client/provider/model/chatBean.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/provider/service/imApi.dart';
import 'package:client/provider/service/imGroupData.dart';
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
const actFriendUpdate = "friendUpdate";
const actFriendDelete = "friendDelete";
const actSyncChat = "syncChat";
const actCreateGroup = "createGroup";
const actQuitGroup = "quitGroup";
const actAllGroupMem = "allGroupMem";
const actGroupInvite = "groupInvite";
const actGroupUpdate = "groupUpdate";

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
    _subMsg = MqttLib.get().messageStream.listen((mqMsg) async {
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

  ImGroupData groupData = ImGroupData();

  Future dispatch(String topic, res) async {
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
      case actCreateGroup:
        groupData.onCreateGroup(tb, res);
        break;
      case actFriendUpdate:
        onFriendUpdate(tb, res);
        break;
      case actFriendDelete:
        onFriendDelete(tb.msgId);
        break;
      case actAllGroupMem:
        groupData.onAllGroupMem(tb, res);
        break;
      case actQuitGroup:
        groupData.onQuitGroup(tb.msgId);
        break;
      case actGroupUpdate:
        await groupData.onGroupUpdate(tb, res);
        break;
    }
    var c = _cacheRequest.remove(tb.act);
    if (c != null) {
      c.complete();
    }
  }

  void onFriendDelete(String fId) {
    ImDb.g().db.friendDao.deleteFriend(fId);
    ImDb.g().db.chatRecentDao.delRecent(fId, typePerson);
    ImDb.g().db.chatMsgDao.delP2PMsgList(fId);
    ImDb.g().db.popsDao.delPop(fId, PopTypeP2P);
  }

  void onFriendUpdate(TopicBean tb, data) async {
    Map map = data;
    if (map["event"] == "update") {
      List list = map["list"];
      list.forEach((json) {
        var fJson = ImApi.parserFriendName(json);
        var friend = Friend.fromJson(fJson);
        ImDb.g().db.friendDao.insertFriend(friend.toCompanion(true));
      });
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
    String fUid = res["targetId"];
    int readTime = res["readTime"];
    int type = res["type"];
    if (type == typePerson) {
      var changeRow =
          await ImDb.g().db.friendDao.updateReadTime(fUid, readTime);
      if (changeRow == 0) {
        await ImApi.friendList();
        changeRow = await ImDb.g().db.friendDao.updateReadTime(fUid, readTime);
        if (changeRow == 0) {
          _log.info("error: not found fUid: $fUid");
        }
      }
      await ImDb.g().db.chatMsgDao.updateReaded(fUid, readTime);
    }
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
    String pageKey;
    if (msg.type == typePerson) {
      pageKey = Im.routeKey(msg.fromId, typePerson);
    } else {
      pageKey = Im.routeKey(msg.peerId, typeGroup);
    }
    if (UcNavigation.curPage.endsWith(pageKey)) {
      var targetId = msg.fromId;
      if (msg.type == typeGroup) {
        targetId = msg.peerId;
      }
      readMsg(targetId, Utils.getTimestampSecond(), msg.type);
    }

    // Notice.send(UcActions.newMsg(), msg);
  }

  void onNewRecent(ChatMsg msg) {
    var jsonMsg = msg.toJson();
    var my = Global.get().curUser;
    jsonMsg["targetId"] = msg.peerId;
    if (msg.type == typePerson) {
      if (my.id == msg.peerId) {
        jsonMsg["targetId"] = msg.fromId;
      }
    }

    var recent = ChatRecent.fromJson(jsonMsg);
    ImDb.g()
        .db
        .chatRecentDao
        .insertChat(recent.toCompanion(true))
        .then((value) => Notice.send(UcActions.recentList()));
    if (msg.type == typePerson) {
      ImDb.g().db.chatUserDao.getChatUsers([jsonMsg["targetId"]]).then((value) {
        if (value.length == 0) {
          Im.get().requestSystem(API.actChatUser, {
            "uids": [jsonMsg["targetId"]]
          });
        }
      });
    } else {
      ImDb.g().db.groupDao.getGroup(jsonMsg["targetId"]).then((g) {
        if (g == null) {
          ImApi.groupInfo([jsonMsg["targetId"]]);
        }
      });
    }
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

  // Future<List<ChatRecentBean>> getRecentList({bool update = false}) async {
  //   List<ChatRecentBean> res = [];
  //   List<ChatRecent> list =
  //       await ImDb.g().db.chatRecentDao.getRecentList(100, 0);

  //   List<String> reqList = [];
  //   if (list.length > 0) {
  //     list.forEach((recent) {
  //       // addUnique2list(reqList, recent.fromId);
  //       if (recent.type == typePerson) addUnique2list(reqList, recent.targetId);
  //     });
  //     var uMap = await getChatUsers(reqList);
  //     list.forEach((recent) {
  //       var bean = ChatRecentBean(recent, user: uMap[recent.targetId]!);
  //       res.add(bean);
  //     });
  //   }
  //   if (update)
  //     ImApi.requestRecentList()
  //         .then((value) => {Notice.send(UcActions.recentList())});
  //   return res;
  // }

  StreamSubscription? _subChatUser, _subGroup;

  Stream<Future<List<ChatRecentBean>>> watchRecentList({bool update = false}) {
    _log.info("watchRecentList");
    _subGroup?.cancel();
    _subGroup = ImDb.g().db.groupDao.watchAllGroup().listen((event) {
      ImDb.g().db.chatRecentDao.refresh();
    });
    _subChatUser?.cancel();
    _subChatUser = ImDb.g().db.chatUserDao.watchAllChatUsers().listen((event) {
      ImDb.g().db.chatRecentDao.refresh();
    });
    var ret =
        ImDb.g().db.chatRecentDao.watchRecentList(100, 0).map((list) async {
      List<ChatRecentBean> res = [];
      // List<String> reqList = [];
      Set<String> reqList = {};
      List<String> reqGroupList = [];
      if (list.length > 0) {
        list.forEach((recent) {
          // addUnique2list(reqList, recent.fromId);
          if (recent.type == typePerson) {
            // addUnique2list(reqList, recent.peerId);
            // addUnique2list(reqList, recent.fromId);
            reqList.add(recent.peerId);
            reqList.add(recent.fromId);
          } else
            addUnique2list(reqGroupList, recent.targetId);
        });
        var uMap = await getChatUsers(reqList.toList());
        var gMap = await getChatGroups(reqGroupList);
        list.forEach((recent) {
          var bean = ChatRecentBean(recent);
          if (recent.type == typePerson) {
            var id = recent.peerId;
            if (id == Global.get().curUser.id) {
              id = recent.fromId;
            }
            bean.user = uMap[id]!;
          } else {
            bean.group = gMap[recent.targetId]!;
          }
          res.add(bean);
        });
      }
      if (update)
        ImApi.requestRecentList()
            .then((value) => {Notice.send(UcActions.recentList())});
      return res;
    });
    return ret;
  }

  Future<Group> getChatGroup(String groupId) async {
    var group = await ImDb.g().db.groupDao.getGroup(groupId);
    if (group == null) {
      var list = await ImApi.groupInfo([groupId]);
      if (list.length > 0) {
        group = list[0];
      } else {
        group = Group(
            id: groupId,
            uid: "loading",
            name: "loading",
            memberCount: 1,
            createTime: 0);
      }
    }
    return group;
  }

  Future<Map<String, Group>> getChatGroups(List<String> reqGroupList) async {
    List<Group> list = await ImDb.g().db.groupDao.queryAllGroup();
    Map<String, Group> res = {};
    list.forEach((group) {
      res[group.id] = group;
    });
    List<String> updateId = [];
    reqGroupList.forEach((id) {
      if (res[id] == null) {
        res[id] = Group(
            id: id,
            uid: Global.get().curUser.id,
            name: "loading...",
            memberCount: 1,
            isDeleted: false,
            createTime: 0);
        updateId.add(id);
      }
    });
    if (updateId.length > 0) {
      ImApi.groupInfo(updateId);
    }
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
      _log.info("list pop: " + jsonEncode(list));
      var res = Map<String, int>();
      for (var i = 0; i < list.length; i++) {
        var pop = list[i];
        var key = Im.routeKey(pop.targetId, pop.type);
        res[key] = pop.count;
      }
      return res;
    });
    return s;
  }

  void readMsg(String fUid, int readTime, int type) {
    var params = {
      "targetId": fUid,
      "readTime": readTime,
      "type": type,
    };
    Im.get().requestSystem(actChatRead, params);
    ImDb.g().db.popsDao.delPop(fUid, type);
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

  Map<String, Completer> _cacheRequest = {};
  Future request(String act, {Object? params, String? msgId}) {
    var completer = Completer();
    Im.get().requestSystem(act, params, msgId: msgId).then((value) {
      _cacheRequest[act] = completer;
      _log.info("_cacheRequest $act");
    });
    return completer.future;
  }

  static ChatUser defaultUser(String uid) {
    return ChatUser(id: uid, name: "loading...");
  }

  static Future getUserInfo(String uid, Callback cb) async {
    var u = await ImData.get().getChatUser(uid);
    cb(u);
  }
}

class TopicBean {
  String type = "";
  String targetId = "";
  String act = "";
  String msgId = "";
}

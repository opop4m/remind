import 'dart:convert';

import 'package:client/provider/model/chatBean.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/provider/service/imApi.dart';
import 'package:client/tools/library.dart';

final _log = Logger("ImData");

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

  ImData._internal() {
    Im.get().setListenner("dbMsg", dispatch);
  }

  void dispatch(String topic, Map<String, dynamic> res) {
    _log.info("message: $res");
    String act = res["act"];
    var data = res["data"];
    switch (act) {
      case "chat":
        onChatMsg(data);
        break;
    }
  }

  void onChatMsg(data) {
    ChatMsg msg = ChatMsg.fromJson(data);
    ImDb.g().db.chatMsgDao.insertChatMsgData(msg.toCompanion(true));
    onNewRecent(msg);
    Notice.send(UcActions.newMsg(), msg);
  }

  void onNewRecent(ChatMsg msg) {
    var jsonMsg = msg.toJson();
    var my = Global.get().curUser;
    jsonMsg["targetId"] = msg.peerId;
    if (my.id == msg.peerId) {
      jsonMsg["targetId"] = msg.fromId;
    }
    var recent = ChatRecent.fromJson(jsonMsg);
    ImDb.g().db.chatRecentDao.insertChat(recent.toCompanion(true));
  }

  Future<List<ChatMsg>> getChatList(String peerId, int type, int offset) async {
    var res =
        await ImDb.g().db.chatMsgDao.getMsgList(peerId, type, 100, offset);
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
        addUnique2list(reqList, recent.peerId);
      });
      var uMap = await getChatUsers(reqList);
      list.forEach((recent) {
        var bean = ChatRecentBean(recent, uMap[recent.peerId]!);
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
    for (var i = 0; i < list.length; i++) {
      var u = list[i];
      res[u.id] = u;
    }
    for (var i = 0; i < uids.length; i++) {
      var uid = uids[i];
      if (res[uid] == null) {
        res[uid] = ChatUser(id: uid, name: "loading...");
        if (!update) {
          _log.info("not found userInfo uid: $uid");

          // List<ChatUser> debug =
          //     await ImDb.g().db.chatUserDao.getChatUsers(uids);
          // String str = jsonEncode(debug);
          // _log.info("all chat user: $str");
        }
      }
    }

    if (update)
      ImApi.getChatUser(uids)
          .then((value) => Notice.send(UcActions.chatUser()));
    return res;
  }

  Future<List<ChatMsg>> getMsgList(String peerId, int type, int limit,
      {int offset = 0}) async {
    List<ChatMsg> list =
        await ImDb.g().db.chatMsgDao.getMsgList(peerId, type, limit, offset);
    return list;
  }

  Future<RspDb<ChatUser>> searchUser(String search) async {
    return await ImApi.searchUser(search);
  }
}

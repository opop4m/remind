import 'dart:convert';

import 'package:client/config/api.dart';
import 'package:client/http/req.dart';
import 'package:client/provider/model/chatDb.dart';
// import 'package:client/provider/model/chatList.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/library.dart';

final _log = Logger("ImApi");

class ImApi {
  // static Future<Rsp<ChatList>> requestChatList() async {
  //   var rsp = await Req.g().get(API.chatList);
  //   var res = new Rsp<ChatList>();
  //   if (rsp.data != null) {
  //     res.fromJson(rsp.data, new ChatList());
  //     if (res.data != null) {}
  //     _log.info("got chat list: ${res.data!.list.length}");
  //   }
  //   return res;
  // }

  static Future<RspDb<List<ChatRecent>>> requestRecentList() async {
    var rsp = await Req.g().get(API.recentList);
    var res = new RspDb<List<ChatRecent>>();
    if (rsp.data != null) {
      res.fromJson(rsp.data);
      if (res.data != null) {
        List list = res.data!["chatList"] ?? [];
        List? userList = res.data!["users"];

        res.res = [];
        for (var i = 0; i < list.length; i++) {
          var recent = ChatRecent.fromJson(list[i]);
          ImDb.g().db.chatRecentDao.insertChat(recent.toCompanion(true));
          res.res!.add(recent);
        }

        if (userList != null) {
          for (var i = 0; i < userList.length; i++) {
            var user = ChatUser.fromJson(userList[i]);
            ImDb.g().db.chatUserDao.insertChatUser(user.toCompanion(false));
          }
        }
      }
    }
    return res;
  }

  // static Future<Rsp<ChatUserList>> getChatUser(List<String> reqList) async {
  //   var res = new Rsp<ChatUserList>();
  //   res.code = 0;
  //   res.data = new ChatUserList();
  //   for (var i = 0; i < reqList.length; i++) {
  //     var uid = reqList[i];
  //     var user = ChatUser();
  //     user.id = uid;
  //     user.name = uid;
  //     res.data!.users[uid] = user;
  //   }
  //   return res;
  // }

  static Future<RspDb<List<ChatUser>>> getChatUser(List<String> reqList) async {
    var uidStr = reqList.join(",");
    var rsp = await Req.g().post(API.getChatUser, {"uids": uidStr});
    var res = new RspDb<List<ChatUser>>();
    if (rsp.data != null) {
      res.fromJson(rsp.data);
      if (res.data != null) {
        List? list = res.data!["users"];
        if (list != null) {
          res.res = [];
          for (var i = 0; i < list.length; i++) {
            var user = ChatUser.fromJson(list[i]);
            ImDb.g().db.chatUserDao.insertChatUser(user.toCompanion(false));
            res.res!.add(user);
          }
        }
      }
    }
    return res;
  }
}

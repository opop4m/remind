import 'package:client/config/api.dart';
import 'package:client/http/req.dart';
// import 'package:client/provider/model/chatList.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/library.dart';
import 'package:lpinyin/lpinyin.dart';

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

  static Future<List<ChatRecent>> requestRecentList() async {
    var rsp = await Req.g().get(API.recentList);
    var res = new RspDb<List<ChatRecent>>();
    if (rsp.data != null) {
      res.fromJson(rsp.data);
      if (res.data != null) {
        List list = res.data!["chatList"] ?? [];
        List? userList = res.data!["users"];
        List? groupList = res.data!["groups"];

        res.res = [];
        await ImDb.g().db.chatRecentDao.delAll();
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
        if (groupList != null) {
          for (var json in groupList) {
            var g = Group.fromJson(json);
            ImDb.g().db.groupDao.insertGroup(g.toCompanion(true));
          }
        }
      }
    }
    _log.info("finished requestRecentList");
    return res.res!;
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

  static Future<List<ChatUser>> getChatUser(List<String> reqList) async {
    var uidStr = reqList.join(",");
    var rsp = await Req.g().post(API.getChatUser, {"uids": uidStr});
    var res = new RspDb<List<ChatUser>>();
    List<ChatUser> resq = [];
    if (rsp.data != null) {
      res.fromJson(rsp.data);
      if (res.data != null) {
        List? list = res.data!["users"];
        if (list != null) {
          for (var i = 0; i < list.length; i++) {
            var user = ChatUser.fromJson(list[i]);
            ImDb.g().db.chatUserDao.insertChatUser(user.toCompanion(false));
            resq.add(user);
          }
        }
      }
    }
    return resq;
  }

  static Future<RspDb<ChatUser>> searchUser(String search) async {
    var rsp = await Req.g().get(API.searchUser, params: {"uid": search});
    var res = new RspDb<ChatUser>();
    if (rsp.data != null) {
      res.fromJson(rsp.data);
      if (res.code == 0) {
        res.res = ChatUser.fromJson(res.data!["user"]);
      }
    }
    return res;
  }

  static Future<RspDb> requestAddFriend(Map params) async {
    var rsp = await Req.g().post(API.addFriend, params);
    var res = RspDb();
    if (rsp.data != null) {
      res.fromJson(rsp.data);
    }
    return res;
  }

  static Future<RspDb<List<Friend>>> friendList() async {
    var rsp = await Req.g().get(API.friendList);
    var res = RspDb<List<Friend>>();
    if (rsp.data != null) {
      res.fromJson(rsp.data);
      if (res.data != null) {
        List? list = res.data!["friends"];
        if (list != null) {
          res.res = [];
          for (var i = 0; i < list.length; i++) {
            var fJson = parserFriendName(list[i]);
            var friend = Friend.fromJson(fJson);
            ImDb.g().db.friendDao.insertFriend(friend.toCompanion(true));
            res.res!.add(friend);
          }
        }
      }
    }
    return res;
  }

  static Map<String, dynamic> parserFriendName(Map<String, dynamic> fJson) {
    if (strNoEmpty(fJson["alias"])) {
      fJson["name"] = fJson["alias"];
    } else {
      fJson["name"] = fJson["nickname"];
    }
    fJson["nameIndex"] = PinyinHelper.getFirstWordPinyin(fJson["name"]);
    return fJson;
  }

  static Future appStart(String token) async {
    return await Req.g().get(API.appStart, params: {"token": token});
  }

  static Future<List<Group>> groupInfo(List<String> groupIds) async {
    var rsp = await Req.g()
        .get(API.groupInfo, params: {"groupIds": groupIds.join(",")});
    var res = RspDb<List<Group>>();
    res.res = [];
    if (rsp.data != null) {
      res.fromJson(rsp.data);
      if (res.data != null) {
        List list = res.data!["groups"];
        list.forEach((json) {
          var g = Group.fromJson(json);
          ImDb.g().db.groupDao.insertGroup(g.toCompanion(true));
          res.res!.add(g);
        });
      }
    }
    return res.res!;
  }
}

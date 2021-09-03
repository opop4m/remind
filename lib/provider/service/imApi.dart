import 'package:client/config/api.dart';
import 'package:client/http/req.dart';
import 'package:client/provider/model/chatList.dart';
import 'package:client/provider/model/user.dart';
import 'package:client/tools/wechat_flutter.dart';

final _log = Logger("ImApi");

class ImApi {
  static Future<Rsp<ChatList>> requestChatList() async {
    var rsp = await Req.g().get(API.chatList);
    var res = new Rsp<ChatList>();
    if (rsp.data != null) {
      res.fromJson(rsp.data, new ChatList());
      if (res.data != null) {}
      _log.info("got chat list: ${res.data!.list.length}");
    }
    return res;
  }

  static Future<Rsp<ChatUserList>> getChatUser(List<String> reqList) async {
    var res = new Rsp<ChatUserList>();
    res.code = 0;
    res.data = new ChatUserList();
    for (var i = 0; i < reqList.length; i++) {
      var uid = reqList[i];
      var user = ChatUser();
      user.id = uid;
      user.name = uid;
      res.data!.users[uid] = user;
    }
    return res;
  }
}

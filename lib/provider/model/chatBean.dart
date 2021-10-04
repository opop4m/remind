import 'package:client/provider/service/imDb.dart';

class ChatRecentBean {
  ChatRecent recent;
  ChatUser? user;
  Group? group;

  ChatRecentBean(this.recent, {this.user, this.group});
}

class SyncChat {
  List<SyncChatPage> chatList = [];
  int? limit;

  SyncChat();
  factory SyncChat.fromJson(Map json) {
    var s = SyncChat();
    s.limit = json["limit"];
    List list = json["chatList"] ?? [];
    for (var i = 0; i < list.length; i++) {
      var chatData = SyncChatPage.fromJson(list[i]);
      s.chatList.add(chatData);
    }
    return s;
  }
  Map toJson() {
    return {
      "chatList": chatList,
    };
  }
}

class SyncChatPage {
  String peerId;
  int type;
  int createTime;

  List<ChatMsg>? msgList;

  SyncChatPage(this.peerId, this.type, this.createTime);
  factory SyncChatPage.fromJson(Map json) {
    var s = SyncChatPage(
      json["peerId"],
      json["type"],
      json["createTime"],
    );
    List? list = json["msgList"];
    s.msgList = [];
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        var msg = ChatMsg.fromJson(list[i]);
        s.msgList!.add(msg);
      }
    }
    return s;
  }
  Map toJson() {
    return {
      "peerId": peerId,
      "type": type,
      "createTime": createTime,
    };
  }
}

import 'package:client/provider/model/user.dart';

class ChatList extends FromJson {
  List<Msg> list = [];
  @override
  ChatList fromJson(json) {
    // print(json);
    List res = json["chatList"];
    for (var i = 0; i < res.length; i++) {
      var row = new Msg().fromJson(res[i]);
      list.add(row);
    }

    return this;
  }
}

// class ChatRow extends FromJson {
//   Msg msg = Msg();
//   ChatUser peerInfo = ChatUser();

//   @override
//   ChatRow fromJson(json) {
//     msg = msg.fromJson(json["msg"]);
//     peerInfo = peerInfo.fromJson(json["peerInfo"]);
//     return this;
//   }
// }

class Msg extends FromJson {
  String msgId = "";
  String peerId = "";
  // ChatUser from = ChatUser();
  String fromId = "";
  int type = 0;
  int msgType = 0;
  int tipsType = 0;
  String content = "";
  int createTime = 0;
  List<String> ext = [];

  @override
  Msg fromJson(json) {
    msgId = json["msgId"];
    peerId = json["peerId"];
    // from.fromJson(json["from"]);
    fromId = json["fromId"];
    msgType = json["msgType"] ?? 0;
    tipsType = json["tipsType"] ?? 0;
    type = json["type"] ?? 0;

    content = json["content"];
    createTime = json["createTime"];
    ext = json["ext"] ?? [];
    return this;
  }

  Map toJson() {
    var map = {
      "msgId": msgId,
      "peerId": peerId,
      "type": type,
      "msgType": msgType,
      "tipsType": tipsType,
      "content": content,
      "createTime": createTime,
      "ext": ext,
      "fromId": fromId,
    };
    return map;
  }
}

class ChatUserList extends FromJson {
  Map<String, ChatUser> users = {};

  @override
  ChatUserList fromJson(json) {
    List res = json["userList"];
    for (var i = 0; i < res.length; i++) {
      var row = new ChatUser().fromJson(res[i]);
      users[row.id] = row;
    }
    return this;
  }
}

class ChatUser extends FromJson {
  String id = "";
  String name = "";
  String? avatar;
  @override
  ChatUser fromJson(json) {
    id = json["id"];
    name = json["name"];
    avatar = json["avatar"];
    return this;
  }

  Map toJson() {
    return {
      "id": id,
      "name": name,
      "avatar": avatar,
    };
  }
}

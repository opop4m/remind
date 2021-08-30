class Rsp<T extends FromJson> {
  int code = -1;
  String msg = "";
  T? data;

  void fromJson(Map json, T t) {
    this.code = json["code"];
    this.msg = json["msg"];
    if (this.code == 0) {
      data = t.fromJson(json["data"]);
    }
  }
}

abstract class FromJson {
  dynamic fromJson(Map json);
}

class Test {
  String t = "";
}

class LoginRsp extends FromJson {
  User user = User();
  ChatConf chatConf = ChatConf();
  LoginRsp();
  LoginRsp fromJson(Map json) {
    user = user.fromJson(json["user"]);
    chatConf = chatConf.fromJson(json["chatConf"]);
    return this;
  }

  Map toJson() {
    return {"user": user.toJson(), "chatConf": chatConf.toJson()};
  }
}

class ChatConf extends FromJson {
  String host = "";
  String port = "";
  String stun = "";
  String turn = "";
  ChatConf();
  ChatConf fromJson(Map json) {
    host = json["host"];
    port = json["port"];
    stun = json["stun"];
    turn = json["turn"];
    return this;
  }

  Map toJson() {
    return {
      "host": host,
      "port": port,
      "stun": stun,
      "turn": turn,
    };
  }
}

class User extends FromJson {
  String nickName = "";
  String accessToken = "";
  String account = "";
  String email = "";
  String id = "";
  int showId = 0;
  String? avatar;
  User();
  User fromJson(Map json) {
    this.avatar = json["avatar"];
    this.nickName = json["nickName"] ?? "";
    this.accessToken = json["accessToken"] ?? "";
    this.account = json["account"] ?? "";
    this.email = json["email"] ?? "";
    this.id = json["id"] ?? "";
    this.showId = json["showId"] ?? 0;
    return this;
  }

  Map toJson() {
    Map map = {
      "avatar": avatar,
      "nickName": nickName,
      "accessToken": accessToken,
      "account": account,
      "email": email,
      "id": id,
      "showId": showId,
    };
    return map;
  }
}

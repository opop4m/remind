class Rsp<T extends FromJson> {
  int code = -1;
  String msg = "";
  T? data;

  void fromJson(Map json, T t) {
    this.code = json["code"];
    this.msg = json["msg"];
    data = t;
    if (this.code == 0) {
      data = t.fromJson(json["data"]);
    }
  }
}

class RspDb<T> {
  int code = -1;
  String msg = "";
  Map<String, dynamic>? data;
  T? res;
  void fromJson(Map json) {
    this.code = json["code"];
    this.msg = json["msg"];
    data = json["data"];
  }
}

abstract class FromJson {
  dynamic fromJson(json);
  static dynamic decodeJson(json) {}
}

class Test {
  String t = "";
}

class LoginRsp extends FromJson {
  User user = User();
  ChatConf chatConf = ChatConf();
  LoginRsp();
  LoginRsp fromJson(dynamic json) {
    user = user.fromJson(json["user"]);
    chatConf = chatConf.fromJson(json["chatConf"]);
    return this;
  }

  Map toJson() {
    return {"user": user.toJson(), "chatConf": chatConf.toJson()};
  }
}

class ChatConf extends FromJson {
  String wsHost = "";
  String wsPort = "";
  String stun = "";
  String turn = "";
  String fileHost = "";
  String uploadHost = "";
  ChatConf();
  ChatConf fromJson(dynamic json) {
    wsHost = json["wsHost"];
    wsPort = json["wsPort"];
    stun = json["stun"];
    turn = json["turn"];
    fileHost = json["fileHost"];
    uploadHost = json["uploadHost"];
    return this;
  }

  Map toJson() {
    return {
      "wsHost": wsHost,
      "wsPort": wsPort,
      "stun": stun,
      "turn": turn,
      "fileHost": fileHost,
      "uploadHost": uploadHost,
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
  int gender = 1;
  String? avatar;

  User();
  User fromJson(json) {
    this.avatar = json["avatar"];
    this.nickName = json["nickName"] ?? "";
    this.accessToken = json["accessToken"] ?? "";
    this.account = json["account"] ?? "";
    this.email = json["email"] ?? "";
    this.id = json["id"] ?? "";
    this.showId = json["showId"] ?? 0;
    this.gender = json["gender"] ?? 1;
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
      "gender": gender,
    };
    return map;
  }
}

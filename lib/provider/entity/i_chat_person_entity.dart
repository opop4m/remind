/*
* 实体类 - 会话个人信息（IOS）
* @param birthday 生日
* @param faceURL 头像URL
* @param identifier ID
* @param role 角色
* @param gender 性别
* @param level 等级
* @param nickname 昵称
* @param language 语言
* @param customInfo 习俗信息
* @param allowType 添加为好友方式
*
* */
class IChatPersonEntity {
  int birthday = 0;
  String? faceURL;
  String? identifier;
  int role = 0;
  int gender = 0;
  int level = 0;
  String nickname = "";
  int language = 0;
  IChatPersonCustominfo? customInfo;
  dynamic allowType;

  IChatPersonEntity(
      {this.birthday = 0,
      this.faceURL,
      this.identifier,
      this.role = 0,
      this.gender = 0,
      this.level = 0,
      this.nickname = "",
      this.language = 0,
      this.customInfo,
      this.allowType});

  IChatPersonEntity.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    faceURL = json['faceURL'];
    identifier = json['identifier'];
    role = json['role'];
    gender = json['gender'];
    level = json['level'];
    nickname = json['nickname'];
    language = json['language'];
    customInfo = json['customInfo'] != null
        ? new IChatPersonCustominfo.fromJson(json['customInfo'])
        : null;
    allowType = json['allowType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this.birthday;
    data['faceURL'] = this.faceURL;
    data['identifier'] = this.identifier;
    data['role'] = this.role;
    data['gender'] = this.gender;
    data['level'] = this.level;
    data['nickname'] = this.nickname;
    data['language'] = this.language;
    if (this.customInfo != null) {
      data['customInfo'] = this.customInfo?.toJson();
    }
    data['allowType'] = this.allowType;
    return data;
  }
}

class IChatPersonCustominfo {
  IChatPersonCustominfo.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

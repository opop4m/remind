class API {
  static const nameUrl = 'https://www.apiopen.top/femaleNameApi';
  static const avatarUrl = 'http://www.lorempixel.com/200/200/';
  static const cat = 'https://api.thecatapi.com/v1/images/search';
  static const upImg = "http://111.230.251.115/oldchen/fUser/oneDaySuggestion";
  static const update = 'http://www.flutterj.com/api/update.json';
  static const uploadImg = 'http://www.flutterj.com/upload/avatar';

  static init(String env) {
    //dev,prod,release
    switch (env) {
      case "dev":
        break;
    }
  }

  static String fileHost = "";
  static String uploadHost = "";

  static String appKey = "unicornKey";
  static String appClientSecret = "unicornSecret";

  static String httpHost = "http://my.t.com:8082/";
  static String userRegister = httpHost + "user/register";
  static String userLogin = httpHost + "user/login";
  static String userInfo = httpHost + "user/info";
  static String userUpdate = httpHost + "user/update";

  static String recentList = httpHost + "chat/recent_list"; //get
  static String getChatUser = httpHost + "chat/chat_user"; //post
  static String searchUser = httpHost + "chat/search_user"; //get
  static String addFriend = httpHost + "chat/add_friend"; //post
  static String friendList = httpHost + "chat/friend_list"; //get

  static String actChatUser = "chatUser";
}

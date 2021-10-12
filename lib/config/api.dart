class API {
  static const nameUrl = 'https://www.apiopen.top/femaleNameApi';
  static const avatarUrl = 'http://www.lorempixel.com/200/200/';
  static const cat = 'https://api.thecatapi.com/v1/images/search';
  static const upImg = "http://111.230.251.115/oldchen/fUser/oneDaySuggestion";
  static const update = 'http://www.flutterj.com/api/update.json';
  static const uploadImg = 'http://www.flutterj.com/upload/avatar';

  static init(String _env) {
    env = _env;
    //dev,prod,release
    switch (_env) {
      case "dev":
        debug = true;
        break;
    }
  }

  static bool debug = false;

  static String env = "dev";

  static String fileHost = "";
  static String uploadHost = "";

  static String appKey = "unicornKey";
  static String appClientSecret = "unicornSecret";

  static String httpHost = "http://192.168.1.2:8082/";
  static String userRegister = httpHost + "user/register";
  static String userLogin = httpHost + "user/login";
  static String userInfo = httpHost + "user/info";
  static String userUpdate = httpHost + "user/update";
  static String appStart = httpHost + "user/start";

  static String recentList = httpHost + "chat/recent_list"; //get
  static String getChatUser = httpHost + "chat/chat_user"; //post
  static String searchUser = httpHost + "chat/search_user"; //get
  static String addFriend = httpHost + "chat/add_friend"; //post
  static String friendList = httpHost + "chat/friend_list"; //get
  static String groupInfo = httpHost + "chat/group_info"; //get

  static String actChatUser = "chatUser";
}

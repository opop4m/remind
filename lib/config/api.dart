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

  static String appKey = "unicornKey";
  static String appClientSecret = "unicornSecret";

  static String httpHost = "http://127.0.0.1:8082/";
  static String userRegister = httpHost + "user/register";
  static String userLogin = httpHost + "user/login";
  static String recentList = httpHost + "chat/recent_list"; //get
  static String getChatUser = httpHost + "chat/chat_user"; //post
}

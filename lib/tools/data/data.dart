import 'package:client/config/keys.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:client/tools/data/store.dart';
export 'package:client/tools/data/store.dart';
export 'package:client/tools/data/notice.dart';

class UcActions {
  static String msg() => 'msg';

  static String groupName() => 'groupName';

  static String voiceImg() => 'voiceImg';

  static String user() => 'user';

  //--- beging
  static String recentList() => 'recentList';

  static String chatUser() => 'chatUser';
  static String logout() => 'logout';
  static String newMsg() => 'newMsg';
}

class Data {
  static String msg() => Store(UcActions.msg()).value = '';

  static String user() => Store(UcActions.user()).value = '';

  static String voiceImg() => Store(UcActions.voiceImg()).value = '';

  static initData() {
    ImDb.g();
    getStoreValue(Keys.account).then((data) {
      Store(UcActions.user()).value = data;
    });
  }
}

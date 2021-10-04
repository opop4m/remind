import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';

class ImGroupData {
  void onCreateGroup(TopicBean tb, data) {
    var group = Group.fromJson(data["group"]);
    ImDb.g().db.groupDao.insertGroup(group.toCompanion(true));
  }
}

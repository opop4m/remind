import 'package:client/provider/global_cache.dart';
import 'package:client/provider/model/chatBean.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/provider/service/im.dart';
import 'package:client/provider/service/imData.dart';
import 'package:client/provider/service/imDb.dart';

class ImGroupData {
  void onCreateGroup(TopicBean tb, data) {
    var group = Group.fromJson(data["group"]);
    ImDb.g().db.groupDao.insertGroup(group.toCompanion(true));
    var my = Global.get().curUser;
    if (my.id != group.uid) {
      SyncChatPage chat = SyncChatPage(group.id, typeGroup, 0);
      SyncChat chatReq = SyncChat();
      chatReq.chatList.add(chat);
      Im.get().requestSystem(actSyncChat, chatReq.toJson());
    }
  }

  void onAllGroupMem(TopicBean tb, res) async {
    String groupId = tb.msgId;
    await ImDb.g().db.groupMemberDao.delGroup(groupId);
    List list = res;
    list.forEach((json) {
      var mem = GroupMember.fromJson(json);
      ImDb.g().db.groupMemberDao.insertGroupMember(mem.toCompanion(true));
    });
  }

  void onQuitGroup(String groupId) {
    ImDb.g().db.groupDao.delGroup(groupId);
    ImDb.g().db.groupMemberDao.delGroup(groupId);
    ImDb.g().db.popsDao.delPop(groupId, typeGroup);
    ImDb.g().db.chatRecentDao.delRecent(groupId, typeGroup);
    ImDb.g().db.chatMsgDao.delGroupMsgList(groupId);
  }

  Future onGroupUpdate(TopicBean tb, res) {
    var group = Group.fromJson(res);
    return ImDb.g().db.groupDao.insertGroup(group.toCompanion(true));
  }

  Future<GroupMember> onGroupMem(TopicBean tb, res) async {
    var mem = GroupMember.fromJson(res);
    // ImDb.g().db.groupMemberDao
    return mem;
  }

  static Future<Map<String, ChatUser>> getMembersUser(String groupId) async {
    List<GroupMember> list =
        await ImDb.g().db.groupMemberDao.queryGroupMember(groupId);
    List<String> uids = [];
    list.forEach((mem) {
      uids.add(mem.uid);
    });
    return await ImData.get().getSyncChatUsers(uids);
  }
}

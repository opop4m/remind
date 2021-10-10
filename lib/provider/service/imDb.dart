import 'package:client/provider/model/chatDb.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:client/tools/library.dart';
import 'package:moor/moor.dart';
import 'package:client/tools/adapter/moor.dart'
    if (dart.library.js) 'package:client/tools/adapter/moor_web.dart';

part 'imDb.g.dart';

class ImDb {
  static ImDb? _instance;

  factory ImDb.g() => _getInstance();
  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = ImDb._internal();
    }
    return _instance;
  }

  UcDatabase? _db;
  ImDb._internal() {}

  void init(String account) async {
    print("init db account: $account");
    if (_db != null) {
      await _db!.close();
    }
    _db = UcDatabase(account);
  }

  // UcDatabase getDb() => _db;
  UcDatabase get db => _db!;
}

@UseMoor(tables: [
  ChatRecents,
  ChatUsers,
  ChatMsgs,
  Friends,
  Pops,
  FriendReqeusts,
  Groups,
  GroupMembers,
], daos: [
  ChatMsgDao,
  ChatRecentDao,
  ChatUserDao,
  FriendDao,
  PopsDao,
  FriendReqeustsDao,
  GroupDao,
  GroupMemberDao,
])
class UcDatabase extends _$UcDatabase {
  // we tell the database where to store the data with this constructor
  UcDatabase(String account)
      // : super(FlutterQueryExecutor.inDatabaseFolder(
      //       path: "db.sqlite", logStatements: true));
      : super(getMoorDataBase(account));

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            // we added the dueDate property in the change from version 1
            await m.addColumn(chatUsers, chatUsers.gender);
          }
        },
      );
}

@UseDao(tables: [Friends])
class FriendDao extends DatabaseAccessor<UcDatabase> with _$FriendDaoMixin {
  FriendDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Stream<List<Friend>> getAllFriend() => select(friends).watch();
  Stream<List<Friend>> watchFriendList(List<String> exceptIds) {
    var q = select(friends);
    q.where((tbl) => tbl.id.isIn(exceptIds).not());
    return q.watch();
  }

  Future insertFriend(FriendsCompanion f) =>
      into(friends).insertOnConflictUpdate(f);

  Future<int> updateReadTime(String fUid, int readTime) {
    var q = update(friends);
    q.where((tbl) => tbl.id.equals(fUid));
    return q.write(FriendsCompanion(readTime: Value(readTime)));
  }

  Future<Friend?> queryFriend(String fUid) {
    var q = select(friends)..where((tbl) => tbl.id.equals(fUid));
    return q.getSingleOrNull();
  }

  Future deleteFriend(String fUid) {
    var q = delete(friends);
    q.where((tbl) => tbl.id.equals(fUid));
    return q.go();
  }
}

@UseDao(tables: [ChatRecents])
class ChatRecentDao extends DatabaseAccessor<UcDatabase>
    with _$ChatRecentDaoMixin {
  ChatRecentDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Future<List<ChatRecent>> getRecentList(int limit, int offset) {
    var q = select(chatRecents)
      ..orderBy([
        (msg) =>
            OrderingTerm(expression: msg.createTime, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: offset);
    return q.get();
  }

  Stream<List<ChatRecent>> watchRecentList(int limit, int offset) {
    var q = select(chatRecents)
      ..orderBy([
        (msg) =>
            OrderingTerm(expression: msg.createTime, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: offset);
    return q.watch();
  }

  Future refresh() {
    Completer completer = Completer();
    select(chatRecents)
      ..limit(1)
      ..getSingleOrNull().then((q) {
        if (q != null) {
          insertChat(q.toCompanion(true));
        }
        completer.complete();
      }).catchError((onError) {
        completer.complete();
      });
    return completer.future;
  }

  Future insertChat(ChatRecentsCompanion chat) async {
    var q = select(chatRecents);
    if (chat.type.value == typePerson) {
      q.where((tbl) =>
          tbl.type.equals(typePerson) &
          ((tbl.fromId.equals(chat.fromId.value) &
                  tbl.peerId.equals(chat.peerId.value)) |
              (tbl.fromId.equals(chat.peerId.value) &
                  tbl.peerId.equals(chat.fromId.value))));
    } else {
      q.where((tbl) =>
          tbl.type.equals(typeGroup) &
          tbl.targetId.equals(chat.targetId.value));
    }
    var query = await q.getSingleOrNull();
    int ret;
    if (query != null) {
      var up = update(chatRecents);
      up.whereExpr = q.whereExpr;
      ret = await up.write(chat);
    } else {
      ret = await into(chatRecents).insert(chat);
    }
    return ret;
    // return into(chatRecents).insertOnConflictUpdate(chat);
  }

  Future delRecent(String targetId, int type) {
    var q = delete(chatRecents);
    if (type == typeGroup) {
      q.where((tbl) => tbl.targetId.equals(targetId) & tbl.type.equals(type));
    } else {
      String fromId = Global.get().curUser.id;
      q.where((tbl) =>
          tbl.type.equals(typePerson) &
          ((tbl.fromId.equals(fromId) & tbl.peerId.equals(targetId)) |
              (tbl.fromId.equals(targetId) & tbl.peerId.equals(fromId))));
    }

    return q.go();
  }

  Future delAll() => delete(chatRecents).go();
}

@UseDao(tables: [ChatMsgs])
class ChatMsgDao extends DatabaseAccessor<UcDatabase> with _$ChatMsgDaoMixin {
  ChatMsgDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Stream<List<ChatMsg>> getGroupMsgList(String peerId, int limit, int offset) {
    var myId = Global.get().curUser.id;
    var q = select(chatMsgs)
      ..where((tbl) {
        return tbl.peerId.equals(peerId) & tbl.type.equals(typeGroup);
      })
      ..orderBy([
        (msg) =>
            OrderingTerm(expression: msg.createTime, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: offset);
    return q.watch();
  }

  Stream<List<ChatMsg>> getP2PMsgList(String peerId, int limit, int offset) {
    var myId = Global.get().curUser.id;
    var q = select(chatMsgs)
      ..where((tbl) {
        return (tbl.peerId.equals(peerId) & tbl.fromId.equals(myId) |
                tbl.fromId.equals(peerId) & tbl.peerId.equals(myId)) &
            tbl.type.equals(typePerson);
      })
      ..orderBy([
        (msg) =>
            OrderingTerm(expression: msg.createTime, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: offset);
    return q.watch();
  }

  Future delGroupMsgList(String peerId) {
    var q = delete(chatMsgs);
    q.where((tbl) => tbl.peerId.equals(peerId) & tbl.type.equals(typeGroup));
    return q.go();
  }

  Future delP2PMsgList(String peerId) {
    var myId = Global.get().curUser.id;
    var q = delete(chatMsgs);
    q.where((tbl) =>
        (tbl.peerId.equals(peerId) & tbl.fromId.equals(myId) |
            tbl.fromId.equals(peerId) & tbl.peerId.equals(myId)) &
        tbl.type.equals(typePerson));
    return q.go();
  }

  Future<List<ChatMsg>> queryMsgList(
      String peerId, int type, int limit, int offset) {
    var q = select(chatMsgs)
      ..where((tbl) {
        return (tbl.peerId.equals(peerId) |
            tbl.fromId.equals(peerId) & tbl.type.equals(type));
      })
      ..orderBy([
        (msg) =>
            OrderingTerm(expression: msg.createTime, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: offset);
    return q.get();
  }

  Future insertChatMsgData(ChatMsgsCompanion msg) =>
      into(chatMsgs).insertOnConflictUpdate(msg);

  Future<ChatMsg?> getMsgById(String msgId) {
    var q = select(chatMsgs)..where((tbl) => tbl.msgId.equals(msgId));
    return q.getSingleOrNull();
  }

  Future updateReaded(String peerId, int readTime) {
    var q = update(chatMsgs);
    q.where((tbl) =>
        tbl.peerId.equals(peerId) &
        tbl.type.equals(typePerson) &
        tbl.createTime.isSmallerOrEqualValue(readTime) &
        tbl.status.equals(msgStateReaded).not());

    return q.write(ChatMsgsCompanion(
      status: Value(msgStateReaded),
    ));
  }

  Future updateArrived(String msgId) {
    var q = update(chatMsgs);
    q.where((tbl) =>
        tbl.msgId.equals(msgId) &
        tbl.type.equals(typePerson) &
        tbl.status.isSmallerOrEqualValue(msgStateArrived));
    return q.write(ChatMsgsCompanion(
      status: Value(msgStateArrived),
    ));
  }
}

@UseDao(tables: [ChatUsers])
class ChatUserDao extends DatabaseAccessor<UcDatabase> with _$ChatUserDaoMixin {
  ChatUserDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Future<List<ChatUser>> getChatUsers(List<String> uids) {
    final q = select(chatUsers);
    q.where((tbl) => tbl.id.isIn(uids));
    return q.get();
  }

  Future<List<ChatUser>> getAllChatUsers() {
    final q = select(chatUsers);
    return q.get();
  }

  Stream<List<ChatUser>> watchAllChatUsers() {
    final q = select(chatUsers);
    return q.watch();
  }

  Future insertChatUser(ChatUsersCompanion user) =>
      into(chatUsers).insertOnConflictUpdate(user);
}

@UseDao(tables: [Pops])
class PopsDao extends DatabaseAccessor<UcDatabase> with _$PopsDaoMixin {
  PopsDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Future insertPop(PopsCompanion pop) => into(pops).insertOnConflictUpdate(pop);

  Stream<List<Pop>> queryAll() => select(pops).watch();

  Future delAll() => delete(pops).go();

  Future delPop(String targetId, int type) {
    var q = delete(pops);
    q.where((tbl) => tbl.targetId.equals(targetId) & tbl.type.equals(type));
    return q.go();
  }

  Stream<int?> queryFriendPopSum() {
    var q = selectOnly(pops);
    var sum = pops.count.sum();
    q.addColumns([sum]);
    q.where(pops.type.equals(PopTypeNewFriend));
    return q.map((row) => row.read(sum)).watchSingle();
  }

  Stream<int?> queryChatPopSum() {
    var q = selectOnly(pops);
    var sum = pops.count.sum();
    q.addColumns([sum]);
    q.where(pops.type.equals(PopTypeGroup) | pops.type.equals(PopTypeP2P));
    return q.map((row) => row.read(sum)).watchSingle();
  }
}

@UseDao(tables: [FriendReqeusts])
class FriendReqeustsDao extends DatabaseAccessor<UcDatabase>
    with _$FriendReqeustsDaoMixin {
  FriendReqeustsDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Future insertFriendRequest(FriendReqeustsCompanion fr) =>
      into(friendReqeusts).insertOnConflictUpdate(fr);

  Stream<List<FriendReqeust>> queryAll() {
    var q = select(friendReqeusts);
    q.orderBy([
      (tb) => OrderingTerm(expression: tb.updateTime, mode: OrderingMode.desc),
    ]);
    return q.watch();
  }

  Future delAll() => delete(friendReqeusts).go();

  Future updateStatus(String requestUid, int status) {
    var q = update(friendReqeusts);
    q.where((tbl) => tbl.requestUid.equals(requestUid));
    return q.write(FriendReqeustsCompanion(
      status: Value(status),
    ));
  }
}

@UseDao(tables: [Groups])
class GroupDao extends DatabaseAccessor<UcDatabase> with _$GroupDaoMixin {
  GroupDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Future insertGroup(GroupsCompanion group) =>
      into(groups).insertOnConflictUpdate(group);

  Future delGroup(String groupId) {
    var q = delete(groups);
    q.where((tbl) => tbl.id.equals(groupId));
    return q.go();
  }

  Future<Group?> getGroup(String groupId) {
    var q = select(groups);
    q.where((tbl) => tbl.id.equals(groupId));
    return q.getSingleOrNull();
  }

  Future<List<Group>> queryAllGroup() => select(groups).get();
  Stream<List<Group>> watchAllGroup() => select(groups).watch();
}

@UseDao(tables: [GroupMembers])
class GroupMemberDao extends DatabaseAccessor<UcDatabase>
    with _$GroupMemberDaoMixin {
  GroupMemberDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Future insertGroupMember(GroupMembersCompanion mem) =>
      into(groupMembers).insertOnConflictUpdate(mem);

  Future<List<GroupMember>> queryGroupMember(String groupId) {
    var q = select(groupMembers);
    q.where((tbl) => tbl.groupId.equals(groupId));
    return q.get();
  }

  Stream<List<GroupMember>> watchGroupMember(String groupId) {
    var q = select(groupMembers);
    q.where((tbl) => tbl.groupId.equals(groupId));
    return q.watch();
  }

  Future delGroup(String groupId) {
    var q = delete(groupMembers);
    q.where((tbl) => tbl.groupId.equals(groupId));
    return q.go();
  }

  Future delGroupMember(String id) {
    var q = delete(groupMembers);
    q.where((tbl) => tbl.id.equals(id));
    return q.go();
  }
}

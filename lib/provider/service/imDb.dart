import 'package:client/provider/model/chatDb.dart';
import 'package:client/provider/model/msgEnum.dart';
import 'package:moor/moor.dart';
import 'package:client/tools/adapter/moor.dart'
    if (dart.library.js) 'package:client/tools/adapter/moor_web.dart';

part 'imDb.g.dart';

Map<String, UcDatabase> _cache = Map();

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

  void init(String account) {
    if (_cache[account] != null) {
      _db = _cache[account];
      return;
    }
    _db = UcDatabase(account);
    _cache[account] = _db!;
  }

  // UcDatabase getDb() => _db;
  UcDatabase get db => _db!;
}

@UseMoor(
    tables: [ChatRecents, ChatUsers, ChatMsgs, Friends, Pops],
    daos: [ChatMsgDao, ChatRecentDao, ChatUserDao, FriendDao, PopsDao])
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

  Future insertFriend(FriendsCompanion f) =>
      into(friends).insertOnConflictUpdate(f);

  Future<int> updateReadTime(String fUid, int readTime) {
    var q = update(friends);
    q.where((tbl) => tbl.id.equals(fUid));
    return q.write(FriendsCompanion(readTime: Value(readTime)));
  }

  Future<Friend> queryFriend(String fUid) {
    var q = select(friends)..where((tbl) => tbl.id.equals(fUid));
    return q.getSingle();
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

  Future insertChat(ChatRecentsCompanion chat) {
    return into(chatRecents).insertOnConflictUpdate(chat);
  }

  Future delAll() => delete(chatRecents).go();
}

@UseDao(tables: [ChatMsgs])
class ChatMsgDao extends DatabaseAccessor<UcDatabase> with _$ChatMsgDaoMixin {
  ChatMsgDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Stream<List<ChatMsg>> getMsgList(
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
    return q.watch();
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

  Future<List<ChatUser>> getAllChatUsers(List<String> uids) {
    final q = select(chatUsers);
    // q.where((tbl) => tbl.id.isIn(uids));
    return q.get();
  }

  Future insertChatUser(ChatUsersCompanion user) =>
      into(chatUsers).insertOnConflictUpdate(user);
}

@UseDao(tables: [Pops])
class PopsDao extends DatabaseAccessor<UcDatabase> with _$PopsDaoMixin {
  PopsDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Future insertPop(PopsCompanion pop) => into(pops).insertOnConflictUpdate(pop);

  Future<List<Pop>> queryAll() => select(pops).get();

  Future delAll() => delete(pops).go();

  Future delPop(String targetId, int type) {
    var q = delete(pops);
    q.where((tbl) => tbl.targetId.equals(targetId) & tbl.type.equals(type));
    return q.go();
  }

  Stream<int?> queryChatPopSum() {
    var q = selectOnly(pops);
    var sum = pops.count.sum();
    q.addColumns([sum]);
    q.where(pops.type.equals(PopTypeGroup) | pops.type.equals(PopTypeP2P));
    return q.map((row) => row.read(sum)).watchSingle();
  }
}

import 'package:client/provider/model/chatDb.dart';
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
    tables: [ChatRecents, ChatUsers, ChatMsgs, Friends],
    daos: [ChatMsgDao, ChatRecentDao, ChatUserDao, FriendDao])
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

  Future<List<Friend>> getAllFriend() => select(friends).get();

  Future insertFriend(FriendsCompanion f) =>
      into(friends).insertOnConflictUpdate(f);
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

  Future<List<ChatMsg>> getMsgList(
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

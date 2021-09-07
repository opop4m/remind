import 'package:client/provider/model/chatDb.dart';
import 'package:moor/moor.dart';
import 'package:client/tools/utils/moor.dart'
    if (dart.library.js) 'package:client/tools/utils/moor_web.dart';

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

  late UcDatabase _db;
  ImDb._internal() {
    _db = new UcDatabase();
  }

  // UcDatabase getDb() => _db;
  UcDatabase get db => _db;
}

@UseMoor(
    tables: [ChatRecents, ChatUsers, ChatMsgs],
    daos: [ChatMsgDao, ChatRecentDao, ChatUserDao])
class UcDatabase extends _$UcDatabase {
  // we tell the database where to store the data with this constructor
  UcDatabase()
      // : super(FlutterQueryExecutor.inDatabaseFolder(
      //       path: "db.sqlite", logStatements: true));
      : super(getMoorDataBase());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [ChatRecents])
class ChatRecentDao extends DatabaseAccessor<UcDatabase>
    with _$ChatRecentDaoMixin {
  ChatRecentDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Future<List<ChatRecent>> getRecentList(int limit, int offset) {
    var q = select(chatRecents)
      // ..where((tbl) => tbl.type.equals(type))
      // ..where((tbl) => tbl.peerId.equals(peerId))
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
}

@UseDao(tables: [ChatMsgs])
class ChatMsgDao extends DatabaseAccessor<UcDatabase> with _$ChatMsgDaoMixin {
  ChatMsgDao(UcDatabase attachedDatabase) : super(attachedDatabase);

  Future<List<ChatMsg>> getMsgList(
      String peerId, int type, int limit, int offset) {
    var q = select(chatMsgs)
      ..where((tbl) => tbl.type.equals(type))
      ..where((tbl) => tbl.peerId.equals(peerId))
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

  Future insertChatUser(ChatUsersCompanion user) =>
      into(chatUsers).insertOnConflictUpdate(user);
}

import 'package:moor/moor.dart';

class ChatRecents extends Table {
  TextColumn get msgId => text()();
  TextColumn get targetId => text()();
  TextColumn get peerId => text()();
  TextColumn get fromId => text()();
  IntColumn get type => integer().withDefault(const Constant(0))();
  IntColumn get msgType => integer().withDefault(const Constant(0))();
  IntColumn get tipsType =>
      integer().nullable().withDefault(const Constant(0))();
  TextColumn get content => text().nullable()();
  IntColumn get createTime => integer().withDefault(const Constant(0))();
  TextColumn get ext => text().nullable()();

  @override
  Set<Column> get primaryKey => {targetId, type};
}

class ChatMsgs extends Table {
  TextColumn get msgId => text()();
  TextColumn get peerId => text()();
  TextColumn get fromId => text()();
  IntColumn get type => integer().withDefault(const Constant(0))();
  IntColumn get msgType => integer().withDefault(const Constant(0))();
  IntColumn get tipsType =>
      integer().nullable().withDefault(const Constant(0))();
  TextColumn get content => text().nullable()();
  IntColumn get createTime => integer().withDefault(const Constant(0))();
  TextColumn get ext => text().nullable()();
  IntColumn get status => integer().nullable().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {msgId};
}

class ChatUsers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get avatar => text().nullable()();
  IntColumn get gender => integer().nullable().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Friends extends Table {
  TextColumn get id => text()();
  TextColumn get alias => text().nullable()();
  TextColumn get nickname => text()();
  TextColumn get avatar => text().nullable()();
  IntColumn get gender => integer().nullable().withDefault(const Constant(0))();
  TextColumn get nameIndex => text()();
  TextColumn get name => text()();
  IntColumn get readTime =>
      integer().nullable().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Pops extends Table {
  TextColumn get targetId => text()();
  IntColumn get type => integer()();
  IntColumn get count => integer()();

  @override
  Set<Column> get primaryKey => {targetId, type};
}

class FriendReqeusts extends Table {
  TextColumn get requestUid => text()();
  TextColumn get msg => text()();
  IntColumn get status => integer()();
  IntColumn get updateTime => integer()();

  @override
  Set<Column> get primaryKey => {requestUid};
}

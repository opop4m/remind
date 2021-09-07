import 'package:moor/moor.dart';

class ChatRecents extends Table {
  TextColumn get msgId => text()();
  TextColumn get peerId => text()();
  TextColumn get fromId => text()();
  IntColumn get type => integer().withDefault(const Constant(0))();
  IntColumn get msgType => integer().withDefault(const Constant(0))();
  IntColumn get tipsType => integer().withDefault(const Constant(0))();
  TextColumn get content => text()();
  IntColumn get createTime => integer().withDefault(const Constant(0))();
  TextColumn get ext => text().nullable()();

  @override
  Set<Column> get primaryKey => {peerId, type};
}

class ChatMsgs extends Table {
  TextColumn get msgId => text()();
  TextColumn get peerId => text()();
  TextColumn get fromId => text()();
  IntColumn get type => integer().withDefault(const Constant(0))();
  IntColumn get msgType => integer().withDefault(const Constant(0))();
  IntColumn get tipsType => integer().withDefault(const Constant(0))();
  TextColumn get content => text()();
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

  @override
  Set<Column> get primaryKey => {id};
}

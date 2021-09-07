// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imDb.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class ChatRecent extends DataClass implements Insertable<ChatRecent> {
  final String msgId;
  final String peerId;
  final String fromId;
  final int type;
  final int msgType;
  final int tipsType;
  final String content;
  final int createTime;
  final String? ext;
  ChatRecent(
      {required this.msgId,
      required this.peerId,
      required this.fromId,
      required this.type,
      required this.msgType,
      required this.tipsType,
      required this.content,
      required this.createTime,
      this.ext});
  factory ChatRecent.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ChatRecent(
      msgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}msg_id'])!,
      peerId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}peer_id'])!,
      fromId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}from_id'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      msgType: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}msg_type'])!,
      tipsType: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tips_type'])!,
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content'])!,
      createTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}create_time'])!,
      ext: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ext']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['msg_id'] = Variable<String>(msgId);
    map['peer_id'] = Variable<String>(peerId);
    map['from_id'] = Variable<String>(fromId);
    map['type'] = Variable<int>(type);
    map['msg_type'] = Variable<int>(msgType);
    map['tips_type'] = Variable<int>(tipsType);
    map['content'] = Variable<String>(content);
    map['create_time'] = Variable<int>(createTime);
    if (!nullToAbsent || ext != null) {
      map['ext'] = Variable<String?>(ext);
    }
    return map;
  }

  ChatRecentsCompanion toCompanion(bool nullToAbsent) {
    return ChatRecentsCompanion(
      msgId: Value(msgId),
      peerId: Value(peerId),
      fromId: Value(fromId),
      type: Value(type),
      msgType: Value(msgType),
      tipsType: Value(tipsType),
      content: Value(content),
      createTime: Value(createTime),
      ext: ext == null && nullToAbsent ? const Value.absent() : Value(ext),
    );
  }

  factory ChatRecent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ChatRecent(
      msgId: serializer.fromJson<String>(json['msgId']),
      peerId: serializer.fromJson<String>(json['peerId']),
      fromId: serializer.fromJson<String>(json['fromId']),
      type: serializer.fromJson<int>(json['type']),
      msgType: serializer.fromJson<int>(json['msgType']),
      tipsType: serializer.fromJson<int>(json['tipsType']),
      content: serializer.fromJson<String>(json['content']),
      createTime: serializer.fromJson<int>(json['createTime']),
      ext: serializer.fromJson<String?>(json['ext']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'msgId': serializer.toJson<String>(msgId),
      'peerId': serializer.toJson<String>(peerId),
      'fromId': serializer.toJson<String>(fromId),
      'type': serializer.toJson<int>(type),
      'msgType': serializer.toJson<int>(msgType),
      'tipsType': serializer.toJson<int>(tipsType),
      'content': serializer.toJson<String>(content),
      'createTime': serializer.toJson<int>(createTime),
      'ext': serializer.toJson<String?>(ext),
    };
  }

  ChatRecent copyWith(
          {String? msgId,
          String? peerId,
          String? fromId,
          int? type,
          int? msgType,
          int? tipsType,
          String? content,
          int? createTime,
          String? ext}) =>
      ChatRecent(
        msgId: msgId ?? this.msgId,
        peerId: peerId ?? this.peerId,
        fromId: fromId ?? this.fromId,
        type: type ?? this.type,
        msgType: msgType ?? this.msgType,
        tipsType: tipsType ?? this.tipsType,
        content: content ?? this.content,
        createTime: createTime ?? this.createTime,
        ext: ext ?? this.ext,
      );
  @override
  String toString() {
    return (StringBuffer('ChatRecent(')
          ..write('msgId: $msgId, ')
          ..write('peerId: $peerId, ')
          ..write('fromId: $fromId, ')
          ..write('type: $type, ')
          ..write('msgType: $msgType, ')
          ..write('tipsType: $tipsType, ')
          ..write('content: $content, ')
          ..write('createTime: $createTime, ')
          ..write('ext: $ext')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      msgId.hashCode,
      $mrjc(
          peerId.hashCode,
          $mrjc(
              fromId.hashCode,
              $mrjc(
                  type.hashCode,
                  $mrjc(
                      msgType.hashCode,
                      $mrjc(
                          tipsType.hashCode,
                          $mrjc(content.hashCode,
                              $mrjc(createTime.hashCode, ext.hashCode)))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatRecent &&
          other.msgId == this.msgId &&
          other.peerId == this.peerId &&
          other.fromId == this.fromId &&
          other.type == this.type &&
          other.msgType == this.msgType &&
          other.tipsType == this.tipsType &&
          other.content == this.content &&
          other.createTime == this.createTime &&
          other.ext == this.ext);
}

class ChatRecentsCompanion extends UpdateCompanion<ChatRecent> {
  final Value<String> msgId;
  final Value<String> peerId;
  final Value<String> fromId;
  final Value<int> type;
  final Value<int> msgType;
  final Value<int> tipsType;
  final Value<String> content;
  final Value<int> createTime;
  final Value<String?> ext;
  const ChatRecentsCompanion({
    this.msgId = const Value.absent(),
    this.peerId = const Value.absent(),
    this.fromId = const Value.absent(),
    this.type = const Value.absent(),
    this.msgType = const Value.absent(),
    this.tipsType = const Value.absent(),
    this.content = const Value.absent(),
    this.createTime = const Value.absent(),
    this.ext = const Value.absent(),
  });
  ChatRecentsCompanion.insert({
    required String msgId,
    required String peerId,
    required String fromId,
    this.type = const Value.absent(),
    this.msgType = const Value.absent(),
    this.tipsType = const Value.absent(),
    required String content,
    this.createTime = const Value.absent(),
    this.ext = const Value.absent(),
  })  : msgId = Value(msgId),
        peerId = Value(peerId),
        fromId = Value(fromId),
        content = Value(content);
  static Insertable<ChatRecent> custom({
    Expression<String>? msgId,
    Expression<String>? peerId,
    Expression<String>? fromId,
    Expression<int>? type,
    Expression<int>? msgType,
    Expression<int>? tipsType,
    Expression<String>? content,
    Expression<int>? createTime,
    Expression<String?>? ext,
  }) {
    return RawValuesInsertable({
      if (msgId != null) 'msg_id': msgId,
      if (peerId != null) 'peer_id': peerId,
      if (fromId != null) 'from_id': fromId,
      if (type != null) 'type': type,
      if (msgType != null) 'msg_type': msgType,
      if (tipsType != null) 'tips_type': tipsType,
      if (content != null) 'content': content,
      if (createTime != null) 'create_time': createTime,
      if (ext != null) 'ext': ext,
    });
  }

  ChatRecentsCompanion copyWith(
      {Value<String>? msgId,
      Value<String>? peerId,
      Value<String>? fromId,
      Value<int>? type,
      Value<int>? msgType,
      Value<int>? tipsType,
      Value<String>? content,
      Value<int>? createTime,
      Value<String?>? ext}) {
    return ChatRecentsCompanion(
      msgId: msgId ?? this.msgId,
      peerId: peerId ?? this.peerId,
      fromId: fromId ?? this.fromId,
      type: type ?? this.type,
      msgType: msgType ?? this.msgType,
      tipsType: tipsType ?? this.tipsType,
      content: content ?? this.content,
      createTime: createTime ?? this.createTime,
      ext: ext ?? this.ext,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (msgId.present) {
      map['msg_id'] = Variable<String>(msgId.value);
    }
    if (peerId.present) {
      map['peer_id'] = Variable<String>(peerId.value);
    }
    if (fromId.present) {
      map['from_id'] = Variable<String>(fromId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (msgType.present) {
      map['msg_type'] = Variable<int>(msgType.value);
    }
    if (tipsType.present) {
      map['tips_type'] = Variable<int>(tipsType.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<int>(createTime.value);
    }
    if (ext.present) {
      map['ext'] = Variable<String?>(ext.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatRecentsCompanion(')
          ..write('msgId: $msgId, ')
          ..write('peerId: $peerId, ')
          ..write('fromId: $fromId, ')
          ..write('type: $type, ')
          ..write('msgType: $msgType, ')
          ..write('tipsType: $tipsType, ')
          ..write('content: $content, ')
          ..write('createTime: $createTime, ')
          ..write('ext: $ext')
          ..write(')'))
        .toString();
  }
}

class $ChatRecentsTable extends ChatRecents
    with TableInfo<$ChatRecentsTable, ChatRecent> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ChatRecentsTable(this._db, [this._alias]);
  final VerificationMeta _msgIdMeta = const VerificationMeta('msgId');
  late final GeneratedColumn<String?> msgId = GeneratedColumn<String?>(
      'msg_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _peerIdMeta = const VerificationMeta('peerId');
  late final GeneratedColumn<String?> peerId = GeneratedColumn<String?>(
      'peer_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _fromIdMeta = const VerificationMeta('fromId');
  late final GeneratedColumn<String?> fromId = GeneratedColumn<String?>(
      'from_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _msgTypeMeta = const VerificationMeta('msgType');
  late final GeneratedColumn<int?> msgType = GeneratedColumn<int?>(
      'msg_type', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _tipsTypeMeta = const VerificationMeta('tipsType');
  late final GeneratedColumn<int?> tipsType = GeneratedColumn<int?>(
      'tips_type', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  late final GeneratedColumn<String?> content = GeneratedColumn<String?>(
      'content', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _createTimeMeta = const VerificationMeta('createTime');
  late final GeneratedColumn<int?> createTime = GeneratedColumn<int?>(
      'create_time', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _extMeta = const VerificationMeta('ext');
  late final GeneratedColumn<String?> ext = GeneratedColumn<String?>(
      'ext', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        msgId,
        peerId,
        fromId,
        type,
        msgType,
        tipsType,
        content,
        createTime,
        ext
      ];
  @override
  String get aliasedName => _alias ?? 'chat_recents';
  @override
  String get actualTableName => 'chat_recents';
  @override
  VerificationContext validateIntegrity(Insertable<ChatRecent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('msg_id')) {
      context.handle(
          _msgIdMeta, msgId.isAcceptableOrUnknown(data['msg_id']!, _msgIdMeta));
    } else if (isInserting) {
      context.missing(_msgIdMeta);
    }
    if (data.containsKey('peer_id')) {
      context.handle(_peerIdMeta,
          peerId.isAcceptableOrUnknown(data['peer_id']!, _peerIdMeta));
    } else if (isInserting) {
      context.missing(_peerIdMeta);
    }
    if (data.containsKey('from_id')) {
      context.handle(_fromIdMeta,
          fromId.isAcceptableOrUnknown(data['from_id']!, _fromIdMeta));
    } else if (isInserting) {
      context.missing(_fromIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('msg_type')) {
      context.handle(_msgTypeMeta,
          msgType.isAcceptableOrUnknown(data['msg_type']!, _msgTypeMeta));
    }
    if (data.containsKey('tips_type')) {
      context.handle(_tipsTypeMeta,
          tipsType.isAcceptableOrUnknown(data['tips_type']!, _tipsTypeMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    }
    if (data.containsKey('ext')) {
      context.handle(
          _extMeta, ext.isAcceptableOrUnknown(data['ext']!, _extMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {peerId, type};
  @override
  ChatRecent map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ChatRecent.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChatRecentsTable createAlias(String alias) {
    return $ChatRecentsTable(_db, alias);
  }
}

class ChatUser extends DataClass implements Insertable<ChatUser> {
  final String id;
  final String name;
  final String? avatar;
  ChatUser({required this.id, required this.name, this.avatar});
  factory ChatUser.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ChatUser(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      avatar: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}avatar']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String?>(avatar);
    }
    return map;
  }

  ChatUsersCompanion toCompanion(bool nullToAbsent) {
    return ChatUsersCompanion(
      id: Value(id),
      name: Value(name),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
    );
  }

  factory ChatUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ChatUser(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String?>(avatar),
    };
  }

  ChatUser copyWith({String? id, String? name, String? avatar}) => ChatUser(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );
  @override
  String toString() {
    return (StringBuffer('ChatUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, avatar.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatUser &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar);
}

class ChatUsersCompanion extends UpdateCompanion<ChatUser> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> avatar;
  const ChatUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
  });
  ChatUsersCompanion.insert({
    required String id,
    required String name,
    this.avatar = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<ChatUser> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String?>? avatar,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
    });
  }

  ChatUsersCompanion copyWith(
      {Value<String>? id, Value<String>? name, Value<String?>? avatar}) {
    return ChatUsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String?>(avatar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatUsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar')
          ..write(')'))
        .toString();
  }
}

class $ChatUsersTable extends ChatUsers
    with TableInfo<$ChatUsersTable, ChatUser> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ChatUsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  late final GeneratedColumn<String?> avatar = GeneratedColumn<String?>(
      'avatar', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, avatar];
  @override
  String get aliasedName => _alias ?? 'chat_users';
  @override
  String get actualTableName => 'chat_users';
  @override
  VerificationContext validateIntegrity(Insertable<ChatUser> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ChatUser.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChatUsersTable createAlias(String alias) {
    return $ChatUsersTable(_db, alias);
  }
}

class ChatMsg extends DataClass implements Insertable<ChatMsg> {
  final String msgId;
  final String peerId;
  final String fromId;
  final int type;
  final int msgType;
  final int tipsType;
  final String content;
  final int createTime;
  final String? ext;
  final int? status;
  ChatMsg(
      {required this.msgId,
      required this.peerId,
      required this.fromId,
      required this.type,
      required this.msgType,
      required this.tipsType,
      required this.content,
      required this.createTime,
      this.ext,
      this.status});
  factory ChatMsg.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ChatMsg(
      msgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}msg_id'])!,
      peerId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}peer_id'])!,
      fromId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}from_id'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      msgType: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}msg_type'])!,
      tipsType: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tips_type'])!,
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content'])!,
      createTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}create_time'])!,
      ext: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ext']),
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['msg_id'] = Variable<String>(msgId);
    map['peer_id'] = Variable<String>(peerId);
    map['from_id'] = Variable<String>(fromId);
    map['type'] = Variable<int>(type);
    map['msg_type'] = Variable<int>(msgType);
    map['tips_type'] = Variable<int>(tipsType);
    map['content'] = Variable<String>(content);
    map['create_time'] = Variable<int>(createTime);
    if (!nullToAbsent || ext != null) {
      map['ext'] = Variable<String?>(ext);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<int?>(status);
    }
    return map;
  }

  ChatMsgsCompanion toCompanion(bool nullToAbsent) {
    return ChatMsgsCompanion(
      msgId: Value(msgId),
      peerId: Value(peerId),
      fromId: Value(fromId),
      type: Value(type),
      msgType: Value(msgType),
      tipsType: Value(tipsType),
      content: Value(content),
      createTime: Value(createTime),
      ext: ext == null && nullToAbsent ? const Value.absent() : Value(ext),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  factory ChatMsg.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ChatMsg(
      msgId: serializer.fromJson<String>(json['msgId']),
      peerId: serializer.fromJson<String>(json['peerId']),
      fromId: serializer.fromJson<String>(json['fromId']),
      type: serializer.fromJson<int>(json['type']),
      msgType: serializer.fromJson<int>(json['msgType']),
      tipsType: serializer.fromJson<int>(json['tipsType']),
      content: serializer.fromJson<String>(json['content']),
      createTime: serializer.fromJson<int>(json['createTime']),
      ext: serializer.fromJson<String?>(json['ext']),
      status: serializer.fromJson<int?>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'msgId': serializer.toJson<String>(msgId),
      'peerId': serializer.toJson<String>(peerId),
      'fromId': serializer.toJson<String>(fromId),
      'type': serializer.toJson<int>(type),
      'msgType': serializer.toJson<int>(msgType),
      'tipsType': serializer.toJson<int>(tipsType),
      'content': serializer.toJson<String>(content),
      'createTime': serializer.toJson<int>(createTime),
      'ext': serializer.toJson<String?>(ext),
      'status': serializer.toJson<int?>(status),
    };
  }

  ChatMsg copyWith(
          {String? msgId,
          String? peerId,
          String? fromId,
          int? type,
          int? msgType,
          int? tipsType,
          String? content,
          int? createTime,
          String? ext,
          int? status}) =>
      ChatMsg(
        msgId: msgId ?? this.msgId,
        peerId: peerId ?? this.peerId,
        fromId: fromId ?? this.fromId,
        type: type ?? this.type,
        msgType: msgType ?? this.msgType,
        tipsType: tipsType ?? this.tipsType,
        content: content ?? this.content,
        createTime: createTime ?? this.createTime,
        ext: ext ?? this.ext,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('ChatMsg(')
          ..write('msgId: $msgId, ')
          ..write('peerId: $peerId, ')
          ..write('fromId: $fromId, ')
          ..write('type: $type, ')
          ..write('msgType: $msgType, ')
          ..write('tipsType: $tipsType, ')
          ..write('content: $content, ')
          ..write('createTime: $createTime, ')
          ..write('ext: $ext, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      msgId.hashCode,
      $mrjc(
          peerId.hashCode,
          $mrjc(
              fromId.hashCode,
              $mrjc(
                  type.hashCode,
                  $mrjc(
                      msgType.hashCode,
                      $mrjc(
                          tipsType.hashCode,
                          $mrjc(
                              content.hashCode,
                              $mrjc(createTime.hashCode,
                                  $mrjc(ext.hashCode, status.hashCode))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMsg &&
          other.msgId == this.msgId &&
          other.peerId == this.peerId &&
          other.fromId == this.fromId &&
          other.type == this.type &&
          other.msgType == this.msgType &&
          other.tipsType == this.tipsType &&
          other.content == this.content &&
          other.createTime == this.createTime &&
          other.ext == this.ext &&
          other.status == this.status);
}

class ChatMsgsCompanion extends UpdateCompanion<ChatMsg> {
  final Value<String> msgId;
  final Value<String> peerId;
  final Value<String> fromId;
  final Value<int> type;
  final Value<int> msgType;
  final Value<int> tipsType;
  final Value<String> content;
  final Value<int> createTime;
  final Value<String?> ext;
  final Value<int?> status;
  const ChatMsgsCompanion({
    this.msgId = const Value.absent(),
    this.peerId = const Value.absent(),
    this.fromId = const Value.absent(),
    this.type = const Value.absent(),
    this.msgType = const Value.absent(),
    this.tipsType = const Value.absent(),
    this.content = const Value.absent(),
    this.createTime = const Value.absent(),
    this.ext = const Value.absent(),
    this.status = const Value.absent(),
  });
  ChatMsgsCompanion.insert({
    required String msgId,
    required String peerId,
    required String fromId,
    this.type = const Value.absent(),
    this.msgType = const Value.absent(),
    this.tipsType = const Value.absent(),
    required String content,
    this.createTime = const Value.absent(),
    this.ext = const Value.absent(),
    this.status = const Value.absent(),
  })  : msgId = Value(msgId),
        peerId = Value(peerId),
        fromId = Value(fromId),
        content = Value(content);
  static Insertable<ChatMsg> custom({
    Expression<String>? msgId,
    Expression<String>? peerId,
    Expression<String>? fromId,
    Expression<int>? type,
    Expression<int>? msgType,
    Expression<int>? tipsType,
    Expression<String>? content,
    Expression<int>? createTime,
    Expression<String?>? ext,
    Expression<int?>? status,
  }) {
    return RawValuesInsertable({
      if (msgId != null) 'msg_id': msgId,
      if (peerId != null) 'peer_id': peerId,
      if (fromId != null) 'from_id': fromId,
      if (type != null) 'type': type,
      if (msgType != null) 'msg_type': msgType,
      if (tipsType != null) 'tips_type': tipsType,
      if (content != null) 'content': content,
      if (createTime != null) 'create_time': createTime,
      if (ext != null) 'ext': ext,
      if (status != null) 'status': status,
    });
  }

  ChatMsgsCompanion copyWith(
      {Value<String>? msgId,
      Value<String>? peerId,
      Value<String>? fromId,
      Value<int>? type,
      Value<int>? msgType,
      Value<int>? tipsType,
      Value<String>? content,
      Value<int>? createTime,
      Value<String?>? ext,
      Value<int?>? status}) {
    return ChatMsgsCompanion(
      msgId: msgId ?? this.msgId,
      peerId: peerId ?? this.peerId,
      fromId: fromId ?? this.fromId,
      type: type ?? this.type,
      msgType: msgType ?? this.msgType,
      tipsType: tipsType ?? this.tipsType,
      content: content ?? this.content,
      createTime: createTime ?? this.createTime,
      ext: ext ?? this.ext,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (msgId.present) {
      map['msg_id'] = Variable<String>(msgId.value);
    }
    if (peerId.present) {
      map['peer_id'] = Variable<String>(peerId.value);
    }
    if (fromId.present) {
      map['from_id'] = Variable<String>(fromId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (msgType.present) {
      map['msg_type'] = Variable<int>(msgType.value);
    }
    if (tipsType.present) {
      map['tips_type'] = Variable<int>(tipsType.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<int>(createTime.value);
    }
    if (ext.present) {
      map['ext'] = Variable<String?>(ext.value);
    }
    if (status.present) {
      map['status'] = Variable<int?>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMsgsCompanion(')
          ..write('msgId: $msgId, ')
          ..write('peerId: $peerId, ')
          ..write('fromId: $fromId, ')
          ..write('type: $type, ')
          ..write('msgType: $msgType, ')
          ..write('tipsType: $tipsType, ')
          ..write('content: $content, ')
          ..write('createTime: $createTime, ')
          ..write('ext: $ext, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $ChatMsgsTable extends ChatMsgs with TableInfo<$ChatMsgsTable, ChatMsg> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ChatMsgsTable(this._db, [this._alias]);
  final VerificationMeta _msgIdMeta = const VerificationMeta('msgId');
  late final GeneratedColumn<String?> msgId = GeneratedColumn<String?>(
      'msg_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _peerIdMeta = const VerificationMeta('peerId');
  late final GeneratedColumn<String?> peerId = GeneratedColumn<String?>(
      'peer_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _fromIdMeta = const VerificationMeta('fromId');
  late final GeneratedColumn<String?> fromId = GeneratedColumn<String?>(
      'from_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _msgTypeMeta = const VerificationMeta('msgType');
  late final GeneratedColumn<int?> msgType = GeneratedColumn<int?>(
      'msg_type', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _tipsTypeMeta = const VerificationMeta('tipsType');
  late final GeneratedColumn<int?> tipsType = GeneratedColumn<int?>(
      'tips_type', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  late final GeneratedColumn<String?> content = GeneratedColumn<String?>(
      'content', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _createTimeMeta = const VerificationMeta('createTime');
  late final GeneratedColumn<int?> createTime = GeneratedColumn<int?>(
      'create_time', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _extMeta = const VerificationMeta('ext');
  late final GeneratedColumn<String?> ext = GeneratedColumn<String?>(
      'ext', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        msgId,
        peerId,
        fromId,
        type,
        msgType,
        tipsType,
        content,
        createTime,
        ext,
        status
      ];
  @override
  String get aliasedName => _alias ?? 'chat_msgs';
  @override
  String get actualTableName => 'chat_msgs';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMsg> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('msg_id')) {
      context.handle(
          _msgIdMeta, msgId.isAcceptableOrUnknown(data['msg_id']!, _msgIdMeta));
    } else if (isInserting) {
      context.missing(_msgIdMeta);
    }
    if (data.containsKey('peer_id')) {
      context.handle(_peerIdMeta,
          peerId.isAcceptableOrUnknown(data['peer_id']!, _peerIdMeta));
    } else if (isInserting) {
      context.missing(_peerIdMeta);
    }
    if (data.containsKey('from_id')) {
      context.handle(_fromIdMeta,
          fromId.isAcceptableOrUnknown(data['from_id']!, _fromIdMeta));
    } else if (isInserting) {
      context.missing(_fromIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('msg_type')) {
      context.handle(_msgTypeMeta,
          msgType.isAcceptableOrUnknown(data['msg_type']!, _msgTypeMeta));
    }
    if (data.containsKey('tips_type')) {
      context.handle(_tipsTypeMeta,
          tipsType.isAcceptableOrUnknown(data['tips_type']!, _tipsTypeMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    }
    if (data.containsKey('ext')) {
      context.handle(
          _extMeta, ext.isAcceptableOrUnknown(data['ext']!, _extMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {msgId};
  @override
  ChatMsg map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ChatMsg.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ChatMsgsTable createAlias(String alias) {
    return $ChatMsgsTable(_db, alias);
  }
}

abstract class _$UcDatabase extends GeneratedDatabase {
  _$UcDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ChatRecentsTable chatRecents = $ChatRecentsTable(this);
  late final $ChatUsersTable chatUsers = $ChatUsersTable(this);
  late final $ChatMsgsTable chatMsgs = $ChatMsgsTable(this);
  late final ChatMsgDao chatMsgDao = ChatMsgDao(this as UcDatabase);
  late final ChatRecentDao chatRecentDao = ChatRecentDao(this as UcDatabase);
  late final ChatUserDao chatUserDao = ChatUserDao(this as UcDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [chatRecents, chatUsers, chatMsgs];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ChatRecentDaoMixin on DatabaseAccessor<UcDatabase> {
  $ChatRecentsTable get chatRecents => attachedDatabase.chatRecents;
}
mixin _$ChatMsgDaoMixin on DatabaseAccessor<UcDatabase> {
  $ChatMsgsTable get chatMsgs => attachedDatabase.chatMsgs;
}
mixin _$ChatUserDaoMixin on DatabaseAccessor<UcDatabase> {
  $ChatUsersTable get chatUsers => attachedDatabase.chatUsers;
}

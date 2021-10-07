// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imDb.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class ChatRecent extends DataClass implements Insertable<ChatRecent> {
  final String msgId;
  final String targetId;
  final String peerId;
  final String fromId;
  final int type;
  final int msgType;
  final int? tipsType;
  final String? content;
  final int createTime;
  final String? ext;
  ChatRecent(
      {required this.msgId,
      required this.targetId,
      required this.peerId,
      required this.fromId,
      required this.type,
      required this.msgType,
      this.tipsType,
      this.content,
      required this.createTime,
      this.ext});
  factory ChatRecent.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ChatRecent(
      msgId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}msg_id'])!,
      targetId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}target_id'])!,
      peerId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}peer_id'])!,
      fromId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}from_id'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      msgType: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}msg_type'])!,
      tipsType: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tips_type']),
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content']),
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
    map['target_id'] = Variable<String>(targetId);
    map['peer_id'] = Variable<String>(peerId);
    map['from_id'] = Variable<String>(fromId);
    map['type'] = Variable<int>(type);
    map['msg_type'] = Variable<int>(msgType);
    if (!nullToAbsent || tipsType != null) {
      map['tips_type'] = Variable<int?>(tipsType);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String?>(content);
    }
    map['create_time'] = Variable<int>(createTime);
    if (!nullToAbsent || ext != null) {
      map['ext'] = Variable<String?>(ext);
    }
    return map;
  }

  ChatRecentsCompanion toCompanion(bool nullToAbsent) {
    return ChatRecentsCompanion(
      msgId: Value(msgId),
      targetId: Value(targetId),
      peerId: Value(peerId),
      fromId: Value(fromId),
      type: Value(type),
      msgType: Value(msgType),
      tipsType: tipsType == null && nullToAbsent
          ? const Value.absent()
          : Value(tipsType),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      createTime: Value(createTime),
      ext: ext == null && nullToAbsent ? const Value.absent() : Value(ext),
    );
  }

  factory ChatRecent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ChatRecent(
      msgId: serializer.fromJson<String>(json['msgId']),
      targetId: serializer.fromJson<String>(json['targetId']),
      peerId: serializer.fromJson<String>(json['peerId']),
      fromId: serializer.fromJson<String>(json['fromId']),
      type: serializer.fromJson<int>(json['type']),
      msgType: serializer.fromJson<int>(json['msgType']),
      tipsType: serializer.fromJson<int?>(json['tipsType']),
      content: serializer.fromJson<String?>(json['content']),
      createTime: serializer.fromJson<int>(json['createTime']),
      ext: serializer.fromJson<String?>(json['ext']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'msgId': serializer.toJson<String>(msgId),
      'targetId': serializer.toJson<String>(targetId),
      'peerId': serializer.toJson<String>(peerId),
      'fromId': serializer.toJson<String>(fromId),
      'type': serializer.toJson<int>(type),
      'msgType': serializer.toJson<int>(msgType),
      'tipsType': serializer.toJson<int?>(tipsType),
      'content': serializer.toJson<String?>(content),
      'createTime': serializer.toJson<int>(createTime),
      'ext': serializer.toJson<String?>(ext),
    };
  }

  ChatRecent copyWith(
          {String? msgId,
          String? targetId,
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
        targetId: targetId ?? this.targetId,
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
          ..write('targetId: $targetId, ')
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
          targetId.hashCode,
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
                                      ext.hashCode))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatRecent &&
          other.msgId == this.msgId &&
          other.targetId == this.targetId &&
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
  final Value<String> targetId;
  final Value<String> peerId;
  final Value<String> fromId;
  final Value<int> type;
  final Value<int> msgType;
  final Value<int?> tipsType;
  final Value<String?> content;
  final Value<int> createTime;
  final Value<String?> ext;
  const ChatRecentsCompanion({
    this.msgId = const Value.absent(),
    this.targetId = const Value.absent(),
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
    required String targetId,
    required String peerId,
    required String fromId,
    this.type = const Value.absent(),
    this.msgType = const Value.absent(),
    this.tipsType = const Value.absent(),
    this.content = const Value.absent(),
    this.createTime = const Value.absent(),
    this.ext = const Value.absent(),
  })  : msgId = Value(msgId),
        targetId = Value(targetId),
        peerId = Value(peerId),
        fromId = Value(fromId);
  static Insertable<ChatRecent> custom({
    Expression<String>? msgId,
    Expression<String>? targetId,
    Expression<String>? peerId,
    Expression<String>? fromId,
    Expression<int>? type,
    Expression<int>? msgType,
    Expression<int?>? tipsType,
    Expression<String?>? content,
    Expression<int>? createTime,
    Expression<String?>? ext,
  }) {
    return RawValuesInsertable({
      if (msgId != null) 'msg_id': msgId,
      if (targetId != null) 'target_id': targetId,
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
      Value<String>? targetId,
      Value<String>? peerId,
      Value<String>? fromId,
      Value<int>? type,
      Value<int>? msgType,
      Value<int?>? tipsType,
      Value<String?>? content,
      Value<int>? createTime,
      Value<String?>? ext}) {
    return ChatRecentsCompanion(
      msgId: msgId ?? this.msgId,
      targetId: targetId ?? this.targetId,
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
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
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
      map['tips_type'] = Variable<int?>(tipsType.value);
    }
    if (content.present) {
      map['content'] = Variable<String?>(content.value);
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
          ..write('targetId: $targetId, ')
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
  final VerificationMeta _targetIdMeta = const VerificationMeta('targetId');
  late final GeneratedColumn<String?> targetId = GeneratedColumn<String?>(
      'target_id', aliasedName, false,
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
      'tips_type', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  late final GeneratedColumn<String?> content = GeneratedColumn<String?>(
      'content', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
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
        targetId,
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
    if (data.containsKey('target_id')) {
      context.handle(_targetIdMeta,
          targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta));
    } else if (isInserting) {
      context.missing(_targetIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
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
  final int? gender;
  ChatUser({required this.id, required this.name, this.avatar, this.gender});
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
      gender: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gender']),
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
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<int?>(gender);
    }
    return map;
  }

  ChatUsersCompanion toCompanion(bool nullToAbsent) {
    return ChatUsersCompanion(
      id: Value(id),
      name: Value(name),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
    );
  }

  factory ChatUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ChatUser(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      gender: serializer.fromJson<int?>(json['gender']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String?>(avatar),
      'gender': serializer.toJson<int?>(gender),
    };
  }

  ChatUser copyWith({String? id, String? name, String? avatar, int? gender}) =>
      ChatUser(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        gender: gender ?? this.gender,
      );
  @override
  String toString() {
    return (StringBuffer('ChatUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('gender: $gender')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(avatar.hashCode, gender.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatUser &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.gender == this.gender);
}

class ChatUsersCompanion extends UpdateCompanion<ChatUser> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> avatar;
  final Value<int?> gender;
  const ChatUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.gender = const Value.absent(),
  });
  ChatUsersCompanion.insert({
    required String id,
    required String name,
    this.avatar = const Value.absent(),
    this.gender = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<ChatUser> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String?>? avatar,
    Expression<int?>? gender,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (gender != null) 'gender': gender,
    });
  }

  ChatUsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? avatar,
      Value<int?>? gender}) {
    return ChatUsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
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
    if (gender.present) {
      map['gender'] = Variable<int?>(gender.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatUsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('gender: $gender')
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
  final VerificationMeta _genderMeta = const VerificationMeta('gender');
  late final GeneratedColumn<int?> gender = GeneratedColumn<int?>(
      'gender', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, avatar, gender];
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
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
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
  final int? tipsType;
  final String? content;
  final int createTime;
  final String? ext;
  final int? status;
  ChatMsg(
      {required this.msgId,
      required this.peerId,
      required this.fromId,
      required this.type,
      required this.msgType,
      this.tipsType,
      this.content,
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
          .mapFromDatabaseResponse(data['${effectivePrefix}tips_type']),
      content: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}content']),
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
    if (!nullToAbsent || tipsType != null) {
      map['tips_type'] = Variable<int?>(tipsType);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String?>(content);
    }
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
      tipsType: tipsType == null && nullToAbsent
          ? const Value.absent()
          : Value(tipsType),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
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
      tipsType: serializer.fromJson<int?>(json['tipsType']),
      content: serializer.fromJson<String?>(json['content']),
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
      'tipsType': serializer.toJson<int?>(tipsType),
      'content': serializer.toJson<String?>(content),
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
  final Value<int?> tipsType;
  final Value<String?> content;
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
    this.content = const Value.absent(),
    this.createTime = const Value.absent(),
    this.ext = const Value.absent(),
    this.status = const Value.absent(),
  })  : msgId = Value(msgId),
        peerId = Value(peerId),
        fromId = Value(fromId);
  static Insertable<ChatMsg> custom({
    Expression<String>? msgId,
    Expression<String>? peerId,
    Expression<String>? fromId,
    Expression<int>? type,
    Expression<int>? msgType,
    Expression<int?>? tipsType,
    Expression<String?>? content,
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
      Value<int?>? tipsType,
      Value<String?>? content,
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
      map['tips_type'] = Variable<int?>(tipsType.value);
    }
    if (content.present) {
      map['content'] = Variable<String?>(content.value);
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
      'tips_type', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _contentMeta = const VerificationMeta('content');
  late final GeneratedColumn<String?> content = GeneratedColumn<String?>(
      'content', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
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

class Friend extends DataClass implements Insertable<Friend> {
  final String id;
  final String? alias;
  final String nickname;
  final String? avatar;
  final int? gender;
  final String nameIndex;
  final String name;
  final int? readTime;
  Friend(
      {required this.id,
      this.alias,
      required this.nickname,
      this.avatar,
      this.gender,
      required this.nameIndex,
      required this.name,
      this.readTime});
  factory Friend.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Friend(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      alias: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}alias']),
      nickname: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}nickname'])!,
      avatar: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}avatar']),
      gender: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}gender']),
      nameIndex: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name_index'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      readTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}read_time']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String?>(alias);
    }
    map['nickname'] = Variable<String>(nickname);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String?>(avatar);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<int?>(gender);
    }
    map['name_index'] = Variable<String>(nameIndex);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || readTime != null) {
      map['read_time'] = Variable<int?>(readTime);
    }
    return map;
  }

  FriendsCompanion toCompanion(bool nullToAbsent) {
    return FriendsCompanion(
      id: Value(id),
      alias:
          alias == null && nullToAbsent ? const Value.absent() : Value(alias),
      nickname: Value(nickname),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      nameIndex: Value(nameIndex),
      name: Value(name),
      readTime: readTime == null && nullToAbsent
          ? const Value.absent()
          : Value(readTime),
    );
  }

  factory Friend.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Friend(
      id: serializer.fromJson<String>(json['id']),
      alias: serializer.fromJson<String?>(json['alias']),
      nickname: serializer.fromJson<String>(json['nickname']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      gender: serializer.fromJson<int?>(json['gender']),
      nameIndex: serializer.fromJson<String>(json['nameIndex']),
      name: serializer.fromJson<String>(json['name']),
      readTime: serializer.fromJson<int?>(json['readTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'alias': serializer.toJson<String?>(alias),
      'nickname': serializer.toJson<String>(nickname),
      'avatar': serializer.toJson<String?>(avatar),
      'gender': serializer.toJson<int?>(gender),
      'nameIndex': serializer.toJson<String>(nameIndex),
      'name': serializer.toJson<String>(name),
      'readTime': serializer.toJson<int?>(readTime),
    };
  }

  Friend copyWith(
          {String? id,
          String? alias,
          String? nickname,
          String? avatar,
          int? gender,
          String? nameIndex,
          String? name,
          int? readTime}) =>
      Friend(
        id: id ?? this.id,
        alias: alias ?? this.alias,
        nickname: nickname ?? this.nickname,
        avatar: avatar ?? this.avatar,
        gender: gender ?? this.gender,
        nameIndex: nameIndex ?? this.nameIndex,
        name: name ?? this.name,
        readTime: readTime ?? this.readTime,
      );
  @override
  String toString() {
    return (StringBuffer('Friend(')
          ..write('id: $id, ')
          ..write('alias: $alias, ')
          ..write('nickname: $nickname, ')
          ..write('avatar: $avatar, ')
          ..write('gender: $gender, ')
          ..write('nameIndex: $nameIndex, ')
          ..write('name: $name, ')
          ..write('readTime: $readTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          alias.hashCode,
          $mrjc(
              nickname.hashCode,
              $mrjc(
                  avatar.hashCode,
                  $mrjc(
                      gender.hashCode,
                      $mrjc(nameIndex.hashCode,
                          $mrjc(name.hashCode, readTime.hashCode))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Friend &&
          other.id == this.id &&
          other.alias == this.alias &&
          other.nickname == this.nickname &&
          other.avatar == this.avatar &&
          other.gender == this.gender &&
          other.nameIndex == this.nameIndex &&
          other.name == this.name &&
          other.readTime == this.readTime);
}

class FriendsCompanion extends UpdateCompanion<Friend> {
  final Value<String> id;
  final Value<String?> alias;
  final Value<String> nickname;
  final Value<String?> avatar;
  final Value<int?> gender;
  final Value<String> nameIndex;
  final Value<String> name;
  final Value<int?> readTime;
  const FriendsCompanion({
    this.id = const Value.absent(),
    this.alias = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatar = const Value.absent(),
    this.gender = const Value.absent(),
    this.nameIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.readTime = const Value.absent(),
  });
  FriendsCompanion.insert({
    required String id,
    this.alias = const Value.absent(),
    required String nickname,
    this.avatar = const Value.absent(),
    this.gender = const Value.absent(),
    required String nameIndex,
    required String name,
    this.readTime = const Value.absent(),
  })  : id = Value(id),
        nickname = Value(nickname),
        nameIndex = Value(nameIndex),
        name = Value(name);
  static Insertable<Friend> custom({
    Expression<String>? id,
    Expression<String?>? alias,
    Expression<String>? nickname,
    Expression<String?>? avatar,
    Expression<int?>? gender,
    Expression<String>? nameIndex,
    Expression<String>? name,
    Expression<int?>? readTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alias != null) 'alias': alias,
      if (nickname != null) 'nickname': nickname,
      if (avatar != null) 'avatar': avatar,
      if (gender != null) 'gender': gender,
      if (nameIndex != null) 'name_index': nameIndex,
      if (name != null) 'name': name,
      if (readTime != null) 'read_time': readTime,
    });
  }

  FriendsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? alias,
      Value<String>? nickname,
      Value<String?>? avatar,
      Value<int?>? gender,
      Value<String>? nameIndex,
      Value<String>? name,
      Value<int?>? readTime}) {
    return FriendsCompanion(
      id: id ?? this.id,
      alias: alias ?? this.alias,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      nameIndex: nameIndex ?? this.nameIndex,
      name: name ?? this.name,
      readTime: readTime ?? this.readTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String?>(alias.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String?>(avatar.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int?>(gender.value);
    }
    if (nameIndex.present) {
      map['name_index'] = Variable<String>(nameIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (readTime.present) {
      map['read_time'] = Variable<int?>(readTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendsCompanion(')
          ..write('id: $id, ')
          ..write('alias: $alias, ')
          ..write('nickname: $nickname, ')
          ..write('avatar: $avatar, ')
          ..write('gender: $gender, ')
          ..write('nameIndex: $nameIndex, ')
          ..write('name: $name, ')
          ..write('readTime: $readTime')
          ..write(')'))
        .toString();
  }
}

class $FriendsTable extends Friends with TableInfo<$FriendsTable, Friend> {
  final GeneratedDatabase _db;
  final String? _alias;
  $FriendsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _aliasMeta = const VerificationMeta('alias');
  late final GeneratedColumn<String?> alias = GeneratedColumn<String?>(
      'alias', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _nicknameMeta = const VerificationMeta('nickname');
  late final GeneratedColumn<String?> nickname = GeneratedColumn<String?>(
      'nickname', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  late final GeneratedColumn<String?> avatar = GeneratedColumn<String?>(
      'avatar', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _genderMeta = const VerificationMeta('gender');
  late final GeneratedColumn<int?> gender = GeneratedColumn<int?>(
      'gender', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _nameIndexMeta = const VerificationMeta('nameIndex');
  late final GeneratedColumn<String?> nameIndex = GeneratedColumn<String?>(
      'name_index', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _readTimeMeta = const VerificationMeta('readTime');
  late final GeneratedColumn<int?> readTime = GeneratedColumn<int?>(
      'read_time', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, alias, nickname, avatar, gender, nameIndex, name, readTime];
  @override
  String get aliasedName => _alias ?? 'friends';
  @override
  String get actualTableName => 'friends';
  @override
  VerificationContext validateIntegrity(Insertable<Friend> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('name_index')) {
      context.handle(_nameIndexMeta,
          nameIndex.isAcceptableOrUnknown(data['name_index']!, _nameIndexMeta));
    } else if (isInserting) {
      context.missing(_nameIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('read_time')) {
      context.handle(_readTimeMeta,
          readTime.isAcceptableOrUnknown(data['read_time']!, _readTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Friend map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Friend.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FriendsTable createAlias(String alias) {
    return $FriendsTable(_db, alias);
  }
}

class Pop extends DataClass implements Insertable<Pop> {
  final String targetId;
  final int type;
  final int count;
  Pop({required this.targetId, required this.type, required this.count});
  factory Pop.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Pop(
      targetId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}target_id'])!,
      type: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
      count: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}count'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['target_id'] = Variable<String>(targetId);
    map['type'] = Variable<int>(type);
    map['count'] = Variable<int>(count);
    return map;
  }

  PopsCompanion toCompanion(bool nullToAbsent) {
    return PopsCompanion(
      targetId: Value(targetId),
      type: Value(type),
      count: Value(count),
    );
  }

  factory Pop.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Pop(
      targetId: serializer.fromJson<String>(json['targetId']),
      type: serializer.fromJson<int>(json['type']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'targetId': serializer.toJson<String>(targetId),
      'type': serializer.toJson<int>(type),
      'count': serializer.toJson<int>(count),
    };
  }

  Pop copyWith({String? targetId, int? type, int? count}) => Pop(
        targetId: targetId ?? this.targetId,
        type: type ?? this.type,
        count: count ?? this.count,
      );
  @override
  String toString() {
    return (StringBuffer('Pop(')
          ..write('targetId: $targetId, ')
          ..write('type: $type, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(targetId.hashCode, $mrjc(type.hashCode, count.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pop &&
          other.targetId == this.targetId &&
          other.type == this.type &&
          other.count == this.count);
}

class PopsCompanion extends UpdateCompanion<Pop> {
  final Value<String> targetId;
  final Value<int> type;
  final Value<int> count;
  const PopsCompanion({
    this.targetId = const Value.absent(),
    this.type = const Value.absent(),
    this.count = const Value.absent(),
  });
  PopsCompanion.insert({
    required String targetId,
    required int type,
    required int count,
  })  : targetId = Value(targetId),
        type = Value(type),
        count = Value(count);
  static Insertable<Pop> custom({
    Expression<String>? targetId,
    Expression<int>? type,
    Expression<int>? count,
  }) {
    return RawValuesInsertable({
      if (targetId != null) 'target_id': targetId,
      if (type != null) 'type': type,
      if (count != null) 'count': count,
    });
  }

  PopsCompanion copyWith(
      {Value<String>? targetId, Value<int>? type, Value<int>? count}) {
    return PopsCompanion(
      targetId: targetId ?? this.targetId,
      type: type ?? this.type,
      count: count ?? this.count,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PopsCompanion(')
          ..write('targetId: $targetId, ')
          ..write('type: $type, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }
}

class $PopsTable extends Pops with TableInfo<$PopsTable, Pop> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PopsTable(this._db, [this._alias]);
  final VerificationMeta _targetIdMeta = const VerificationMeta('targetId');
  late final GeneratedColumn<String?> targetId = GeneratedColumn<String?>(
      'target_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>(
      'type', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _countMeta = const VerificationMeta('count');
  late final GeneratedColumn<int?> count = GeneratedColumn<int?>(
      'count', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [targetId, type, count];
  @override
  String get aliasedName => _alias ?? 'pops';
  @override
  String get actualTableName => 'pops';
  @override
  VerificationContext validateIntegrity(Insertable<Pop> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('target_id')) {
      context.handle(_targetIdMeta,
          targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta));
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {targetId, type};
  @override
  Pop map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Pop.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PopsTable createAlias(String alias) {
    return $PopsTable(_db, alias);
  }
}

class FriendReqeust extends DataClass implements Insertable<FriendReqeust> {
  final String requestUid;
  final String msg;
  final int status;
  final int updateTime;
  FriendReqeust(
      {required this.requestUid,
      required this.msg,
      required this.status,
      required this.updateTime});
  factory FriendReqeust.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return FriendReqeust(
      requestUid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}request_uid'])!,
      msg: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}msg'])!,
      status: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status'])!,
      updateTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}update_time'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['request_uid'] = Variable<String>(requestUid);
    map['msg'] = Variable<String>(msg);
    map['status'] = Variable<int>(status);
    map['update_time'] = Variable<int>(updateTime);
    return map;
  }

  FriendReqeustsCompanion toCompanion(bool nullToAbsent) {
    return FriendReqeustsCompanion(
      requestUid: Value(requestUid),
      msg: Value(msg),
      status: Value(status),
      updateTime: Value(updateTime),
    );
  }

  factory FriendReqeust.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return FriendReqeust(
      requestUid: serializer.fromJson<String>(json['requestUid']),
      msg: serializer.fromJson<String>(json['msg']),
      status: serializer.fromJson<int>(json['status']),
      updateTime: serializer.fromJson<int>(json['updateTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'requestUid': serializer.toJson<String>(requestUid),
      'msg': serializer.toJson<String>(msg),
      'status': serializer.toJson<int>(status),
      'updateTime': serializer.toJson<int>(updateTime),
    };
  }

  FriendReqeust copyWith(
          {String? requestUid, String? msg, int? status, int? updateTime}) =>
      FriendReqeust(
        requestUid: requestUid ?? this.requestUid,
        msg: msg ?? this.msg,
        status: status ?? this.status,
        updateTime: updateTime ?? this.updateTime,
      );
  @override
  String toString() {
    return (StringBuffer('FriendReqeust(')
          ..write('requestUid: $requestUid, ')
          ..write('msg: $msg, ')
          ..write('status: $status, ')
          ..write('updateTime: $updateTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(requestUid.hashCode,
      $mrjc(msg.hashCode, $mrjc(status.hashCode, updateTime.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FriendReqeust &&
          other.requestUid == this.requestUid &&
          other.msg == this.msg &&
          other.status == this.status &&
          other.updateTime == this.updateTime);
}

class FriendReqeustsCompanion extends UpdateCompanion<FriendReqeust> {
  final Value<String> requestUid;
  final Value<String> msg;
  final Value<int> status;
  final Value<int> updateTime;
  const FriendReqeustsCompanion({
    this.requestUid = const Value.absent(),
    this.msg = const Value.absent(),
    this.status = const Value.absent(),
    this.updateTime = const Value.absent(),
  });
  FriendReqeustsCompanion.insert({
    required String requestUid,
    required String msg,
    required int status,
    required int updateTime,
  })  : requestUid = Value(requestUid),
        msg = Value(msg),
        status = Value(status),
        updateTime = Value(updateTime);
  static Insertable<FriendReqeust> custom({
    Expression<String>? requestUid,
    Expression<String>? msg,
    Expression<int>? status,
    Expression<int>? updateTime,
  }) {
    return RawValuesInsertable({
      if (requestUid != null) 'request_uid': requestUid,
      if (msg != null) 'msg': msg,
      if (status != null) 'status': status,
      if (updateTime != null) 'update_time': updateTime,
    });
  }

  FriendReqeustsCompanion copyWith(
      {Value<String>? requestUid,
      Value<String>? msg,
      Value<int>? status,
      Value<int>? updateTime}) {
    return FriendReqeustsCompanion(
      requestUid: requestUid ?? this.requestUid,
      msg: msg ?? this.msg,
      status: status ?? this.status,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (requestUid.present) {
      map['request_uid'] = Variable<String>(requestUid.value);
    }
    if (msg.present) {
      map['msg'] = Variable<String>(msg.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (updateTime.present) {
      map['update_time'] = Variable<int>(updateTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendReqeustsCompanion(')
          ..write('requestUid: $requestUid, ')
          ..write('msg: $msg, ')
          ..write('status: $status, ')
          ..write('updateTime: $updateTime')
          ..write(')'))
        .toString();
  }
}

class $FriendReqeustsTable extends FriendReqeusts
    with TableInfo<$FriendReqeustsTable, FriendReqeust> {
  final GeneratedDatabase _db;
  final String? _alias;
  $FriendReqeustsTable(this._db, [this._alias]);
  final VerificationMeta _requestUidMeta = const VerificationMeta('requestUid');
  late final GeneratedColumn<String?> requestUid = GeneratedColumn<String?>(
      'request_uid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _msgMeta = const VerificationMeta('msg');
  late final GeneratedColumn<String?> msg = GeneratedColumn<String?>(
      'msg', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<int?> status = GeneratedColumn<int?>(
      'status', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _updateTimeMeta = const VerificationMeta('updateTime');
  late final GeneratedColumn<int?> updateTime = GeneratedColumn<int?>(
      'update_time', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [requestUid, msg, status, updateTime];
  @override
  String get aliasedName => _alias ?? 'friend_reqeusts';
  @override
  String get actualTableName => 'friend_reqeusts';
  @override
  VerificationContext validateIntegrity(Insertable<FriendReqeust> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('request_uid')) {
      context.handle(
          _requestUidMeta,
          requestUid.isAcceptableOrUnknown(
              data['request_uid']!, _requestUidMeta));
    } else if (isInserting) {
      context.missing(_requestUidMeta);
    }
    if (data.containsKey('msg')) {
      context.handle(
          _msgMeta, msg.isAcceptableOrUnknown(data['msg']!, _msgMeta));
    } else if (isInserting) {
      context.missing(_msgMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('update_time')) {
      context.handle(
          _updateTimeMeta,
          updateTime.isAcceptableOrUnknown(
              data['update_time']!, _updateTimeMeta));
    } else if (isInserting) {
      context.missing(_updateTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {requestUid};
  @override
  FriendReqeust map(Map<String, dynamic> data, {String? tablePrefix}) {
    return FriendReqeust.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FriendReqeustsTable createAlias(String alias) {
    return $FriendReqeustsTable(_db, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final String id;
  final String uid;
  final String name;
  final String? avatar;
  final String? manager;
  final int memberCount;
  final String? notice;
  final bool? isDeleted;
  final int createTime;
  Group(
      {required this.id,
      required this.uid,
      required this.name,
      this.avatar,
      this.manager,
      required this.memberCount,
      this.notice,
      this.isDeleted,
      required this.createTime});
  factory Group.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Group(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      uid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}uid'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      avatar: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}avatar']),
      manager: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}manager']),
      memberCount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}member_count'])!,
      notice: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}notice']),
      isDeleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_deleted']),
      createTime: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}create_time'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['uid'] = Variable<String>(uid);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String?>(avatar);
    }
    if (!nullToAbsent || manager != null) {
      map['manager'] = Variable<String?>(manager);
    }
    map['member_count'] = Variable<int>(memberCount);
    if (!nullToAbsent || notice != null) {
      map['notice'] = Variable<String?>(notice);
    }
    if (!nullToAbsent || isDeleted != null) {
      map['is_deleted'] = Variable<bool?>(isDeleted);
    }
    map['create_time'] = Variable<int>(createTime);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      uid: Value(uid),
      name: Value(name),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      manager: manager == null && nullToAbsent
          ? const Value.absent()
          : Value(manager),
      memberCount: Value(memberCount),
      notice:
          notice == null && nullToAbsent ? const Value.absent() : Value(notice),
      isDeleted: isDeleted == null && nullToAbsent
          ? const Value.absent()
          : Value(isDeleted),
      createTime: Value(createTime),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<String>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      manager: serializer.fromJson<String?>(json['manager']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      notice: serializer.fromJson<String?>(json['notice']),
      isDeleted: serializer.fromJson<bool?>(json['isDeleted']),
      createTime: serializer.fromJson<int>(json['createTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'uid': serializer.toJson<String>(uid),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String?>(avatar),
      'manager': serializer.toJson<String?>(manager),
      'memberCount': serializer.toJson<int>(memberCount),
      'notice': serializer.toJson<String?>(notice),
      'isDeleted': serializer.toJson<bool?>(isDeleted),
      'createTime': serializer.toJson<int>(createTime),
    };
  }

  Group copyWith(
          {String? id,
          String? uid,
          String? name,
          String? avatar,
          String? manager,
          int? memberCount,
          String? notice,
          bool? isDeleted,
          int? createTime}) =>
      Group(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        manager: manager ?? this.manager,
        memberCount: memberCount ?? this.memberCount,
        notice: notice ?? this.notice,
        isDeleted: isDeleted ?? this.isDeleted,
        createTime: createTime ?? this.createTime,
      );
  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('manager: $manager, ')
          ..write('memberCount: $memberCount, ')
          ..write('notice: $notice, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          uid.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  avatar.hashCode,
                  $mrjc(
                      manager.hashCode,
                      $mrjc(
                          memberCount.hashCode,
                          $mrjc(
                              notice.hashCode,
                              $mrjc(isDeleted.hashCode,
                                  createTime.hashCode)))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.manager == this.manager &&
          other.memberCount == this.memberCount &&
          other.notice == this.notice &&
          other.isDeleted == this.isDeleted &&
          other.createTime == this.createTime);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<String> id;
  final Value<String> uid;
  final Value<String> name;
  final Value<String?> avatar;
  final Value<String?> manager;
  final Value<int> memberCount;
  final Value<String?> notice;
  final Value<bool?> isDeleted;
  final Value<int> createTime;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.manager = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.notice = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createTime = const Value.absent(),
  });
  GroupsCompanion.insert({
    required String id,
    required String uid,
    required String name,
    this.avatar = const Value.absent(),
    this.manager = const Value.absent(),
    required int memberCount,
    this.notice = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required int createTime,
  })  : id = Value(id),
        uid = Value(uid),
        name = Value(name),
        memberCount = Value(memberCount),
        createTime = Value(createTime);
  static Insertable<Group> custom({
    Expression<String>? id,
    Expression<String>? uid,
    Expression<String>? name,
    Expression<String?>? avatar,
    Expression<String?>? manager,
    Expression<int>? memberCount,
    Expression<String?>? notice,
    Expression<bool?>? isDeleted,
    Expression<int>? createTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (manager != null) 'manager': manager,
      if (memberCount != null) 'member_count': memberCount,
      if (notice != null) 'notice': notice,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createTime != null) 'create_time': createTime,
    });
  }

  GroupsCompanion copyWith(
      {Value<String>? id,
      Value<String>? uid,
      Value<String>? name,
      Value<String?>? avatar,
      Value<String?>? manager,
      Value<int>? memberCount,
      Value<String?>? notice,
      Value<bool?>? isDeleted,
      Value<int>? createTime}) {
    return GroupsCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      manager: manager ?? this.manager,
      memberCount: memberCount ?? this.memberCount,
      notice: notice ?? this.notice,
      isDeleted: isDeleted ?? this.isDeleted,
      createTime: createTime ?? this.createTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String?>(avatar.value);
    }
    if (manager.present) {
      map['manager'] = Variable<String?>(manager.value);
    }
    if (memberCount.present) {
      map['member_count'] = Variable<int>(memberCount.value);
    }
    if (notice.present) {
      map['notice'] = Variable<String?>(notice.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool?>(isDeleted.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<int>(createTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('manager: $manager, ')
          ..write('memberCount: $memberCount, ')
          ..write('notice: $notice, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  final GeneratedDatabase _db;
  final String? _alias;
  $GroupsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _uidMeta = const VerificationMeta('uid');
  late final GeneratedColumn<String?> uid = GeneratedColumn<String?>(
      'uid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  late final GeneratedColumn<String?> avatar = GeneratedColumn<String?>(
      'avatar', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _managerMeta = const VerificationMeta('manager');
  late final GeneratedColumn<String?> manager = GeneratedColumn<String?>(
      'manager', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _memberCountMeta =
      const VerificationMeta('memberCount');
  late final GeneratedColumn<int?> memberCount = GeneratedColumn<int?>(
      'member_count', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _noticeMeta = const VerificationMeta('notice');
  late final GeneratedColumn<String?> notice = GeneratedColumn<String?>(
      'notice', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  late final GeneratedColumn<bool?> isDeleted = GeneratedColumn<bool?>(
      'is_deleted', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_deleted IN (0, 1))');
  final VerificationMeta _createTimeMeta = const VerificationMeta('createTime');
  late final GeneratedColumn<int?> createTime = GeneratedColumn<int?>(
      'create_time', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uid,
        name,
        avatar,
        manager,
        memberCount,
        notice,
        isDeleted,
        createTime
      ];
  @override
  String get aliasedName => _alias ?? '"groups"';
  @override
  String get actualTableName => '"groups"';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
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
    if (data.containsKey('manager')) {
      context.handle(_managerMeta,
          manager.isAcceptableOrUnknown(data['manager']!, _managerMeta));
    }
    if (data.containsKey('member_count')) {
      context.handle(
          _memberCountMeta,
          memberCount.isAcceptableOrUnknown(
              data['member_count']!, _memberCountMeta));
    } else if (isInserting) {
      context.missing(_memberCountMeta);
    }
    if (data.containsKey('notice')) {
      context.handle(_noticeMeta,
          notice.isAcceptableOrUnknown(data['notice']!, _noticeMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    } else if (isInserting) {
      context.missing(_createTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Group.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(_db, alias);
  }
}

class GroupMember extends DataClass implements Insertable<GroupMember> {
  final String id;
  final String uid;
  final String groupId;
  final bool? isNotify;
  GroupMember(
      {required this.id,
      required this.uid,
      required this.groupId,
      this.isNotify});
  factory GroupMember.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return GroupMember(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      uid: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}uid'])!,
      groupId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}group_id'])!,
      isNotify: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_notify']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['uid'] = Variable<String>(uid);
    map['group_id'] = Variable<String>(groupId);
    if (!nullToAbsent || isNotify != null) {
      map['is_notify'] = Variable<bool?>(isNotify);
    }
    return map;
  }

  GroupMembersCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersCompanion(
      id: Value(id),
      uid: Value(uid),
      groupId: Value(groupId),
      isNotify: isNotify == null && nullToAbsent
          ? const Value.absent()
          : Value(isNotify),
    );
  }

  factory GroupMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GroupMember(
      id: serializer.fromJson<String>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      groupId: serializer.fromJson<String>(json['groupId']),
      isNotify: serializer.fromJson<bool?>(json['isNotify']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'uid': serializer.toJson<String>(uid),
      'groupId': serializer.toJson<String>(groupId),
      'isNotify': serializer.toJson<bool?>(isNotify),
    };
  }

  GroupMember copyWith(
          {String? id, String? uid, String? groupId, bool? isNotify}) =>
      GroupMember(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        groupId: groupId ?? this.groupId,
        isNotify: isNotify ?? this.isNotify,
      );
  @override
  String toString() {
    return (StringBuffer('GroupMember(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('groupId: $groupId, ')
          ..write('isNotify: $isNotify')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(uid.hashCode, $mrjc(groupId.hashCode, isNotify.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMember &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.groupId == this.groupId &&
          other.isNotify == this.isNotify);
}

class GroupMembersCompanion extends UpdateCompanion<GroupMember> {
  final Value<String> id;
  final Value<String> uid;
  final Value<String> groupId;
  final Value<bool?> isNotify;
  const GroupMembersCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.groupId = const Value.absent(),
    this.isNotify = const Value.absent(),
  });
  GroupMembersCompanion.insert({
    required String id,
    required String uid,
    required String groupId,
    this.isNotify = const Value.absent(),
  })  : id = Value(id),
        uid = Value(uid),
        groupId = Value(groupId);
  static Insertable<GroupMember> custom({
    Expression<String>? id,
    Expression<String>? uid,
    Expression<String>? groupId,
    Expression<bool?>? isNotify,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (groupId != null) 'group_id': groupId,
      if (isNotify != null) 'is_notify': isNotify,
    });
  }

  GroupMembersCompanion copyWith(
      {Value<String>? id,
      Value<String>? uid,
      Value<String>? groupId,
      Value<bool?>? isNotify}) {
    return GroupMembersCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      groupId: groupId ?? this.groupId,
      isNotify: isNotify ?? this.isNotify,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (isNotify.present) {
      map['is_notify'] = Variable<bool?>(isNotify.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('groupId: $groupId, ')
          ..write('isNotify: $isNotify')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTable extends GroupMembers
    with TableInfo<$GroupMembersTable, GroupMember> {
  final GeneratedDatabase _db;
  final String? _alias;
  $GroupMembersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _uidMeta = const VerificationMeta('uid');
  late final GeneratedColumn<String?> uid = GeneratedColumn<String?>(
      'uid', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  late final GeneratedColumn<String?> groupId = GeneratedColumn<String?>(
      'group_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _isNotifyMeta = const VerificationMeta('isNotify');
  late final GeneratedColumn<bool?> isNotify = GeneratedColumn<bool?>(
      'is_notify', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_notify IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns => [id, uid, groupId, isNotify];
  @override
  String get aliasedName => _alias ?? 'group_members';
  @override
  String get actualTableName => 'group_members';
  @override
  VerificationContext validateIntegrity(Insertable<GroupMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('is_notify')) {
      context.handle(_isNotifyMeta,
          isNotify.isAcceptableOrUnknown(data['is_notify']!, _isNotifyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    return GroupMember.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $GroupMembersTable createAlias(String alias) {
    return $GroupMembersTable(_db, alias);
  }
}

abstract class _$UcDatabase extends GeneratedDatabase {
  _$UcDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ChatRecentsTable chatRecents = $ChatRecentsTable(this);
  late final $ChatUsersTable chatUsers = $ChatUsersTable(this);
  late final $ChatMsgsTable chatMsgs = $ChatMsgsTable(this);
  late final $FriendsTable friends = $FriendsTable(this);
  late final $PopsTable pops = $PopsTable(this);
  late final $FriendReqeustsTable friendReqeusts = $FriendReqeustsTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $GroupMembersTable groupMembers = $GroupMembersTable(this);
  late final ChatMsgDao chatMsgDao = ChatMsgDao(this as UcDatabase);
  late final ChatRecentDao chatRecentDao = ChatRecentDao(this as UcDatabase);
  late final ChatUserDao chatUserDao = ChatUserDao(this as UcDatabase);
  late final FriendDao friendDao = FriendDao(this as UcDatabase);
  late final PopsDao popsDao = PopsDao(this as UcDatabase);
  late final FriendReqeustsDao friendReqeustsDao =
      FriendReqeustsDao(this as UcDatabase);
  late final GroupDao groupDao = GroupDao(this as UcDatabase);
  late final GroupMemberDao groupMemberDao = GroupMemberDao(this as UcDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        chatRecents,
        chatUsers,
        chatMsgs,
        friends,
        pops,
        friendReqeusts,
        groups,
        groupMembers
      ];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$FriendDaoMixin on DatabaseAccessor<UcDatabase> {
  $FriendsTable get friends => attachedDatabase.friends;
}
mixin _$ChatRecentDaoMixin on DatabaseAccessor<UcDatabase> {
  $ChatRecentsTable get chatRecents => attachedDatabase.chatRecents;
}
mixin _$ChatMsgDaoMixin on DatabaseAccessor<UcDatabase> {
  $ChatMsgsTable get chatMsgs => attachedDatabase.chatMsgs;
}
mixin _$ChatUserDaoMixin on DatabaseAccessor<UcDatabase> {
  $ChatUsersTable get chatUsers => attachedDatabase.chatUsers;
}
mixin _$PopsDaoMixin on DatabaseAccessor<UcDatabase> {
  $PopsTable get pops => attachedDatabase.pops;
}
mixin _$FriendReqeustsDaoMixin on DatabaseAccessor<UcDatabase> {
  $FriendReqeustsTable get friendReqeusts => attachedDatabase.friendReqeusts;
}
mixin _$GroupDaoMixin on DatabaseAccessor<UcDatabase> {
  $GroupsTable get groups => attachedDatabase.groups;
}
mixin _$GroupMemberDaoMixin on DatabaseAccessor<UcDatabase> {
  $GroupMembersTable get groupMembers => attachedDatabase.groupMembers;
}

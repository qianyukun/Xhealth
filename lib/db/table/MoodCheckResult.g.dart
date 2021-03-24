// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MoodCheckResult.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class MoodCheckTable extends DataClass implements Insertable<MoodCheckTable> {
  final int id;
  final int feelingId;
  final String thoughtIds;
  int sandTableSceneId;
  int breathFeelingId;
  final DateTime insertTime;
  MoodCheckTable(
      {@required this.id,
      @required this.feelingId,
      @required this.thoughtIds,
      this.sandTableSceneId,
      this.breathFeelingId,
      @required this.insertTime});
  factory MoodCheckTable.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return MoodCheckTable(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      feelingId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}feeling_id']),
      thoughtIds: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}thought_ids']),
      sandTableSceneId: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}sand_table_scene_id']),
      breathFeelingId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}breath_feeling_id']),
      insertTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}insert_time']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || feelingId != null) {
      map['feeling_id'] = Variable<int>(feelingId);
    }
    if (!nullToAbsent || thoughtIds != null) {
      map['thought_ids'] = Variable<String>(thoughtIds);
    }
    if (!nullToAbsent || sandTableSceneId != null) {
      map['sand_table_scene_id'] = Variable<int>(sandTableSceneId);
    }
    if (!nullToAbsent || breathFeelingId != null) {
      map['breath_feeling_id'] = Variable<int>(breathFeelingId);
    }
    if (!nullToAbsent || insertTime != null) {
      map['insert_time'] = Variable<DateTime>(insertTime);
    }
    return map;
  }

  MoodCheckDbBeanDefineCompanion toCompanion(bool nullToAbsent) {
    return MoodCheckDbBeanDefineCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      feelingId: feelingId == null && nullToAbsent
          ? const Value.absent()
          : Value(feelingId),
      thoughtIds: thoughtIds == null && nullToAbsent
          ? const Value.absent()
          : Value(thoughtIds),
      sandTableSceneId: sandTableSceneId == null && nullToAbsent
          ? const Value.absent()
          : Value(sandTableSceneId),
      breathFeelingId: breathFeelingId == null && nullToAbsent
          ? const Value.absent()
          : Value(breathFeelingId),
      insertTime: insertTime == null && nullToAbsent
          ? const Value.absent()
          : Value(insertTime),
    );
  }

  factory MoodCheckTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return MoodCheckTable(
      id: serializer.fromJson<int>(json['id']),
      feelingId: serializer.fromJson<int>(json['feelingId']),
      thoughtIds: serializer.fromJson<String>(json['thoughtIds']),
      sandTableSceneId: serializer.fromJson<int>(json['sandTableSceneId']),
      breathFeelingId: serializer.fromJson<int>(json['breathFeelingId']),
      insertTime: serializer.fromJson<DateTime>(json['insertTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'feelingId': serializer.toJson<int>(feelingId),
      'thoughtIds': serializer.toJson<String>(thoughtIds),
      'sandTableSceneId': serializer.toJson<int>(sandTableSceneId),
      'breathFeelingId': serializer.toJson<int>(breathFeelingId),
      'insertTime': serializer.toJson<DateTime>(insertTime),
    };
  }

  MoodCheckTable copyWith(
          {int id,
          int feelingId,
          String thoughtIds,
          int sandTableSceneId,
          int breathFeelingId,
          DateTime insertTime}) =>
      MoodCheckTable(
        id: id ?? this.id,
        feelingId: feelingId ?? this.feelingId,
        thoughtIds: thoughtIds ?? this.thoughtIds,
        sandTableSceneId: sandTableSceneId ?? this.sandTableSceneId,
        breathFeelingId: breathFeelingId ?? this.breathFeelingId,
        insertTime: insertTime ?? this.insertTime,
      );
  @override
  String toString() {
    return (StringBuffer('MoodCheckTable(')
          ..write('id: $id, ')
          ..write('feelingId: $feelingId, ')
          ..write('thoughtIds: $thoughtIds, ')
          ..write('sandTableSceneId: $sandTableSceneId, ')
          ..write('breathFeelingId: $breathFeelingId, ')
          ..write('insertTime: $insertTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          feelingId.hashCode,
          $mrjc(
              thoughtIds.hashCode,
              $mrjc(sandTableSceneId.hashCode,
                  $mrjc(breathFeelingId.hashCode, insertTime.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is MoodCheckTable &&
          other.id == this.id &&
          other.feelingId == this.feelingId &&
          other.thoughtIds == this.thoughtIds &&
          other.sandTableSceneId == this.sandTableSceneId &&
          other.breathFeelingId == this.breathFeelingId &&
          other.insertTime == this.insertTime);
}

class MoodCheckDbBeanDefineCompanion extends UpdateCompanion<MoodCheckTable> {
  final Value<int> id;
  final Value<int> feelingId;
  final Value<String> thoughtIds;
  final Value<int> sandTableSceneId;
  final Value<int> breathFeelingId;
  final Value<DateTime> insertTime;
  const MoodCheckDbBeanDefineCompanion({
    this.id = const Value.absent(),
    this.feelingId = const Value.absent(),
    this.thoughtIds = const Value.absent(),
    this.sandTableSceneId = const Value.absent(),
    this.breathFeelingId = const Value.absent(),
    this.insertTime = const Value.absent(),
  });
  MoodCheckDbBeanDefineCompanion.insert({
    this.id = const Value.absent(),
    @required int feelingId,
    @required String thoughtIds,
    this.sandTableSceneId = const Value.absent(),
    this.breathFeelingId = const Value.absent(),
    @required DateTime insertTime,
  })  : feelingId = Value(feelingId),
        thoughtIds = Value(thoughtIds),
        insertTime = Value(insertTime);
  static Insertable<MoodCheckTable> custom({
    Expression<int> id,
    Expression<int> feelingId,
    Expression<String> thoughtIds,
    Expression<int> sandTableSceneId,
    Expression<int> breathFeelingId,
    Expression<DateTime> insertTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feelingId != null) 'feeling_id': feelingId,
      if (thoughtIds != null) 'thought_ids': thoughtIds,
      if (sandTableSceneId != null) 'sand_table_scene_id': sandTableSceneId,
      if (breathFeelingId != null) 'breath_feeling_id': breathFeelingId,
      if (insertTime != null) 'insert_time': insertTime,
    });
  }

  MoodCheckDbBeanDefineCompanion copyWith(
      {Value<int> id,
      Value<int> feelingId,
      Value<String> thoughtIds,
      Value<int> sandTableSceneId,
      Value<int> breathFeelingId,
      Value<DateTime> insertTime}) {
    return MoodCheckDbBeanDefineCompanion(
      id: id ?? this.id,
      feelingId: feelingId ?? this.feelingId,
      thoughtIds: thoughtIds ?? this.thoughtIds,
      sandTableSceneId: sandTableSceneId ?? this.sandTableSceneId,
      breathFeelingId: breathFeelingId ?? this.breathFeelingId,
      insertTime: insertTime ?? this.insertTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (feelingId.present) {
      map['feeling_id'] = Variable<int>(feelingId.value);
    }
    if (thoughtIds.present) {
      map['thought_ids'] = Variable<String>(thoughtIds.value);
    }
    if (sandTableSceneId.present) {
      map['sand_table_scene_id'] = Variable<int>(sandTableSceneId.value);
    }
    if (breathFeelingId.present) {
      map['breath_feeling_id'] = Variable<int>(breathFeelingId.value);
    }
    if (insertTime.present) {
      map['insert_time'] = Variable<DateTime>(insertTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodCheckDbBeanDefineCompanion(')
          ..write('id: $id, ')
          ..write('feelingId: $feelingId, ')
          ..write('thoughtIds: $thoughtIds, ')
          ..write('sandTableSceneId: $sandTableSceneId, ')
          ..write('breathFeelingId: $breathFeelingId, ')
          ..write('insertTime: $insertTime')
          ..write(')'))
        .toString();
  }
}

class $MoodCheckDbBeanDefineTable extends MoodCheckDbBeanDefine
    with TableInfo<$MoodCheckDbBeanDefineTable, MoodCheckTable> {
  final GeneratedDatabase _db;
  final String _alias;
  $MoodCheckDbBeanDefineTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _feelingIdMeta = const VerificationMeta('feelingId');
  GeneratedIntColumn _feelingId;
  @override
  GeneratedIntColumn get feelingId => _feelingId ??= _constructFeelingId();
  GeneratedIntColumn _constructFeelingId() {
    return GeneratedIntColumn(
      'feeling_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _thoughtIdsMeta = const VerificationMeta('thoughtIds');
  GeneratedTextColumn _thoughtIds;
  @override
  GeneratedTextColumn get thoughtIds => _thoughtIds ??= _constructThoughtIds();
  GeneratedTextColumn _constructThoughtIds() {
    return GeneratedTextColumn(
      'thought_ids',
      $tableName,
      false,
    );
  }

  final VerificationMeta _sandTableSceneIdMeta =
      const VerificationMeta('sandTableSceneId');
  GeneratedIntColumn _sandTableSceneId;
  @override
  GeneratedIntColumn get sandTableSceneId =>
      _sandTableSceneId ??= _constructSandTableSceneId();
  GeneratedIntColumn _constructSandTableSceneId() {
    return GeneratedIntColumn(
      'sand_table_scene_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _breathFeelingIdMeta =
      const VerificationMeta('breathFeelingId');
  GeneratedIntColumn _breathFeelingId;
  @override
  GeneratedIntColumn get breathFeelingId =>
      _breathFeelingId ??= _constructBreathFeelingId();
  GeneratedIntColumn _constructBreathFeelingId() {
    return GeneratedIntColumn(
      'breath_feeling_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _insertTimeMeta = const VerificationMeta('insertTime');
  GeneratedDateTimeColumn _insertTime;
  @override
  GeneratedDateTimeColumn get insertTime =>
      _insertTime ??= _constructInsertTime();
  GeneratedDateTimeColumn _constructInsertTime() {
    return GeneratedDateTimeColumn(
      'insert_time',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        feelingId,
        thoughtIds,
        sandTableSceneId,
        breathFeelingId,
        insertTime
      ];
  @override
  $MoodCheckDbBeanDefineTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'mood_check_db_bean_define';
  @override
  final String actualTableName = 'mood_check_db_bean_define';
  @override
  VerificationContext validateIntegrity(Insertable<MoodCheckTable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('feeling_id')) {
      context.handle(_feelingIdMeta,
          feelingId.isAcceptableOrUnknown(data['feeling_id'], _feelingIdMeta));
    } else if (isInserting) {
      context.missing(_feelingIdMeta);
    }
    if (data.containsKey('thought_ids')) {
      context.handle(
          _thoughtIdsMeta,
          thoughtIds.isAcceptableOrUnknown(
              data['thought_ids'], _thoughtIdsMeta));
    } else if (isInserting) {
      context.missing(_thoughtIdsMeta);
    }
    if (data.containsKey('sand_table_scene_id')) {
      context.handle(
          _sandTableSceneIdMeta,
          sandTableSceneId.isAcceptableOrUnknown(
              data['sand_table_scene_id'], _sandTableSceneIdMeta));
    }
    if (data.containsKey('breath_feeling_id')) {
      context.handle(
          _breathFeelingIdMeta,
          breathFeelingId.isAcceptableOrUnknown(
              data['breath_feeling_id'], _breathFeelingIdMeta));
    }
    if (data.containsKey('insert_time')) {
      context.handle(
          _insertTimeMeta,
          insertTime.isAcceptableOrUnknown(
              data['insert_time'], _insertTimeMeta));
    } else if (isInserting) {
      context.missing(_insertTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodCheckTable map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return MoodCheckTable.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $MoodCheckDbBeanDefineTable createAlias(String alias) {
    return $MoodCheckDbBeanDefineTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $MoodCheckDbBeanDefineTable _moodCheckDbBeanDefine;
  $MoodCheckDbBeanDefineTable get moodCheckDbBeanDefine =>
      _moodCheckDbBeanDefine ??= $MoodCheckDbBeanDefineTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [moodCheckDbBeanDefine];
}

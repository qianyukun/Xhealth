import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'MoodCheckResult.g.dart';

@DataClassName("MoodCheckTable")
class MoodCheckDbBeanDefine extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get feelingId => integer()();

  TextColumn get thoughtIds => text()();

  IntColumn get sandTableSceneId => integer().nullable()();

  IntColumn get breathFeelingId => integer().nullable()();

  DateTimeColumn get insertTime => dateTime()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [MoodCheckDbBeanDefine])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<MoodCheckTable>> getTodayMoodCheckResult(DateTime dateTime) {
    return (select(moodCheckDbBeanDefine)
          ..where((tbl) {
            final date = tbl.insertTime;
            return date.year.equals(dateTime.year) &
                date.month.equals(dateTime.month) &
                date.day.equals(dateTime.day);
          })
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.insertTime, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<int> createMoodCheckResult(MoodCheckDbBeanDefineCompanion entity) {
    return into(moodCheckDbBeanDefine).insert(entity);
  }

  Future<bool> updateMoodCheckResult(MoodCheckTable entity) {
    return update(moodCheckDbBeanDefine).replace(entity);
  }

  Stream<MoodCheckTable> queryById(int id) {
    return (select(moodCheckDbBeanDefine)..where((tbl) => tbl.id.equals(id)))
        .watchSingle();
  }
}

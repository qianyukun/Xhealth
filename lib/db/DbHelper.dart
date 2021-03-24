import 'package:flutter/foundation.dart';
import 'package:health/db/table/MoodCheckResult.dart';
import 'package:health/routes/selfAssessment/Thought.dart';
import 'package:moor/moor.dart';

class DbHelper with ChangeNotifier {
  final Database db;

  DbHelper() : db = Database();

  Future<int> addMoodCheck(int _feelingId, List<int> _thoughtIds) {
    String thoughtIds = "";
    for (int thoughtId in _thoughtIds) {
      thoughtIds = thoughtIds.length > 0
          ? thoughtIds + "," + thoughtId.toString()
          : thoughtId.toString();
    }
    return db.createMoodCheckResult(MoodCheckDbBeanDefineCompanion(
        feelingId: Value(_feelingId), thoughtIds: Value(thoughtIds)));
  }

  Future<int> addMoodCheckWithThoughts(
      int _feelingId, List<Thought> _thoughtIds) {
    String thoughtIds = "";
    for (Thought thought in _thoughtIds) {
      thoughtIds = thoughtIds.length > 0
          ? thoughtIds + "," + thought.id.toString()
          : thought.id.toString();
    }
    return db.createMoodCheckResult(MoodCheckDbBeanDefineCompanion(
        feelingId: Value(_feelingId),
        thoughtIds: Value(thoughtIds),
        insertTime: Value(DateTime.now())));
  }

  void updateMoodCheck(MoodCheckTable entity) {
    db.updateMoodCheckResult(entity);
  }

  Stream<MoodCheckTable> queryMoodCheckById(int id) {
    return db.queryById(id);
  }

  Future<List<MoodCheckTable>> getTodayMoodCheckResult(DateTime dateTime) {
    return db.getTodayMoodCheckResult(dateTime);
  }

  void close() {
    db.close();
  }
}

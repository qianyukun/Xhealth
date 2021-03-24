import 'package:health/routes/selfAssessment/Thought.dart';

class ThoughtsUtil {
  static List<Thought> _thoughts = [];

  ThoughtsUtil._() {
    getThoughts();
  }

  static ThoughtsUtil _instance;

  static ThoughtsUtil getInstance() {
    if (_instance == null) {
      _instance = ThoughtsUtil._();
    }
    return _instance;
  }

  Future<List<Thought>> getThoughts() async {
    if (_thoughts.length == 0) {
      _thoughts.add(Thought(id: 1, thoughtAdj: "Balanced", thoughtNoun: "balanced"));
      _thoughts.add(Thought(id: 2, thoughtAdj: "Calm", thoughtNoun: "calm"));
      _thoughts.add(Thought(id: 3, thoughtAdj: "Relaxed", thoughtNoun: "relaxed"));
      _thoughts.add(Thought(id: 4, thoughtAdj: "Encouraged", thoughtNoun: "encouraged"));
      _thoughts.add(Thought(id: 5, thoughtAdj: "Happy", thoughtNoun: "happy"));
      _thoughts.add(Thought(id: 6, thoughtAdj: "Satisfied", thoughtNoun: "satisfied"));
      _thoughts.add(Thought(id: 7, thoughtAdj: "Grateful", thoughtNoun: "grateful"));
      _thoughts.add(Thought(id: 8, thoughtAdj: "Excited", thoughtNoun: "excited"));

      _thoughts.add(Thought(id: 9, thoughtAdj: "Anxiety", thoughtNoun:"anxiety"));
      _thoughts.add(Thought(id: 10, thoughtAdj: "Lonely", thoughtNoun:"loneliness"));
      _thoughts.add(Thought(id: 11, thoughtAdj: "Depressed", thoughtNoun:"depression"));
      _thoughts.add(Thought(id: 12, thoughtAdj: "Exhausted", thoughtNoun:"exhaustion"));
      _thoughts.add(Thought(id: 13, thoughtAdj: "Helpless", thoughtNoun:"helplessness"));
      _thoughts.add(Thought(id: 14, thoughtAdj: "Frustrated", thoughtNoun:"frustration"));
      _thoughts.add(Thought(id: 15, thoughtAdj: "Bored", thoughtNoun:"bore"));
      _thoughts.add(Thought(id: 16, thoughtAdj: "Fear", thoughtNoun:"fear"));
    }
    return _thoughts;
  }

  Future<List<Thought>> getGoodThoughts() async {
    var list = await getThoughts();
    return list.sublist(0, 8);
  }

  Future<List<Thought>> getBadThoughts() async {
    var list = await getThoughts();
    return list.sublist(8);
  }

  Thought getThoughtById(int id) {
    getThoughts();
    for (Thought thought in _thoughts) {
      if (thought.id == id) {
        return thought;
      }
    }
    return _thoughts[0];
  }
}

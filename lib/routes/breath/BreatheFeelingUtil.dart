import 'BreatheFeeling.dart';

class BreatheFeelingUtil {
  static List<BreatheFeeling> _feelings = [];

  BreatheFeelingUtil._();

  static BreatheFeelingUtil _instance;

  static BreatheFeelingUtil getInstance() {
    if (_instance == null) {
      _instance = BreatheFeelingUtil._();
    }
    return _instance;
  }

  Future<List<BreatheFeeling>> getBreatheFeelings() async {
    if (_feelings.length == 0) {
      _feelings = [
        BreatheFeeling(1, "Better"),
        BreatheFeeling(2, "Same as before"),
        BreatheFeeling(3, "Worse"),
      ];
    }
    return _feelings;
  }

  BreatheFeeling getBreatheFeelingById(int id) {
    if (_feelings.length == 0) {
      getBreatheFeelings();
    }

    for (BreatheFeeling feeling in _feelings) {
      if (feeling.id == id) {
        return feeling;
      }
    }
    return BreatheFeeling(id, "unknown");
  }
}

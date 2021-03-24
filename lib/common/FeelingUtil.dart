import 'package:health/routes/selfAssessment/Feeling.dart';

class FeelingUtil {
  static List<Feeling> _feelings = [];

  FeelingUtil._();

  static FeelingUtil? _instance;

  static FeelingUtil getInstance() {
    if (_instance == null) {
      _instance = FeelingUtil._();
    }
    return _instance!;
  }

  Future<List<Feeling>> getFeelings() async {
    if (_feelings.length == 0) {
      _feelings = [
        Feeling(
            id: 1,
            isPositive: false,
            feelingText: "Bad",
            imageUrl: "imgs/feeling/mood_s_bad.png",
            bigImageUrl: "imgs/feeling/mood_l_bad.png",
        ),
        Feeling(
            id: 2,
            isPositive: false,
            feelingText: "Not good",
            imageUrl: "imgs/feeling/mood_s_notgood.png",
            bigImageUrl: "imgs/feeling/mood_l_notgood.png",
        ),
        Feeling(
            id: 3,
            isPositive: true,
            feelingText: "Okay",
            imageUrl: "imgs/feeling/mood_s_okey.png",
            bigImageUrl: "imgs/feeling/mood_l_okey.png",
        ),
        Feeling(
            id: 4,
            isPositive: true,
            feelingText: "Good",
            imageUrl: "imgs/feeling/mood_s_good.png",
            bigImageUrl: "imgs/feeling/mood_l_good.png",
        ),
        Feeling(
            id: 5,
            isPositive: true,
            feelingText: "Great",
            imageUrl: "imgs/feeling/mood_s_great.png",
            bigImageUrl: "imgs/feeling/mood_l_great.png",
        ),
      ];
    }
    return _feelings;
  }

  Feeling getFeelingById(int id) {
    if (_feelings.length == 0) {
      getFeelings();
    }

    for (Feeling feeling in _feelings) {
      if (feeling.id == id) {
        return feeling;
      }
    }
    return Feeling(
        id: id,
        isPositive: false,
        feelingText: "unknown",
        imageUrl: "imgs/feeling/mood_l_default.png",
        bigImageUrl: "imgs/feeling/mood_l_default.png",
    );
  }
}

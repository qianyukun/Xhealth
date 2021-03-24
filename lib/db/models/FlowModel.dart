import 'package:health/common/FeelingUtil.dart';
import 'package:health/common/SandTableUtil.dart';
import 'package:health/common/ThoughtsUtil.dart';
import 'package:health/db/table/MoodCheckResult.dart';
import 'package:health/routes/breath/BreatheFeeling.dart';
import 'package:health/routes/breath/BreatheFeelingUtil.dart';
import 'package:health/routes/sandTable/SandTableScene.dart';
import 'package:health/routes/selfAssessment/Feeling.dart';
import 'package:health/routes/selfAssessment/Thought.dart';

class FlowModel {
  Feeling feeling;
  List<Thought> thoughts;
  SandTableScene sandTableScene;
  BreatheFeeling breathFeeling;
  DateTime insertTime;

  FlowModel(this.feeling, this.thoughts, this.sandTableScene,
      this.breathFeeling, this.insertTime);

  static FlowModel convertFromDbMoodCheckTable(MoodCheckTable moodCheckTable) {
    List<Thought> thoughts = [];
    try {
      for (String thoughtId in moodCheckTable.thoughtIds.split(",")) {
        try {
          thoughts.add(
              ThoughtsUtil.getInstance().getThoughtById(int.parse(thoughtId)));
        } catch (e) {}
      }
    } catch (e) {}
    return FlowModel(
        FeelingUtil.getInstance().getFeelingById(moodCheckTable.feelingId),
        thoughts,
        moodCheckTable.sandTableSceneId != null
            ? SandTableSceneUtil.getInstance()
                .getSandTableSceneById(moodCheckTable.sandTableSceneId)
            : null,
        moodCheckTable.breathFeelingId != null
            ? BreatheFeelingUtil.getInstance()
                .getBreatheFeelingById(moodCheckTable.breathFeelingId)
            : null,
        moodCheckTable.insertTime);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/common/Global.dart';
import 'package:health/db/DbHelper.dart';
import 'package:health/routes/HomeRoute.dart';
import 'package:health/routes/selfAssessment/AssessmentEnterName.dart';
import 'package:health/routes/selfAssessment/AssessmentFeeling.dart';
import 'package:health/routes/selfAssessment/Feeling.dart';
import 'package:health/widget/GradientLinearPrograssBar.dart';
import 'package:provider/provider.dart';

import '../sandTable/SandTableRoute.dart';
import 'AssessmentThought.dart';
import 'Thought.dart';
import 'package:health/extension/ScreenExtension.dart';

class SelfAssessmentRoute extends StatefulWidget {
  static const String selfAssessmentName = "/selfAssessment";

  @override
  State<StatefulWidget> createState() {
    return _SelfAssessmentRouteState();
  }
}

class _SelfAssessmentRouteState extends State<SelfAssessmentRoute> {
  int totalCheckCount = 3;
  int currentPosition = 0;
  bool isFeelingGood = false;
  Feeling feeling;
  List<Thought> selectedThoughts = [];
  var _hasEnterNameFuture;
  List<Widget> contents;

  DbHelper get dbHelper => Provider.of<DbHelper>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _hasEnterNameFuture = hasEnterName();
  }

  @override
  Widget build(BuildContext context) {
    return buildAssessment();
  }

  Widget buildAssessment() {
    return FutureBuilder(future: _hasEnterNameFuture, builder: _buildFuture);
  }

  Future<bool> hasEnterName() async {
    return await Global.getPref().hasKey(AssessmentEnterName.nickName);
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData) {
        totalCheckCount = snapshot.data ? 2 : 3;
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("imgs/bg/bg_guide.jpg"), fit: BoxFit.cover),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildIndicators(currentPosition, snapshot.data),
                  buildAppbar(),
                  Expanded(
                      child: Container(
                    width: double.infinity,
                    child: buildContents(currentPosition, snapshot.data),
                  ))
                ],
              ),
            ),
          ),
        );
      }
    }
    return Scaffold(body: CircularProgressIndicator());
  }

  Widget buildAppbar() {
    return Container(
      width: double.infinity,
      height: 56,
      alignment: Alignment.centerLeft,
      child: !(totalCheckCount == 3 && currentPosition == 0)
          ? Padding(
              padding: EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Image.asset("imgs/common/bt_back.png"),
                onPressed: _onBackPress,
              ),
            )
          : null,
    );
  }

  Widget buildIndicators(int position, bool hasEnteredName) {
    double value = 0;
    if (!hasEnteredName) {
      if (position == 0) {
        value = 0.33;
      } else if (position == 1) {
        value = 0.66;
      } else {
        value = 1;
      }
    } else {
      if (position == 0) {
        value = 0.50;
      } else {
        value = 1;
      }
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 19),
      height: 4,
      child: GradientLinearProgressBar(
        value: value,
        strokeWidth: 4,
        strokeCapRound: true,
        colors: [Color(0xFF6F86FF), Color(0xFF6F86FF)],
        backgroundColor: Color(0x0d000000),
      ),
    );
  }

  Widget buildContents(int position, bool hasEnteredName) {
    contents = [];
    if (!hasEnteredName) {
      contents.add(AssessmentEnterName(
        onFinishEnterName: _onFinishCurrentPage,
      ));
    }
    contents.add(AssessmentFeeling(
      feeling: feeling,
      onFinishSelectedFeelings: _onFinishSelectFeeling,
    ));
    contents.add(AssessmentThought(
      onFinishSelectThought: _onFinishSelectThought,
      onPreSelectThought: _onPreSelectThought,
      isFeelingGood: this.isFeelingGood,
      initThoughts: selectedThoughts,
    ));
    return contents[position];
  }

  void _onFinishCurrentPage() {
    setState(() {
      if (currentPosition < totalCheckCount - 1) {
        currentPosition++;
      }
    });
  }

  void _onFinishSelectFeeling(bool isFeelingGood, Feeling feeling) {
    if (this.feeling != null && feeling.id != this.feeling.id) {
      selectedThoughts.clear();
    }
    this.isFeelingGood = isFeelingGood;
    this.feeling = feeling;
    _onFinishCurrentPage();
  }

  void _onFinishSelectThought(List<Thought> thoughts) async {
    selectedThoughts.addAll(thoughts);
    var moodCheckId =
        await dbHelper.addMoodCheckWithThoughts(this.feeling.id, thoughts);

    if (moodCheckId > -1) {
      Map<String, dynamic> map = Map();
      map.putIfAbsent("moodCheckId", () => moodCheckId);
      map.putIfAbsent("scroll", () => 300.0);

      Navigator.of(context).pop();
      Navigator.of(context).pushNamedAndRemoveUntil(
          isFeelingGood ? HomeRoute.homeName : SandTableRoute.sandTableName,
          (Route<dynamic> route) => false,
          arguments: map);
    }
  }

  void _onPreSelectThought(List<Thought> thoughts) async {
    selectedThoughts.clear();
    selectedThoughts.addAll(thoughts);
  }

  void _onBackPress() {
    if (currentPosition == 0 && totalCheckCount == 3) {
      return;
    }
    if (currentPosition == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      currentPosition--;
    });
  }
}

typedef void OnFinishCurrentPage();
typedef void OnFinishSelectFeeling(bool isFeelingGood, Feeling feeling);
typedef void OnFinishSelectThoughts(List<Thought> thoughts);

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:health/common/EventConstants.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:health/common/ThoughtsUtil.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:health/routes/selfAssessment/Thought.dart';

import 'SelfAssessmentRoute.dart';
import 'package:health/extension/ScreenExtension.dart';

class AssessmentThought extends StatefulWidget {
  final OnFinishSelectThoughts onFinishSelectThought;
  final OnFinishSelectThoughts onPreSelectThought;
  final isFeelingGood;
  var initThoughts = <Thought>[];

  AssessmentThought(
      {Key key,
      @required this.onFinishSelectThought,
      @required this.onPreSelectThought,
      @required this.isFeelingGood,
      @required this.initThoughts})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AssessmentThoughtState(this.isFeelingGood);
  }
}

class _AssessmentThoughtState extends State<AssessmentThought> {
  var thoughts = <Thought>[];
  var selectedThoughts = <Thought>{};

  bool isFeelingGood;
  Future<List<Thought>> thoughtFuture;

  _AssessmentThoughtState(this.isFeelingGood);

  var selectedBg = <String>[
    "imgs/thought/icon_feel_l1_selected.png",
    "imgs/thought/icon_feel_l2_selected.png",
    "imgs/thought/icon_feel_l3_selected.png",
    "imgs/thought/icon_feel_l4_selected.png",
    "imgs/thought/icon_feel_r1_selected.png",
    "imgs/thought/icon_feel_r2_selected.png",
    "imgs/thought/icon_feel_r3_selected.png",
    "imgs/thought/icon_feel_r4_selected.png",
  ];
  var unselectedBg = <String>[
    "imgs/thought/icon_feel_l1_unselect.png",
    "imgs/thought/icon_feel_l2_unselect.png",
    "imgs/thought/icon_feel_l3_unselect.png",
    "imgs/thought/icon_feel_l4_unselect.png",
    "imgs/thought/icon_feel_r1_unselect.png",
    "imgs/thought/icon_feel_r2_unselect.png",
    "imgs/thought/icon_feel_r3_unselect.png",
    "imgs/thought/icon_feel_r4_unselect.png",
  ];

  Future<List<Thought>> initThoughtFuture(bool isFeelingGood) {
    return isFeelingGood
        ? ThoughtsUtil.getInstance().getGoodThoughts()
        : ThoughtsUtil.getInstance().getBadThoughts();
  }

  final _memoizer = AsyncMemoizer<List<Thought>>();

  @override
  void initState() {
    super.initState();
    thoughtFuture = initThoughtFuture(isFeelingGood);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: 52.pt, left: 38.pt, right: 38.pt, bottom: 51),
          child: Text(
            "What about your thoughts?",
            textAlign: TextAlign.center,
            strutStyle: StrutStyle(leading: 0.9),
            style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 20.pt,
                letterSpacing: 0.4.pt,
                fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.pt, right: 20.pt),
          child: _buildThoughtsWidget(),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: TextButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(70.pt, 70.pt)),
                shape: MaterialStateProperty.all(StadiumBorder()),
                backgroundColor: selectedThoughts.isNotEmpty
                    ? MaterialStateProperty.all(Color(0xFF6F86FF))
                    : MaterialStateProperty.all(Color(0xFFDDDEE4)),
              ),
              onPressed: selectedThoughts.isEmpty ? null : _next,
              child: Image.asset("imgs/common/bt_next_arrow.png"),
            ),
          ),
          flex: 2,
        ),
      ],
    );
  }

  _buildThoughtsWidget() {
    return FutureBuilder<List<Thought>>(
      future: _memoizer.runOnce(() => thoughtFuture),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          thoughts = snapshot.data ?? [];
          if (widget.initThoughts.isNotEmpty) {
            for (Thought thought in widget.initThoughts) {
              !selectedThoughts.contains(thought)
                  ? selectedThoughts.add(thought)
                  : {};
            }
          }
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 64.pt, crossAxisCount: 2),
            itemCount: thoughts.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  width: 170.pt,
                  height: 64.pt,
                  alignment: index % 4 == 0 || index % 4 == 1
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedThoughts.contains(thoughts[index])) {
                          selectedThoughts.remove(thoughts[index]);
                          widget.onPreSelectThought(selectedThoughts.toList());
                        } else {
                          if (selectedThoughts.length >= 3) {
                            return;
                          }
                          selectedThoughts.add(thoughts[index]);
                          widget.onPreSelectThought(selectedThoughts.toList());
                          Map<String, dynamic> map = Map();
                          map.putIfAbsent(
                              "thought", () => thoughts[index].thoughtAdj);
                          ReportUtil.getInstance().trackEvent(
                              eventName: EventConstants.thoughts_choose,
                              parameters: map);
                        }
                      });
                    },
                    child: Container(
                      height: 64.pt,
                      width: 132.pt,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(selectedThoughts
                                      .contains(thoughts[index])
                                  ? selectedBg[index % selectedBg.length]
                                  : unselectedBg[index % selectedBg.length]),
                              fit: BoxFit.fitWidth)),
                      alignment: Alignment.center,
                      child: Text(
                        thoughts[index].thoughtAdj,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: selectedThoughts.contains(thoughts[index])
                                ? Colors.white
                                : selectedThoughts.length >= 3
                                    ? Color(0xFFDDDEE4)
                                    : Color(0xFF666666),
                            fontSize: 16.pt,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ));
            },
          );
        }
        return Align();
      },
    );
  }

  _next() {
    ReportUtil.getInstance()
        .trackEvent(eventName: EventConstants.thoughts_next);
    widget.onFinishSelectThought(selectedThoughts.toList());
  }
}

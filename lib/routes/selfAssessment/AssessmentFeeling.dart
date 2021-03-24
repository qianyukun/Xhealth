import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/common/FeelingUtil.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:health/routes/selfAssessment/Feeling.dart';

import 'SelfAssessmentRoute.dart';
import 'package:health/extension/ScreenExtension.dart';

class AssessmentFeeling extends StatefulWidget {
  final OnFinishSelectFeeling onFinishSelectedFeelings;
  Feeling feeling;

  AssessmentFeeling(
      {Key key, @required this.onFinishSelectedFeelings, this.feeling})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AssessmentFeeling();
  }
}

class _AssessmentFeeling extends State<AssessmentFeeling> {
  List<Feeling> feelings = [];
  int selectedPosition = -1;
  Future<List<Feeling>> feelingsFuture;
  final _memoizer = AsyncMemoizer<List<Feeling>>();

  @override
  void initState() {
    feelingsFuture = initFeelings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _memoizer.runOnce(() => feelingsFuture),
        builder: _buildFeelingPanel,
      ),
    );
  }

  _next() {
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      widget.onFinishSelectedFeelings(
          selectedPosition > 1, feelings[selectedPosition]);
      Map<String, dynamic> map = Map();
      map.putIfAbsent("feeling", () => feelings[selectedPosition].feelingText);
      ReportUtil.getInstance()
          .trackEvent(eventName: EventConstants.feeling_next, parameters: map);
    });
  }

  Future<List<Feeling>> initFeelings() {
    return FeelingUtil.getInstance().getFeelings();
  }

  Widget _buildFeelingWidgets() {
    return Container(
      height: 72.pt,
      margin: EdgeInsets.only(top: 34.pt),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: feelings.length,
        itemExtent: 72.pt,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPosition = index;
                    Map<String, dynamic> map = Map();
                    map.putIfAbsent("feeling",
                        () => feelings[selectedPosition].feelingText);
                    ReportUtil.getInstance().trackEvent(
                        eventName: EventConstants.feeling_choose,
                        parameters: map);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 2.5.pt, right: 2.5.pt),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: buildFeelingWidget(index),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  buildFeelingWidget(int index) {
    List<Widget> feelingWidgets = [];
    feelingWidgets.add(Image.asset(
      feelings[index].imageUrl,
      height: 56.pt,
      width: 56.pt,
    ));
    if (selectedPosition == index) {
      feelingWidgets.add(Padding(
        padding: EdgeInsets.only(top: 4.pt),
        child: Image.asset(
          "imgs/feeling/mood_s_shadow.png",
          width: 58.pt,
        ),
      ));
    }
    return feelingWidgets;
  }

  Widget _buildFeelingPanel(
      BuildContext context, AsyncSnapshot<List<Feeling>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      feelings = snapshot.data ?? [];
      if (widget.feeling != null) {
        selectedPosition = feelings.indexOf(widget.feeling);
        widget.feeling = null;
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                top: 52.pt, left: 38.pt, right: 38.pt, bottom: 51),
            child: Text(
              "How are you feeling right now?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.pt,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4.pt,
              ),
            ),
          ),
          Container(
            height: 174.pt,
            width: 174.pt,
            alignment: Alignment.center,
            child: Image.asset(
              selectedPosition == -1
                  ? "imgs/feeling/mood_l_default.png"
                  : feelings[selectedPosition].bigImageUrl,
              height: 174.pt,
              width: 174.pt,
              fit: BoxFit.fill,
            ),
          ),
          Text(
            selectedPosition == -1
                ? ""
                : feelings[selectedPosition].feelingText,
            style: TextStyle(
                color: Color(0xFFD1D2D7),
                fontSize: 20.pt,
                fontWeight: FontWeight.w500),
          ),
          _buildFeelingWidgets(),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(70.pt, 70.pt)),
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  backgroundColor: selectedPosition != -1
                      ? MaterialStateProperty.all(Color(0xFF6F86FF))
                      : MaterialStateProperty.all(Color(0xFFDDDEE4)),
                ),
                onPressed: selectedPosition == -1 ? null : _next,
                child: Image.asset("imgs/common/bt_next_arrow.png"),
              ),
            ),
            flex: 3,
          )
        ],
      );
    } else {
      return Align();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/db/DbHelper.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:health/routes/breath/BreatheFeelingUtil.dart';
import 'package:health/widget/SlideVerticalWidget.dart';
import 'package:provider/provider.dart';

import '../HomeRoute.dart';
import 'BreathSource.dart';
import 'BreatheFeeling.dart';
import 'package:health/extension/ScreenExtension.dart';

class BreatheFeelingCheck extends StatefulWidget {
  static const String breatheFeelingCheckName = "/breathFellingCheck";

  @override
  State<StatefulWidget> createState() {
    return _BreatheFeelingCheckState();
  }
}

class _BreatheFeelingCheckState extends State<BreatheFeelingCheck> {
  List<BreatheFeeling> breathResultFeelings = [];

  Future<List<BreatheFeeling>> futureBreatheFeeling;
  int selectedPosition = -1;
  int moodCheckId;

  DbHelper get dbHelper => Provider.of<DbHelper>(context, listen: false);
  BreathSource fromHome = BreathSource.selfAssessment;

  @override
  void initState() {
    futureBreatheFeeling = initBreatheFeeling();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings?.arguments;
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    if (args.containsKey("moodCheckId")) {
      moodCheckId = args["moodCheckId"];
    }
    if (args.containsKey("breathSource")) {
      fromHome = args["breathSource"];
    }
    return Scaffold(
      backgroundColor: Color(0xFFF6FAFF),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 109.pt,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("imgs/breath/bg_bottom.png"),
                      fit: BoxFit.cover)),
            ),
          ),
          SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppBar(),
              Container(
                margin: EdgeInsets.only(top: 86.pt, bottom: 95.pt),
                alignment: Alignment.center,
                child: Text(
                  "How are you feeling now?",
                  style: TextStyle(
                      fontSize: 24.pt,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333)),
                ),
              ),
              FutureBuilder<List<BreatheFeeling>>(
                builder: _buildBreatheFeelingCheck,
                future: futureBreatheFeeling,
              )
            ],
          ))
        ],
      ),
    );
  }

  void _onBackPressed() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("scroll", () => 300.0);

    ///从home页面过来
    if (fromHome == BreathSource.selfAssessment) {
      Navigator.of(context).pop();
      Navigator.of(context).push(SlideVerticalRoute(
          child: HomeRoute(), settings: RouteSettings(arguments: map)));
    }
  }

  void _enterHome() {
    _onBackPressed();
  }

  Future<List<BreatheFeeling>> initBreatheFeeling() {
    return BreatheFeelingUtil.getInstance().getBreatheFeelings();
  }

  _buildAppBar() {
    return Container(
      alignment: Alignment.centerRight,
      height: 70.pt,
      width: double.infinity,
      child: IconButton(
        iconSize: 54.pt,
        icon: Image.asset("imgs/common/bt_close.png"),
        onPressed: _onBackPressed,
      ),
    );
  }

  Widget _buildBreatheFeelingCheck(
      BuildContext context, AsyncSnapshot<List<BreatheFeeling>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      breathResultFeelings = snapshot.data ?? [];
      return Container(
        width: double.infinity,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: breathResultFeelings.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin:
                    EdgeInsets.symmetric(vertical: 10.pt, horizontal: 65.pt),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedPosition = index;
                      _recordMoodCheck();
                    });
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        BorderSide(color: Color(0x6F86FF).withOpacity(0.3))),
                    overlayColor: MaterialStateProperty.all(
                        Color(0x6F86FF).withOpacity(0.2)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.pt),
                    )),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.pt, horizontal: 20.pt),
                    child: Text(
                      breathResultFeelings[index].breatheFeelingText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF6274D2),
                          fontSize: 20.pt,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              );
            }),
      );
    } else {
      return Align();
    }
  }

  void _recordMoodCheck() async {
    if (moodCheckId != null) {
      var entity = await dbHelper.queryMoodCheckById(moodCheckId).first;
      entity.breathFeelingId = breathResultFeelings[selectedPosition].id;
      dbHelper.updateMoodCheck(entity);
      Map<String, dynamic> map = Map();
      map.putIfAbsent("feeling",
          () => breathResultFeelings[selectedPosition].breatheFeelingText);
      ReportUtil.getInstance().trackEvent(
          eventName: EventConstants.secfeeling__choose, parameters: map);
    }
    _enterHome();
  }
}

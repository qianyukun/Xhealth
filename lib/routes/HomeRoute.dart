import 'package:flutter/material.dart';
import 'package:health/common/DailyMotionSentencesUtil.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/common/Global.dart';
import 'package:health/db/DbHelper.dart';
import 'package:health/db/models/FlowModel.dart';
import 'package:health/db/table/MoodCheckResult.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:health/routes/breath/BreathRoute.dart';
import 'package:health/routes/selfAssessment/SelfAssessmentRoute.dart';
import 'package:health/routes/sound/SoundRoute.dart';
import 'package:health/routes/breath/BreathSource.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'selfAssessment/AssessmentEnterName.dart';
import 'package:health/extension/ScreenExtension.dart';

class HomeRoute extends StatefulWidget {
  static const String homeName = "/home";

  @override
  State<StatefulWidget> createState() {
    return _HomeRouteState();
  }
}

class _HomeRouteState extends State<HomeRoute> {
  ///用户名
  String nickName;

  ///标题栏颜色和透明度
  Color _timeColor = Colors.white;
  int alpha = 0;
  ScrollController _controller = ScrollController();

  ///每日一语
  Future<DailyMotion> dailyMotionFuture =
      DailyMotionSentencesUtil.getInstance().getSentence();

  ///日夜间
  bool isDay = false;

  DbHelper get dbHelper => Provider.of<DbHelper>(context, listen: false);

  Future<List<MoodCheckTable>> futureMoodChecks;

  double scrollY = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null) {
      final Map<String, dynamic> args = arguments as Map<String, dynamic>;
      if (args.containsKey("scroll")) {
        scrollY = args["scroll"];
        Future.delayed(Duration(milliseconds: 200), () {
          if (_controller.hasClients) {
            _controller.animateTo(scrollY,
                curve: Curves.easeOutQuart,
                duration: Duration(milliseconds: 300));
            args.remove("scroll");
          }
        });
      }
    }
    return WillPopScope(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _controller,
                  slivers: [
                    SliverList(
                        delegate: SliverChildListDelegate([
                      buildHeader(),
                    ])),
                    FutureBuilder(
                      builder: buildFlow,
                      future: futureMoodChecks,
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate(
                            [buildMoment(), buildFooter()])),
                  ],
                ),
                buildTitleBar(),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          ReportUtil.getInstance()
              .trackEvent(eventName: EventConstants.app_out);
          return true;
        });
  }

  void _onCheck() {
    ReportUtil.getInstance()
        .trackEvent(eventName: EventConstants.feeling_check);
    Navigator.of(context).pushNamed(SelfAssessmentRoute.selfAssessmentName);
  }

  void _onSoundPlay() {
    ReportUtil.getInstance().trackEvent(eventName: EventConstants.sounds_click);
    Navigator.of(context).push(PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
      return SoundRoute();
    }));
  }

  void _onBreathing() {
    ReportUtil.getInstance()
        .trackEvent(eventName: EventConstants.breathing_click);
    Map<String, dynamic> map = Map();
    map.putIfAbsent("breathSource", () => BreathSource.home);
    // Navigator.of(context)
    //     .pushNamed(BreathRoute.breathRouteName, arguments: map);

    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return BreathRoute();
        },
        settings: RouteSettings(arguments: map)));
  }

  initData() async {
    nickName = await Global.getPref().getStorage(AssessmentEnterName.nickName);
    isDay = DateTime.now().hour <= 20 && DateTime.now().hour >= 8;
    futureMoodChecks = initFutureMoodChecks();
    setState(() {
      _controller.addListener(() {
        setState(() {
          if (_controller.offset > 0) {
            alpha = (255 * (_controller.offset / 100.0)).toInt();
            if (alpha > 255) alpha = 255;
          } else {
            alpha = 0;
          }
        });
      });
    });
  }

  Future<List<MoodCheckTable>> initFutureMoodChecks() {
    return dbHelper.getTodayMoodCheckResult(DateTime.now());
  }

  buildTitleBar() {
    return Wrap(
      children: [
        Container(
          color: _timeColor.withAlpha(alpha),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 20.13,
                      top: 12.35 + MediaQuery.of(context).padding.top,
                      right: 20.13),
                  child: Text(
                    "Hi,$nickName",
                    style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 28,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 9.2, horizontal: 20.13),
                  child: Text(
                    "${DateFormat("EEEE,MMM d").format(DateTime.now())}",
                    style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  buildHeader() {
    return Container(
      width: double.infinity,
      height: 479.pt,
      margin: EdgeInsets.only(bottom: 20.pt),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(isDay
                  ? "imgs/home/banner_top_day.png"
                  : "imgs/home/banner_top_night.png"),
              fit: BoxFit.fitHeight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 39.pt, top: 177.pt),
              child: Image.asset(
                "imgs/home/ic_comma.png",
              ),
            ),
            FutureBuilder(
              future: dailyMotionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: 40.pt, right: 40.pt, top: 4.pt),
                        child: Text((snapshot.data as DailyMotion).sentence,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            strutStyle: StrutStyle(
                                forceStrutHeight: true, height: 1, leading: 1),
                            style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 18.pt,
                                fontWeight: FontWeight.w300)),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: 40.pt, right: 40.pt, top: 15.pt),
                        child: (snapshot.data as DailyMotion).author.isNotEmpty
                            ? Text("-" + (snapshot.data as DailyMotion).author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 18.pt,
                                    fontWeight: FontWeight.w300))
                            : null,
                      )
                    ],
                  );
                }
                return Align();
              },
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 60.pt),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: TextButton(
                          onPressed: _onCheck,
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 100, 120, 222)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 112, 137, 252)),
                              shape:
                                  MaterialStateProperty.all(StadiumBorder())),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 7.pt, horizontal: 14.pt),
                            child: Text(
                              "How do you feel?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.pt,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFlow(
      BuildContext context, AsyncSnapshot<List<MoodCheckTable>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      List<MoodCheckTable> moodCheckTables = snapshot.data ?? [];
      if (moodCheckTables.length == 0) {
        return SliverToBoxAdapter(
          child: Align(),
        );
      }
      List<FlowModel> flowModels = [];
      for (MoodCheckTable moodCheckTable in moodCheckTables) {
        flowModels.add(FlowModel.convertFromDbMoodCheckTable(moodCheckTable));
      }
      return SliverToBoxAdapter(
          child: Column(
        children: [
          buildFlowTitle(),
          Container(
            margin: EdgeInsets.only(left: 15.pt, right: 15.pt),
            height: 170.pt,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return buildMoodCheckItems(flowModels[index]);
              },
              itemExtent: 151.pt,
              itemCount: flowModels.length,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ));
    } else {
      return SliverToBoxAdapter(
        child: Align(),
      );
    }
  }

  buildFlowTitle() {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.12.pt, vertical: 20.2.pt),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Feelings",
            style: TextStyle(
                fontSize: 20.pt,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w600),
          ),
          // buildMoodCheckItems()
        ],
      ),
    );
  }

  buildMoodCheckItems(FlowModel flowModel) {
    String feelingText = flowModel.feeling.isPositive
        ? "I feel ${flowModel.feeling.feelingText}."
        : "I feel ${flowModel.feeling.feelingText}, but I eliminate my negative thoughts.";
    return Container(
      margin: EdgeInsets.all(4.5.pt),
      width: 151.pt,
      decoration: BoxDecoration(
          color: const Color(0xFFEDF6FF),
          borderRadius: BorderRadius.all(Radius.circular(6.pt))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8.88.pt, bottom: 7.46.pt),
              child: Image.asset(flowModel.feeling.imageUrl),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 11.pt, top: 11.pt, right: 25.pt),
            child: Text(
              feelingText,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14.pt,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w400),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(11.pt),
              child: Text(
                DateFormat("Hm").format(flowModel.insertTime),
                maxLines: 1,
                style: TextStyle(
                    fontSize: 14.pt,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildMoment() {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.12.pt, vertical: 20.2.pt),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mindful Moments",
            style: TextStyle(
                fontSize: 20.pt,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w500),
          ),
          buildSoundItem(),
          buildBreathItem()
        ],
      ),
    );
  }

  buildSoundItem() {
    return GestureDetector(
      onTap: _onSoundPlay,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 16.51.pt),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("imgs/home/item_sounds.png"),
              fit: BoxFit.fitWidth),
        ),
        child: Stack(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20.pt, right: 20.pt, top: 32.pt, bottom: 30.pt),
                child: Text(
                  "Focus Sounds",
                  style: TextStyle(
                      fontSize: 18.pt,
                      color: const Color(0xFF333333),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Image.asset("imgs/home/ic_sounds.png"),
            ),
          ],
        ),
      ),
    );
  }

  buildBreathItem() {
    return GestureDetector(
      onTap: _onBreathing,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 16.51.pt),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("imgs/home/item_breath.png"),
              fit: BoxFit.fitWidth),
        ),
        child: Stack(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20.pt, right: 20.pt, top: 32.pt, bottom: 30.pt),
                child: Text(
                  "Breathing",
                  style: TextStyle(
                      fontSize: 18.pt,
                      color: const Color(0xFF333333),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Image.asset("imgs/home/ic_breath.png"),
            ),
          ],
        ),
      ),
    );
  }

  buildFooter() {
    return Container(
      height: 200.pt,
      // child: Image.asset(
      //   "imgs/home/bottom_pic_day.png",
      //   fit: BoxFit.fitWidth,
      // ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:health/Utils.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/db/DbHelper.dart';
import 'package:health/db/models/FlowModel.dart';
import 'package:health/db/table/MoodCheckResult.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:health/routes/breath/BreathRoute.dart';
import 'package:health/routes/breath/BreathSource.dart';
import 'package:health/routes/sandTable/SandTableScene.dart';
import 'package:health/widget/SlideVerticalWidget.dart';
import 'package:health/widget/scratch_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:health/extension/ScreenExtension.dart';
import 'dart:ui' as ui;

class SandTableDetailRoute extends StatelessWidget {
  static const String sandTableDetailName = "/sandTableDetail";
  int moodCheckId;
  SandTableScene sandTableScene;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    if (args.containsKey("moodCheckId") && args.containsKey("scene")) {
      sandTableScene = args["scene"];
      moodCheckId = args["moodCheckId"];

      return Scaffold(
          body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("imgs/bg/bg_guide.jpg"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SandTableDetailPage(
            sandTableScene: sandTableScene,
            moodCheckId: moodCheckId,
          ),
        ),
      ));
    } else {
      return Scaffold(
        body: Align(),
      );
    }
  }
}

class SandTableDetailPage extends StatefulWidget {
  final SandTableScene sandTableScene;
  final int moodCheckId;

  SandTableDetailPage({Key key, this.sandTableScene, this.moodCheckId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SandTableDetailPageState();
  }
}

class _SandTableDetailPageState extends State<SandTableDetailPage>
    with SingleTickerProviderStateMixin {
  int _animState = -1;
  int _animSentence = -1;

  var _showDetailAnim = false;

  DbHelper get dbHelper => Provider.of<DbHelper>(context, listen: false);

  Future<MoodCheckTable> _futureMoodCheck;
  FlowModel flowModel;

  AnimationController _btnAnimationController;
  Animation<double> _btnAnimation;
  ui.Image _image;

  @override
  void initState() {
    _futureMoodCheck = initFutureMoodCheck();
    super.initState();
    _btnAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 9));
    _btnAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 25),
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 25),
    ]).animate(_btnAnimationController);
    Utils.getImage(widget.sandTableScene.imgUrl, 300, 216).then((image) {
      _image = image;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child:
          FutureBuilder(future: _futureMoodCheck, builder: _builderMoodCheck),
    );
  }

  @override
  void dispose() {
    _btnAnimationController.dispose();
    super.dispose();
  }

  Widget buildDetail(SandTableScene args) {
    return SafeArea(
        child: args == null
            ? Align()
            : AnimatedOpacity(
                opacity: _showDetailAnim ? 1 : 0,
                duration: Duration(milliseconds: 1500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 40),
                        padding: EdgeInsets.only(
                            left: 20.pt,
                            top: 22.pt,
                            right: 20.pt,
                            bottom: 22.pt),
                        child: Text(
                          "Your ${flowModel?.thoughts[0].thoughtNoun} looks like this. \nLet’s cope with it.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.pt,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: ScratchCardWidget(
                              strokeWidth: 40,
                              threshold: 0.15,
                              foreground: (canvas, size, offset) {
                                if (_image != null) {
                                  double scale;
                                  double dx = 0;
                                  double dy = 0;
                                  if (_image.width * size.height >
                                      size.width * _image.height) {
                                    scale = size.height / _image.height;
                                    dx =
                                        (size.width - _image.width * scale) / 2;
                                  } else {
                                    scale = size.width / _image.width;
                                    dy = (size.height - _image.height * scale) /
                                        2;
                                  }
                                  scale = 1;
                                  dx = (size.width - _image.width * scale) / 2;
                                  dy =
                                      (size.height - _image.height * scale) / 2;

                                  canvas.save();
                                  canvas.translate(dx, dy);
                                  canvas.scale(scale, scale);
                                  canvas.clipRRect(
                                      RRect.fromRectXY(
                                          Rect.fromLTWH(
                                              0,
                                              0,
                                              _image.width * scale,
                                              _image.height * scale),
                                          20.pt,
                                          20.pt),
                                      doAntiAlias: false);
                                  canvas.drawImage(
                                      _image, Offset(0, 0), new Paint());
                                  canvas.restore();
                                } else {
                                  canvas.drawRRect(
                                      RRect.fromLTRBR(0, 0, size.width,
                                          size.height, Radius.circular(20.pt)),
                                      Paint()..color = Colors.grey);
                                }
                              },
                              onFinish: () {
                                _onNext();
                              },
                              child: Container(
                                height: 450.pt,
                                width: 300.pt,
                                // color: Colors.blueAccent,
                                alignment: Alignment.center,
                              ))),
                      flex: 4,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        // margin: EdgeInsets.only(top: 81.pt),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 80.pt, vertical: 10.pt),
                          child: FadeTransition(
                            opacity: _btnAnimation,
                            child: Text(
                              "Scratch off to erase",
                              style: TextStyle(
                                  fontSize: 20.pt,
                                  color: Color(0xFF999999),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    )
                  ],
                ),
              ));
  }

  Widget buildPositiveSentence() {
    return AnimatedOpacity(
      onEnd: _onFinish,
      opacity: _animSentence != 0 ? 1.0 : 0,
      duration: Duration(milliseconds: 1000),
      child: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: 272.pt),
        child: Text(
          "The ${flowModel?.thoughts[0].thoughtNoun} has gone away.\nLet's relax for a moment.",
          textAlign: TextAlign.center,
          strutStyle: StrutStyle(leading: 0.9.pt),
          style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 20.pt,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Future<MoodCheckTable> initFutureMoodCheck() async {
    return await dbHelper.queryMoodCheckById(widget.moodCheckId).first;
  }

  Widget _builderMoodCheck(
      BuildContext context, AsyncSnapshot<MoodCheckTable> snapshot) {
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      var moodCheckTable = snapshot.data;
      flowModel = FlowModel.convertFromDbMoodCheckTable(moodCheckTable);

      Future.delayed(Duration(milliseconds: 200), () {
        if (_animSentence == 0) {
          return;
        }
        setState(() {
          _showDetailAnim = true;
          _btnAnimationController.forward();
        });
      });
      return Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            onEnd: _onShowSentence,
            opacity: _animState == -1 ? 1.0 : 0.0,
            child: buildDetail(widget.sandTableScene),
            duration: Duration(milliseconds: 1000),
          ),
          AnimatedOpacity(
            onEnd: _onSentenceShown,
            opacity: _animState == 2 ? 1.0 : 0.0,
            duration: Duration(milliseconds: 1000),
            child: buildPositiveSentence(),
          )
        ],
      );
    } else {
      return Align();
    }
  }

  void _onNext() {
    ReportUtil.getInstance().trackEvent(eventName: EventConstants.cards_tap);
    setState(() {
      _animState++;
    });
  }

  _onShowSentence() {
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _animState = 2;
      });
    });
  }

  void _onSentenceShown() {
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _animSentence = 0;
      });
    });
  }

  void _onFinish() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("moodCheckId", () => widget.moodCheckId);
    map.putIfAbsent("breathSource", () => BreathSource.selfAssessment);
    Navigator.of(context).pop();
    Navigator.of(context).push(SlideVerticalRoute(
        child: BreathRoute(), settings: RouteSettings(arguments: map)));
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:health/routes/HomeRoute.dart';
import 'package:health/routes/breath/BreathSource.dart';
import 'package:health/routes/breath/BreatheResult.dart';

import 'BreatheFeelingCheck.dart';
import 'package:health/extension/ScreenExtension.dart';

class BreathRoute extends StatefulWidget {
  static const String breathRouteName = "/breath";

  @override
  State<StatefulWidget> createState() {
    return _BreathRouteState();
  }
}

class _BreathRouteState extends State<BreathRoute>
    with SingleTickerProviderStateMixin {
  Animation<double> _breatheAnim;
  Animation<double> _breatheMidAnim;
  Animation<double> _breatheOutAnim;
  AnimationController _controller;

  int _count = -1;
  int _totalCount = 60;
  Timer _timer;
  Timer initDelayTimer;
  BreathSource fromHome = BreathSource.selfAssessment;
  int moodCheckId;

  @override
  void initState() {
    _initBreathAnim();
    super.initState();
  }

  @override
  void dispose() {
    initDelayTimer?.cancel();
    _timer?.cancel();
    _timer = null;
    _controller.removeListener(_refreshAnim);
    _controller.removeStatusListener(_animStateListener);
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    if (args.containsKey("breathSource")) {
      fromHome = args["breathSource"];
    }
    if (args.containsKey("moodCheckId")) {
      moodCheckId = args["moodCheckId"];
    }
    return Scaffold(
      backgroundColor: Color(0xFFF6FAFF),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child:
                  Image.asset("imgs/breath/bg_bottom.png", fit: BoxFit.cover),
            ),
          ),
          SafeArea(
              child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: _buildBreathWidget(),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top: 10.pt),
                    child: _count == -1 ? Container() : _buildTimerText(),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    child: _count == -1 ? Container() : _buildFinishBtn(),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  _buildAppBar() {
    return Container(
      alignment: Alignment.centerRight,
      height: 70,
      width: double.infinity,
      child: IconButton(
        iconSize: 54,
        icon: Image.asset("imgs/common/bt_close.png"),
        onPressed: _onBackPressed,
      ),
    );
  }

  _buildBreathWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      width: 375.pt,
      height: 375.pt,
      child: Container(
        alignment: Alignment.center,
        child: Stack(alignment: Alignment.center, children: [
          ///外
          Container(
            height: _breatheOutAnim.value,
            width: _breatheOutAnim.value,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [Color(0xFFFFC48D), Color(0xFFABC9FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    tileMode: TileMode.mirror)),
          ),
          Container(
            height: _breatheOutAnim.value - 1,
            width: _breatheOutAnim.value - 1,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF6FAFF)),
          ),

          ///中
          Container(
            height: _breatheMidAnim.value,
            width: _breatheMidAnim.value,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [Color(0xFFFFC48D), Color(0xFFABC9FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    tileMode: TileMode.mirror)),
          ),
          Container(
            height: _breatheMidAnim.value - 1,
            width: _breatheMidAnim.value - 1,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF6FAFF)),
          ),

          ///内
          Container(
            height: _breatheAnim.value,
            width: _breatheAnim.value,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [Color(0xFFFFD8AE), Color(0xFFB2BBFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    tileMode: TileMode.mirror)),
          ),
          Container(
            height: _breatheAnim.value - 10.pt,
            width: _breatheAnim.value - 10.pt,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF6FAFF)),
          ),
          Container(
            child: _count == -1
                ? Text("Relax",
                    style: TextStyle(
                      fontSize: 22.pt,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ))
                : _buildText(_count),
          )
        ]),
      ),
    );
  }

  _buildText(int _time) {
    String breathText;
    int time = _time % 12;
    if (_time >= _totalCount) {
      breathText = "Breathe out";
    } else if (time < 5) {
      breathText = "Breathe in";
    } else if (time < 7) {
      breathText = "Hold";
    } else if (time < 12) {
      breathText = "Breathe out";
    } else {
      breathText = "Relax";
    }
    return Text(
      breathText,
      style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  _buildTimerText() {
    return Text(
      RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
              .firstMatch(
                  "${Duration(seconds: (_totalCount - _count - 1 < 0 ? 0 : _totalCount - _count - 1))}")
              ?.group(1) ??
          '${Duration(seconds: (_totalCount - _count - 1 < 0 ? 0 : _totalCount - _count - 1))}',
      style: TextStyle(
          color: Color(0xFFD1D2D7),
          fontSize: 20.pt,
          fontWeight: FontWeight.w500),
    );
  }

  _buildFinishBtn() {
    return Align(
      child: TextButton(
        onPressed: _onFinishEarlier,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.pt, vertical: 10.pt),
          child: Text(
            "Finish Earlier",
            style: TextStyle(
                color: Color(0xFF6274D2),
                fontSize: 20.pt,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  void _initBreathAnim() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 12000));
    _controller.addListener(_refreshAnim);
    _controller.addStatusListener(_animStateListener);
    _breatheAnim = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 145.0.pt, end: 194.0.pt), weight: 42),
      TweenSequenceItem(tween: ConstantTween(194.0.pt), weight: 16),
      TweenSequenceItem(
          tween: Tween(begin: 194.0.pt, end: 145.0.pt), weight: 42),
    ]).animate(_controller);

    _breatheMidAnim = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 145.0.pt, end: 214.0.pt), weight: 42),
      TweenSequenceItem(tween: ConstantTween(214.0.pt), weight: 16),
      TweenSequenceItem(
          tween: Tween(begin: 214.0.pt, end: 145.0.pt), weight: 42),
    ]).animate(_controller);

    _breatheOutAnim = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 145.0.pt, end: 244.0.pt), weight: 42),
      TweenSequenceItem(tween: ConstantTween(244.0.pt), weight: 16),
      TweenSequenceItem(
          tween: Tween(begin: 244.0.pt, end: 145.0.pt), weight: 42),
    ]).animate(_controller);
    initDelayTimer = Timer(Duration(milliseconds: 2000), () {
      setState(() {
        _count = 0;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _count++;
        });
        if (_count > _totalCount) {
          _onFinishBreathe();
        }
      });
      _controller.forward();
    });
  }

  void _refreshAnim() {
    setState(() {});
  }

  void _animStateListener(AnimationStatus status) {
    if (status == AnimationStatus.completed && _count < _totalCount) {
      _controller.reset();
      _controller.forward();
    }
    if (_count > _totalCount) {
      _controller.stop();
    }
  }

  void _onBackPressed() {
    if (fromHome == BreathSource.home) {
      ReportUtil.getInstance()
          .trackEvent(eventName: EventConstants.home_breathe_back);
    } else {
      ReportUtil.getInstance()
          .trackEvent(eventName: EventConstants.cards_breathe_off);
    }
    _onFinishBreathe();
    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil(HomeRoute.homeName, (route) => false);
  }

  void _onFinishBreathe() {
    Navigator.of(context).pop();
    Map<String, dynamic> map = Map();

    ///从自我测评进入
    if (moodCheckId != null && fromHome == BreathSource.selfAssessment) {
      map.putIfAbsent("moodCheckId", () => moodCheckId);
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return BreatheFeelingCheck();
          },
          settings: RouteSettings(arguments: map)));
    } else if (_count > _totalCount) {
      ///从其他入口进入，且完成了呼吸
      map.putIfAbsent("breathSource", () => fromHome);
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return SlideTransition(
              position: animation.drive(
                  Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.ease))),
              child: BreatheResult(),
            );
          },
          settings: RouteSettings(arguments: map),
          transitionDuration: Duration(milliseconds: 500)));
    } else {
      ///直接关闭
    }
  }

  void _onFinishEarlier() {
    if (fromHome == BreathSource.home) {
      ReportUtil.getInstance()
          .trackEvent(eventName: EventConstants.home_breathe_finishealrlier);
    } else {
      ReportUtil.getInstance()
          .trackEvent(eventName: EventConstants.cards_breathe_finishealrlier);
    }
    _onFinishBreathe();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/common/Global.dart';
import 'package:health/routes/HomeRoute.dart';
import 'package:health/routes/splash/SplashPage.dart';

import 'guide/GuideRoute.dart';
import 'package:health/extension/ScreenExtension.dart';

class SplashRoute extends StatefulWidget {
  static const String splashName = "/splash";

  @override
  _SplashRouteState createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  final String firstOpened = "first_opened";

  bool isFirstOpen = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    checkFirstOpened();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SplashPage();
  }

  ///跳转guide页面
  void navigateToGuide() {
    Navigator.of(context).popAndPushNamed(GuideRoute.guideName);
    _timer.cancel();
  }

  ///跳转Space页面
  void navigateToHome() {
    Navigator.of(context).popAndPushNamed(HomeRoute.homeName);
    _timer.cancel();
  }

  void startTimer() async {
    _timer = new Timer(Duration(milliseconds: 3000), () {
      if (isFirstOpen) {
        navigateToGuide();
      } else {
        navigateToHome();
      }
    });
  }

  ///判断是否首次打开，如果首次打开返回 true，并设置已经打开过
  checkFirstOpened() async {
    bool containsFirstOpened = await Global.getPref().hasKey(firstOpened);
    if (!containsFirstOpened) {
      await Global.getPref().setStorage(firstOpened, true);
    }
    setState(() {
      isFirstOpen = !containsFirstOpened;
    });
  }
}

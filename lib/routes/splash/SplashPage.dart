import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/extension/ScreenExtension.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Theme(
      data: themeData,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("imgs/splash/bg_splash.jpg"),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "imgs/appicon/ic_launcher_512x512.png",
                        height: 90.pt,
                        width: 90.pt,
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 70.pt,bottom: 150.pt),
                    child: Text("Welcome to Flow",
                        style: TextStyle(
                            color: Color(0xFFD1D2D7), fontSize: 20.pt)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

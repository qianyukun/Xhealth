import 'package:flutter/material.dart';
import 'package:health/routes/breath/BreathRoute.dart';
import 'package:health/routes/breath/BreathSource.dart';
import 'package:health/extension/ScreenExtension.dart';

class BreatheResult extends StatefulWidget {
  static const String breatheResultName = "/breatheResult";

  @override
  State<StatefulWidget> createState() {
    return _BreatheResultState();
  }
}

class _BreatheResultState extends State<BreatheResult> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                margin: EdgeInsets.only(top: 84.pt),
                child: Text(
                  "Great",
                  style: TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                      fontSize: 24.pt),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 94.pt),
                  child: OutlinedButton(
                    onPressed: _restartBreath,
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
                          vertical: 14.pt, horizontal: 50.pt),
                      child: Text(
                        "Start Again",
                        style: TextStyle(
                            color: Color(0x6F86FF).withOpacity(0.8),
                            fontSize: 20.pt,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ))
            ],
          ))
        ],
      ),
    );
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

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  void _restartBreath() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("breathSource", () => BreathSource.home);
    Navigator.of(context)
        .popAndPushNamed(BreathRoute.breathRouteName, arguments: map);
  }
}

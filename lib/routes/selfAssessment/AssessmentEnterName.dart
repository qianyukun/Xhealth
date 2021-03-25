import 'package:flutter/material.dart';
import 'package:health/common/EventConstants.dart';
import 'package:health/common/Global.dart';
import 'package:health/report/ReportUtil.dart';

import 'SelfAssessmentRoute.dart';
import 'package:health/extension/ScreenExtension.dart';

class AssessmentEnterName extends StatefulWidget {
  static final nickName = "nick_name";
  final OnFinishCurrentPage onFinishEnterName;

  AssessmentEnterName({Key key, @required this.onFinishEnterName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AssessmentEnterName();
  }
}

class _AssessmentEnterName extends State<AssessmentEnterName> {
  TextEditingController nickNameController = TextEditingController();
  bool nameAvailable = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        reverse: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 52.pt, bottom: 59.pt),
              child: Text(
                "What would you like to be called?",
                style: TextStyle(
                    fontSize: 20.pt,
                    letterSpacing: 0.4.pt,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff333333)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 40.pt,
                  right: 40.pt,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextField(
                cursorWidth: 3.pt,
                showCursor: true,
                cursorColor: Color(0xFF6F86FF),
                cursorRadius: Radius.circular(5.pt),
                onChanged: _onNickNameChange,
                controller: nickNameController,
                maxLines: 1,
                maxLength: 12,
                decoration: InputDecoration(
                    hintText: "Your Nickname",
                    counterText: "",
                    hintStyle: TextStyle(color: Color(0xFFD1D2D7))),
                style: TextStyle(
                    fontSize: 24.pt,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333)),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 38.pt),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  backgroundColor: nameAvailable
                      ? MaterialStateProperty.all(Color(0xFF6F86FF))
                      : MaterialStateProperty.all(Color(0xFFDDDEE4)),
                ),
                onPressed: nameAvailable ? onNext : null,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.pt, vertical: 10.pt),
                  child: Wrap(
                    children: [
                      Text(
                        "Sweet",
                        style: TextStyle(
                            fontSize: 20.pt,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool checkNickName() {
    if (nickNameController.text.trim().length > 0) {
      return true;
    } else {
      return false;
    }
  }

  onNext() async {
    if (checkNickName()) {
      Map<String, dynamic> map = Map();
      map.putIfAbsent("name", () => nickNameController.text.trim());
      ReportUtil.getInstance()
          .trackEvent(eventName: EventConstants.nickname_next, parameters: map);
      Global.getPref().setStorage(
          AssessmentEnterName.nickName, nickNameController.text.trim());
      widget.onFinishEnterName();
    }
  }

  void _onNickNameChange(String value) {
    setState(() {
      nameAvailable = checkNickName();
    });
  }
}

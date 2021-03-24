import 'package:flutter/material.dart';

import 'SandTablePage.dart';
import 'package:health/extension/ScreenExtension.dart';

class SandTableRoute extends StatefulWidget {
  static const String sandTableName = "/sandTable";

  @override
  State<StatefulWidget> createState() {
    return _SandTableRouteState();
  }
}

class _SandTableRouteState extends State<SandTableRoute> {
  int moodCheckId;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    if (args.containsKey("moodCheckId")) {
      moodCheckId = args["moodCheckId"];

    }
    return SandTablePage(moodCheckId);
  }
}

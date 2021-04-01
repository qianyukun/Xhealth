import 'package:flutter/material.dart';
import 'package:health/common/Global.dart';
import 'package:health/report/ReportUtil.dart';
import 'package:health/routes/App.dart';
import 'package:firebase_core/firebase_core.dart';

import 'common/EventConstants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ReportUtil.getInstance().reportProperties();
  ReportUtil.getInstance().trackEvent(eventName: EventConstants.app_enter);
  Global.init().then((value) => runApp(App()));
}

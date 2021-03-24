import 'package:flutter/material.dart';
import 'package:health/common/Global.dart';
import 'package:health/routes/App.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Global.init().then((value) => runApp(App()));
}

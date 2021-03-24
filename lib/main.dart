import 'package:flutter/material.dart';
import 'package:health/common/Global.dart';
import 'package:health/routes/App.dart';

void main() {
  Global.init().then((value) => runApp(App()));
}

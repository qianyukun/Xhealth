// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/firebase_analytics.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class ReportUtil {
  static FirebaseAnalytics _analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver _observer =
      FirebaseAnalyticsObserver(analytics: _analytics);
  bool isReleaseMode = const bool.fromEnvironment("dart.vm.product");

  FirebaseAnalytics get firebaseAnalytics => _analytics;

  FirebaseAnalyticsObserver get firebaseAnalyticsObserver => _observer;

  ReportUtil._() {
    _analytics.setAnalyticsCollectionEnabled(true);
  }

  static ReportUtil _instance;

  static ReportUtil getInstance() {
    if (_instance == null) {
      _instance = ReportUtil._();
    }
    return _instance;
  }

  Future<void> trackEvent(
      {@required String eventName, Map<String, dynamic> parameters}) async {
    if (!isReleaseMode) {
      print(eventName +
          " " +
          ((parameters != null) ? parameters.toString() : ""));
      return ;
    }
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }
}

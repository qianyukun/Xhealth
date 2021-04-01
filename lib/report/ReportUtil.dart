// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:health/common/Global.dart';
import 'package:health/common/Md5Util.dart';
import 'package:health/common/ScreenUtils.dart';
import 'package:health/report/KikaReportUtil.dart';
import 'package:package_info/package_info.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> reportProperties() async {
    String countryCode = window.locale.countryCode;
    String languageCode = window.locale.languageCode;
    var packageInfo = await PackageInfo.fromPlatform();
    String appVersionName = packageInfo.version;
    String appVersionCode = packageInfo.buildNumber;
    String packageName = packageInfo.packageName;
    String dpi = ScreenUtils.getScreenWidth().round().toString();
    String osPlatform = "";
    String osVersion = "";
    if (Platform.isAndroid) {
      var androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      osPlatform = "ANDROID";
      osVersion = androidDeviceInfo.version.release;
    } else if (Platform.isIOS) {
      var iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
      osPlatform = "IOS";
      osVersion = iosDeviceInfo.systemVersion;
    }

    String duid = await Global.getPref().getStorage("duid");
    if (duid == null || duid.isEmpty) {
      duid = Uuid().v1().replaceAll("-", "");
      await Global.getPref().setStorage("duid", duid);
    }
    String appKey = "da4116c8e744844b1591f76931db5454";
    String USER_AGENT =
        "$packageName/$appVersionCode (${duid}/$appKey) Country/$countryCode "
        "Language/$languageCode System/$osPlatform Version/$osVersion Screen/$dpi";

    await _analytics.setUserProperty(name: "X_COUNTRY", value: countryCode);
    await _analytics.setUserProperty(name: "X_LANGUAGE", value: languageCode);
    await _analytics.setUserProperty(
        name: "X_VERSION_NAME", value: appVersionName);
    await _analytics.setUserProperty(
        name: "X_VERSION_CODE", value: appVersionCode);
    await _analytics.setUserProperty(
        name: "X_PACKAGE_NAME", value: packageName);
    await _analytics.setUserProperty(name: "X_PLATFORM", value: osPlatform);
    await _analytics.setUserProperty(name: "X_OS_VERSION", value: osVersion);
    await _analytics.setUserProperty(name: "X_DUID", value: duid);

    KikaReportUtil.user_agent = USER_AGENT;
    KikaReportUtil.sign = Md5Util.generateMd5(
        "app_key" + appKey + "app_version" + appVersionCode + "duid" + duid);
  }

  Future<void> trackEvent(
      {@required String eventName, Map<String, dynamic> parameters}) async {
    KikaReportUtil.getInstance()
        .trackEvent(eventName: eventName, parameters: parameters);
    if (!isReleaseMode) {
      print(eventName +
          " " +
          ((parameters != null) ? parameters.toString() : ""));
      return;
    }
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }
}

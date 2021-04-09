import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health/report/ReportUtil.dart';

import 'common/EventConstants.dart';
import 'common/FeedbackUtil.dart';
import 'common/Global.dart';

Future<RemoteMessage> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  print("back $message");
  return message;
}

class PushManager {
  String _token;

  PushManager._() {}

  static PushManager _instance;

  bool ios_pushNotificationPermission = false;

  static PushManager getInstance() {
    if (_instance == null) {
      _instance = PushManager._();
    }
    return _instance;
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      'This channel is used for important notifications.',
      importance: Importance.max);

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Stream<String> _tokenStream;

  void setToken(String token) {
    // print('FCM Token: $token');
    _token = token;
    saveTokenToDatabase(_token);
  }

  //保存duid和token的关系
  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = await Global.getPref().getStorage("duid");

    var documentSnapshot = await FirebaseFirestore.instance
        .collection('push_duid')
        .doc(userId)
        .get();
    if (!documentSnapshot.exists) {
      FirebaseFirestore.instance
          .collection('push_duid')
          .doc(userId)
          .set({"token": _token, "duid": userId})
          .then((value) => print("added!"))
          .catchError((error) => print(error));
    } else {
      FirebaseFirestore.instance
          .collection('push_duid')
          .doc(userId)
          .update({
            'token': token,
          })
          .then((value) => print("updated!"))
          .catchError((error) => print(error));
    }
  }

  init() async {
    await FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    initLocalNotification();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print("onMessage ${message}");
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print("onMessageOpenedApp ${message.data}");
      if (message.data.isNotEmpty) {
        // print(message.data);
        onSelectNotification(json.encode(message.data));
      }
    });
  }

  initLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<NotificationSettings> requestIosPermissions() async {
    if (Platform.isIOS) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      // print(settings.authorizationStatus);
    }
  }

  void showNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    if (notification != null && notification.android != null) {
      _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              importance: Importance.defaultImportance,
              priority: Priority.high,
              ongoing: false,
              icon: '@mipmap/ic_launcher',
              largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
              // styleInformation: DefaultStyleInformation(true, true),
            ),
          ),
          payload: json.encode(message.data));
    }
  }

  Future onSelectNotification(String payload) {
    Map messageData = json.decode(payload);
    if (messageData.isNotEmpty) {
      if (messageData["type"] == "1" && messageData["url"] != null) {
        ReportUtil.getInstance()
            .trackEvent(eventName: EventConstants.feedback_push_enter);
        FeedbackUtil.enterUrl(messageData["url"]);
      }
    }
  }
}

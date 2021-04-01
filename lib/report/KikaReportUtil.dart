import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class KikaReportUtil {
  bool isReleaseMode = const bool.fromEnvironment("dart.vm.product");
  static String user_agent = "";
  static String sign = "";
  Dio dio;

  KikaReportUtil._() {
    dio = Dio();
    dio.options.baseUrl = 'https://flow.dailyup.tech/';
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    if (!isReleaseMode) {
      dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  static KikaReportUtil _instance;

  static KikaReportUtil getInstance() {
    if (_instance == null) {
      _instance = KikaReportUtil._();
    }
    return _instance;
  }

  ///"转义成\"
  String mapToJsonString(Map<String, dynamic> parameters) {
    String sb = "";
    parameters.forEach((key, value) {
      if (sb.length > 0) {
        sb += ",";
      }
      sb += "\\\"$key\\\":\\\"$value\\\"";
    });
    return "{" + sb + "}";
  }

  Future<void> trackEvent(
      {String eventName, Map<String, dynamic> parameters}) async {
    if (!isReleaseMode) {
      print(eventName +
          " " +
          ((parameters != null) ? parameters.toString() : ""));
      return;
    }
    var body = "[" +
        json.encode({
          "eventName": eventName,
          "commitTime":
              DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
          "extra": parameters == null ? "{}" : mapToJsonString(parameters)
        }) +
        "]";

    dio.post("/v1/event/report",
        data: body,
        queryParameters: {"sign": sign},
        options: Options(headers: {HttpHeaders.userAgentHeader: user_agent}));
  }
}

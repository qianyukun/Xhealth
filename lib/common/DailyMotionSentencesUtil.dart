import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DailyMotionSentencesUtil {
  late List<DailyMotion> _dailyMotion = [];

  DailyMotionSentencesUtil._();

  static DailyMotionSentencesUtil? _instance;

  static DailyMotionSentencesUtil getInstance() {
    if (_instance == null) {
      _instance = DailyMotionSentencesUtil._();
    }
    return _instance!;
  }

  Future<DailyMotion> getSentence() async {
    if (_dailyMotion.length < 1) {
      String jsonString =
          await rootBundle.loadString("config/dailyMotionSentence.json");
      _dailyMotion = (json.decode(jsonString) as List).map((data)=>DailyMotion.fromJson(data)).toList();
    }
    int format = int.parse(DateFormat("m").format(DateTime.now()));
    Random random = Random(format);
    return _dailyMotion[random.nextInt(_dailyMotion.length) % _dailyMotion.length];
  }
}

class DailyMotion {
  final String sentence;
  final String author;

  DailyMotion(this.sentence, this.author);

  DailyMotion.fromJson(Map<String, dynamic> json)
      : sentence = json['sentence'],
        author = json['author'];

  Map<String, dynamic> toJson() =>
      {
        'sentence': sentence,
        'author': author,
      };

  @override
  String toString() {
    return 'DailyMotion{sentence: $sentence, author: $author}';
  }
}

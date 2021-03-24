import 'package:flutter/material.dart';

///Localizations类 用于语言资源整合
class StringLocalizations {
  final Locale locale;

  StringLocalizations(this.locale);


  ///此处通过静态方式来初始化
  static StringLocalizations? of(BuildContext context) {
    ///Localizations 是多国语言资源的汇总
    return Localizations.of<StringLocalizations>(context, StringLocalizations);
  }

  //根据不同locale.languageCode 加载不同语言对应
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app name': 'SunSpace',
    }
  };

  get appName {
    return _localizedValues[locale.languageCode]!['app name'];
  }

}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'StringLocalizations.dart';

class CustomLocalizationsDelegates
    extends LocalizationsDelegate<StringLocalizations> {
  ///构造
  const CustomLocalizationsDelegates();
  ///静态构造
  static CustomLocalizationsDelegates delegate = const CustomLocalizationsDelegates();

  @override
  bool isSupported(Locale locale) {
    return ['en'].contains(locale.languageCode);
  }

  @override //是否需要重载
  bool shouldReload(LocalizationsDelegate old) => false;

  ///通过方法的 locale 参数，判断需要加载的语言，然后返回自定义好多语言实现类
  ///最后通过静态 delegate 对外提供 LocalizationsDelegate。
  @override
  Future<StringLocalizations> load(Locale locale) {
    //加载本地化
    return SynchronousFuture<StringLocalizations>(StringLocalizations(locale));
  }
}
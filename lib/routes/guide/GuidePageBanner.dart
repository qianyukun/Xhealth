import 'package:flutter/foundation.dart';

class BannerBean {
  /// banner 地址
  String bannerUrl;

  /// banner 标题
  String bannerTitle;

  /// banner描述
  String bannerDesc;

  BannerBean(
      {@required this.bannerUrl,
      @required this.bannerTitle,
      @required this.bannerDesc});
}

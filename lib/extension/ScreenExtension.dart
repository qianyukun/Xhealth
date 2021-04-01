import 'package:health/common/ScreenUtils.dart';

/// 为num 添加扩充类 DeviceUnit 设备单位换算
extension IntDeviceUnit on int {
  /// [px] 为 以px为单位的 w_h 数值提供不同设备的尺寸适配
  double get px => ScreenUtils.pxFix(this);

  /// [dp] 为 以dp为单位的 w_h 数值提供不同设备的尺寸适配
  double get dp => ScreenUtils.dpFix(this);

  /// [pt] 为 以pt为单位的 w_h 数值提供不同设备的尺寸适配
  double get pt => ScreenUtils.ptFix(this);
}

extension DoubleDeviceUnit on double {
  /// [px] 为 以px为单位的 w_h 数值提供不同设备的尺寸适配
  double get px => ScreenUtils.pxFix(this);

  /// [dp] 为 以dp为单位的 w_h 数值提供不同设备的尺寸适配
  double get dp => ScreenUtils.dpFix(this);

  /// [pt] 为 以pt为单位的 w_h 数值提供不同设备的尺寸适配
  double get pt => ScreenUtils.ptFix(this);
}


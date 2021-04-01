import 'dart:ui';

class ScreenUtils {
  static num _screenW = 0; //设备的宽高
  static num _screenH = 0; //设备的宽高
  static num _statusBarH = 0; //设备的状态栏高度
  static num _devicePixelRatio = 0; // 设备的像素密度
  static Size _physicalSize = Size(0, 0); // 设备的尺寸... (px)
  static num _deviceScale = 0; // 基于iPhone6 的基本尺寸单位换算设备缩放比

  /// 初始化设备的宽高
  /// 全局记录设备的基本信息
  ScreenUtils.initDeviceW_H() {
    // 从 window对象获取屏幕的物理尺寸(px) 及 像素密度
    final physicalSize = window.physicalSize;
    final devicePixelRatio = window.devicePixelRatio;
    final padding = window.padding;

    ScreenUtils._devicePixelRatio = devicePixelRatio;
    ScreenUtils._physicalSize = physicalSize;

    // 计算出ios/android 常用的屏幕逻辑宽高 (dp / pt);
    ScreenUtils._screenW =
        ScreenUtils._physicalSize.width / ScreenUtils._devicePixelRatio;
    ScreenUtils._screenH =
        ScreenUtils._physicalSize.height / ScreenUtils._devicePixelRatio;
    ScreenUtils._statusBarH = padding.top / ScreenUtils._devicePixelRatio;

    // 基于6s机型(基于375,为了便捷查看,我们基于375的物理尺寸即750px为缩放基准),计算缩放比
    // 该缩放比 为 不同设备的的逻辑尺寸与 iPhone6s 的逻辑尺寸的缩放比
    ScreenUtils._deviceScale = ScreenUtils._screenW / (375);
  }
  
  static double getScreenWidth(){
    if (ScreenUtils._screenW <= 0 || ScreenUtils._screenW == null) {
      // 初始化一下
      ScreenUtils.initDeviceW_H();
    }
    return ScreenUtils._physicalSize.width;
  }

  /// 提供基于px的各机型尺寸适配换算
  /// 入参必须是以px为单位的宽高数值
  static pxFix(num w_h_px) {
    if (ScreenUtils._screenW <= 0 || ScreenUtils._screenW == null) {
      // 初始化一下
      ScreenUtils.initDeviceW_H();
    }
    return w_h_px / 2 * ScreenUtils._deviceScale;
  }

  /// 提供基于dp的各机型适配换算
  /// 入参必须是以dp为单位的宽高数值
  static dpFix(num w_h_dp) {
    if (ScreenUtils._screenW <= 0 || ScreenUtils._screenW == null) {
      // 初始化一下
      ScreenUtils.initDeviceW_H();
    }
    return w_h_dp * ScreenUtils._deviceScale;
  }

  /// 提供基于pt的各机型适配换算
  /// 入参必须是以pt为单位的宽高数值
  static ptFix(num w_h_pt) {
    if (ScreenUtils._screenW <= 0 || ScreenUtils._screenW == null) {
      // 初始化一下
      ScreenUtils.initDeviceW_H();
    }
    return w_h_pt * ScreenUtils._deviceScale;
  }
}


import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;

class Utils {
  final context;

  Utils({this.context}) : super();

  static double getWidth() {
    return ui.window.physicalSize.width;
  }

  static double getlRatio() {
    return ui.window.devicePixelRatio;
  }

  static double getHeight() {
    return ui.window.physicalSize.height;
  }

  static Future<ui.Image> getImage(
      String asset, int targetHeight, int targetWidth) async {
    ByteData data = await rootBundle.load(asset);
    Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: targetHeight, targetWidth: targetWidth);
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}

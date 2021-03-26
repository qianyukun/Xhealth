import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef MaskPainter = Function(Canvas canvas, Size size, Offset offset);
typedef IonFinish = Function();

class ScratchCardWidget extends StatefulWidget {
  final Widget child;
  final MaskPainter foreground;
  final double strokeWidth;
  final IonFinish onFinish;
  final double threshold;

  const ScratchCardWidget(
      {Key key,
      this.onFinish,
      this.child,
      this.foreground,
      this.strokeWidth,
      this.threshold})
      : assert(foreground != null),
        super(key: key);

  @override
  _ScratchCardWidgetState createState() => _ScratchCardWidgetState();
}

class _ScratchCardWidgetState extends State<ScratchCardWidget> {
  Path _path = Path();
  bool _complete = false;
  GlobalKey scratchCardRenderKey = new GlobalKey();
  final Set<Point<double>> points = Set();
  Set<Point<double>> checkPoints;
  Set<Point<double>> checkedPoints = Set();
  int totalCheckpoints = 0;
  MaskPainter foreground;

  @override
  void initState() {
    foreground = (canvas, size, offset) {
      if (totalCheckpoints == 0) {
        // print(" ${size.width} ${size.height} ${widget.strokeWidth}");
        _setCheckpoints(size);
      }
    };
    super.initState();
  }

  void _setCheckpoints(Size size) {
    final calculated = _calculateCheckpoints(size).toSet();
    checkPoints = calculated;
    totalCheckpoints = calculated.length;
    // print("total ${checkPoints.length} $totalCheckpoints");
  }

  List<Point<double>> _calculateCheckpoints(Size size) {
    final accuracy = 10;
    final xOffset = size.width / accuracy;
    final yOffset = size.height / accuracy;

    final points = <Point<double>>[];
    for (var x = 0; x < accuracy; x++) {
      for (var y = 0; y < accuracy; y++) {
        final point = Point(
          x * xOffset,
          y * yOffset,
        );
        points.add(point);
      }
    }

    return points;
  }

  bool _inCircle(Point center, Point point, double radius) {
    final dX = center.x - point.x;
    final dY = center.y - point.y;
    final multi = dX * dX + dY * dY;
    final distance = sqrt(multi).roundToDouble();

    return distance <= radius;
  }

  void addPoint(Point<double> point) async {
    if (checkedPoints == null || checkedPoints.contains(point)) {
      return;
    }
    checkedPoints.add(point);
    final reached = <Point<double>>{};
    for (final checkpoint in checkPoints) {
      final radius = widget.strokeWidth / 2;
      // print("tryadd  $point");
      if (_inCircle(checkpoint, point, radius)) {
        reached.add(checkpoint);
        points.add(checkpoint);
        // print("add checkpoint $checkpoint added count ${points.length}");
      }
    }
    checkPoints = checkPoints.difference(reached);
    // print("diffrence left points  ${checkPoints.length}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (detail) {
          if (_complete) {
            return;
          }
          _path.lineTo(detail.globalPosition.dx, detail.globalPosition.dy);
          addPoint(Point(detail.globalPosition.dx, detail.globalPosition.dy));
          setState(() {});
        },
        onPanStart: (detail) {
          if (_complete) {
            return;
          }
          _path.moveTo(detail.globalPosition.dx, detail.globalPosition.dy);
          addPoint(Point(detail.globalPosition.dx, detail.globalPosition.dy));
          setState(() {});
        },
        onPanEnd: (detail) {
          if (_complete) {
            return;
          }
          if (points != null) {
            // print("${points.length} ${totalCheckpoints * widget.threshold}");
            if (points.length > totalCheckpoints * widget.threshold) {
              setState(() {
                // print("done");
                _complete = true;
                widget.onFinish();
              });
            }
          }
        },
        child: _complete
            ? widget.child
            : RepaintBoundary(
                child: _ScratchCardRenderWidget(
                key: scratchCardRenderKey,
                child: widget.child,
                path: _path,
                foreground: (canvas, size, offset) {
                  foreground.call(canvas, size, offset);
                  widget.foreground.call(canvas, size, offset);
                },
                strokeWidth: widget.strokeWidth,
              )));
  }
}

class _ScratchCardRenderWidget extends SingleChildRenderObjectWidget {
  final Path path;
  final MaskPainter foreground;
  final double strokeWidth;

  const _ScratchCardRenderWidget(
      {Key key, Widget child, this.path, this.foreground, this.strokeWidth})
      : super(key: key, child: child);

  @override
  _ScratchCardRenderObject createRenderObject(BuildContext context) {
    return _ScratchCardRenderObject(
        path: path, foreground: foreground, strokeWidth: strokeWidth);
  }

  @override
  void updateRenderObject(
      BuildContext context, _ScratchCardRenderObject renderObject) {
    renderObject.path = path;
    renderObject.strokeWidth = strokeWidth;
    renderObject.foreground = foreground;
    renderObject.updatePoint();
  }
}

class _ScratchCardRenderObject extends RenderProxyBox {
  _ScratchCardRenderObject(
      {RenderBox child, this.path, this.foreground, this.strokeWidth})
      : super(child);

  MaskPainter foreground;

  Path path;

  double strokeWidth;

  void updatePoint() {
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    context.canvas.saveLayer(
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height), Paint());
    context.canvas.translate(offset.dx, offset.dy);
    foreground(context.canvas, size, offset);
    var eraserPaint = Paint();
    eraserPaint.color = Colors.transparent;
    eraserPaint.style = PaintingStyle.stroke;
    eraserPaint.strokeWidth = strokeWidth == null ? 20 : strokeWidth;
    eraserPaint.strokeCap = StrokeCap.round;
    eraserPaint.strokeJoin = StrokeJoin.round;
    eraserPaint.blendMode = BlendMode.dstIn;
    eraserPaint.isAntiAlias = true;
    if (path != null) {
      var toGlobal = localToGlobal(Offset(0, 0));
      var _path = path.shift(-toGlobal);
      context.canvas.drawPath(_path, eraserPaint);
    }
    context.canvas.restore();
  }
}

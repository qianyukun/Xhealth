import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  // double? _dragValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SliderTheme(
          data: SliderThemeData(
              trackHeight: 2,
              thumbShape: HiddenThumbComponentShape(),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              overlayColor: Colors.transparent,
              trackShape: MyRoundedRectSliderTrackShape()),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: widget.position.inMilliseconds.toDouble(),
              onChanged: (value) {
                // setState(() {
                //   _dragValue = value;
                // });
                // if (widget.onChanged != null) {
                //   widget.onChanged!(Duration(milliseconds: value.round()));
                // }
              },
              // onChangeEnd: (value) {
              //   if (widget.onChangeEnd != null) {
              //     widget.onChangeEnd!(Duration(milliseconds: value.round()));
              //   }
              //   _dragValue = null;
              // },
            ),
          ),
        ),
        // SliderTheme(
        //   data: _sliderThemeData.copyWith(
        //     inactiveTrackColor: Colors.transparent,
        //   ),
        //   child: Slider(
        //     min: 0.0,
        //     max: widget.duration.inMilliseconds.toDouble(),
        //     value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
        //         widget.duration.inMilliseconds.toDouble()),
        //     onChanged: (value) {
        //     //   setState(() {
        //     //     _dragValue = value;
        //     //   });
        //     //   if (widget.onChanged != null) {
        //     //     widget.onChanged!(Duration(milliseconds: value.round()));
        //     //   }
        //     },
        //     // onChangeEnd: (value) {
        //     //   if (widget.onChangeEnd != null) {
        //     //     widget.onChangeEnd!(Duration(milliseconds: value.round()));
        //     //   }
        //     //   _dragValue = null;
        //     // },
        //   ),
        // ),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 22),
              child: Text(
                  RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                          .firstMatch("${widget.position}")
                          ?.group(1) ??
                      '${widget.position}',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
            )),
            Align(
                child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                  RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                          .firstMatch("${widget.duration}")
                          ?.group(1) ??
                      '${widget.duration}',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
            ))
          ],
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class MyRoundedRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const MyRoundedRectSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting  can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius = Radius.circular(trackRect.height / 2 + 1);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}

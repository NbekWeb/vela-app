import 'package:flutter/material.dart';

class FullWidthTrackShape extends SliderTrackShape {
  const FullWidthTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    Offset? secondaryOffset,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.blue
      ..style = PaintingStyle.fill;
    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.grey
      ..style = PaintingStyle.fill;

    // Draw left (active) track
    if (thumbCenter.dx > trackRect.left) {
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            trackRect.left,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
          ),
          const Radius.circular(4),
        ),
        activePaint,
      );
    }
    // Draw right (inactive) track
    if (thumbCenter.dx < trackRect.right) {
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            thumbCenter.dx,
            trackRect.top,
            trackRect.right,
            trackRect.bottom,
          ),
          const Radius.circular(4),
        ),
        inactivePaint,
      );
    }
  }
}

class AudioSliderTrackShape extends SliderTrackShape {
  const AudioSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 6;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    Offset? secondaryOffset,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Create gradient for active track
    final Paint activePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFC9DFF4),
          Colors.white,
        ],
      ).createShader(trackRect)
      ..style = PaintingStyle.fill;

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw inactive track background
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(
        trackRect,
        const Radius.circular(3),
      ),
      inactivePaint,
    );

    // Draw active track with gradient
    if (thumbCenter.dx > trackRect.left) {
      final activeRect = Rect.fromLTRB(
        trackRect.left,
        trackRect.top,
        thumbCenter.dx,
        trackRect.bottom,
      );
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(
          activeRect,
          const Radius.circular(3),
        ),
        activePaint,
      );
    }
  }
} 
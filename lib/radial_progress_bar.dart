import 'dart:math';
import 'package:flutter/material.dart';


class RadialProgressBar extends StatefulWidget {

  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;

  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;

  final Widget child;

  RadialProgressBar({
    this.trackWidth = 3.0,
    this.trackColor = Colors.grey,
    this.progressWidth = 5.0,
    this.progressColor = Colors.black,
    this.progressPercent = 0.0,
    this.thumbSize = 10.0,
    this.thumbColor = Colors.black,
    this.thumbPosition = 0.0,
    this.outerPadding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0),
    this.child,
  });

  @override
  _RadialProgressBar createState() => _RadialProgressBar
();
}

class _RadialProgressBar extends State<RadialProgressBar> {
  EdgeInsets _insetsForPainter() {
    // Make room for painted track, progress, and thumb.
    final outerThickness = max(
      widget.trackWidth,
      max(widget.progressWidth, widget.thumbSize)
    ) / 2.0;

    return EdgeInsets.all(outerThickness) + widget.innerPadding;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: CustomPaint(
        foregroundPainter: RadialProgressBarPainter(
          trackWidth: widget.trackWidth,
          trackColor: widget.trackColor,
          progressWidth: widget.progressWidth,
          progressColor: widget.progressColor,
          progressPercent: widget.progressPercent,
          thumbSize: widget.thumbSize,
          thumbColor: widget.thumbColor,
          thumbPosition: widget.thumbPosition,
        ),
        child: Padding(
          padding: _insetsForPainter(),
          child: widget.child,
        ),
      ),
    );
  }
}

class RadialProgressBarPainter extends CustomPainter {

  final double trackWidth;
  final Paint trackPaint;

  final double progressWidth;
  final double progressPercent;
  final Paint progressPaint;

  final double thumbSize;
  final double thumbPosition;
  final Paint thumbPaint;

  RadialProgressBarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required progressColor,
    @required this.progressPercent,
    @required this.thumbSize,
    @required thumbColor,
    @required this.thumbPosition,
  }) : trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth,
       progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = progressWidth
        ..strokeCap = StrokeCap.round,
       thumbPaint = Paint()
        ..color = thumbColor
        ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    Size constrainedSize = Size(
      size.width - outerThickness,
      size.height - outerThickness,
    );

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(constrainedSize.width, constrainedSize.height) / 2;

    canvas.drawCircle(center, radius, trackPaint);

    final progressAngle = 2 * pi * progressPercent;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      progressAngle,
      false,
      progressPaint
    );

    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = Offset(thumbX, thumbY) + center;
    final thumbRadius = thumbSize / 2.0;

    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

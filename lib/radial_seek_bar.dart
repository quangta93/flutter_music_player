import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fluttery/gestures.dart';

import 'radial_progress_bar.dart';
import 'songs.dart';
import 'theme.dart';


class RadialSeekBar extends StatefulWidget {

  final double progress;
  final double seekPercent;
  final Function(double) onSeekRequested;
  final Widget child;

  RadialSeekBar({
    this.progress = 0.0,
    this.seekPercent = 0.0,
    this.onSeekRequested,
    this.child,
  });

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {

  double _progress = 0.0;
  PolarCoord _startCoord;
  double _startDragPercent;
  double _currentDragPercent;

  @override
  void initState() {
    super.initState();

    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    _progress = widget.progress;
  }

  void _onDragStart(PolarCoord coord) {
    _startCoord = coord;
    _startDragPercent = _progress;
  }

  void _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startCoord.angle;
    final dragPercent = dragAngle / (2 * pi);

    setState(() {
      _currentDragPercent = (_startDragPercent + dragPercent) % 1.0;
    });
  }

  void _onDragEnd() {
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }

    setState(() {
      _currentDragPercent = null;
      _startCoord = null;
      _startDragPercent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition = _progress;

    if (_currentDragPercent != null) {
      // dragging
      thumbPosition = _currentDragPercent;
    } else if (widget.seekPercent != null) {
      // seeking
      thumbPosition = widget.seekPercent;
    }

    return RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 140.0,
            height: 140.0,
            child: RadialProgressBar(
              trackColor: Color(0xFFDDDDDD),
              progressPercent: _progress, // _progress is the real progress of the audio
              progressColor: accentColor,
              thumbPosition: thumbPosition,
              thumbColor: lightAccentColor,
              innerPadding: EdgeInsets.all(10.0),
              child: ClipOval(
                clipper: CircleClipper(),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
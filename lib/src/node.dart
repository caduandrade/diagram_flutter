import 'package:diagram/src/bounds.dart';
import 'package:flutter/material.dart';

abstract class DiagramNode {
  final Key key = UniqueKey();

  Bounds _bounds = Bounds(left: 0, top: 0, width: 0, height: 0);
  Bounds get bounds => _bounds;

  ScaledBounds? _scaledBounds;

  ScaledBounds scaledBounds(double scale) {
    if (_scaledBounds == null || _scaledBounds!.scale != scale) {
      _scaledBounds = ScaledBounds(scale: scale, bounds: bounds);
    }
    return _scaledBounds!;
  }

  void setLocation({required int x, required int y}) {
    _bounds =
        Bounds(left: x, top: y, width: _bounds.width, height: _bounds.height);
  }

  void setSize({required int width, required int height}) {
    _bounds = Bounds(
        left: _bounds.left, top: _bounds.top, width: width, height: height);
  }

  void setBounds(
      {required int x,
      required int y,
      required int width,
      required int height}) {
    _bounds = Bounds(left: x, top: y, width: width, height: height);
  }

  Widget build(
      {required BuildContext context,
      required double scale,
      required double viewportWidth,
      required double viewportHeight});
}

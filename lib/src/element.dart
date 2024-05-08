import 'package:flutter/material.dart';

abstract class DiagramElement {
  final Key key = UniqueKey();

  Rect _bounds = Rect.zero;
  Rect get bounds => _bounds;

  void setLocation({required double x, required double y}) {
    _bounds = Rect.fromLTWH(x, y, _bounds.width, _bounds.height);
  }

  void setSize({required double width, required double height}) {
    _bounds = Rect.fromLTWH(_bounds.left, _bounds.top, width, height);
  }

  void setBounds(
      {required double x,
      required double y,
      required double width,
      required double height}) {
    _bounds = Rect.fromLTWH(x, y, width, height);
  }

  Widget build(BuildContext context);
}

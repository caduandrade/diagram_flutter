import 'package:diagram/src/element.dart';
import 'package:diagram/src/model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
class DiagramViewportLayout extends StatelessWidget {
  const DiagramViewportLayout(
      {super.key, required this.model, required this.offset});

  final DiagramModel model;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (DiagramElement element in model.elements) {
      children.add(LayoutId(
          key: element.key, id: element.key, child: element.build(context)));
    }
    return CustomMultiChildLayout(
        delegate: _LayoutDelegate(model: model, offset: offset),
        children: children);
  }
}

class _LayoutDelegate extends MultiChildLayoutDelegate {
  _LayoutDelegate({required this.model, required this.offset});

  final DiagramModel model;
  final Offset offset;

  @override
  void performLayout(Size size) {
    for (DiagramElement element in model.elements) {
      layoutChild(
          element.key,
          BoxConstraints.tightFor(
              width: element.bounds.width, height: element.bounds.height));
      positionChild(
          element.key,
          Offset(
              element.bounds.left + offset.dx, element.bounds.top + offset.dy));
    }
  }

  @override
  bool shouldRelayout(covariant _LayoutDelegate oldDelegate) {
    return true;
  }
}

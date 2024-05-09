import 'package:diagram/src/node.dart';
import 'package:diagram/src/model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
class DiagramViewportLayout extends StatelessWidget {
  const DiagramViewportLayout(
      {super.key,
      required this.model,
      required this.offset,
      required this.width,
      required this.height});

  final DiagramModel model;
  final double width;
  final double height;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (DiagramNode node in model.nodes) {
      children.add(LayoutId(
          key: node.key,
          id: node.key,
          child: node.build(
              context: context,
              scale: model.scale,
              viewportWidth: width,
              viewportHeight: height)));
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
    for (DiagramNode node in model.nodes) {
      layoutChild(
          node.key,
          BoxConstraints.tightFor(
              width: node.bounds.width * model.scale,
              height: node.bounds.height * model.scale));
      positionChild(
          node.key,
          Offset((node.bounds.left * model.scale) + offset.dx,
              (node.bounds.top * model.scale) + offset.dy));
    }
  }

  @override
  bool shouldRelayout(covariant _LayoutDelegate oldDelegate) {
    return true;
  }
}

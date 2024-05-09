import 'package:diagram/src/bounds.dart';
import 'package:diagram/src/node.dart';
import 'package:diagram/src/controller.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
class DiagramViewportLayout extends StatelessWidget {
  const DiagramViewportLayout(
      {super.key,
      required this.controller,
      required this.width,
      required this.height});

  final DiagramController controller;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (DiagramNode node in controller.nodes) {
      children.add(LayoutId(
          key: node.key,
          id: node.key,
          child: node.build(
              context: context,
              scale: controller.scale,
              viewportWidth: width,
              viewportHeight: height)));
    }
    // print('nodes: ${children.length}');
    return CustomMultiChildLayout(
        delegate: _LayoutDelegate(controller: controller), children: children);
  }
}

class _LayoutDelegate extends MultiChildLayoutDelegate {
  _LayoutDelegate({required this.controller});

  final DiagramController controller;

  @override
  void performLayout(Size size) {
    for (DiagramNode node in controller.nodes) {
      ScaledBounds bounds = node.scaledBounds(controller.scale);
      layoutChild(
          node.key,
          BoxConstraints.tightFor(
              width: bounds.width.toDouble(),
              height: bounds.height.toDouble()));
      positionChild(
          node.key,
          Offset((bounds.left + controller.translation.x).toDouble(),
              (bounds.top + controller.translation.y).toDouble()));
    }
  }

  @override
  bool shouldRelayout(covariant _LayoutDelegate oldDelegate) {
    return true;
  }
}

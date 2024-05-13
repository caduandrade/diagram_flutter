import 'package:diagram/src/node.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SquareNode extends DiagramNode {
  SquareNode({required this.color});

  final Color color;

  @override
  Widget build(
      {required BuildContext context,
      required double scale,
      required double viewportWidth,
      required double viewportHeight}) {
    return _SquareWidget(node: this);
  }
}

class _SquareWidget extends StatefulWidget {
  const _SquareWidget({required this.node});

  final SquareNode node;

  @override
  State<StatefulWidget> createState() => _SquareWidgetState();
}

class _SquareWidgetState extends State<_SquareWidget> {
  bool over = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        child: Container(
            color: widget.node.color,
            child: over ? const Placeholder() : null));
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      over = true;
    });
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      over = false;
    });
  }
}

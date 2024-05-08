import 'package:diagram/src/element.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SquareElement extends DiagramElement {
  SquareElement({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return _SquareWidget(element: this);
  }
}

class _SquareWidget extends StatefulWidget {
  const _SquareWidget({required this.element});

  final SquareElement element;

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
            color: widget.element.color,
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

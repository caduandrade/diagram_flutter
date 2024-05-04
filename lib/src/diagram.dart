import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Diagram extends StatelessWidget {
  final Random random = Random();

  Diagram({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (int i = 0; i < 1000; i++) {
      children.add(LayoutId(id: i, child: randomWidget(i)));
    }

    return CustomMultiChildLayout(
        delegate: _LayoutDelegate(children.length), children: children);
  }

  Widget randomWidget(int i) {
    Color color = Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
    return _Child(color: color);
  }
}

class _Child extends StatefulWidget {
  const _Child({required this.color});

  final Color color;

  @override
  State<StatefulWidget> createState() => _ChildState();
}

class _ChildState extends State<_Child> {
  bool over = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: _onEnter,
        onExit: _onExit,
        child: Container(
            color: widget.color, child: over ? const Placeholder() : null));
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

class _LayoutDelegate extends MultiChildLayoutDelegate {
  _LayoutDelegate(this.count);

  int count;

  @override
  void performLayout(Size size) {
    Random random = Random();
    for (int i = 0; i < count; i++) {
      layoutChild(i, const BoxConstraints.tightFor(width: 50, height: 50));
      positionChild(
          i,
          Offset(random.nextInt(size.width.toInt()).toDouble() - 50,
              random.nextInt(size.height.toInt()).toDouble() - 50));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

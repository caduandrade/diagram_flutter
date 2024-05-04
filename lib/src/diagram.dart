import 'dart:math';
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
    return Container(
        color: Color.fromARGB(255, random.nextInt(255), random.nextInt(255),
            random.nextInt(255)));
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

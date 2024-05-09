import 'package:diagram/src/viewport.dart';
import 'package:diagram/src/controller.dart';
import 'package:flutter/material.dart';

class Diagram extends StatefulWidget {
  const Diagram({super.key});

  @override
  State<StatefulWidget> createState() => _DiagramState();
}

class _DiagramState extends State<Diagram> {
  final DiagramController _controller = DiagramController();

  @override
  void initState() {
    super.initState();
    DiagramControllerFactory.addSquares(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return DiagramViewport(controller: _controller);
  }
}

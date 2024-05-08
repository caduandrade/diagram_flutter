import 'package:diagram/src/viewport.dart';
import 'package:diagram/src/model.dart';
import 'package:flutter/material.dart';

class Diagram extends StatefulWidget {
  const Diagram({super.key});

  @override
  State<StatefulWidget> createState() => _DiagramState();
}

class _DiagramState extends State<Diagram> {
  final DiagramModel _model = DiagramModel();

  @override
  void initState() {
    super.initState();
    DiagramModelFactory.addSquares(_model);
  }

  @override
  Widget build(BuildContext context) {
    return DiagramViewport(model: _model);
  }
}

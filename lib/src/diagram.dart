import 'package:diagram/src/debug_notifier.dart';
import 'package:diagram/src/viewport.dart';
import 'package:diagram/src/controller.dart';
import 'package:flutter/material.dart';

class Diagram extends StatefulWidget {
  const Diagram({super.key, this.controller, this.debugNotifier});

  final DebugNotifier? debugNotifier;
  final DiagramController? controller;

  @override
  State<StatefulWidget> createState() => _DiagramState();
}

class _DiagramState extends State<Diagram> {
  late DiagramController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller != null ? widget.controller! : DiagramController();
    DiagramControllerFactory.addSquares(_controller);
  }

  @override
  void didUpdateWidget(covariant Diagram oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != widget.controller) {
      _controller = widget.controller!;
    }
    _controller =
        widget.controller != null ? widget.controller! : DiagramController();
  }

  @override
  Widget build(BuildContext context) {
    return DiagramViewport(
        controller: _controller, debugNotifier: widget.debugNotifier);
  }
}

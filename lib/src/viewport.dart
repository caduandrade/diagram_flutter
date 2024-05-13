import 'package:diagram/src/bounds.dart';
import 'package:diagram/src/controller.dart';
import 'package:diagram/src/debug_notifier.dart';
import 'package:diagram/src/notifier.dart';
import 'package:diagram/src/translation.dart';
import 'package:diagram/src/viewport_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
class DiagramViewport extends StatefulWidget {
  const DiagramViewport(
      {super.key, required this.controller, required this.debugNotifier});

  final DiagramController controller;
  final DebugNotifier? debugNotifier;

  @override
  State<StatefulWidget> createState() => _DiagramViewportState();
}

class _DiagramViewportState extends State<DiagramViewport> {
  bool _dragging = false;
  double _width = double.nan;
  double _height = double.nan;

  @override
  Widget build(BuildContext context) {
    Notifier notifier =
        DiagramControllerHelper.viewportNotifier(widget.controller);
    return ListenableBuilder(
        listenable: notifier,
        builder: (context, child) => LayoutBuilder(builder: _builder));
  }

  Widget _builder(BuildContext context, BoxConstraints constraints) {
    if (_width != constraints.maxWidth || _height != constraints.maxHeight) {
      Translation translation = _createValidTranslation(
          x: widget.controller.translation.x,
          y: widget.controller.translation.y,
          viewportWidth: constraints.maxWidth.toInt(),
          viewportHeight: constraints.maxHeight.toInt());
      DiagramControllerHelper.updateTranslation(
          widget.controller, translation, false);
      _width = constraints.maxWidth;
      _height = constraints.maxHeight;
    }

    return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _onDragDown,
        onPointerUp: (event) => _onDragStop(),
        onPointerCancel: (event) => _onDragStop(),
        onPointerMove: _onDragUpdate,
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            _onZoom(event.scrollDelta.dy < 0);
          }
        },
        child: IgnorePointer(
            ignoring: _dragging,
            child: DiagramViewportLayout(
                controller: widget.controller,
                debugNotifier: widget.debugNotifier,
                width: _width,
                height: _height)));
  }

  void _onDragDown(PointerDownEvent event) {
    if (event.buttons == kMiddleMouseButton) {
      setState(() {
        _dragging = true;
      });
    }
  }

  void _onDragStop() {
    if (_dragging) {
      setState(() {
        _dragging = false;
      });
    }
  }

  void _onDragUpdate(PointerMoveEvent event) {
    if (_dragging && event.buttons == kMiddleMouseButton) {
      Translation translation = _createValidTranslation(
          x: widget.controller.translation.x + event.delta.dx.toInt(),
          y: widget.controller.translation.y + event.delta.dy.toInt(),
          viewportWidth: _width.toInt(),
          viewportHeight: _height.toInt());
      DiagramControllerHelper.updateTranslation(
          widget.controller, translation, true);
    }
  }

  void _onZoom(bool zoomIn) {
    double scale = widget.controller.scale * (zoomIn ? 1.05 : 0.95);
    DiagramControllerHelper.updateScale(widget.controller, scale);
  }

  Translation _createValidTranslation(
      {required int x,
      required int y,
      required int viewportWidth,
      required int viewportHeight}) {
    ScaledBounds bounds = widget.controller.scaledBounds;
    if (bounds.left + x > viewportWidth) {
      // dragging to right
      x = viewportWidth;
    } else if (bounds.right + x < 0) {
      // dragging to left
      x = -bounds.width;
    }

    if (bounds.top + y > viewportHeight) {
      y = viewportHeight;
    } else if (bounds.bottom + y < 0) {
      y = -bounds.height;
    }
    return Translation(x, y);
  }
}

import 'package:diagram/src/model.dart';
import 'package:diagram/src/viewport_layout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DiagramViewport extends StatefulWidget {
  const DiagramViewport({super.key, required this.model});

  final DiagramModel model;

  @override
  State<StatefulWidget> createState() => _DiagramViewportState();
}

class _DiagramViewportState extends State<DiagramViewport> {
  bool _dragging = false;
  double _width = double.nan;
  double _height = double.nan;
  Offset _modelOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _builder);
  }

  Widget _builder(BuildContext context, BoxConstraints constraints) {
    if (_width != constraints.maxWidth || _height != constraints.maxHeight) {
      _modelOffset = _createValidOffset(
          x: _modelOffset.dx,
          y: _modelOffset.dy,
          viewportWidth: constraints.maxWidth,
          viewportHeight: constraints.maxHeight);
      _width = constraints.maxWidth;
      _height = constraints.maxHeight;
    }

    return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          if (event.buttons == kMiddleMouseButton) {
            setState(() {
              _dragging = true;
            });
          }
        },
        onPointerUp: (e) {
          if (_dragging) {
            setState(() {
              _dragging = false;
            });
          }
        },
        onPointerCancel: (e) {
          if (_dragging) {
            setState(() {
              _dragging = false;
            });
          }
        },
        onPointerMove: (event) {
          if (_dragging && event.buttons == kMiddleMouseButton) {
            Offset newOffset = _createValidOffset(
                x: _modelOffset.dx + event.delta.dx,
                y: _modelOffset.dy + event.delta.dy,
                viewportWidth: _width,
                viewportHeight: _height);
            if (_modelOffset != newOffset) {
              setState(() {
                _modelOffset = newOffset;
              });
            }
          }
        },
        child: IgnorePointer(
            ignoring: _dragging,
            child: DiagramViewportLayout(
                model: widget.model, offset: _modelOffset)));
  }

  Offset _createValidOffset(
      {required double x,
      required double y,
      required double viewportWidth,
      required double viewportHeight}) {
    if (widget.model.bounds.left + x > viewportWidth) {
      x = viewportWidth;
    } else if (widget.model.bounds.right + x < 0) {
      x = -widget.model.bounds.width;
    }

    if (widget.model.bounds.top + y > viewportHeight) {
      y = viewportHeight;
    } else if (widget.model.bounds.bottom + y < 0) {
      y = -widget.model.bounds.height;
    }
    return Offset(x, y);
  }
}

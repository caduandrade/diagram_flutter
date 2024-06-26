import 'dart:collection';
import 'dart:math' as math;

import 'package:diagram/src/bounds.dart';
import 'package:diagram/src/node.dart';
import 'package:diagram/src/nodes/tank_node.dart';
import 'package:diagram/src/notifier.dart';
import 'package:diagram/src/nodes/square_node.dart';
import 'package:diagram/src/translation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class DiagramController {
  final Notifier _viewportNotifier = Notifier();

  final List<DiagramNode> _nodes = [];
  UnmodifiableListView<DiagramNode>? _unmodifiableNodes;
  List<DiagramNode> get nodes {
    _unmodifiableNodes ??= UnmodifiableListView(_nodes);
    return _unmodifiableNodes!;
  }

  int get count => _nodes.length;

  Bounds? _bounds;
  Bounds get bounds {
    if (_bounds == null) {
      int left = 0;
      int top = 0;
      int right = 0;
      int bottom = 0;
      for (int index = 0; index < _nodes.length; index++) {
        DiagramNode node = _nodes[index];
        if (index == 0) {
          left = node.bounds.left;
          top = node.bounds.top;
          right = node.bounds.right;
          bottom = node.bounds.bottom;
        } else {
          left = math.min(left, node.bounds.left);
          top = math.min(top, node.bounds.top);
          right = math.max(right, node.bounds.right);
          bottom = math.max(bottom, node.bounds.bottom);
        }
      }
      _bounds = Bounds(
          left: left, top: top, width: right - left, height: bottom - top);
    }
    return _bounds!;
  }

  ScaledBounds? _scaledBounds;

  ScaledBounds get scaledBounds {
    if (_scaledBounds == null || _scaledBounds!.scale != scale) {
      _scaledBounds = ScaledBounds(scale: scale, bounds: bounds);
    }
    return _scaledBounds!;
  }

  double _scale = 1;
  double get scale => _scale;
  void _updateScale(double scale) {
    if (_scale != scale) {
      _scale = scale;
      _scaledBounds = null;
      _viewportNotifier.notify();
    }
  }

  Translation _translation = Translation(0, 0);
  Translation get translation => _translation;
  void _updateTranslation(Translation translation, bool notify) {
    if (_translation != translation) {
      _translation = translation;
      if (notify) {
        _viewportNotifier.notify();
      }
    }
  }

  void add(DiagramNode node) {
    _nodes.add(node);
    _bounds = bounds.expandToInclude(node.bounds);
    _scaledBounds = null;
  }

  void addAll(Iterable<DiagramNode> list) {
    for (DiagramNode node in list) {
      _nodes.add(node);
      _bounds = bounds.expandToInclude(node.bounds);
      _scaledBounds = null;
    }
  }
}

class DiagramControllerFactory {
  static void addSquares(DiagramController controller) {
    List<DiagramNode> nodes = [];
    math.Random random = math.Random();
    for (int i = 0; i < 5; i++) {
      Color color = Color.fromARGB(
          255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
      SquareNode squareNode = SquareNode(color: color);
      squareNode.setBounds(
          x: random.nextInt(450),
          y: random.nextInt(450),
          width: 50,
          height: 50);
      nodes.add(squareNode);

      TankNode tankNode = TankNode();
      tankNode.setBounds(
          x: random.nextInt(450),
          y: random.nextInt(450),
          width: 50,
          height: 50);
      nodes.add(tankNode);
    }
    controller.addAll(nodes);
  }
}

@internal
class DiagramControllerHelper {
  static Notifier viewportNotifier(DiagramController controller) =>
      controller._viewportNotifier;

  static void updateScale(DiagramController controller, double scale) {
    controller._updateScale(scale);
  }

  static void updateTranslation(
      DiagramController controller, Translation translation, bool notify) {
    controller._updateTranslation(translation, notify);
  }
}

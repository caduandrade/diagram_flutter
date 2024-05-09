import 'dart:math' as math;

import 'package:diagram/src/node.dart';
import 'package:diagram/src/square_node.dart';
import 'package:flutter/material.dart';

class DiagramModel {
  final Map<Key, DiagramNode> _nodes = {};

  Rect _bounds = Rect.zero;

  Rect get bounds => _bounds;

  double _scale = 1;
  double get scale => _scale;
  set scale(double value) {
    if (_scale != value) {
      _scale = value;
      _calculateBounds();
    }
  }

  Iterable<DiagramNode> get nodes => _nodes.values;

  int get count => _nodes.length;

  DiagramNode? get(Key key) {
    return _nodes[key];
  }

  void add(DiagramNode node) {
    _nodes[node.key] = node;
    _calculateBounds();
  }

  void addAll(Iterable<DiagramNode> list) {
    for (DiagramNode node in list) {
      _nodes[node.key] = node;
    }
    _calculateBounds();
  }

  void _calculateBounds() {
    if (_nodes.isEmpty) {
      _bounds = Rect.zero;
    } else {
      double left = double.maxFinite;
      double top = double.maxFinite;
      double right = double.minPositive;
      double bottom = double.minPositive;
      for (DiagramNode node in _nodes.values) {
        left = math.min(left, node.bounds.left);
        top = math.min(top, node.bounds.top);
        right = math.max(right, node.bounds.right);
        bottom = math.max(bottom, node.bounds.bottom);
      }
      _bounds = Rect.fromLTRB(
          left * _scale, top * _scale, right * _scale, bottom * _scale);
    }
  }
}

class DiagramModelFactory {
  static void addSquares(DiagramModel model) {
    List<DiagramNode> nodes = [];
    math.Random random = math.Random();
    for (int i = 0; i < 1000; i++) {
      Color color = Color.fromARGB(
          255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
      SquareNode node = SquareNode(color: color);
      node.setBounds(
          x: random.nextInt(450).toDouble(),
          y: random.nextInt(450).toDouble(),
          width: 50,
          height: 50);
      nodes.add(node);
    }
    model.addAll(nodes);
  }
}

import 'dart:math' as math;

import 'package:diagram/src/element.dart';
import 'package:diagram/src/square_element.dart';
import 'package:flutter/material.dart';

class DiagramModel {
  final Map<Key, DiagramElement> _elements = {};

  Rect _bounds = Rect.zero;

  Rect get bounds => _bounds;

  Iterable<DiagramElement> get elements => _elements.values;

  int get count => _elements.length;

  DiagramElement? get(Key key) {
    return _elements[key];
  }

  void add(DiagramElement element) {
    _elements[element.key] = element;
    _calculateBounds();
  }

  void addAll(Iterable<DiagramElement> list) {
    for (DiagramElement element in list) {
      _elements[element.key] = element;
    }
    _calculateBounds();
  }

  void _calculateBounds() {
    if (_elements.isEmpty) {
      _bounds = Rect.zero;
    } else {
      double left = double.maxFinite;
      double top = double.maxFinite;
      double right = double.minPositive;
      double bottom = double.minPositive;
      for (DiagramElement element in _elements.values) {
        left = math.min(left, element.bounds.left);
        top = math.min(top, element.bounds.top);
        right = math.max(right, element.bounds.right);
        bottom = math.max(bottom, element.bounds.bottom);
      }
      _bounds = Rect.fromLTRB(left, top, right, bottom);
    }
  }
}

class DiagramModelFactory {
  static void addSquares(DiagramModel model) {
    List<DiagramElement> elements = [];
    math.Random random = math.Random();
    for (int i = 0; i < 1000; i++) {
      Color color = Color.fromARGB(
          255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
      SquareElement element = SquareElement(color: color);
      element.setBounds(
          x: random.nextInt(450).toDouble(),
          y: random.nextInt(450).toDouble(),
          width: 50,
          height: 50);
      elements.add(element);
    }
    model.addAll(elements);
  }
}

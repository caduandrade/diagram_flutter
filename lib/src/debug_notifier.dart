import 'package:flutter/material.dart';

class DebugNotifier extends ChangeNotifier {
  int _visibleNodes = 0;

  int get visibleNodes => _visibleNodes;
  set visibleNodes(int value) {
    if (_visibleNodes != value) {
      _visibleNodes = value;
      notifyListeners();
    }
  }
}

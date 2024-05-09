import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
class Notifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

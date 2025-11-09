import 'package:flutter/material.dart';

import '../../data/models/event.dart';

class OverlayController extends ChangeNotifier {
  Event? activeEvent;
  bool flipped = false;

  void show(Event event) {
    activeEvent = event;
    flipped = false;
    notifyListeners();
  }

  void hide() {
    activeEvent = null;
    flipped = false;
    notifyListeners();
  }

  void toggleFlip() {
    flipped = !flipped;
    notifyListeners();
  }
}

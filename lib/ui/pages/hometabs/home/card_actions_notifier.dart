import 'package:flutter/foundation.dart';

class CardActionsNotifier extends ChangeNotifier {
  bool _isVerticalView = false;
  bool _isHorizontalView = false;

  bool get isHorizontalView => _isHorizontalView;

  set isHorizontalView(bool value) {
    _isHorizontalView = value;
    notifyListeners();
  }

  bool get isVerticalView => _isVerticalView;

  set isVerticalView(bool value) {
    _isVerticalView = value;
    // if (value == false) AppState.backButtonDispatcher!.didPopRoute();

    notifyListeners();
  }
}

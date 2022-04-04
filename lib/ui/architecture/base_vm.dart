//Project Imports
import 'package:felloapp/core/enums/view_state_enum.dart';

//Flutter Imports
import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  bool _disposed = false;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

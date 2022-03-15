import 'dart:math';

import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

enum STATUS { Pending, Complete, Cancel }

class AutoPayProcessViewModel extends BaseModel {
  STATUS _processStatus = STATUS.Pending;
  Color _gradColor = UiConstants.tertiaryLight;
  bool _showSetAmountView = false;

  bool get showSetAmountView => this._showSetAmountView;

  set showSetAmountView(showSetAmountView) {
    this._showSetAmountView = showSetAmountView;
    notifyListeners();
  }

  get gradColor => this._gradColor;

  set gradColor(value) {
    this._gradColor = value;
    notifyListeners();
  }

  get processStatus => this._processStatus;

  set processStatus(value) {
    this._processStatus = value;
    notifyListeners();
  }

  init() async {
    Future.delayed(Duration(seconds: 2), () {
      Random r = new Random();
      bool result = true;
      //r.nextDouble() <= 0.7;
      processStatus =
          // result ? STATUS.Complete :
          STATUS.Cancel;
      gradColor = Colors.white;
      // result ? UiConstants.primaryLight : Colors.white;
    });
  }

  tryAgain() {
    processStatus = STATUS.Pending;
    Future.delayed(Duration(seconds: 2), () {
      processStatus = STATUS.Complete;
      gradColor = Colors.white;
    });
  }
}

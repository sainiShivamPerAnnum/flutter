import 'dart:async';

import 'package:flutter/cupertino.dart';

enum TambolaWidgetType { Banner, Timer, Tickets }

class TambolaWidgetController extends ChangeNotifier {
  TambolaWidgetController({TambolaWidgetType? tambolaWidgetType})
      : _tambolaWidgetType = tambolaWidgetType ?? TambolaWidgetType.Banner,
        super() {
    setTambolaWidgetType();
  }

  TambolaWidgetType _tambolaWidgetType;

  DateTime get _dateTime => DateTime.now();

  TambolaWidgetType get tambolaWidgetType => _tambolaWidgetType;

  Timer? timer;

  int timeLeftForTambola = 0;

  void setTambolaWidgetType() {
    Duration diffToChangeWidget;
    if (_dateTime.hour >= 0 && _dateTime.hour < 16) {
      diffToChangeWidget = _dateTime.difference(
          DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 16, 0, 0));
      _tambolaWidgetType = TambolaWidgetType.Banner;
    } else if (_dateTime.hour >= 18) {
      if (timer != null) {
        if (timer!.isActive) timer!.cancel();
      }
      _tambolaWidgetType = TambolaWidgetType.Tickets;
      diffToChangeWidget = _dateTime.difference(
        DateTime(_dateTime.year, _dateTime.month,
            _dateTime.add(Duration(days: 1)).day, 00, 1, 0),
      );
    } else {
      _tambolaWidgetType = TambolaWidgetType.Timer;
      diffToChangeWidget = _dateTime.difference(
          DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 18, 0, 0));
      timer = Timer.periodic(
        Duration(seconds: 1),
        (_) {
          timeLeftForTambola = _dateTime
              .difference(DateTime(
                  _dateTime.year, _dateTime.month, _dateTime.day, 18, 0, 0))
              .inSeconds
              .abs();
          notifyListeners();
        },
      );
    }

    Future.delayed(diffToChangeWidget.abs(), () => setTambolaWidgetType());
    notifyListeners();
  }
}

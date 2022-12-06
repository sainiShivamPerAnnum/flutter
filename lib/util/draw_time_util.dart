import 'dart:async';

import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

mixin DrawTimeUtil<T extends StatefulWidget> on State<T> {
  late Duration _timeRemaining;

  @override
  void initState() {
    init();
    super.initState();
  }

  Timer? _timer;

  void init() {
    _timeRemaining = _timeRemainingForDraw();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        _timeRemaining = _timeRemainingForDraw();
        setState(() {});
      });
    });
  }

  Duration get timeRemaining => _timeRemaining;

  Duration _timeRemainingForDraw() {
    DateTime currentTime = DateTime.now();
    DateTime drawTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 18, 0, 10);
    Duration timeDiff = drawTime.difference(currentTime);

    return timeDiff;
  }

  String _convertToTwoDigit(int n) => n.toString().padLeft(2, '0');

  String get inHours => _convertToTwoDigit(_timeRemaining.inHours.abs());

  String get inMinutes =>
      _convertToTwoDigit(_timeRemaining.inMinutes.remainder(60).abs());

  String get inSeconds =>
      _convertToTwoDigit(_timeRemaining.inSeconds.remainder(60).abs());

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

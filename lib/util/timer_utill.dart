import 'dart:async';

import 'package:flutter/material.dart';

abstract class TimerUtil<T extends StatefulWidget> extends State<T> {
  TimerUtil({required this.endTime, required this.startTime, Key? key})
      : super() {
    _timeRemaining = _timeRemainingFor();
  }
  final DateTime endTime;
  final DateTime startTime;

  late Duration _timeRemaining;

  @override
  void initState() {
    if (mounted) init();
    super.initState();
  }

  Timer? _timer;

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_timeRemainingFor().isNegative ||
            _timeRemainingFor().inSeconds == 0) {
          closeTimer();
        } else {
          _timeRemaining = _timeRemainingFor();
        }
        setState(() {});
      });
    });
  }

  Duration get timeRemaining => _timeRemaining;

  Duration _timeRemainingFor() {
    DateTime currentTime = DateTime.now();
    Duration startTimeDiff = startTime.difference(currentTime);
    Duration endTimeDiff = endTime.difference(currentTime);

    return !startTimeDiff.isNegative ? startTimeDiff : endTimeDiff;
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

  @override
  Widget build(BuildContext context) {
    final _widget = buildBody(context);
    return _widget;
  }

  Widget buildBody(BuildContext context);

  @mustCallSuper
  void closeTimer() {
    _timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) setState(() {});
    });
  }
}

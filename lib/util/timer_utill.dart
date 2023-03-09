import 'dart:async';

import 'package:flutter/material.dart';

abstract class TimerUtil<T extends StatefulWidget> extends State<T> {
  TimerUtil({Key? key, required this.endTime}) : super() {
    _timeRemaining = _timeRemainingFor();
  }
  final DateTime endTime;

  late Duration _timeRemaining;

  @override
  void initState() {
    if (mounted) init();
    super.initState();
  }

  Timer? _timer;

  void init() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        if (_timeRemainingFor().isNegative ||
            _timeRemainingFor().inSeconds == 0) {
          closeTimer();
        } else
          _timeRemaining = _timeRemainingFor();
        setState(() {});
      });
    });
  }

  Duration get timeRemaining => _timeRemaining;

  Duration _timeRemainingFor() {
    DateTime currentTime = DateTime.now();

    Duration timeDiff = endTime.difference(currentTime);

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

  @override
  Widget build(BuildContext context) {
    final _widget = buildBody(context);
    return _widget;
  }

  Widget buildBody(BuildContext context);

  @mustCallSuper
  void closeTimer() {
    _timer?.cancel();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }
}

class Sanket extends StatefulWidget {
  const Sanket({Key? key}) : super(key: key);

  @override
  State<Sanket> createState() => _SanketState();
}

class _SanketState extends State<Sanket> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

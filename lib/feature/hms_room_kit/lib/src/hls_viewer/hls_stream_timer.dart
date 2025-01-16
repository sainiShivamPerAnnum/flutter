import 'dart:async';

import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/hms_room_kit/lib/src/meeting/meeting_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HLSStreamTimer extends StatefulWidget {
  const HLSStreamTimer({super.key});

  @override
  State<HLSStreamTimer> createState() => _HLSStreamTimerState();
}

class _HLSStreamTimerState extends State<HLSStreamTimer> {
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    DateTime? startedAt = context
        .read<MeetingStore>()
        .hmsRoom
        ?.hmshlsStreamingState
        ?.variants
        .first
        ?.startedAt;

    if (startedAt != null) {
      _secondsElapsed = DateTime.now()
          .difference(
            DateTime.fromMillisecondsSinceEpoch(
              startedAt.millisecondsSinceEpoch,
            ),
          )
          .inSeconds;
    }
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  ///[_getFormattedTime] returns the formatted time in hh:mm:ss format
  String _getFormattedTime() {
    int minutes = _secondsElapsed ~/ 60;
    int seconds = _secondsElapsed % 60;

    int hours = 0;
    if (minutes > 59) {
      hours = minutes ~/ 60;
      minutes %= 60;
    }

    ///We only show seconds if hours and minutes are 0
    ///only minutes if hours are 0
    ///only hours if hours are greater than 0
    return "Started${hours > 0 ? " ${hours.toString()}h" : ""} ${hours < 1 && minutes > 0 ? "${minutes.toString()}m" : ""} ${hours < 1 && minutes < 1 ? "${seconds.toString()}s " : ""}ago";
  }

  @override
  Widget build(BuildContext context) {
    return HMSSubtitleText(
      text: _getFormattedTime(),
      letterSpacing: 0.4,
      textColor: HMSThemeColors.onSurfaceMediumEmphasis,
    );
  }
}

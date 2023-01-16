import 'dart:async';
import 'dart:developer';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyPicksTimer extends StatefulWidget {
  final Widget replacementWidget;
  final Color? bgColor;
  final MainAxisAlignment? alignment;

  DailyPicksTimer({
    required this.replacementWidget,
    this.bgColor,
    this.alignment,
  });
  @override
  _DailyPicksTimerState createState() => _DailyPicksTimerState();
}

class _DailyPicksTimerState extends State<DailyPicksTimer> {
  late Duration duration;
  Timer? timer;
  bool showClock = true;
  bool countDown = true;
  BaseUtil? baseProvider;
  TambolaService? _tambolaService = locator<TambolaService>();

  @override
  void initState() {
    if (getDifferance().isNegative) {
      duration = getDifferance().abs();
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
      });
    } else
      showClock = false;
    super.initState();
  }

  Duration getDifferance() {
    DateTime currentTime = DateTime.now();
    DateTime drawTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 18, 0, 10);
    Duration timeDiff = currentTime.difference(drawTime);

    return timeDiff;
  }

  void addTime() async {
    if (!getDifferance().isNegative) {
      await _tambolaService?.fetchWeeklyPicks(forcedRefresh: true);
      setState(() {
        showClock = false;
        timer?.cancel();
      });
      return;
    }

    final addSeconds = countDown ? -1 : 1;
    final seconds = getDifferance().inSeconds.abs() + addSeconds;

    setState(() {
      duration = Duration(seconds: seconds);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    if (showClock) {
      final hours = twoDigits(duration.inHours);
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return Row(
          mainAxisAlignment: widget.alignment ?? MainAxisAlignment.center,
          children: [
            buildTimeCard(time: hours),
            TimerDots(),
            buildTimeCard(time: minutes),
            TimerDots(),
            buildTimeCard(time: seconds),
          ]);
    }
    return widget.replacementWidget;
  }

  Widget buildTimeCard({required String time}) => Container(
        height: SizeConfig.screenWidth! * 0.16,
        width: SizeConfig.screenWidth! * 0.16,
        // margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
        decoration: BoxDecoration(
          color: UiConstants.kBackgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(time, style: TextStyles.rajdhaniSB.title2.letterSpace(2)),
      );
}

class TimerDots extends StatelessWidget {
  const TimerDots({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenWidth! * 0.14,
      width: SizeConfig.padding20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: SizeConfig.padding2,
            backgroundColor: UiConstants.kTextColor,
          ),
          SizedBox(height: SizeConfig.padding8),
          CircleAvatar(
            radius: SizeConfig.padding2,
            backgroundColor: UiConstants.kTextColor2,
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DailyPicksTimer extends StatefulWidget {
  final Widget replacementWidget;
  final Color bgColor;
  final MainAxisAlignment alignment;
  final Widget additionalWidget;

  DailyPicksTimer(
      {@required this.replacementWidget,
      this.bgColor,
      this.alignment,
      this.additionalWidget});
  @override
  _DailyPicksTimerState createState() => _DailyPicksTimerState();
}

class _DailyPicksTimerState extends State<DailyPicksTimer> {
  Duration duration;
  Timer timer;
  bool showClock = true;
  bool countDown = true;
  BaseUtil baseProvider;
  TambolaService _tambolaService = locator<TambolaService>();

  @override
  void initState() {
    if (calculateTime())
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
      });
    else
      showClock = false;
    super.initState();
  }

  bool calculateTime() {
    DateTime currentTime = DateTime.now();
    DateTime drawTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 18, 00, 10);
    Duration timeDiff = currentTime.difference(drawTime);
    if (timeDiff.inSeconds < 0) {
      duration = timeDiff.abs();
      return true;
    }
    return false;
  }

  void addTime() async {
    final addSeconds = countDown ? -1 : 1;
    final seconds = duration.inSeconds + addSeconds;
    if (seconds <= 0) {
      await _tambolaService.fetchWeeklyPicks(forcedRefresh: true);
      setState(() {
        showClock = false;
        timer?.cancel();
      });
    } else {
      setState(() {
        duration = Duration(seconds: seconds);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    if (showClock) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final hours = twoDigits(duration.inHours);
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.additionalWidget ?? SizedBox(),
          Row(
              mainAxisAlignment: widget.alignment ?? MainAxisAlignment.center,
              children: [
                buildTimeCard(time: hours),
                buildDivider(),
                buildTimeCard(time: minutes),
                buildDivider(),
                buildTimeCard(time: seconds),
              ]),
        ],
      );
    }
    return widget.replacementWidget;
  }

  Widget buildTimeCard({@required String time}) => Container(
        height: SizeConfig.screenWidth * 0.14,
        width: SizeConfig.screenWidth * 0.14,
        decoration: BoxDecoration(
          color: widget.bgColor ?? Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          time,
          style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: SizeConfig.cardTitleTextSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              shadows: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(1, 1),
                    blurRadius: 5,
                    spreadRadius: 5)
              ]),
        ),
      );

  Widget buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        ":",
        style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            shadows: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(1, 1),
                  blurRadius: 5,
                  spreadRadius: 5)
            ]),
      ),
    );
  }
}

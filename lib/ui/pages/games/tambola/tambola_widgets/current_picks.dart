import 'dart:math';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentPicks extends StatelessWidget {
  const CurrentPicks(
      {super.key,
      this.todaysPicks,
      this.dailyPicksCount,
      this.isTambolaCard = true});

  final List<int>? todaysPicks;
  final int? dailyPicksCount;
  final bool isTambolaCard;

  // int renderedTimes = 0;
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DailyPicksTimer(
          replacementWidget: TodayPicksBallsAnimation(
            picksList: todaysPicks!,
          ),
        ),
        if (!isTambolaCard)
          Container(
            padding: EdgeInsets.only(
                top: SizeConfig.padding24, bottom: SizeConfig.padding16),
            child: Text(
              todaysPicks == [-1, -1, -1]
                  ? locale.tDrawnAtText1
                  : locale.tDrawnAtText2,
              style: TextStyles.sourceSansSB.body4,
            ),
          )
      ],
    );
  }
}

class TodayPicksBallsAnimation extends StatelessWidget {
  const TodayPicksBallsAnimation(
      {Key? key,
      required this.picksList,
      this.ballHeight,
      this.ballWidth,
      this.margin})
      : super(key: key);
  final List<int> picksList;
  final double? ballHeight;
  final double? ballWidth;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    List<int> animationDurations = [2500, 4000, 5000, 3500, 4500];
    List<Color> ballColorCodes = [
      const Color(0xffC34B29),
      const Color(0xffFFD979),
      const Color(0xffAECCFF),
    ];

    return Consumer<AppState>(
      builder: (context, m, child) {
        debugPrint("I am generated 2 ${picksList!.length}");

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            picksList.length,
            (index) => Container(
              height: ballHeight ?? SizeConfig.screenWidth! * 0.14,
              margin: margin ??
                  EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
              child: AnimatedPicksDisplay(
                ballHeight: ballHeight ?? SizeConfig.screenWidth! * 0.14,
                ballWidth: ballWidth ?? SizeConfig.screenWidth! * 0.14,
                number: picksList[index],
                animationDurationMilliseconds: animationDurations[index],
                ballColor: ballColorCodes[index],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedPicksDisplay extends StatefulWidget {
  const AnimatedPicksDisplay({
    Key? key,
    required this.number,
    required this.animationDurationMilliseconds,
    required this.ballColor,
    required this.ballHeight,
    required this.ballWidth,
  }) : super(key: key);

  final int number;

  final int animationDurationMilliseconds;
  final Color ballColor;
  final double ballHeight;
  final double ballWidth;

  @override
  State<AnimatedPicksDisplay> createState() => _AnimatedPicksDisplayState();
}

class _AnimatedPicksDisplayState extends State<AnimatedPicksDisplay> {
  Random random =  Random();

  List<int> randomList = [];

  bool isAnimationDone = false;

  List<Color> ballColorCodes = [
    const Color(0xffC34B29),
    const Color(0xffFFD979),
    const Color(0xffAECCFF),
  ];

  ScrollController? _controller;

  @override
  void initState() {
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isAnimationDone == false) {
        Future.delayed(const Duration(milliseconds: 500), _scrollDown);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _scrollDown() {
    _controller!.animateTo(
      _controller!.position.maxScrollExtent,
      duration: Duration(milliseconds: widget.animationDurationMilliseconds),
      curve: Curves.fastOutSlowIn,
    );
    isAnimationDone = true;
  }

  Container _buildBalls(int nToShow, bool showEmpty, Color ballColor) {
    return Container(
      width: widget.ballWidth,
      height: widget.ballHeight,
      padding: EdgeInsets.all(SizeConfig.padding4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.padding4),
        width: widget.ballWidth,
        height: widget.ballHeight,
        decoration: BoxDecoration(
          color: ballColor,
          shape: BoxShape.circle,
        ),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.padding2),
          decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 0.7)),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                nToShow == -1 || nToShow == 0 ? '-' : nToShow.toString(),
                style: TextStyles.rajdhaniB.body2.colour(Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //GEnerating random numbers
    return Container(
      width: SizeConfig.screenWidth! * 0.14,
      height: SizeConfig.screenWidth! * 0.14,
      decoration: const BoxDecoration(
        color: UiConstants.kArrowButtonBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isAnimationDone
                  ? _buildBalls(widget.number, false, widget.ballColor)
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: randomList.length,
                      itemBuilder: (context, index) {
                        return _buildBalls(
                            randomList[index],
                            index == 0 ,
                            Colors.primaries[
                                Random().nextInt(Colors.primaries.length)]);
                      },
                    ),
              _buildBalls(widget.number, false, widget.ballColor),
            ],
          ),
        ),
      ),
    );
    ;
  }
}


class TicketNumber extends StatelessWidget {
  const TicketNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

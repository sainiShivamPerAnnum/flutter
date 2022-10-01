import 'dart:math';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/ui/widgets/tambola_card/tambola_card_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentPicks extends StatelessWidget {
  CurrentPicks({this.todaysPicks, this.dailyPicksCount});
  final List<int> todaysPicks;
  final int dailyPicksCount;

  int renderedTimes = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.padding10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DailyPicksTimer(
            replacementWidget: TodayPicksBallsAnimation(
              picksList: todaysPicks,
            ),
          ),
        ],
      ),
    );
  }
}

class TodayPicksBallsAnimation extends StatelessWidget {
  const TodayPicksBallsAnimation({
    Key key,
    @required this.picksList,
  }) : super(key: key);
  final List<int> picksList;

  @override
  Widget build(BuildContext context) {
    List<int> animationDurations = [2500, 4000, 5000, 3500, 4500];
    List<Color> ballColorCodes = [
      Color(0xffC34B29),
      Color(0xffFFD979),
      Color(0xffAECCFF),
    ];

    return Consumer<AppState>(
      builder: (context, m, child) {
        print("I am generated 2 ${picksList.length}");

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            picksList.length,
            (index) => Container(
              margin: EdgeInsets.only(
                  right:
                      index == picksList.length - 1 ? 0 : SizeConfig.padding26),
              child: AnimatedPicksDisplay(
                number: picksList[index],
                tabIndex: m.getCurrentTabIndex ?? 0,
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

class AnimatedPicksDisplay extends StatelessWidget {
  AnimatedPicksDisplay({
    Key key,
    @required this.number,
    @required this.tabIndex,
    @required this.animationDurationMilliseconds,
    @required this.ballColor,
  }) : super(key: key);

  final int number;
  final int tabIndex;
  final int animationDurationMilliseconds;
  final Color ballColor;

  Random random = new Random();

  List<int> randomList = [];
  bool isAnimationDone = false;
  List<Color> ballColorCodes = [
    Color(0xffC34B29),
    Color(0xffFFD979),
    Color(0xffAECCFF),
  ];

  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: animationDurationMilliseconds),
      curve: Curves.fastOutSlowIn,
    );
    isAnimationDone = true;
  }

  Container _buildBalls(int nToShow, bool showEmpty, Color ballColor) {
    return Container(
      width: SizeConfig.screenWidth * 0.14,
      height: SizeConfig.screenWidth * 0.14,
      padding: EdgeInsets.all(SizeConfig.padding4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.padding8),
        width: SizeConfig.screenWidth * 0.14,
        height: SizeConfig.screenWidth * 0.14,
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
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                showEmpty ? "" : nToShow.toString(),
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
    for (int i = 0; i < 8; i++) {
      randomList.add(random.nextInt(99));
    }

    if (tabIndex == 2 && isAnimationDone == false) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _scrollDown();
      });
    }
    return Container(
      width: SizeConfig.screenWidth * 0.14,
      height: SizeConfig.screenWidth * 0.14,
      decoration: BoxDecoration(
        color: UiConstants.kArowButtonBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isAnimationDone
                  ? _buildBalls(number, false, ballColor)
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: randomList.length,
                      itemBuilder: (context, index) {
                        return _buildBalls(
                            randomList[index],
                            index == 0 ? true : false,
                            Colors.primaries[
                                Random().nextInt(Colors.primaries.length)]);
                      },
                    ),
              _buildBalls(number, false, ballColor),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

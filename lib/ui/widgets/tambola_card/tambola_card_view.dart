import 'dart:math';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/current_picks.dart';
import 'package:felloapp/ui/pages/static/game_card_big.dart';
import 'package:felloapp/ui/widgets/tambola_card/tambola_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TambolaCard extends StatelessWidget {
  const TambolaCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaCardModel>(onModelReady: (model) {
      model.init();
    }, builder: (ctx, model, child) {
      return GestureDetector(
        onTap: () {
          Haptic.vibrate();
          AppState.delegate.parseRoute(
            Uri.parse(model.game.route),
          );
        },
        child: Container(
          height: SizeConfig.screenWidth * 0.9,
          margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
          decoration: BoxDecoration(
            color: UiConstants.kSnackBarPositiveContentColor,
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness24)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, -SizeConfig.padding20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: SvgPicture.asset(
                          Assets.tambolaCardAsset,
                          width: SizeConfig.screenWidth * 0.5,
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.padding2,
                                top: SizeConfig.padding3),
                            child: Text(
                              "Tambola",
                              style: TextStyles.rajdhaniEB.title50
                                  .colour(UiConstants.kBlogCardRandomColor2),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.padding1,
                                top: SizeConfig.padding2),
                            child: Text(
                              "Tambola",
                              style: TextStyles.rajdhaniEB.title50
                                  .colour(UiConstants.kTambolaMidTextColor),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Tambola",
                              style: TextStyles.rajdhaniEB.title50.colour(
                                  UiConstants.kWinnerPlayerPrimaryColor),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Play and Win rewards",
                        style: TextStyles.sourceSans.body3.bold
                            .colour(UiConstants.kBlogCardRandomColor2),
                      ),
                      SizedBox(
                        height: SizeConfig.padding12,
                      ),
                      SizedBox(
                        height: SizeConfig.screenWidth * 0.2,
                        child: CurrentPicks(
                          dailyPicksCount: model.dailyPicksCount ?? 3,
                          todaysPicks: model.todaysPicks != null
                              ? model.todaysPicks
                              : List.generate(
                                  model.dailyPicksCount ?? 3, (index) => 0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: SizeConfig.padding8),
                        child: Text(
                          "Next draw at 6 PM",
                          style:
                              TextStyles.sourceSans.body3.colour(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.circle,
                      ),
                      height: SizeConfig.avatarRadius * 2,
                      width: SizeConfig.avatarRadius * 2,
                      padding: EdgeInsets.all(SizeConfig.padding4),
                      child: GestureDetector(
                        onTap: () {
                          Haptic.vibrate();
                          print(model.game.route);
                          AppState.delegate.parseRoute(
                            Uri.parse(model.game.route),
                          );
                        },
                        child: SvgPicture.asset(
                          Assets.chevRonRightArrow,
                          color: Colors.white,
                          width: SizeConfig.padding24,
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      );
    });
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

    return Consumer<AppState>(
      builder: (context, m, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          picksList.length,
          (index) => Container(
            margin: EdgeInsets.only(
                right:
                    index == picksList.length - 1 ? 0 : SizeConfig.padding26),
            child: AnimatedPicksDisplay(
              number: picksList[index],
              tabIndex: AppState.delegate.appState.getCurrentTabIndex,
              animationDurationMilliseconds: animationDurations[index],
            ),
          ),
        ),
      ),
    );
  }
}

//Widget to render single ball with animation
class AnimatedPicksDisplay extends StatefulWidget {
  const AnimatedPicksDisplay(
      {Key key,
      @required this.number,
      @required this.tabIndex,
      @required this.animationDurationMilliseconds})
      : super(key: key);

  final int number;
  final int tabIndex;
  final int animationDurationMilliseconds;

  @override
  State<AnimatedPicksDisplay> createState() => _AnimatedPicksDisplayState();
}

class _AnimatedPicksDisplayState extends State<AnimatedPicksDisplay> {
  Random random = new Random();

  List<int> randomList = [];
  bool isAnimationDone = false;

  final ScrollController _controller = ScrollController();

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: widget.animationDurationMilliseconds),
      curve: Curves.fastOutSlowIn,
    );
    isAnimationDone = true;
  }

  @override
  Widget build(BuildContext context) {
    //GEnerating random numbers
    for (int i = 0; i < 8; i++) {
      randomList.add(random.nextInt(99));
    }

    if (widget.tabIndex == 1 && isAnimationDone == false) {
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
                  ? SizedBox.shrink()
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: randomList.length,
                      itemBuilder: (context, index) {
                        return _buildBalls(
                            randomList[index], index == 0 ? true : false);
                      },
                    ),
              _buildBalls(widget.number, false),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildBalls(int nToShow, bool showEmpty) {
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
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
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
}

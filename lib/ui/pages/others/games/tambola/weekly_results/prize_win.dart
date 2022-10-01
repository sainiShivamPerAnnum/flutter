// import 'package:confetti/confetti.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/winnerbox.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrizeWin extends StatefulWidget {
  final Map<String, int> winningsMap;
  final PrizesModel tPrizes;
  const PrizeWin({Key key, @required this.winningsMap, @required this.tPrizes})
      : super(key: key);

  @override
  _PrizeWinState createState() => _PrizeWinState();
}

class _PrizeWinState extends State<PrizeWin> {
  // ConfettiController _confettiController;
  FcmListener _fcmListener;
  bool addedSubscription = false;

  @override
  void initState() {
    // _confettiController = new ConfettiController(
    //   duration: new Duration(seconds: 2),
    // );

    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   _confettiController.play();
    // });
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    _fcmListener = locator<FcmListener>();
    if (!addedSubscription) {
      _fcmListener.addSubscription(FcmTopic.WINNERWINNER);
      addedSubscription = true;
    }
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * 0.6,
                      height: SizeConfig.screenWidth * 0.6,
                      padding: EdgeInsets.all(SizeConfig.padding16),
                      decoration: BoxDecoration(
                        color: UiConstants.kSliverAppBarBackgroundColor
                            .withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: SizeConfig.screenWidth * 0.6,
                        height: SizeConfig.screenWidth * 0.6,
                        decoration: BoxDecoration(
                          color: UiConstants.kSliverAppBarBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      Assets.tambolaCardAsset,
                      width: SizeConfig.screenWidth * 0.7,
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                Text(
                  "Congratulations!",
                  style: TextStyles.rajdhaniEB.title2.colour(Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding20,
                  ),
                  child: Text("Your tickets won.",
                      textAlign: TextAlign.center,
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kFAQsAnswerColor)),
                ),
                WinnerBox(
                  winningsmap: widget.winningsMap,
                  tPrize: widget.tPrizes,
                ),
                SizedBox(
                  height: SizeConfig.screenWidth * 0.5,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              color: UiConstants.kBackgroundColor2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding20,
                  ),
                  child: Text(
                      "Your prizes will be credited tomorrow. Be sure to\ncheck out the leaderboard ",
                      textAlign: TextAlign.center,
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kFAQsAnswerColor)),
                ),
                Container(
                  margin:
                      EdgeInsets.only(bottom: SizeConfig.pageHorizontalMargins),
                  child: AppPositiveBtn(
                    width: SizeConfig.screenWidth * 0.9,
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                    btnText: "SAVE MORE",
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

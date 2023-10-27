import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'winnerbox.dart';

class PrizeWin extends StatefulWidget {
  final Winners winner;
  final PrizesModel? tPrizes;
  final bool isEligible;

  const PrizeWin(
      {required this.winner,
      required this.tPrizes,
      required this.isEligible,
      Key? key})
      : super(key: key);

  @override
  _PrizeWinState createState() => _PrizeWinState();
}

class _PrizeWinState extends State<PrizeWin> {
  // ConfettiController _confettiController;
  // FcmListener? _fcmListener;
  bool addedSubscription = false;

  @override
  void initState() {
    super.initState();

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
    // S? locale = S.of(context);
    // _fcmListener = locator<FcmListener>();
    // if (!addedSubscription) {
    //   _fcmListener!.addSubscription(FcmTopic.WINNERWINNER);
    //   addedSubscription = true;
    // }
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth! * 0.5,
                      height: SizeConfig.screenWidth! * 0.5,
                      padding: EdgeInsets.all(SizeConfig.padding16),
                      decoration: BoxDecoration(
                        color: UiConstants.kSliverAppBarBackgroundColor
                            .withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: SizeConfig.screenWidth! * 0.4,
                        height: SizeConfig.screenWidth! * 0.4,
                        decoration: const BoxDecoration(
                          color: UiConstants.kSliverAppBarBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      Assets.tambolaCardAsset,
                      width: SizeConfig.screenWidth! * 0.4,
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
                    vertical: SizeConfig.padding6,
                  ),
                  child: Text("Your tickets won!",
                      textAlign: TextAlign.center,
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kFAQsAnswerColor)),
                ),
                const SizedBox(
                  height: 10,
                ),
                WinnerBox(
                    winner: widget.winner,
                    tPrize: widget.tPrizes,
                    isEligible: widget.isEligible),
                SizedBox(
                  height: SizeConfig.screenWidth! * 0.5,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: SizeConfig.screenWidth,
            decoration: const BoxDecoration(
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
                  child: Text("Your prizes will be credited on Monday",
                      textAlign: TextAlign.center,
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kFAQsAnswerColor)),
                ),
                // Container(
                //   margin:
                //       EdgeInsets.only(bottom: SizeConfig.pageHorizontalMargins),
                //   child: AppPositiveBtn(
                //     width: SizeConfig.screenWidth! * 0.9,
                //     onPressed: () {
                //       AppState.delegate!.parseRoute(Uri.parse('/myWinnings'));

                //       // if (model.isShareAlreadyClicked == false) {
                //       //   model.shareLink();
                //       // }
                //     },
                //     btnText: "Claim Your Prizes",
                //   ),
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

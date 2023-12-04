import 'dart:ui';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/elements/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/elements/texts/breathing_text_widget.dart';
import 'package:felloapp/ui/pages/rewards/multiple_scratch_cards/multiple_scratch_cards_vm.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card_utils.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scratcher/widgets.dart';

class MultipleScratchCardsView extends StatefulWidget {
  const MultipleScratchCardsView({Key? key}) : super(key: key);

  @override
  State<MultipleScratchCardsView> createState() =>
      _MultipleScratchCardsViewState();
}

class _MultipleScratchCardsViewState extends State<MultipleScratchCardsView> {
  S locale = locator<S>();

  final List<Color> colorList = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.amber
  ];

  @override
  Widget build(BuildContext context) {
    return BaseView<MultipleScratchCardsViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.black.withOpacity(0.75),
        body: SizedBox(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.04,
                  child: Image.asset(
                    Assets.gtBackground,
                    height: SizeConfig.screenHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: Row(
                        children: [
                          SizedBox(
                            width: SizeConfig.pageHorizontalMargins,
                          ),
                          const FelloAppBarBackButton(),
                          const Spacer(),
                          FelloCoinBar(),
                          SizedBox(width: SizeConfig.padding20)
                        ],
                      ),
                    ),
                  ),
                  //Scratch Card Pageview
                  if (!model.showRewardLottie)
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInCubic,
                      scale: model.cardScale,
                      child: Column(
                        children: [
                          SizedBox(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenWidth! * 0.5,
                            child: PageView.builder(
                              controller: model.pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: model.scratchCardList.length,
                              itemBuilder: (ctx, i) {
                                return ValueListenableBuilder(
                                    valueListenable: model.pageNotifier!,
                                    builder: (ctx, double value, _) {
                                      final factorChange = (value - i).abs();
                                      return Transform.scale(
                                        scale:
                                            lerpDouble(1.1, 0.8, factorChange),
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: SizeConfig
                                                    .pageHorizontalMargins),
                                            width: SizeConfig.screenWidth,
                                            height:
                                                SizeConfig.screenWidth! * 0.7,
                                            child: AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: model.scratchCardList[i]
                                                          .gtId?.isEmpty ??
                                                      true
                                                  ? UnRedeemedGoldenScratchCard(
                                                      isLevelChange: false,
                                                      width: SizeConfig
                                                          .screenWidth!,
                                                    )
                                                  : Scratcher(
                                                      color: Colors.transparent,
                                                      accuracy:
                                                          ScratchAccuracy.low,
                                                      brushSize: 50,
                                                      threshold: 20,
                                                      key: model
                                                          .scratchStateKeys[i],
                                                      onScratchStart: () {
                                                        // model.isCardScratchStarted = true;
                                                        model.showScratchGuideLabel =
                                                            false;
                                                      },
                                                      onChange: (value) => model
                                                              .currentCardScratchPercentage =
                                                          value,
                                                      onThreshold: () {
                                                        model.redeemScratchCard(
                                                            i);
                                                      },
                                                      image: Image.asset(
                                                        model.scratchCardList[i]
                                                                .isLevelChange!
                                                            ? Assets
                                                                .levelUpUnredeemedScratchCardBGPNG
                                                            : Assets
                                                                .unredeemedScratchCardBG_png,
                                                        fit: BoxFit.contain,
                                                        height: SizeConfig
                                                                .screenWidth! *
                                                            0.6,
                                                        width: SizeConfig
                                                                .screenWidth! *
                                                            0.6,
                                                      ),
                                                      child:
                                                          RedeemedGoldenScratchCard(
                                                        ticket: model
                                                            .scratchCardList[i],
                                                        width: SizeConfig
                                                                .screenWidth! *
                                                            0.6,
                                                      ),
                                                    ),
                                            )),
                                      );
                                    });
                              },
                            ),
                          ),
                          //Currently viewing scratch card description (iff card is scratched)
                          Container(
                            child: Column(children: [
                              SizedBox(height: SizeConfig.padding24),
                              AnimatedContainer(
                                decoration: const BoxDecoration(),
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeIn,
                                width: SizeConfig.screenWidth,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins),
                                child: Text(locale.btnCongratulations,
                                    style: TextStyles.rajdhaniB.title2
                                        .colour(Colors.white),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                width: SizeConfig.screenWidth,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins * 2),
                                child: AnimatedSwitcher(
                                  duration: const Duration(seconds: 1),
                                  child:
                                      (model
                                                  .scratchCardList[model
                                                      .pageNotifier!.value
                                                      .toInt()]
                                                  .note ??
                                              locale.wonGT)
                                          .beautify(
                                              style: TextStyles
                                                  .sourceSans.body3
                                                  .colour(
                                                      UiConstants.kTextColor2),
                                              boldStyle: TextStyles
                                                  .sourceSansB.body3
                                                  .colour(UiConstants
                                                      .kTextColor),
                                              italicStyle:
                                                  TextStyles
                                                      .sourceSans.body3
                                                      .colour(UiConstants
                                                          .kTextColor2)
                                                      .italic,
                                              alignment: TextAlign.center),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  Container(
                      height: kToolbarHeight + SizeConfig.viewInsets.bottom),
                ],
              ),
              if (model.showConfetti)
                Align(
                  alignment: Alignment.center,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Lottie.asset(
                      Assets.gtConfetti,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                    ),
                  ),
                ),
              if (model.showScratchGuideLabel && !model.showRewardLottie)
                Align(
                  alignment: Alignment.center,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: SizeConfig.screenWidth! * 0.1),
                      width: SizeConfig.screenWidth! * 0.53,
                      color: UiConstants.kScratchHereStripColor,
                      alignment: Alignment.center,
                      height: SizeConfig.screenWidth! * 0.1,
                      child: BreathingText(
                        alertText: "Scratch Here",
                        textStyle: TextStyles.sourceSansSB.body1,
                      ),
                    ),
                  ),
                ),
              if (model.showRewardLottie)
                Align(
                  alignment: Alignment.center,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FullScreenLoader(
                          size: SizeConfig.screenWidth! * 0.4,
                        ),
                        SizedBox(height: SizeConfig.padding10),
                        Text("Fetching rewards",
                            style: TextStyles.rajdhaniB.title2
                                .colour(Colors.white),
                            textAlign: TextAlign.center),
                        Text(
                          "Please wait...",
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor2),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:confetti/confetti.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/texts/breathing_text_widget.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_ticket_utils.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

enum GTSOURCE { newuser, deposit, cricket, panVerify }

class GTInstantView extends StatefulWidget {
  final String title;
  final GTSOURCE source;
  final double amount;
  GTInstantView({this.title, @required this.source, this.amount});
  @override
  State<GTInstantView> createState() => _GTInstantViewState();
}

class _GTInstantViewState extends State<GTInstantView>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    this._controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<GTInstantViewModel>(
      onModelReady: (model) {
        model.init();

        if (widget.source == GTSOURCE.deposit)
          model.initDepositSuccessAnimation(widget.amount);
        else
          model.initNormalFlow();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8),
          body: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.04,
                    child: Image.asset(
                      "assets/images/gtdbg.png",
                      height: SizeConfig.screenHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (model.showMainContent)
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/lotties/glitter.json",
                        repeat: false),
                  ),
                // if (model.isCoinAnimationInProgress)
                AnimatedOpacity(
                  opacity: model.isCoinAnimationInProgress ? 1 : 0,
                  duration: Duration(milliseconds: 100),
                  curve: Curves.decelerate,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/lotties/coin-stack.json",
                          width: SizeConfig.screenWidth / 2,
                        ),
                        SizedBox(height: SizeConfig.padding16),
                        Text(
                          "${widget.amount.toInt()} Tokens Credited!",
                          style: TextStyles.title3.bold.colour(Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.screenWidth / 4)
                      ],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: model.isInvestmentAnimationInProgress ? 1 : 0,
                  curve: Curves.decelerate,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/lotties/success.json",
                            repeat: false, width: SizeConfig.screenWidth / 2.4),
                        SizedBox(height: SizeConfig.padding16),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.title ?? "Hurray!",
                            style: TextStyles.title3.bold.colour(Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        //SizedBox(height: SizeConfig.screenWidth / 4)
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    FelloAppBar(
                      leading: FelloAppBarBackButton(),
                      actions: [
                        Container(
                          height: SizeConfig.avatarRadius * 2,
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset(
                                Assets.tokens,
                                height: SizeConfig.iconSize1,
                              ),
                              SizedBox(width: SizeConfig.padding6),
                              AnimatedCount(
                                  count: model.coinsCount,
                                  duration: Duration(seconds: 2)),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        NotificationButton(),
                      ],
                    ),
                    if (model.showMainContent)
                      Expanded(
                        child: AnimatedOpacity(
                          opacity: model.showMainContent ? 1 : 0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInCubic,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(flex: 1),
                              Column(
                                children: [
                                  Text(
                                    "Hurray!",
                                    style: TextStyles.title2.bold
                                        .colour(Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    width: SizeConfig.screenWidth,
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins,
                                      vertical: SizeConfig.padding8,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "You've earned a new golden ticket",
                                        style: TextStyles.title5.bold
                                            .colour(Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(flex: 1),
                              Transform.scale(
                                scale: 1 - _controller.value,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness16),
                                  child: Scratcher(
                                    accuracy: ScratchAccuracy.low,
                                    brushSize: 50,
                                    enabled: model.state == ViewState.Idle
                                        ? true
                                        : false,
                                    threshold: 40,
                                    key: scratchKey,
                                    onScratchStart: () {
                                      model.isCardScratchStarted = true;
                                      model.showScratchGuide = false;
                                    },
                                    onThreshold: () {
                                      if (model.goldenTicket.isRewarding) {
                                        model.isShimmerEnabled = true;
                                        model.confettiController.play();

                                        Future.delayed(
                                            Duration(
                                              seconds: 3,
                                            ), () {
                                          model.isShimmerEnabled = false;
                                        });
                                        _controller.forward().then(
                                            (value) => _controller.reverse());
                                      }

                                      model.redeemTicket();
                                    },
                                    image: Image.asset(
                                      Assets.gtCover,
                                      fit: BoxFit.cover,
                                      height: SizeConfig.screenWidth * 0.6,
                                      width: SizeConfig.screenWidth * 0.6,
                                    ),
                                    child: Shimmer(
                                      color: UiConstants.tertiarySolid,
                                      enabled: model.isShimmerEnabled,
                                      child: model.state == ViewState.Busy
                                          ? Container(
                                              width:
                                                  SizeConfig.screenWidth * 0.6,
                                              height:
                                                  SizeConfig.screenWidth * 0.6,
                                            )
                                          : RedeemedGoldenScratchCard(
                                              ticket: model.goldenTicket,
                                              titleStyle: TextStyles.title2,
                                              titleStyle2: TextStyles.title4,
                                              subtitleStyle: TextStyles.body1,
                                              width:
                                                  SizeConfig.screenWidth * 0.6,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 1),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins),
                                child: Column(
                                  children: [
                                    Opacity(
                                      opacity: model.buttonOpacity,
                                      child: AnimatedContainer(
                                        duration: Duration(seconds: 1),
                                        curve: Curves.easeIn,
                                        width: SizeConfig.screenWidth / 2,
                                        child: FelloButtonLg(
                                          color: UiConstants.primaryColor,
                                          child: Text(
                                            getButtonText(
                                                    model, widget.source) ??
                                                "Start Playing",
                                            style: TextStyles.body2.bold
                                                .colour(Colors.white),
                                          ),
                                          onPressed: getButtonAction(
                                                  model, widget.source) ??
                                              () {
                                                if (!model.isCardScratched)
                                                  return;
                                                AppState.backButtonDispatcher
                                                    .didPopRoute();
                                              },
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    TextButton(
                                      onPressed: () {
                                        while (
                                            AppState.screenStack.length > 1) {
                                          AppState.backButtonDispatcher
                                              .didPopRoute();
                                        }
                                        AppState.delegate.appState
                                            .setCurrentTabIndex = 2;
                                        AppState.delegate.appState
                                                .currentAction =
                                            PageAction(
                                                state: PageState.addPage,
                                                page: MyWinnigsPageConfig);
                                      },
                                      child: Text(
                                        'My Winnings',
                                        style: TextStyles.body3
                                            .colour(Colors.white)
                                            .underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(flex: 2),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                if (model.isCardScratched && model.isShimmerEnabled)
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/lotties/confetti.json",
                        height: SizeConfig.screenWidth * 0.8),
                  ),
                // if (model.isCardScratched && model.isShimmerEnabled)
                // Container(
                //   height: 100,
                //   width: 100,
                //   child: ConfettiWidget(
                //     blastDirectionality: BlastDirectionality.directional,
                //     blastDirection: 90,
                //     confettiController: model.confettiController,
                //     emissionFrequency: 0.05,
                //     numberOfParticles: 25,
                //     shouldLoop: false,
                //     colors: [
                //       Color(0xffa864fd),
                //       Color(0xff29cdff),
                //       Color(0xff78ff44),
                //       Color(0xffff718d),
                //       Color(0xfffdff6a),
                //     ],
                //   ),
                // ),
                if (model.showScratchGuide && !model.isCardScratchStarted)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: Color(0xffffc875),
                      width: SizeConfig.screenWidth * 0.62,
                      height: SizeConfig.padding40,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: BreathingText(
                        alertText: "Scratch Here",
                        textStyle: TextStyles.body2.colour(Colors.black).bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Function getButtonAction(GTInstantViewModel model, GTSOURCE source) {
    Function onPressed;
    if (source == GTSOURCE.cricket || source == GTSOURCE.panVerify) {
      onPressed = () {
        if (!model.isCardScratched) return;
        AppState.backButtonDispatcher.didPopRoute();
      };
    } else {
      onPressed = () {
        if (!model.isCardScratched) return;
        AppState.delegate.appState.setCurrentTabIndex = 1;
        while (AppState.screenStack.length > 1) {
          AppState.backButtonDispatcher.didPopRoute();
        }
      };
    }
    return onPressed;
  }

  getButtonText(GTInstantViewModel model, GTSOURCE source) {
    String title;
    if (source == GTSOURCE.deposit) {
      title = "Start Playing";
    } else {
      title = "Continue";
    }
    return title;
  }
}

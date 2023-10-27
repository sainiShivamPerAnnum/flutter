import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/elements/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/elements/texts/breathing_text_widget.dart';
import 'package:felloapp/ui/pages/rewards/detailed_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/ui/pages/rewards/instant_scratch_card/gt_instant_vm.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card_utils.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scratcher/scratcher.dart';

enum GTSOURCE {
  newuser,
  deposit,
  cricket,
  footBall,
  candyFiesta,
  poolClub,
  panVerify,
  autosave,
  game,
  prize,
  event,
  referral
}

class GTInstantView extends StatefulWidget {
  final String? title;
  final GTSOURCE source;
  final double? amount;
  final bool showRatingDialog;

  final bool showAutosavePrompt;

  const GTInstantView(
      {required this.source,
      super.key,
      this.title,
      this.amount,
      this.showRatingDialog = true,
      this.showAutosavePrompt = false});

  @override
  State<GTInstantView> createState() => _GTInstantViewState();
}

class _GTInstantViewState extends State<GTInstantView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  S locale = locator<S>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locator<MarketingEventHandlerService>().showModalsheet = false;
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locator<MarketingEventHandlerService>().showModalsheet = true;
    });
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<GTInstantViewModel>(
      onModelReady: (model) {
        model.lottieAnimationController = AnimationController(vsync: this);
        model.init();

        // if (widget.source == GTSOURCE.deposit)
        //   model.initDepositSuccessAnimation(widget.amount);
        // else
        model.initNormalFlow();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.7),
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
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
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
                  )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //if (model.showMainContent)
                      AnimatedOpacity(
                        opacity: model.showMainContent ? 1 : 0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInCubic,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: SizeConfig.padding80),
                            Container(
                              height: SizeConfig.screenWidth! * 0.5,
                              width: SizeConfig.screenWidth! * 0.6,
                              alignment: Alignment.center,
                              child: AnimatedRotation(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInCubic,
                                turns: model.showMainContent ? 0.0 : -0.1,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInCubic,
                                  width: model.showMainContent
                                      ? SizeConfig.screenWidth! * 0.6
                                      : 0,
                                  height: model.showMainContent
                                      ? SizeConfig.screenWidth! * 0.5
                                      : 0,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Transform.scale(
                                      scale: 1 - _controller.value,
                                      child: Scratcher(
                                        color: Colors.transparent,
                                        accuracy: ScratchAccuracy.low,
                                        brushSize: 50,
                                        enabled: model.state == ViewState.Idle
                                            ? true
                                            : false,
                                        threshold: 20,
                                        key: scratchKey,
                                        onScratchStart: () {
                                          model.isCardScratchStarted = true;
                                          model.showScratchGuide = false;
                                        },
                                        onThreshold: () {
                                          if (model.scratchCard!.isRewarding!) {
                                            model.isShimmerEnabled = true;

                                            Future.delayed(
                                                const Duration(
                                                  seconds: 3,
                                                ), () {
                                              model.isShimmerEnabled = false;
                                            });
                                            _controller.forward().then(
                                                (value) =>
                                                    _controller.reverse());
                                          }

                                          model.redeemTicket(
                                              widget.showRatingDialog);
                                        },
                                        image: Image.asset(
                                          model.scratchCard!.isLevelChange!
                                              ? Assets
                                                  .levelUpUnredeemedScratchCardBGPNG
                                              : Assets
                                                  .unredeemedScratchCardBG_png,
                                          fit: BoxFit.contain,
                                          height: SizeConfig.screenWidth! * 0.6,
                                          width: SizeConfig.screenWidth! * 0.6,
                                        ),
                                        child: model.state == ViewState.Busy
                                            ? SizedBox(
                                                width: SizeConfig.screenWidth! *
                                                    0.6,
                                                height:
                                                    SizeConfig.screenWidth! *
                                                        0.5,
                                              )
                                            : RedeemedGoldenScratchCard(
                                                ticket: model.scratchCard,
                                                width: SizeConfig.screenWidth! *
                                                    0.6,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding24),
                            AnimatedContainer(
                              decoration: const BoxDecoration(),
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeIn,
                              width: SizeConfig.screenWidth,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.pageHorizontalMargins),
                              child: Text(getGTTitle(),
                                  style: TextStyles.rajdhaniB.title2
                                      .colour(Colors.white),
                                  textAlign: TextAlign.center),
                            ),
                            AnimatedContainer(
                              decoration: const BoxDecoration(),
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeIn,
                              width: SizeConfig.screenWidth,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.pageHorizontalMargins * 2),
                              child: model.isCardScratched
                                  ? (model.scratchCard!.note ?? locale.wonGT)
                                      .beautify(
                                          style: TextStyles.sourceSans.body3
                                              .colour(Colors.grey),
                                          alignment: TextAlign.center)
                                  : Text("You won a new scratch card",
                                      style: TextStyles.sourceSans.body3
                                          .colour(Colors.grey),
                                      textAlign: TextAlign.center),
                            ),
                            SizedBox(height: SizeConfig.padding24),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (model.isCardScratched && model.isShimmerEnabled)
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
                if (model.showScratchGuide && !model.isCardScratchStarted)
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
              ],
            ),
          ),
        );
      },
    );
  }

  getGTTitle() {
    if (widget.source == GTSOURCE.deposit) {
      return locale.hurray;
    } else {
      if (widget.title != null && widget.title!.isNotEmpty) {
        return widget.title;
      } else {
        return locale.hurray;
      }
    }
  }

  Function getButtonAction(GTInstantViewModel model, GTSOURCE source) {
    Function onPressed;
    // if (source == GTSOURCE.cricket ||
    //     source == GTSOURCE.panVerify ||
    //     source == GTSOURCE.poolClub ||
    //     source == GTSOURCE.footBall ||
    //     source == GTSOURCE.candyFiesta ||
    //     source == GTSOURCE.game) {
    onPressed = () {
      if (!model.isCardScratched) return;
      AppState.backButtonDispatcher!.didPopRoute();
      // if (widget.showAutosavePrompt && !model.isAutosaveAlreadySetup)
      //   model.showAutosavePrompt();
    };
    // }
    return onPressed;
  }

  getButtonText(GTInstantViewModel model, GTSOURCE source) {
    String title;
    if (source == GTSOURCE.deposit || source == GTSOURCE.autosave) {
      if (!model.isAutosaveAlreadySetup) {
        title = locale.btnContinue;
      } else {
        title = locale.btnStartPlaying;
      }
    } else {
      title = locale.btnContinue;
    }
    return title;
  }
}

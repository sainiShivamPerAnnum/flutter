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
import 'package:lottie/lottie.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

enum GTSOURCE { newuser, deposit, cricket }

class GTInstantView extends StatefulWidget {
  final String title;
  final GTSOURCE source;
  GTInstantView({this.title, @required this.source});
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
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.7),
          body: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      "assets/images/gtdbg.png",
                      height: SizeConfig.screenHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Lottie.asset("assets/lotties/glitter.json",
                      repeat: false),
                ),
                Column(
                  children: [
                    FelloAppBar(
                      leading: FelloAppBarBackButton(),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(flex: 1),
                          Text(
                            widget.title ?? "Hurray!!",
                            style: TextStyles.title2.bold.colour(Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins,
                              vertical: SizeConfig.padding8,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "You've earned a new golden ticket",
                                style:
                                    TextStyles.title3.bold.colour(Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Spacer(flex: 2),
                          Transform.scale(
                            scale: 1 - _controller.value,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness16),
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
                                    Future.delayed(
                                        Duration(
                                          seconds: 3,
                                        ), () {
                                      model.isShimmerEnabled = false;
                                    });
                                    _controller
                                        .forward()
                                        .then((value) => _controller.reverse());
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
                                          width: SizeConfig.screenWidth * 0.6,
                                          height: SizeConfig.screenWidth * 0.6,
                                        )
                                      : RedeemedGoldenScratchCard(
                                          ticket: model.goldenTicket,
                                          titleStyle: TextStyles.title2,
                                          titleStyle2: TextStyles.title4,
                                          subtitleStyle: TextStyles.body1,
                                          width: SizeConfig.screenWidth * 0.6,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(flex: 2),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins),
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
                                        getButtonText(model, widget.source) ??
                                            "Start Playing",
                                        style: TextStyles.body2.bold
                                            .colour(Colors.white),
                                      ),
                                      onPressed: getButtonAction(
                                              model, widget.source) ??
                                          () {
                                            if (!model.isCardScratched) return;
                                            AppState.backButtonDispatcher
                                                .didPopRoute();
                                          },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                TextButton(
                                  onPressed: () {
                                    while (AppState.screenStack.length > 1) {
                                      AppState.backButtonDispatcher
                                          .didPopRoute();
                                    }
                                    AppState.delegate.appState
                                        .setCurrentTabIndex = 2;
                                    AppState.delegate.appState.currentAction =
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
                    )
                  ],
                ),
                if (model.isCardScratched && model.isShimmerEnabled)
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/lotties/confetti.json",
                        height: SizeConfig.screenHeight),
                  ),
                if (model.showScratchGuide && !model.isCardScratchStarted)
                  Align(
                    alignment: Alignment.center,
                    child: BreathingText(
                      alertText: "Scratch Here",
                      textStyle: TextStyles.body2.colour(Colors.black54),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Function getButtonAction(GTInstantViewModel model, GTSOURCE source) {
    Function onPressed;
    if (source == GTSOURCE.cricket) {
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

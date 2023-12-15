import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/texts/breathing_text_widget.dart';
import 'package:felloapp/ui/pages/splash/splash_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
//Flutter and dart imports
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LauncherView extends StatefulWidget {
  const LauncherView({super.key});

  @override
  State<LauncherView> createState() => _LauncherViewState();
}

class _LauncherViewState extends State<LauncherView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    S? locale = S.of(context);
    return Consumer<ConnectivityService>(
        builder: (context, service, child) => service.connectivityStatus ==
                ConnectivityStatus.Online
            ? BaseView<LauncherViewModel>(onModelReady: (model) {
                model.loopOutlottieAnimationController =
                    AnimationController(vsync: this);
                model.loopingLottieAnimationController = AnimationController(
                    vsync: this, duration: const Duration(milliseconds: 2500));

                model.init();
              }, onModelDispose: (model) {
                model.loopOutlottieAnimationController?.dispose();
                model.loopingLottieAnimationController?.dispose();
                model.exit();
              }, builder: (ctx, model, child) {
                return Scaffold(
                  backgroundColor: Colors.black,
                  body: Container(
                      width: SizeConfig.screenWidth,
                      // height: SizeConfig.screenHeight,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0D4042),
                            Color(0xFF053739),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: AnimatedOpacity(
                              opacity: model.isFetchingData ? 0 : 1,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.linear,
                              child: Lottie.asset(
                                Assets.felloSplashZoomOutLogo,
                                width: SizeConfig.screenWidth,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                controller:
                                    model.loopOutlottieAnimationController,
                                onLoaded: (composition) {
                                  model.loopOutlottieAnimationController!
                                      .duration = composition.duration;
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: AnimatedOpacity(
                              opacity: model.isFetchingData ? 1 : 0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.linear,
                              child: Lottie.asset(Assets.felloSplashLoopLogo,
                                  height: SizeConfig.screenHeight,
                                  alignment: Alignment.center,
                                  // width: SizeConfig.screenWidth,
                                  controller:
                                      model.loopingLottieAnimationController,
                                  onLoaded: (composition) {
                                model.loopingLottieAnimationController!
                                    .duration = composition.duration;
                                model.loopLottieDuration =
                                    composition.duration.inMilliseconds;
                              }, fit: BoxFit.cover),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Visibility(
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: model.isSlowConnection,
                                child: service.connectivityStatus ==
                                        ConnectivityStatus.Offline
                                    ? Text(
                                        locale.splashNoInternet,
                                        style: TextStyles.body3.bold,
                                      )
                                    : BreathingText(
                                        alertText: locale.splashSlowConnection,
                                        textStyle: TextStyles.sourceSans.body2,
                                      ),
                              ),
                            ),
                          )
                        ],
                      )),
                );
              })
            : const NoInternetView());
  }
}

class NoInternetView extends StatefulWidget {
  const NoInternetView({super.key});

  @override
  State<NoInternetView> createState() => _NoInternetViewState();
}

class _NoInternetViewState extends State<NoInternetView> {
  bool viewContent = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          viewContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D4042),
                Color(0xFF053739),
              ],
            ),
          ),
          child: viewContent
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.logoMaxSize,
                      width: SizeConfig.screenWidth! * 0.3,
                      color: UiConstants.primaryColor.withOpacity(0.3),
                    ),
                    Transform.translate(
                      offset: Offset(
                        0,
                        -SizeConfig.padding10,
                      ),
                      child: Text(
                        "No Internet Connection",
                        style: TextStyles.sourceSans.body3,
                      ),
                    )
                  ],
                )
              : const SizedBox()),
    );
  }
}

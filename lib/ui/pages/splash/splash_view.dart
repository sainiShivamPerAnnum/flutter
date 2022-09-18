import 'package:felloapp/core/enums/connectivity_status_enum.dart';
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
  @override
  State<LauncherView> createState() => _LauncherViewState();
}

class _LauncherViewState extends State<LauncherView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context, listen: true);
    S locale = S.of(context);
    return BaseView<LauncherViewModel>(
      onModelReady: (model) {
        model.loopOutlottieAnimationController =
            AnimationController(vsync: this);
        model.init();
      },
      onModelDispose: (model) {
        model.loopOutlottieAnimationController.dispose();
        model.exit();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            width: SizeConfig.screenWidth,
            // height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
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
                    duration: Duration(milliseconds: 100),
                    curve: Curves.linear,
                    child: Lottie.asset(
                      Assets.felloSplashZoomOutLogo,
                      width: SizeConfig.screenWidth,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      controller: model.loopOutlottieAnimationController,
                      onLoaded: (composition) {
                        model.loopOutlottieAnimationController
                          ..duration = composition.duration;
                      },
                    ),
                  ),
                ),
                if (model.isFetchingData)
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.asset(Assets.felloSplashLoopLogo,
                        height: SizeConfig.screenHeight,
                        alignment: Alignment.center,
                        // width: SizeConfig.screenWidth,
                        onLoaded: (composition) {
                      model.loopLottieDuration =
                          composition.duration.inMilliseconds;
                    }, fit: BoxFit.cover),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: model.isSlowConnection,
                      child: connectivityStatus == ConnectivityStatus.Offline
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
            ),
          ),
        );
      },
    );
  }
}

import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/logo/logo_container.dart';
import 'package:felloapp/ui/elements/texts/breathing_text_widget.dart';
import 'package:felloapp/ui/pages/splash/splash_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

//Flutter and dart imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LauncherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context, listen: true);
    S locale = S.of(context);
    return BaseView<LauncherViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.exit(),
      builder: (ctx, model, child) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(Assets.splashBackground),
              //     fit: BoxFit.fitWidth,
              //   ),
              // ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    child: Image.asset(
                      Assets.splashBackground,
                      width: SizeConfig.screenWidth,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.logoMaxSize,
                          width: SizeConfig.screenWidth / 3,
                        ),
                        Text(
                          locale.splashTagline,
                          style: TextStyles.body2,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: kToolbarHeight,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth * 0.1),
                      child: Column(
                        children: [
                          Text(locale.splashSecureText),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(Assets.augmontLogo,
                                  color: Colors.grey,
                                  width: SizeConfig.screenWidth * 0.2),
                              // SizedBox(width: 16),
                              // Image.asset(Assets.iciciGraphic,
                              //     width: SizeConfig.screenWidth * 0.1),
                              SizedBox(width: 16),
                              Image.asset(Assets.sebiGraphic,
                                  color: Colors.grey,
                                  width: SizeConfig.screenWidth * 0.04),
                              SizedBox(width: 16),
                              Image.asset(Assets.amfiGraphic,
                                  color: Colors.grey,
                                  width: SizeConfig.screenWidth * 0.04)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 40),
                            child: Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: model.isSlowConnection,
                              child: connectivityStatus ==
                                      ConnectivityStatus.Offline
                                  ? Text(
                                      locale.splashNoInternet,
                                      style: TextStyles.body3.bold,
                                    )
                                  : BreathingText(
                                      alertText: locale.splashSlowConnection,
                                      textStyle: TextStyles.body2,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}

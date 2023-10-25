import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class JourneyErrorScreen extends StatelessWidget {
  const JourneyErrorScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF097178).withOpacity(0.2),
            const Color(0xFF0C867C),
            const Color(0xff0B867C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(Assets.fullScreenLoaderLottie,
              height: SizeConfig.screenWidth! / 2),
          SizedBox(height: SizeConfig.padding20),
          Text(
            locale.jFailed,
            style: TextStyles.rajdhaniEB.title2,
          ),
          SizedBox(height: SizeConfig.padding20),
          AppNegativeBtn(
              btnText: locale.btnRetry,
              onPressed: () {
                AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.replaceAll,
                  page: SplashPageConfig,
                );
              })
        ],
      ),
    );
  }
}

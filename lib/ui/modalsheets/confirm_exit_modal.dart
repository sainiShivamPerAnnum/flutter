import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../pages/static/app_widget.dart';

class ConfirmExitModal extends StatelessWidget {
  const ConfirmExitModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight! * 0.59,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.padding20),
      child: Column(
        children: [
          Text(
            "Are you sure you want to exit the app?",
            style: TextStyles.sourceSansB.body1.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Text(
            "Don’t miss a chance to earn 15.5% returns & rewards on your savings",
            textAlign: TextAlign.center,
            style: TextStyles.sourceSans.body2.colour(
              const Color(0xffD9D9D9),
            ),
          ),
          LottieBuilder.network(
            Assets.goldDepostSuccessLottie,
            height: SizeConfig.screenHeight! * 0.25,
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.multiAvatars),
              const SizedBox(
                width: 4,
              ),
              Text(
                "1M+ users trust Fello",
                style: TextStyles.sourceSansB.colour(
                  const Color(0xffd9d9d9).withOpacity(0.9),
                ),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          AppPositiveBtn(
            btnText: "COMPLETE SIGN UP",
            onPressed: () {
              locator<AnalyticsService>()
                  .track(eventName: "Signup Cancel - Continue Tapped");
              AppState.backButtonDispatcher!.didPopRoute();
            },
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          TextButton(
            onPressed: () async {
              locator<AnalyticsService>()
                  .track(eventName: "Signup Cancel - Exit Tapped");
              SystemNavigator.pop();
            },
            child: Text(
              "EXIT ANYWAY",
              style: TextStyles.rajdhaniB.body2,
            ),
          )
        ],
      ),
    );
  }
}

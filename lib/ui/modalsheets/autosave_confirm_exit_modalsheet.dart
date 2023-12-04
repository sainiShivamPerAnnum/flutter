import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutosaveConfirmExitModalSheet extends StatelessWidget {
  const AutosaveConfirmExitModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (AppState.screenStack.last == ScreenItem.dialog) {
          AppState.screenStack.removeLast();
        }
        return Future.value(true);
      },
      child: Container(
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SizeConfig.padding16),
            Text(
              "Users who do an SIP, get compounded returns!",
              style: TextStyles.sourceSansSB.title4,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.padding32),
            Text("You can pause or cancel the SIP at anytime",
                style: TextStyles.sourceSans.body2),
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding32),
              child: SvgPicture.asset(
                Assets.multiAvatars,
                fit: BoxFit.cover,
                width: SizeConfig.screenWidth! * 0.6,
              ),
            ),
            AppPositiveBtn(
              btnText: "CONTINUE WITH AUTOSAVE",
              onPressed: () {
                AppState.backButtonDispatcher!.didPopRoute();
                locator<AnalyticsService>()
                    .track(eventName: AnalyticsEvents.asCancelContinueTapped);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    AppState.backButtonDispatcher!.didPopRoute();
                    AppState.backButtonDispatcher!.didPopRoute();
                    BaseUtil.openDepositOptionsModalSheet(timer: 800);
                    locator<AnalyticsService>()
                        .track(eventName: AnalyticsEvents.asCancelOTPTapped);
                  },
                  child: Text(
                    "DO A ONE-TIME PAYMENT INSTEAD",
                    style: TextStyles.sourceSans.body2,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

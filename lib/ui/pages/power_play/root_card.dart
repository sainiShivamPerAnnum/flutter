import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PowerPlayCard extends StatelessWidget {
  const PowerPlayCard({
    super.key,
  });

  String get title => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.powerplayConfig)['saveScreen']['title'];

  String get subtitle => AppConfig.getValue<Map<String, dynamic>>(
      AppConfigKey.powerplayConfig)['saveScreen']['subtitle'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.isFirstTime = false;
        Haptic.vibrate();
        locator<AnalyticsService>().track(
          eventName: AnalyticsEvents.iplBannerTapped,
          properties: {"subtitle": subtitle},
        );
        if (PreferenceHelper.getBool(PreferenceHelper.POWERPLAY_IS_PLAYED)) {
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addPage,
            page: PowerPlayHomeConfig,
          );
        } else {
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addPage,
            page: PowerPlayFTUXPageConfig,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.padding14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          border: Border.all(
            color: Colors.white.withOpacity(.1),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              UiConstants.kPowerPlayGradientPrimary,
              UiConstants.kPowerPlayGradientSecondary,
            ],
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(SizeConfig.padding1),
          padding: EdgeInsets.only(
            top: SizeConfig.padding16,
            bottom: SizeConfig.padding16,
            left: SizeConfig.pageHorizontalMargins,
            right: SizeConfig.padding16,
          ),
          child: Row(
            children: [
              SvgPicture.network(
                Assets.powerPlayMain,
                width: SizeConfig.padding80,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: SizeConfig.padding16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.rajdhaniSB.body3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyles.rajdhaniSB.body3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: SizeConfig.iconSize0,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

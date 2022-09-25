import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/enums/user_coin_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/service_elements/user_coin_service/coin_balance_text.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import '../../../core/service/analytics/analytics_service.dart';
import '../../../util/locator.dart';

class FelloCoinBar extends StatelessWidget {
  final _analytics = locator<AnalyticsService>();

  final String svgAsset;
  final Color borderColor;
  final TextStyle style;
  final double size;

  FelloCoinBar({
    this.svgAsset,
    this.borderColor,
    this.style,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    log("FLC build called");
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.AvatarRemoteMilestoneIndex],
      builder: (context, journeyModel, properties) {
        return PropertyChangeConsumer<UserCoinService,
            UserCoinServiceProperties>(
          properties: [UserCoinServiceProperties.coinBalance],
          builder: (context, model, properties) {
            return GestureDetector(
              onTap: () {
                if (JourneyService.isAvatarAnimationInProgress) return;
                _analytics.track(
                    eventName: AnalyticsEvents.addFLCTokensTopRight);
                BaseUtil.openModalBottomSheet(
                  addToScreenStack: true,
                  backgroundColor: UiConstants.gameCardColor,
                  content: WantMoreTicketsModalSheet(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness24),
                    topRight: Radius.circular(SizeConfig.roundness24),
                  ),
                  hapticVibrate: true,
                  isScrollControlled: true,
                  isBarrierDismissable: true,
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding8,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding12,
                    vertical: SizeConfig.padding6),
                height: SizeConfig.roundedButtonRadius * 2,
                decoration: BoxDecoration(
                  color: UiConstants.kTextFieldColor.withOpacity(0.4),
                  border: Border.all(color: borderColor ?? Colors.white10),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      svgAsset ?? Assets.token,
                      height: size ?? SizeConfig.padding20,
                      width: size ?? SizeConfig.padding20,
                    ),
                    SizedBox(width: SizeConfig.padding4),
                    model.flcBalance == null
                        ? SpinKitThreeBounce(
                            size: SizeConfig.padding16,
                            color: Colors.white,
                          )
                        : CoinBalanceTextSE(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

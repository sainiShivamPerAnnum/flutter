import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/ui/modalsheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/service_elements/user_coin_service/coin_balance_text.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/service/analytics/analytics_service.dart';
import '../../../util/locator.dart';

class FelloCoinBar extends StatelessWidget {
  final AnalyticsService? _analytics = locator<AnalyticsService>();
  final Key? key;
  final String? svgAsset;
  final Color? borderColor;
  final TextStyle? style;
  final double? size;

  FelloCoinBar({
    this.key,
    this.svgAsset,
    this.borderColor,
    this.style,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    log("FLC build called");
    return Consumer<UserCoinService>(
      builder: (context, model, properties) {
        return GestureDetector(
          onTap: () {
            if (JourneyService.isAvatarAnimationInProgress) return;
            _analytics!.track(eventName: AnalyticsEvents.addFLCTokensTopRight);
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
              isBarrierDismissible: true,
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding8,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding12,
                vertical: SizeConfig.padding6),
            height: SizeConfig.avatarRadius * 2,
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
                model!.flcBalance == null
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
  }
}

class CoinBar extends StatelessWidget {
  final Widget child;
  const CoinBar({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding8,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding12, vertical: SizeConfig.padding6),
      height: SizeConfig.avatarRadius * 2,
      decoration: BoxDecoration(
        color: UiConstants.kTextFieldColor.withOpacity(0.4),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            Assets.token,
            height: SizeConfig.padding20,
            width: SizeConfig.padding20,
          ),
          SizedBox(width: SizeConfig.padding4),
          child
        ],
      ),
    );
  }
}

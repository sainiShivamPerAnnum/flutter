import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/ui/modalsheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/service_elements/user_coin_service/coin_balance_text.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../core/service/analytics/analytics_service.dart';
import '../../../util/locator.dart';

class FelloCoinBar extends StatelessWidget {
  final AnalyticsService _analytics = locator<AnalyticsService>();
  @override
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
                model.flcBalance == null
                    ? SpinKitThreeBounce(
                        size: SizeConfig.padding16,
                        color: Colors.white,
                      )
                    : const CoinBalanceTextSE(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FelloInfoBar extends StatelessWidget {
  final String? svgAsset;
  final String? lottieAsset;
  final Color? borderColor;
  final TextStyle? style;
  final double? size;
  final String? child;
  final bool mark;
  final VoidCallback onPressed;

  const FelloInfoBar(
      {required this.onPressed,
      super.key,
      this.svgAsset,
      this.lottieAsset,
      this.borderColor,
      this.style,
      this.size,
      this.child,
      this.mark = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding2,
        ),
        height: SizeConfig.avatarRadius * 2,
        decoration: BoxDecoration(
          color: UiConstants.kTextFieldColor.withOpacity(0.4),
          border: Border.all(color: borderColor ?? Colors.white10),
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: SizeConfig.padding8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: SizeConfig.padding12),
                    if (lottieAsset != null)
                      Transform.translate(
                        offset: Offset(0, -SizeConfig.padding2),
                        child: Lottie.asset(
                          lottieAsset!,
                          repeat: false,
                          height: size ?? SizeConfig.padding20,
                          width: size ?? SizeConfig.padding20,
                        ),
                      ),
                    if (svgAsset != null)
                      SvgPicture.asset(
                        svgAsset ?? Assets.token,
                        height: size ?? SizeConfig.padding20,
                        width: size ?? SizeConfig.padding20,
                      ),
                    SizedBox(width: SizeConfig.padding4),
                    child != null
                        ? Text(child!,
                            style: TextStyles.sourceSansM.body2
                                .colour(Colors.white))
                        : const SizedBox(),
                    SizedBox(width: SizeConfig.padding12),
                  ],
                ),
                SizedBox(height: SizeConfig.padding6),
              ],
            ),
            if (mark)
              const Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.red,
                ),
              )
          ],
        ),
      ),
    );
  }
}

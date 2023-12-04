import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FloPremiumTierCard extends StatelessWidget {
  const FloPremiumTierCard({
    required this.userService,
    required this.tier,
    required this.actionUri,
    required this.cta,
    super.key,
    this.title,
    this.lockIn,
    this.minInvestment,
    this.summary,
    this.promoText,
  });

  final String tier;
  final String? title;
  final String? lockIn;
  final String? summary;
  final String? minInvestment;
  final String actionUri;
  final VoidCallback cta;
  final UserService userService;
  final String? promoText;

  void trackTierCardTap(
    String assetName,
  ) {
    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.floSlabBannerTapped, properties: {
      "asset name": assetName,
      "new user":
          locator<UserService>().userSegments.contains(Constants.NEW_USER),
      "invested amount": getTrail(),
      "current amount": getLead(),
      "lockin period": lockIn,
    });
  }

  @override
  Widget build(BuildContext context) {
    // List lendboxDetails = AppConfig.getValue(AppConfigKey.lendbox);

    return Column(
      children: [
        InkWell(
          onTap: () {
            Haptic.vibrate();
            AppState.delegate!.parseRoute(Uri.parse(actionUri));
            trackTierCardTap(title!);
          },
          child: Container(
            // margin: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                color: Colors.white10),
            padding: EdgeInsets.all(SizeConfig.padding16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title ?? 'Fello Flo',
                              style: TextStyles.sourceSansB.title5,
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.padding6),
                        Row(
                          children: [
                            FloPremiumTierChip(value: lockIn),
                            if (!isUserInvestedInThisTier())
                              SizedBox(width: SizeConfig.padding16),
                            if (!isUserInvestedInThisTier())
                              FloPremiumTierChip(value: minInvestment),
                            if (!isUserInvestedInThisTier())
                              SizedBox(width: SizeConfig.padding16),
                          ],
                        )
                      ],
                    ),

                    const Spacer(),
                    Transform.translate(
                      offset: Offset(SizeConfig.padding4, SizeConfig.padding2),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: SizeConfig.iconSize1,
                      ),
                    )
                    // SizedBox(
                    //   width: SizeConfig.padding80,
                    //   child: MaterialButton(
                    //     color: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius:
                    //             BorderRadius.circular(SizeConfig.roundness5)),
                    //     // height: SizeConfig.padding44,
                    //     padding: EdgeInsets.all(SizeConfig.padding6),
                    //     onPressed: cta,
                    //     child: FittedBox(
                    //       fit: BoxFit.scaleDown,
                    //       child: Text(
                    //         "SAVE",
                    //         style:
                    //             TextStyles.sourceSansB.body2.colour(Colors.black),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                SizedBox(height: SizeConfig.padding16),
                isUserInvestedInThisTier()
                    ? FloBalanceBriefRow(
                        tier: tier,
                        mini: true,
                      )
                    : SizedBox(
                        child: Text(
                          summary ?? "",
                          style: TextStyles.body3.colour(
                            Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        if (promoText != null && promoText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding4,
                horizontal: SizeConfig.padding16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: promoText!.beautify(
                    boldStyle:
                        TextStyles.sourceSansB.body4.colour(Colors.white),
                    style: TextStyles.sourceSans.body4.colour(Colors.white),
                    alignment: TextAlign.left,
                  ),
                ),
                SizedBox(width: SizeConfig.padding16),
                MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5)),
                  // height: SizeConfig.padding44,
                  // padding: EdgeInsets.all(SizeConfig.padding6),
                  onPressed: cta,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "SAVE",
                      style: TextStyles.sourceSansB.body2.colour(Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  double getLead() {
    switch (tier) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return userService.userPortfolio.flo.fixed2.balance;
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return userService.userPortfolio.flo.fixed1.balance;
      case Constants.ASSET_TYPE_FLO_FELXI:
        return userService.userPortfolio.flo.flexi.balance;

      default:
        return 0;
    }
  }

  double getTrail() {
    switch (tier) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return userService.userPortfolio.flo.fixed2.principle;
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return userService.userPortfolio.flo.fixed1.principle;
      case Constants.ASSET_TYPE_FLO_FELXI:
        return userService.userPortfolio.flo.flexi.principle;
      default:
        return 0;
    }
  }

  bool isUserInvestedInThisTier() {
    switch (tier) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return (userService.userPortfolio.flo.fixed2.balance) > 0;
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return (userService.userPortfolio.flo.fixed1.balance) > 0;
      case Constants.ASSET_TYPE_FLO_FELXI:
        return (userService.userPortfolio.flo.flexi.balance) > 0;
      default:
        return false;
    }
  }
}

class FloPremiumTierChip extends StatelessWidget {
  const FloPremiumTierChip({
    super.key,
    this.value,
  });

  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding6),
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding2, horizontal: SizeConfig.padding10),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness8,
        ),
      ),
      child: Text(
        value ?? "-",
        style: TextStyles.body4.colour(Colors.white),
      ),
    );
  }
}

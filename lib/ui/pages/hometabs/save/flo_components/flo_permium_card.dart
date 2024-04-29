import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FloPremiumTierCard extends StatelessWidget {
  const FloPremiumTierCard({
    required this.tier,
    required this.actionUri,
    required this.onTapSave,
    required this.newUser,
    required this.portfolio,
    required this.title,
    required this.lockIn,
    required this.minInvestment,
    required this.summary,
    required this.promoText,
    super.key,
  });

  final String tier;
  final String title;
  final String lockIn;
  final String summary;
  final String minInvestment;
  final String actionUri;
  final VoidCallback onTapSave;
  final String promoText;
  final bool newUser;
  final Portfolio portfolio;

  void trackTierCardTap(String assetName) {
    final props = {
      "asset name": assetName,
      "new user": newUser,
      "invested amount": getTrail(),
      "current amount": getLead(),
      "lockin period": lockIn,
    };

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.floSlabBannerTapped,
      properties: props,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Haptic.vibrate();
            AppState.delegate!.parseRoute(Uri.parse(actionUri));
            trackTierCardTap(title);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              color: Colors.white10,
            ),
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
                              title,
                              style: TextStyles.sourceSansB.title5,
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.padding6),
                        Row(
                          children: [
                            FloPremiumTierChip(value: lockIn),
                            if (!isUserInvestedInThisTier()) ...[
                              SizedBox(width: SizeConfig.padding16),
                              FloPremiumTierChip(value: minInvestment),
                              SizedBox(width: SizeConfig.padding16),
                            ]
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
                  ],
                ),
                SizedBox(height: SizeConfig.padding16),
                if (isUserInvestedInThisTier())
                  FloBalanceBriefRow(
                    tier: tier,
                    mini: true,
                  )
                else
                  SizedBox(
                    child: Text(
                      summary,
                      style: TextStyles.body3.colour(
                        Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (promoText.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding4,
              horizontal: SizeConfig.padding16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: promoText.beautify(
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
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                  onPressed: onTapSave,
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

  num getLead() {
    return portfolio.flo.assetInfo[tier]!.balance;
  }

  num getTrail() {
    return portfolio.flo.assetInfo[tier]!.principle;
  }

  bool isUserInvestedInThisTier() {
    return portfolio.flo.assetInfo[tier]!.balance > 0;
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
        vertical: SizeConfig.padding2,
        horizontal: SizeConfig.padding10,
      ),
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

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_permium_card.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FloPremiumSection extends StatelessWidget {
  final UserService model;

  const FloPremiumSection({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = BaseUtil.calculateRemainingDays(
        DateTime(2023, 9, 1)); // Set the end date as September 1

    bool isLendboxOldUser = model.userSegments.contains(Constants.US_FLO_OLD);

    List lendboxDetails = AppConfig.getValue(AppConfigKey.lendbox);

    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.pageHorizontalMargins / 2,
                  horizontal: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: const Color(0xFF326164)),
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                color: const Color(0xFF013B3F),
              ),
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  FloPremiumTierCard(
                    userService: model,
                    title: "12% Flo",
                    summary: lendboxDetails[0]["descText"] ??
                        "Ideal for diversifying portfolios, long term gains especially for salaried individuals",
                    lockIn: lendboxDetails[0]["maturityPeriodText"] ??
                        "6 months maturity",
                    minInvestment:
                        lendboxDetails[0]["minAmountText"] ?? "Min - ₹25,000",
                    tier: Constants.ASSET_TYPE_FLO_FIXED_6,
                    actionUri: "flo12Details",
                    promoText: (lendboxDetails[0]["tambolaMultiplier"] != null)
                        ? "Get *${lendboxDetails[0]["tambolaMultiplier"]}X tickets* on saving in 12% Flo till maturity"
                        : null,
                    cta: () => BaseUtil.openFloBuySheet(
                        floAssetType: Constants.ASSET_TYPE_FLO_FIXED_6),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.screenWidth! / 8,
                ),
                width: SizeConfig.screenWidth! * 0.5,
                child: Stack(
                  children: [
                    Container(
                      // alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding12,
                          vertical: SizeConfig.padding2),
                      decoration: BoxDecoration(
                        color: const Color(0xff62E3C4),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12),
                      ),
                      child: Shimmer.fromColors(
                        period: const Duration(milliseconds: 2500),
                        baseColor: Colors.grey[900]!,
                        highlightColor: Colors.grey[100]!,
                        loop: 3,
                        child:
                            "Available only for *$daysRemaining days*".beautify(
                          boldStyle:
                              TextStyles.sourceSansB.body4.colour(Colors.white),
                          style:
                              TextStyles.sourceSans.body4.colour(Colors.white),
                          alignment: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      child: CustomPaint(
                        size: Size(
                            SizeConfig.padding14,
                            (SizeConfig.padding14 * 1.09).toDouble()),
                        painter: StarCustomPainter(),
                      ),
                    ),
                    Positioned(
                      right: 22,
                      child: CustomPaint(
                        size: Size(
                            SizeConfig.padding8,
                            (SizeConfig.padding8 * 1.09).toDouble()),
                        painter: StarCustomPainter(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        if (!isLendboxOldUser)
          Container(
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.pageHorizontalMargins / 2,
                horizontal: SizeConfig.pageHorizontalMargins),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: const Color(0xFF326164),
              ),
              borderRadius: BorderRadius.circular(
                SizeConfig.roundness12,
              ),
              color: const Color(0xFF013B3F),
            ),
            width: SizeConfig.screenWidth,
            child: FloPremiumTierCard(
              userService: model,
              title: "10% Flo",
              summary: lendboxDetails[1]["descText"] ??
                  "Ideal for diversifying portfolios, long term gains especially for salaried individuals",
              lockIn: lendboxDetails[1]["maturityPeriodText"] ??
                  "6 months maturity",
              minInvestment:
                  lendboxDetails[1]["minAmountText"] ?? "Min - ₹25,000",
              tier: Constants.ASSET_TYPE_FLO_FIXED_3,
              actionUri: "flo10Details",
              promoText: (lendboxDetails[1]["tambolaMultiplier"] != null)
                  ? "Get *${lendboxDetails[1]["tambolaMultiplier"]}X tickets* on saving in 10% Flo till maturity"
                  : null,
              cta: () => BaseUtil.openFloBuySheet(
                  floAssetType: Constants.ASSET_TYPE_FLO_FIXED_3),
            ),
          ),
      ],
    );
  }
}

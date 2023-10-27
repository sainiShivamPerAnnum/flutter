import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_permium_card.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FloPremiumSection extends StatelessWidget {
  final UserService model;

  const FloPremiumSection({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                        : "Get consistent returns on saving in 12% Flo till maturity",
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
                  child: const AvailabilityOfferWidget()),
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
                  : "Get consistent returns on saving in 10% Flo till maturity",
              cta: () => BaseUtil.openFloBuySheet(
                  floAssetType: Constants.ASSET_TYPE_FLO_FIXED_3),
            ),
          ),
      ],
    );
  }
}

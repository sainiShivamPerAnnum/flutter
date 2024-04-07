import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
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
    final oldLBUser = model.userSegments.contains(Constants.US_FLO_OLD);
    final newUser = model.userSegments.contains(Constants.NEW_USER);
    final portfolio = model.userPortfolio;

    final assetConfiguration = AppConfigV2.instance.lendBoxP2P.where(
      (element) => element.fundType != FundType.UNI_FLEXI,
    );

    return Column(
      children: [
        for (final configuration in assetConfiguration)
          if (!(configuration.fundType != FundType.UNI_FIXED_3 && oldLBUser))
            _FloAssetCard(
              portfolio: portfolio,
              newUser: newUser,
              oldLBUser: oldLBUser,
              model: model,
              assetConfig: configuration,
              onTapSave: () => BaseUtil.openFloBuySheet(
                floAssetType: configuration.fundType.name,
              ),
            ),
      ],
    );
  }
}

class _FloAssetCard extends StatelessWidget {
  const _FloAssetCard({
    required this.model,
    required this.assetConfig,
    required this.oldLBUser,
    required this.onTapSave,
    required this.newUser,
    required this.portfolio,
  });

  final UserService model;
  final LendboxAssetConfiguration assetConfig;
  final bool oldLBUser;
  final VoidCallback onTapSave;
  final bool newUser;
  final Portfolio portfolio;

  ({int percentage, String redirection}) _getAssetDetails(FundType fundType) {
    return switch (fundType) {
      FundType.UNI_FIXED_6 => (percentage: 12, redirection: 'flo12Details'),
      FundType.UNI_FIXED_3 => (percentage: 10, redirection: 'flo10Details'),
      FundType.UNI_FLEXI when oldLBUser => (
          percentage: 10,
          redirection: 'flo10Details'
        ),
      _ => (percentage: 8, redirection: 'flo10Details'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (:percentage, :redirection) = _getAssetDetails(assetConfig.fundType);
    final decoration = BoxDecoration(
      border: Border.all(
        width: 1,
        strokeAlign: BorderSide.strokeAlignOutside,
        color: const Color(0xFF326164),
      ),
      borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      color: const Color(0xFF013B3F),
    );
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.pageHorizontalMargins / 2,
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      decoration: decoration,
      child: FloPremiumTierCard(
        portfolio: portfolio,
        newUser: newUser,
        title: "$percentage% Flo",
        summary: assetConfig.descText,
        lockIn: assetConfig.maturityPeriodText,
        minInvestment: assetConfig.minAmountText,
        tier: assetConfig.fundType.name,
        actionUri: redirection,
        promoText:
            "Get *${assetConfig.tambolaMultiplier}X tickets* on saving in $percentage% Flo till maturity",
        onTapSave: onTapSave,
      ),
    );
  }
}

import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FloPremiumTierCard extends StatelessWidget {
  const FloPremiumTierCard({
    super.key,
    required this.userService,
    required this.tier,
    this.title,
    this.lockIn,
    this.minInvestment,
    this.summary,
    required this.actionUri,
    required this.cta,
  });

  final String tier;
  final String? title;
  final String? lockIn;
  final String? summary;
  final String? minInvestment;
  final String actionUri;
  final VoidCallback cta;
  final UserService userService;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Haptic.vibrate();
        AppState.delegate!.parseRoute(Uri.parse(actionUri));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.roundness16),
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
                      children: [
                        Text(
                          title ?? 'Fello Flo',
                          style: TextStyles.sourceSansB.title5,
                        ),
                        Transform.translate(
                          offset:
                              Offset(SizeConfig.padding4, SizeConfig.padding2),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: SizeConfig.iconSize1,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: SizeConfig.padding6),
                    Row(
                      children: [
                        FloPremiumTierChip(value: lockIn),
                        if (!isUserInvestedInThisTier())
                          SizedBox(width: SizeConfig.padding4),
                        if (!isUserInvestedInThisTier())
                          FloPremiumTierChip(value: minInvestment),
                        if (!isUserInvestedInThisTier())
                          SizedBox(width: SizeConfig.padding4),
                      ],
                    )
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: SizeConfig.padding80,
                  child: MaterialButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness5)),
                    // height: SizeConfig.padding44,
                    padding: EdgeInsets.all(SizeConfig.padding6),
                    onPressed: cta,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "INVEST",
                        style:
                            TextStyles.sourceSansB.body2.colour(Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: SizeConfig.padding16),
            isUserInvestedInThisTier()
                ? FloBalanceBriefRow(
                    tier: tier!,
                    mini: true,
                  )
                : SizedBox(
                    child: Text(
                      summary ?? "",
                      style: TextStyles.body3.colour(
                        Colors.white.withOpacity(0.6),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  double getLead() {
    switch (tier) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return userService.userFundWallet?.wLbBalance ?? 0;
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return userService.userFundWallet?.wLbBalance ?? 0;
      case Constants.ASSET_TYPE_FLO_FELXI:
        return userService.userFundWallet?.wLbBalance ?? 0;
      default:
        return 0;
    }
  }

  double getTrail() {
    switch (tier) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return userService.userFundWallet?.wLbPrinciple ?? 0;
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return userService.userFundWallet?.wLbPrinciple ?? 0;
      case Constants.ASSET_TYPE_FLO_FELXI:
        return userService.userFundWallet?.wLbPrinciple ?? 0;
      default:
        return 0;
    }
  }

  bool isUserInvestedInThisTier() {
    switch (tier) {
      case Constants.ASSET_TYPE_FLO_FIXED_6:
        return (userService.userFundWallet?.wLbPrinciple ?? 0) > 0;
      case Constants.ASSET_TYPE_FLO_FIXED_3:
        return (userService.userFundWallet?.wLbPrinciple ?? 0) > 0;
      case Constants.ASSET_TYPE_FLO_FELXI:
        return (userService.userFundWallet?.wLbPrinciple ?? 0) > 0;
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

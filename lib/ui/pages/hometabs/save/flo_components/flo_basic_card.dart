import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_permium_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloBasicCard extends StatelessWidget {
  final UserService model;
  const FloBasicCard({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isLendboxOldUser = model.userSegments.contains(Constants.US_FLO_OLD);
    List lendboxDetails = AppConfig.getValue(AppConfigKey.lendbox);
    //if true => user will se 10%
    //else => user will se 8%
    double basicPrinciple = getPrinciple(isLendboxOldUser);
    double basicBalance = getBalance(isLendboxOldUser);
    double percent = getPercent(isLendboxOldUser);
    return InkWell(
      onTap: () => BaseUtil.openFloBuySheet(
          floAssetType: Constants.ASSET_TYPE_FLO_FELXI),
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.pageHorizontalMargins / 2,
            horizontal: SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(
            SizeConfig.roundness24,
          ),
          color: UiConstants.kFloContainerColor,
        ),
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.pageHorizontalMargins,
            horizontal: SizeConfig.pageHorizontalMargins),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fello Flo Basic",
              style: TextStyles.rajdhaniSB.title4,
            ),
            SizedBox(height: SizeConfig.padding16),
            basicPrinciple > 0
                ? Row(
                    children: [
                      Text(isLendboxOldUser ? "10% Flo" : '8% Flo',
                          style: TextStyles.sourceSansB.title5),
                      const Spacer(),
                      FloPremiumTierChip(
                          value: isLendboxOldUser
                              ? lendboxDetails[2]["maturityPeriodText"]
                              : lendboxDetails[3]["maturityPeriodText"] ??
                                  "1 Week Lockin"),
                    ],
                  )
                : Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isLendboxOldUser ? "10% Flo" : '8% Flo',
                            style: TextStyles.sourceSansB.title5),
                        SizedBox(height: SizeConfig.padding4),
                        FloPremiumTierChip(
                          value: isLendboxOldUser
                              ? lendboxDetails[2]["minAmountText"]
                              : lendboxDetails[3]["minAmountText"],
                        ),
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
                        onPressed: () => BaseUtil.openFloBuySheet(
                            floAssetType: Constants.ASSET_TYPE_FLO_FELXI),

                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "SAVE",
                            style: TextStyles.sourceSansB.body2
                                .colour(Colors.black),
                          ),
                        ),
                      ),
                    )
                  ]),
            SizedBox(height: SizeConfig.padding16),
            basicPrinciple > 0
                ? const FloBalanceBriefRow(
                    tier: Constants.ASSET_TYPE_FLO_FELXI,
                    mini: true,
                  )
                : SizedBox(
                    child: Text(
                      isLendboxOldUser
                          ? lendboxDetails[2]["descText"]
                          : lendboxDetails[3]["descText"] ??
                              "Ideal for diversifying portfolios, long term gains especially for salaried individuals",
                      style: TextStyles.body3.colour(
                        Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
            SizedBox(height: SizeConfig.padding10),
            if (basicPrinciple > 0)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        log(locator<BankAndPanService>()
                            .isBankDetailsAdded
                            .toString());
                        if (locator<BankAndPanService>().isBankDetailsAdded) {
                          BaseUtil().openSellModalSheet(
                              investmentType: InvestmentType.LENDBOXP2P);
                        } else {
                          BaseUtil.openDialog(
                            isBarrierDismissible: true,
                            addToScreenStack: true,
                            barrierColor: Colors.black87,
                            hapticVibrate: true,
                            content: MoreInfoDialog(
                              title:
                                  "Add Bank Information to withdraw your inveinvestment ",
                              text:
                                  "Your Bank account will be register and verified in x working days",
                              btnText: "ADD BANK INFORMATION",
                              asset: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                padding: EdgeInsets.all(SizeConfig.padding12),
                                child: SvgPicture.asset(
                                  Assets.bankLogo,
                                  width: SizeConfig.padding70,
                                ),
                              ),
                              onPressed: () {
                                AppState.backButtonDispatcher!.didPopRoute();
                                AppState.delegate!
                                    .parseRoute(Uri.parse("bankDetails"));
                              },
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(const BorderSide(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid))),
                      child: Text(
                        "WITHDRAW",
                        style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding16),
                  Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness5),
                      ),
                      color: Colors.white,
                      onPressed: () => BaseUtil.openFloBuySheet(
                          floAssetType: Constants.ASSET_TYPE_FLO_FELXI),
                      child: Text(
                        "SAVE",
                        style: TextStyles.rajdhaniB.body2.colour(Colors.black),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  double getPrinciple(bool isLendboxOldUser) {
    if (isLendboxOldUser) {
      return model.userFundWallet?.wLbPrinciple ?? 0;
    } else {
      return model.userFundWallet?.wLbPrinciple ?? 0;
    }
  }

  double getBalance(bool isLendboxOldUser) {
    if (isLendboxOldUser) {
      return model.userFundWallet?.wLbBalance ?? 0;
    } else {
      return model.userFundWallet?.wLbBalance ?? 0;
    }
  }

  double getPercent(isLendboxOldUser) {
    if (isLendboxOldUser) {
      return 0.05;
    } else {
      return 0.01;
    }
  }
}

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/modalsheets/gold_sell_reason_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/save/flo_components/flo_permium_card.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
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

  void trackBasicCardWithdrawTap(bool isLendboxOldUser, String lockIn) {
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.withdrawFloTapped,
      properties: {
        "asset name": isLendboxOldUser ? "10% Flo" : "8% Flo",
        "new user":
            locator<UserService>().userSegments.contains(Constants.NEW_USER),
        "invested amount": getPrinciple(isLendboxOldUser),
        "current amount": getBalance(isLendboxOldUser),
        "lockin period": lockIn,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLendboxOldUser = model.userSegments.contains(Constants.US_FLO_OLD);
    List lendboxDetails = AppConfig.getValue(AppConfigKey.lendbox);
    double basicPrinciple = getPrinciple(isLendboxOldUser);

    return InkWell(
      onTap: () {
        BaseUtil.openFloBuySheet(floAssetType: Constants.ASSET_TYPE_FLO_FELXI);
        trackBasicCardWithdrawTap(
          isLendboxOldUser,
          isLendboxOldUser
              ? lendboxDetails[2]["maturityPeriodText"]
              : lendboxDetails[3]["maturityPeriodText"] ?? "1 Week Lockin",
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: SizeConfig.pageHorizontalMargins / 2,
          horizontal: SizeConfig.pageHorizontalMargins,
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding12,
                horizontal: SizeConfig.padding16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                color: Colors.white10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (basicPrinciple < 0)
                    Column(
                      children: [
                        Text(
                          isLendboxOldUser ? "10% Flo" : '8% Flo',
                          style: TextStyles.sourceSansB.title5,
                        ),
                        SizedBox(height: SizeConfig.padding8),
                        FloPremiumTierChip(
                          value: isLendboxOldUser
                              ? lendboxDetails[2]["maturityPeriodText"]
                              : lendboxDetails[3]["maturityPeriodText"] ??
                                  "1 Week Lockin",
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLendboxOldUser ? "10% Flo" : '8% Flo',
                              style: TextStyles.sourceSansB.title5,
                            ),
                            SizedBox(height: SizeConfig.padding4),
                            Row(
                              children: [
                                FloPremiumTierChip(
                                  value: isLendboxOldUser
                                      ? lendboxDetails[2]["minAmountText"]
                                      : lendboxDetails[3]["minAmountText"],
                                ),
                                SizedBox(width: SizeConfig.padding16),
                                FloPremiumTierChip(
                                  value: isLendboxOldUser
                                      ? lendboxDetails[2]["maturityPeriodText"]
                                      : lendboxDetails[3]
                                              ["maturityPeriodText"] ??
                                          "1 Week Lockin",
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  SizedBox(height: SizeConfig.padding12),
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
                ],
              ),
            ),
            if (basicPrinciple > 0)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding8,
                  horizontal: SizeConfig.padding16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (locator<BankAndPanService>().isBankDetailsAdded) {
                            BaseUtil.openModalBottomSheet(
                              backgroundColor:
                                  UiConstants.kModalSheetBackgroundColor,
                              isBarrierDismissible: true,
                              addToScreenStack: true,
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(SizeConfig.roundness32),
                                topRight:
                                    Radius.circular(SizeConfig.roundness32),
                              ),
                              content: const SellingReasonBottomSheet(
                                investmentType: InvestmentType.LENDBOXP2P,
                              ),
                            );
                          } else {
                            BaseUtil.openDialog(
                              isBarrierDismissible: true,
                              addToScreenStack: true,
                              barrierColor: Colors.black87,
                              hapticVibrate: true,
                              content: MoreInfoDialog(
                                title:
                                    "Add your Bank Details to withdraw your investment ",
                                text: "",
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
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Text(
                          key: const ValueKey('floWithdraw'),
                          "WITHDRAW",
                          style:
                              TextStyles.rajdhaniSB.body2.colour(Colors.white),
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
                        onPressed: () {
                          BaseUtil.openFloBuySheet(
                            floAssetType: Constants.ASSET_TYPE_FLO_FELXI,
                          );
                        },
                        child: Text(
                          "SAVE",
                          style:
                              TextStyles.rajdhaniB.body2.colour(Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding4,
                  horizontal: SizeConfig.padding16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child:
                          "Get *1 Ticket for every ₹${AppConfig.getValue(AppConfigKey.tambola_cost)}* saved in ${isLendboxOldUser ? 10 : 8}% Flo"
                              .beautify(
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
                            BorderRadius.circular(SizeConfig.roundness5),
                      ),
                      onPressed: () => BaseUtil.openFloBuySheet(
                        floAssetType: Constants.ASSET_TYPE_FLO_FELXI,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "SAVE",
                          style:
                              TextStyles.sourceSansB.body2.colour(Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  double getPrinciple(bool isLendboxOldUser) {
    return model.userFundWallet?.wLbPrinciple ?? 0;
  }

  double getBalance(bool isLendboxOldUser) {
    return model.userFundWallet?.wLbBalance ?? 0;
  }

  double getPercent(bool isLendboxOldUser) {
    return isLendboxOldUser ? 0.05 : 0.01;
  }
}

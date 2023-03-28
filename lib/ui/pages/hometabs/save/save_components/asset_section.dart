import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/elements/custom_card/custom_cards.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/ui/service_elements/user_service/net_worth_value.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:showcaseview/showcaseview.dart';

class SaveNetWorthSection extends StatelessWidget {
  final SaveViewModel saveViewModel;

  const SaveNetWorthSection({Key? key, required this.saveViewModel})
      : super(key: key);

  getAssetsOrder() {
    S locale = locator<S>();
    List<Widget> orderedAssets = [];
    DynamicUiUtils.saveViewOrder[0].forEach((key) {
      switch (key) {
        case 'LB':
          orderedAssets.add(
            Showcase(
              key: ShowCaseKeys.LendBoxAssetKey,
              description:
                  'You can also invest in P2P asset Fello Flo, which gives you 10% returns per annum',
              child: SaveCustomCard(
                title: locale.felloFloMainTitle,
                subtitle: locale.currentValue,
                chipText: ["P2P Asset", "Safe & Secure", "10% Returns"],
                key: Key(Constants.ASSET_TYPE_LENDBOX),
                cardBgColor: UiConstants.kSaveStableFelloCardBg,
                cardAssetName: Assets.felloFlo,
                investmentType: InvestmentType.LENDBOXP2P,
                onCardTap: () {
                  saveViewModel.navigateToSaveAssetView(
                    InvestmentType.LENDBOXP2P,
                  );
                },
                onTap: () {
                  Haptic.vibrate();

                  locator<AnalyticsService>()
                      .track(eventName: "Save on Asset Banner", properties: {
                    "asset name": "LENDBOX",
                    "balance in gold":
                        locator<UserService>().userFundWallet?.augGoldBalance ??
                            0,
                    "balance in flo":
                        locator<UserService>().userFundWallet?.wLbBalance ?? 0,
                  });
                  return BaseUtil().openRechargeModalSheet(
                    investmentType: InvestmentType.LENDBOXP2P,
                  );
                },
              ),
            ),
          );
          break;
        case 'AG':
          orderedAssets.add(
            Showcase(
              key: ShowCaseKeys.GoldAssetKey,
              description:
                  'You can start your savings journey on Fello with Digital Gold - a secure and stable asset',
              child: SaveCustomCard(
                title: locale.digitalGoldMailTitle,
                subtitle: locale.youOwn,
                chipText: [
                  "Safe & Secure",
                  "24K Gold",
                  "99.9% Pure",
                ],
                key: Key(Constants.ASSET_TYPE_AUGMONT),
                cardBgColor: UiConstants.kSaveDigitalGoldCardBg,
                cardAssetName: Assets.digitalGoldBar,
                investmentType: InvestmentType.AUGGOLD99,
                onCardTap: () {
                  saveViewModel.navigateToSaveAssetView(
                    InvestmentType.AUGGOLD99,
                  );
                },
                onTap: () {
                  Haptic.vibrate();
                  locator<AnalyticsService>()
                      .track(eventName: "Save on Asset Banner", properties: {
                    "asset name": "LENDBOX",
                    "isNewUser": false,
                    "balance in gold":
                        locator<UserService>().userFundWallet?.augGoldBalance ??
                            0,
                    "balance in flo":
                        locator<UserService>().userFundWallet?.wLbBalance ?? 0,
                  });
                  return BaseUtil().openRechargeModalSheet(
                    investmentType: InvestmentType.AUGGOLD99,
                  );
                },
              ),
            ),
          );
          break;
      }
    });
    return Column(
      children: orderedAssets,
    );
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      // height: SizeConfig.screenWidth * 1.4,
      margin: EdgeInsets.only(bottom: SizeConfig.padding16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(SizeConfig.roundness16),
          bottomRight: Radius.circular(SizeConfig.roundness16),
        ),
        color: UiConstants.kSecondaryBackgroundColor,
      ),
      child: Column(
        children: [
          // SizedBox(
          //   height: SizeConfig.padding12,
          // ),
          PropertyChangeConsumer<UserService, UserServiceProperties>(
            properties: [UserServiceProperties.myUserFund],
            builder: (context, model, property) => Container(
              height: SizeConfig.screenWidth! * 0.22,
              child: model?.userFundWallet?.netWorth != null &&
                      model?.userFundWallet?.netWorth != 0
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: SizeConfig.padding12,
                          ),
                          Text(
                            locale.totalSavings,
                            style: TextStyles.rajdhani.body2
                                .colour(UiConstants.kTextColor),
                            key: ValueKey(Constants.TOTAL_SAVINGS),
                          ),
                          NetWorthValue(
                            style: TextStyles.sourceSans.title0.bold,
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding12,
                          horizontal: SizeConfig.pageHorizontalMargins),
                      child: Text(
                        "Take your first step towards healthy Savings",
                        textAlign: TextAlign.center,
                        style:
                            TextStyles.rajdhaniSB.title4.colour(Colors.white),
                      ),
                    ),
            ),
          ),
          getAssetsOrder(),
          SaveAssetsFooter(),
        ],
      ),
    );
  }
}

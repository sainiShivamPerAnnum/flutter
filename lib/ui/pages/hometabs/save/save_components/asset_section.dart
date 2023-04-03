import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
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
                chipText: const ["P2P Asset", "Safe & Secure", "10% Returns"],
                key: const Key(Constants.ASSET_TYPE_LENDBOX),
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
                chipText: const [
                  "Safe & Secure",
                  "24K Gold",
                  "99.9% Pure",
                ],
                key: const Key(Constants.ASSET_TYPE_AUGMONT),
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
            properties: const [UserServiceProperties.myUserFund],
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
                            key: const ValueKey(Constants.TOTAL_SAVINGS),
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
          const SizedBox(
            height: 15,
          ),
          const SaveAssetsFooter(),
        ],
      ),
    );
  }
}

class PowerPlayCard extends StatelessWidget {
  const PowerPlayCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addPage,
          page: PowerPlayHomeConfig,
        );
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 23),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              stops: [0.5, 1], colors: [Color(0xff1F2C65), Color(0xffE35833)]),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Row(children: [
          SvgPicture.network(
            'https://d37gtxigg82zaw.cloudfront.net/powerplay/logo.svg',
            width: 63,
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Make your Prediction for:',
                style: TextStyles.rajdhaniB.body3,
              ),
              const SizedBox(
                height: 3,
              ),
              Text('Bengaluru vs Chennai', style: TextStyles.rajdhaniSB.body3),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 10,
            color: Colors.white,
          )
        ]),
      ),
    );
  }
}

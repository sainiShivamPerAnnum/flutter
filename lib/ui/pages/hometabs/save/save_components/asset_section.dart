import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/custom_card/custom_cards.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SaveAssetsGroupCard extends StatelessWidget {
  final SaveViewModel saveViewModel;

  const SaveAssetsGroupCard({required this.saveViewModel, Key? key})
      : super(key: key);

  Widget getAssetsOrder() {
    S locale = locator<S>();
    List<Widget> orderedAssets = [];
    for (final key in DynamicUiUtils.saveViewOrder[0]) {
      switch (key) {
        case 'LB':
          orderedAssets.add(
            SaveCustomCard(
              title: locale.felloFloMainTitle,
              subtitle:
                  "Save in Lendbox powered P2P Assets with upto 12% Returns",
              chipText: const ["P2P Asset", "Safe & Secure", "12% Returns"],
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
                    .track(eventName: "Save on Flo Banner", properties: {
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
              footerText:
                  "Introducing  12% returns on your investment with *12% Flo*",
              footerColor: UiConstants.kFloContainerColor,
            ),
          );
          break;
        case 'AG':
          orderedAssets.add(
            SaveCustomCard(
              title: locale.digitalGoldMailTitle,
              subtitle: "Save in Augmont backed 99.9% Pure Digital Gold",
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
                    .track(eventName: "Save on Gold Banner", properties: {
                  "asset name": "AUGGOLD99",
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
              // footerText: "Chance to get *${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% Extra Gold* on your savings",
              footerColor: UiConstants.kGoldContainerColor,
            ),
          );
          break;
      }
    }
    return Column(
      children: orderedAssets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
      child: getAssetsOrder(),
    );
  }
}

class MiniAssetsGroupSection extends StatelessWidget {
  const MiniAssetsGroupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
        vertical: SizeConfig.padding14,
      ),
      child: Row(
        children: [
          const Expanded(
            child: MiniAssetCard(
              color: UiConstants.kSaveDigitalGoldCardBg,
              asset: Assets.goldAsset,
              title: "Digital Gold",
              subtitle: "Know Digital Gold",
              actionUri: "goldDetails",
            ),
          ),
          SizedBox(width: SizeConfig.padding16),
          const Expanded(
            child: MiniAssetCard(
              color: UiConstants.kSaveStableFelloCardBg,
              asset: Assets.floAsset,
              title: "Fello P2P",
              subtitle: "Know Fello P2P",
              actionUri: "floDetails",
            ),
          ),
        ],
      ),
    );
  }
}

class MiniAssetCard extends StatelessWidget {
  final String asset, title, subtitle, actionUri;
  final Color color;

  const MiniAssetCard({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.actionUri,
    required this.color,
    super.key,
  });

  void _onTapCard() {
    Haptic.vibrate();
    AppState.delegate!.parseRoute(Uri.parse(actionUri));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTapCard,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 6,
              spreadRadius: 4,
              color: Colors.black.withOpacity(.15),
            ),
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 3,
              spreadRadius: 0,
              color: Colors.black.withOpacity(.30),
            ),
          ],
        ),
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  asset,
                  height: SizeConfig.padding60,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.padding10),
                  child: SvgPicture.asset(
                    Assets.chevRonRightArrow,
                    color: Colors.white,
                    width: SizeConfig.padding24,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "  $title",
                  style: TextStyles.rajdhaniSB.title5.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "    $subtitle",
                  style: TextStyles.sourceSans.body4.colour(Colors.white54),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.padding14)
          ],
        ),
      ),
    );
  }
}

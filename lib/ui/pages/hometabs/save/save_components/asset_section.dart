import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/ui/service_elements/user_service/net_worth_value.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SaveNetWorthSection extends StatelessWidget {
  final SaveViewModel saveViewModel;

  const SaveNetWorthSection({Key? key, required this.saveViewModel})
      : super(key: key);

  getAssetsOrder() {
    List<Widget> orderedAssests = [];
    DynamicUiUtils.saveViewOrder[0].forEach((key) {
      switch (key) {
        case 'LB':
          orderedAssests.add(
            SaveCustomCard(
              title: 'Fello Flo (10%)',
              subtitle: "Current Value",
              key: ValueKey(Constants.ASSET_TYPE_LENDBOX),
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
                return BaseUtil().openRechargeModalSheet(
                  investmentType: InvestmentType.LENDBOXP2P,
                );
              },
            ),
          );
          break;
        case 'AG':
          orderedAssests.add(
            SaveCustomCard(
              title: 'Digital Gold',
              subtitle: "You Own",
              key: ValueKey(Constants.ASSET_TYPE_AUGMONT),
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
                return BaseUtil().openRechargeModalSheet(
                  investmentType: InvestmentType.AUGGOLD99,
                );
              },
            ),
          );
          break;
      }
    });
    return Column(
      children: orderedAssests,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [UserServiceProperties.myUserFund],
      builder: (context, model, property) => Container(
        // height: SizeConfig.screenWidth * 1.4,
        margin: EdgeInsets.only(bottom: SizeConfig.padding24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(SizeConfig.roundness16),
            bottomRight: Radius.circular(SizeConfig.roundness16),
          ),
          color: UiConstants.kSecondaryBackgroundColor,
        ),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.padding12,
            ),
            model?.userFundWallet?.netWorth != null &&
                    model?.userFundWallet?.netWorth != 0
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: SizeConfig.padding12,
                        ),
                        Text(
                          'Total Savings',
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
                : Container(),
            SizedBox(
              height: SizeConfig.padding10,
            ),
            getAssetsOrder(),
            SaveAssetsFooter(),
          ],
        ),
      ),
    );
  }
}

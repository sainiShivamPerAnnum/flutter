import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/others/finance/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_view.dart';
import 'package:felloapp/ui/service_elements/user_service/lendbox_principle_value.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/ui/widgets/appbar/faq_button_rounded.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class LendboxDetailsView extends StatelessWidget {
  const LendboxDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kDarkBackgroundColor,
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        elevation: 0,
        leading: FelloAppBarBackButton(),
        actions: [
          FaqButtonRounded(type: FaqsType.savings),
          SizedBox(
            width: SizeConfig.padding24,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: BaseView<SaveViewModel>(
            onModelReady: (model) => model.init(),
            builder: (context, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: UiConstants.kBackgroundColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AssetCard(),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      MiniTransactionCard(
                        investmentType: InvestmentType.LENDBOXP2P,
                      ),
                    ],
                  ),
                ),
                SellCardView(
                  investmentType: InvestmentType.LENDBOXP2P,
                ),
                SizedBox(
                  height: SizeConfig.screenWidth * 0.2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AssetCard extends StatelessWidget {
  const AssetCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaseView<SaveViewModel>(
          builder: (ctx, model, child) => Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.padding54,
              left: SizeConfig.padding24,
              right: SizeConfig.padding24,
            ),
            child: Container(
              height: SizeConfig.screenWidth * 0.88,
              width: SizeConfig.screenWidth * 0.87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness32),
                color: UiConstants.kSaveStableFelloCardBg,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.only(top: SizeConfig.screenWidth * 0.25),
                  child: Column(
                    children: [
                      Text('Fello Flo', style: TextStyles.rajdhaniB.title2),
                      Text(
                        'Safer way to invest',
                        style: TextStyles.sourceSans.body4,
                      ),
                      SizedBox(
                        height: SizeConfig.padding40,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                LendboxPrincipleValue(
                                  prefix: "\u20b9",
                                  style: TextStyles.sourceSans.body0
                                      .colour(Colors.white),
                                ),
                                SizedBox(
                                  height: SizeConfig.padding2,
                                ),
                                Text(
                                  'Invested',
                                  style: TextStyles.sourceSans.body3.colour(
                                    UiConstants.kTextColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                UserFundQuantitySE(
                                  style: TextStyles.sourceSans.body0
                                      .colour(Colors.white),
                                  investmentType: InvestmentType.LENDBOXP2P,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding2,
                                ),
                                Text(
                                  'Current',
                                  style: TextStyles.sourceSans.body3.colour(
                                      UiConstants.kTextColor.withOpacity(0.8)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding26,
                      ),
                      CustomSaveButton(
                        onTap: () {
                          return BaseUtil().openRechargeModalSheet(
                            investmentType: InvestmentType.LENDBOXP2P,
                          );
                        },
                        title: 'Save',
                        isFullScreen: true,
                        width: SizeConfig.screenWidth * 0.2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
          child: Container(
            height: SizeConfig.screenWidth - 50,
            width: SizeConfig.screenWidth * 0.87,
            child: Align(
              alignment: Alignment.topCenter,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Image.asset(
                  Assets.felloFlo,
                  height: SizeConfig.screenWidth * 0.4,
                  width: SizeConfig.screenWidth * 0.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

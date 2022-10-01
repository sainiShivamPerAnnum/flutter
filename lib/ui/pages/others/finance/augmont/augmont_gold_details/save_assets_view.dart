import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/others/finance/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_view.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SaveAssetView extends StatelessWidget {
  const SaveAssetView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kDarkBackgroundColor,
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        elevation: 0,
        leading: FelloAppBarBackButton(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: BaseView<SaveViewModel>(
            onModelReady: (model) => model.init(),
            builder: (context, model, child) => RefreshIndicator(
              onRefresh: () async {
                model.refreshTransactions(InvestmentType.AUGGOLD99);
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: UiConstants.kBackgroundColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GoldAssetCard(),
                              SizedBox(
                                height: SizeConfig.padding24,
                              ),
                              // -- Break --
                              AutosaveCard(),
                              MiniTransactionCard(
                                investmentType: InvestmentType.AUGGOLD99,
                              ),
                            ],
                          ),
                        ),
                        SellCardView(
                          investmentType: InvestmentType.AUGGOLD99,
                        ),
                        SizedBox(
                          height: SizeConfig.screenWidth * 0.4,
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: UiConstants.kBackgroundColor,
                      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                      child: AppPositiveBtn(
                        btnText: "SAVE",
                        width: SizeConfig.screenWidth -
                            SizeConfig.pageHorizontalMargins * 2,
                        onPressed: () => BaseUtil().openRechargeModalSheet(
                            investmentType: InvestmentType.AUGGOLD99),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoldAssetCard extends StatelessWidget {
  const GoldAssetCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        color: UiConstants.kSaveDigitalGoldCardBg,
      ),
      padding: EdgeInsets.fromLTRB(
          SizeConfig.pageHorizontalMargins / 2,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.pageHorizontalMargins),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Image.asset(
              Assets.digitalGoldBar,
              height: SizeConfig.screenWidth * 0.32,
              width: SizeConfig.screenWidth * 0.32,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(width: SizeConfig.screenWidth * 0.35),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Digital Gold',
                            style: TextStyles.rajdhaniB.title2),
                        Text('Safer way to invest',
                            style: TextStyles.sourceSans.body4),
                        SizedBox(
                          height: SizeConfig.padding20,
                        ),
                        UserFundQuantitySE(
                          style: TextStyles.rajdhaniSB.title4,
                        ),
                        Text(
                          'Invested',
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor2),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.padding20,
              ),
              // Padding(
              //   padding:
              //       EdgeInsets.only(left: SizeConfig.pageHorizontalMargins / 2),
              //   child: CustomSaveButton(
              //     onTap: () {
              //       return BaseUtil().openRechargeModalSheet(
              //           investmentType: InvestmentType.AUGGOLD99);
              //     },
              //     title: 'Save',
              //     width: SizeConfig.screenWidth,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_info_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/titlesGames.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/others/finance/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
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
import 'package:flutter_svg/flutter_svg.dart';

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
        child: BaseView<SaveViewModel>(
          onModelReady: (model) => model.init(),
          builder: (context, model, child) => RefreshIndicator(
            color: UiConstants.primaryColor,
            backgroundColor: Colors.black,
            onRefresh: () async {
              model.refreshTransactions(InvestmentType.LENDBOXP2P);
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: UiConstants.kBackgroundColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LBoxAssetCard(),
                            InfoComponent3(
                              mainTitle: "What is Felllo Flo?",
                              subTitle:
                                  "Fello Flo is a P2P lending product powered by Lendbox. Start saving and investing in Fello Flo and earn 10% stable returns!",
                              secondaryTitle: "Why to invest?",
                              boxAssets: model.boxAssets,
                              boxTitlles: model.boxTitlles,
                              isBoxOpen: model.getQuantity(model.userFundWallet,
                                              InvestmentType.LENDBOXP2P) ==
                                          0 &&
                                      model.getInvestedQuantity(
                                              model.userFundWallet) ==
                                          0
                                  ? true
                                  : false,
                            ),
                            SizedBox(
                              height: SizeConfig.padding24,
                            ),
                            MiniTransactionCard(
                              investmentType: InvestmentType.LENDBOXP2P,
                            ),
                          ],
                        ),
                      ),
                      model.getQuantity(model.userFundWallet,
                                      InvestmentType.LENDBOXP2P) ==
                                  0 &&
                              model.getInvestedQuantity(model.userFundWallet) ==
                                  0
                          ? SizedBox.shrink()
                          : SellCardView(
                              investmentType: InvestmentType.LENDBOXP2P,
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
                          investmentType: InvestmentType.LENDBOXP2P),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LBoxAssetCard extends StatelessWidget {
  const LBoxAssetCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        color: UiConstants.kSaveStableFelloCardBg,
      ),
      padding: EdgeInsets.fromLTRB(
          SizeConfig.pageHorizontalMargins / 2,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.pageHorizontalMargins,
          SizeConfig.pageHorizontalMargins),
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(-SizeConfig.padding12, -SizeConfig.padding40),
            child: Image.asset(
              Assets.felloFlo,
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
                        Text('Fello Flo', style: TextStyles.rajdhaniB.title2),
                        Text('Safer way to invest',
                            style: TextStyles.sourceSans.body4),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    top: SizeConfig.padding35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LendboxPrincipleValue(
                            prefix: "\u20b9",
                            style: TextStyles.rajdhaniSB.title4,
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
                    ),
                    SizedBox(width: SizeConfig.padding16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserFundQuantitySE(
                            style: TextStyles.rajdhaniSB.title4,
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
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
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

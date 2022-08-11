import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/augmont_gold_details_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_view.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_spinkit/flutter_spinkit.dart';

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
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: SizeConfig.screenWidth * 2.4,
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
                  SaveTitleContainer(title: 'Auto SIP'),
                  SizedBox(
                    height: SizeConfig.padding10,
                  ),
                  AutoSIPCard(),
                  SizedBox(
                    height: SizeConfig.padding24,
                  ),
                  SaveTitleContainer(title: 'Transactions'),
                  MiniTransactionCard(),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [CurrentGoldRateText(), _sellButton(onTap: () {})]),
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
              child: FAQCardView(
                  category: 'digital_gold',
                  bgColor: UiConstants.kDarkBackgroundColor),
            ),
            SizedBox(
              height: SizeConfig.screenWidth * 0.2,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _sellButton({@required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.screenWidth * 0.12,
        width: SizeConfig.screenWidth * 0.29,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Center(
          child: Text(
            'SELL',
            style: TextStyles.rajdhaniSB.body0,
          ),
        ),
      ),
    );
  }
}

class CurrentGoldRateText extends StatelessWidget {
  const CurrentGoldRateText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AugmontGoldDetailsViewModel>(
        onModelReady: (model) => model.fetchGoldRates(),
        builder: (ctx, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sell your current gold \nat current market rate',
                  style: TextStyles.sourceSansSB.body2
                      .colour(Colors.grey.withOpacity(0.8)),
                ),
                model.isGoldRateFetching
                    ? SpinKitThreeBounce(
                        size: SizeConfig.title5,
                        color: Colors.white,
                      )
                    : Text(
                        model.goldRates != null
                            ? "₹ ${model.goldRates.goldSellPrice.toStringAsFixed(2)}/gm ~"
                            : "- gm",
                        style: TextStyles.body3
                            .colour(UiConstants.kBlogTitleColor),
                      ),
              ],
            ));
  }
}

class GoldAssetCard extends StatelessWidget {
  const GoldAssetCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaseView<SaveViewModel>(
            builder: (ctx, model, child) => Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.padding54,
                      left: SizeConfig.padding24,
                      right: SizeConfig.padding24),
                  child: Container(
                    height: SizeConfig.screenWidth * 0.88,
                    width: SizeConfig.screenWidth * 0.87,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness32),
                        color: UiConstants.kSaveDigitalGoldCardBg),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: SizeConfig.screenWidth * 0.25),
                        child: Column(
                          children: [
                            Text('Digital Gold',
                                style: TextStyles.rajdhaniB.title2),
                            Text('Safer way to invest',
                                style: TextStyles.sourceSans.body4),
                            SizedBox(
                              height: SizeConfig.padding40,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '\u20b9 2000',
                                        style: TextStyles.sourceSans.body0
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding2,
                                      ),
                                      Text(
                                        'Invested',
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor
                                                .withOpacity(0.8)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      UserGoldQuantitySE(
                                        style: TextStyles.sourceSans.body0
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding2,
                                      ),
                                      Text(
                                        'Total Gold',
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor
                                                .withOpacity(0.8)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '\u20b9 4390.8',
                                        style: TextStyles.sourceSans.body0
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding2,
                                      ),
                                      Text(
                                        'Current',
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor
                                                .withOpacity(0.8)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding26,
                            ),
                            Center(
                                child: Container(
                              height: SizeConfig.screenWidth * 0.10,
                              width: SizeConfig.screenWidth * 0.4,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness5)),
                              child: Center(
                                child: Text(
                                  'SAVE',
                                  style: TextStyles.rajdhaniSB.body1,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
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
                  Assets.digitalGoldBar,
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

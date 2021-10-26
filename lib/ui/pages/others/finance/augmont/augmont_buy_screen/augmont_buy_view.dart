import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AugmontGoldBuyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<AugmontGoldBuyViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          whiteBackground: WhiteBackground(
              color: UiConstants.scaffoldColor,
              height: SizeConfig.screenHeight * 0.08),
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: locale.abBuyDigitalGold,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding20,
                      vertical: SizeConfig.padding32),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness32),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff0B175F0D),
                          blurRadius: SizeConfig.padding12,
                          offset: Offset(0, SizeConfig.padding12),
                          spreadRadius: SizeConfig.padding20,
                        )
                      ]),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      Text(
                        "Enter Amount",
                        style: TextStyles.title4.bold,
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenWidth * 0.135,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffDFE4EC),
                          ),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: SizeConfig.padding24),
                            Expanded(
                              child: TextField(
                                enabled: !model.isGoldBuyInProgress,
                                focusNode: model.buyFieldNode,
                                enableInteractiveSelection: false,
                                controller: model.goldAmountController,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                style: TextStyles.body2.bold,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'^0+(?!$)')),
                                ],
                                onChanged: (val) {
                                  model.onBuyValueChanged(val);
                                },
                                decoration: InputDecoration(
                                  prefix:
                                      Text("₹ ", style: TextStyles.body2.bold),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              width: SizeConfig.screenWidth * 0.275,
                              height: SizeConfig.screenWidth * 0.135,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(SizeConfig.roundness12),
                                  bottomRight:
                                      Radius.circular(SizeConfig.roundness12),
                                ),
                                color: UiConstants.scaffoldColor,
                              ),
                              padding:
                                  EdgeInsets.only(left: SizeConfig.padding20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "You buy",
                                    style: TextStyles.body3.colour(Colors.grey),
                                  ),
                                  SizedBox(height: SizeConfig.padding4 / 2),
                                  FittedBox(
                                    child: Text(
                                      "${model.goldAmountInGrams.toStringAsFixed(4)} gm",
                                      style: TextStyles.body2.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if (model.showMaxCapText)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding4),
                          child: Text(
                            "Upto ₹ 50,000 can be invested at one go.",
                            style: TextStyles.body4.bold
                                .colour(UiConstants.primaryColor),
                          ),
                        ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          model.amoutChip(model.chipAmountList[0]),
                          model.amoutChip(model.chipAmountList[1]),
                          model.amoutChip(model.chipAmountList[2]),
                          // model.amoutChip(model.chipAmountList[3]),
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding54),
                      CurrentPriceWidget(
                        fetchGoldRates: model.fetchGoldRates,
                        goldprice: model.goldRates != null
                            ? model.goldRates.goldBuyPrice
                            : 0.0,
                        isFetching: model.isGoldRateFetching,
                      ),
                      SizedBox(height: SizeConfig.padding54),
                      FelloButtonLg(
                        child: model.isGoldBuyInProgress
                            ? SpinKitThreeBounce(
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                model.status == 0 ? "UNAVAILABLE" : "BUY",
                                style:
                                    TextStyles.body2.colour(Colors.white).bold,
                              ),
                        onPressed: () {
                          if (!model.isGoldBuyInProgress) {
                            FocusScope.of(context).unfocus();
                            model.initiateBuy();
                          }
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.padding20,
                      ),
                      // Text(
                      //   "Buy Clicking on Buy, you agree to T&C",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyles.body3.colour(Colors.grey),
                      // ),
                      SizedBox(height: SizeConfig.padding80),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InfoChip(
                              asset: Assets.gold24K, text: locale.saveGold24k),
                          InfoChip(
                              asset: Assets.goldPure,
                              text: locale.saveGoldPure),
                          InfoChip(
                              asset: Assets.goldSecure,
                              text: locale.saveSecure),
                        ],
                      ),
                      SizedBox(height: SizeConfig.padding40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(Assets.augLogo,
                              height: SizeConfig.padding24),
                          Image.asset(Assets.amfiGraphic,
                              color: UiConstants.primaryColor,
                              height: SizeConfig.padding24),
                          Image.asset(Assets.sebiGraphic,
                              color: Color(0xff2E2A81),
                              height: SizeConfig.padding20),
                        ],
                      ),
                      SizedBox(height: SizeConfig.viewInsets.bottom)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final String asset, text;
  InfoChip({this.asset, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SvgPicture.asset(
            asset,
            width: SizeConfig.padding24,
            color: UiConstants.primaryColor,
          ),
          SizedBox(width: SizeConfig.padding8),
          Text(text, style: TextStyles.body3.bold)
        ],
      ),
    );
  }
}

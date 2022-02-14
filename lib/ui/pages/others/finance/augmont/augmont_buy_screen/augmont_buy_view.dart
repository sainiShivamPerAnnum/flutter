import 'package:felloapp/ui/modals_sheets/augmont_coupons_modal.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AugmontBuyCard extends StatelessWidget {
  final AugmontGoldBuyViewModel model;
  AugmontBuyCard({this.model, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      width: SizeConfig.screenWidth,
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding16,
        vertical: SizeConfig.padding20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (model.buyNotice != null && model.buyNotice.isNotEmpty)
            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.padding16),
              decoration: BoxDecoration(
                color: UiConstants.primaryLight,
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              ),
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.all(SizeConfig.padding16),
              child: Text(
                model.buyNotice,
                textAlign: TextAlign.center,
                style: TextStyles.body3.light,
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Enter Amount",
              style: TextStyles.title5.bold.colour(Colors.grey),
            ),
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
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
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
                    cursorWidth: 1,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    style: TextStyles.body2.bold,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'^0+(?!$)')),
                    ],
                    onChanged: (val) {
                      model.onBuyValueChanged(val);
                    },
                    decoration: InputDecoration(
                      prefix: Text("₹ ", style: TextStyles.body2.bold),
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
                      topRight: Radius.circular(SizeConfig.roundness12),
                      bottomRight: Radius.circular(SizeConfig.roundness12),
                    ),
                    color: UiConstants.scaffoldColor,
                  ),
                  padding: EdgeInsets.only(left: SizeConfig.padding20),
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
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
              child: Text(
                "Upto ₹ 50,000 can be invested at one go.",
                style: TextStyles.body4.bold.colour(UiConstants.primaryColor),
              ),
            ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              model.amoutChip(0),
              model.amoutChip(1),
              model.amoutChip(2),
              model.amoutChip(3),
            ],
          ),
          SizedBox(height: SizeConfig.padding12),
          if (model.showCoupons)
            Container(
              margin: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
              child: model.appliedCoupon != null
                  ? CouponItem(
                      model: model,
                      coupon: model.appliedCoupon,
                      onTap: () {},
                      trailingWidget: InkWell(
                        onTap: () => model.appliedCoupon = null,
                        child: Icon(Icons.cancel,
                            color: Colors.grey, size: SizeConfig.iconSize1),
                      ),
                    )
                  : Container(
                      // color: UiConstants.tertiaryLight,
                      // width: SizeConfig.screenWidth,
                      // decoration
                      child: InkWell(
                          onTap: () => model.showOfferModal(model),
                          child: RichText(
                            text: new TextSpan(
                              children: [
                                new TextSpan(
                                    text: 'Apply a',
                                    style: TextStyles.body3
                                        .colour(UiConstants.felloBlue)),
                                new TextSpan(
                                  text: ' Coupon Code',
                                  style: TextStyles.body3
                                      .colour(UiConstants.felloBlue)
                                      .bold,
                                ),
                              ],
                            ),
                          )),
                    ),
            ),
          SizedBox(height: SizeConfig.padding12),
          if (model.augOnbRegInProgress)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                color: UiConstants.primaryLight.withOpacity(0.5),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                  vertical: SizeConfig.padding12),
              child: FittedBox(
                child: Text(
                  "Please wait, we are onboarding you to Augmont",
                  style:
                      TextStyles.title3.bold.colour(UiConstants.primaryColor),
                ),
              ),
            ),
          if (model.augRegFailed && !model.augOnbRegInProgress)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                color: Colors.red.withOpacity(0.1),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding16,
                  vertical: SizeConfig.padding12),
              child: FittedBox(
                  child: RichText(
                text: new TextSpan(
                  children: [
                    new TextSpan(
                        text: 'Augmont Onboarding failed, please ',
                        style: TextStyles.body4
                            .colour(Colors.red.withOpacity(0.6))),
                    new TextSpan(
                      text: 'try again',
                      style: TextStyles.body4.colour(Colors.red).underline,
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          Haptic.vibrate();
                          model.onboardUser();
                        },
                    ),
                  ],
                ),
              )
                  // Text(
                  //   "Augmont Onboarding failed, please try again in sometime",
                  //   maxLines: 1,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyles.title5.bold.colour(Colors.red),
                  // ),
                  ),
            ),
          if (!model.augOnbRegInProgress && !model.augRegFailed)
            FelloButtonLg(
              child: model.isGoldBuyInProgress
                  ? SpinKitThreeBounce(
                      color: Colors.white,
                      size: 20,
                    )
                  : Text(
                      model.status == 2
                          ? "BUY"
                          : (model.status == 0 ? "UNAVAILABLE" : "REGISTER"),
                      style: TextStyles.body2.colour(Colors.white).bold,
                    ),
              onPressed: () {
                if (!model.isGoldBuyInProgress) {
                  FocusScope.of(context).unfocus();
                  model.initiateBuy();
                }
              },
            ),
          SizedBox(
            height: SizeConfig.padding16,
          )
        ],
      ),
    );
  }
}

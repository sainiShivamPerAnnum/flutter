import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewAugmontBuyView extends StatelessWidget {
  const NewAugmontBuyView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AugmontGoldBuyViewModel>(
        onModelReady: (model) => model.init(),
        builder: (ctx, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: UiConstants.kProfileBorderColor,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                ),
                width: SizeConfig.screenWidth * 0.25,
                height: SizeConfig.padding4,
              ),
              SizedBox(
                height: SizeConfig.padding32,
              ),
              Text(
                'Recharge',
                style: TextStyles.sourceSansSB.title4,
              ),
              SizedBox(
                height: SizeConfig.padding54,
              ),
              EnterAmountView(model: model),
              Spacer(),
              if (model.showCoupons)
                model.couponApplyInProgress
                    ? SpinKitThreeBounce(
                        size: SizeConfig.body2,
                        color: UiConstants.kTabBorderColor,
                      )
                    : model.appliedCoupon != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/temp/ticket.svg',
                                width: SizeConfig.iconSize0,
                                height: SizeConfig.iconSize0,
                                color: UiConstants.kpurpleTicketColor,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding8),
                                child: Text(
                                  model.appliedCoupon.code,
                                  style: TextStyles.sourceSansSB.body2,
                                ),
                              ),
                              Text(
                                "applied",
                                style:
                                    TextStyles.sourceSans.body4.setOpecity(0.6),
                              ),
                              SizedBox(
                                width: SizeConfig.padding8,
                              ),
                              InkWell(
                                onTap: () => model.appliedCoupon = null,
                                child: Icon(Icons.cancel,
                                    color: Colors.grey,
                                    size: SizeConfig.iconSize1),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () => model.showOfferModal(model),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/temp/ticket.svg',
                                  width: SizeConfig.iconSize0,
                                  height: SizeConfig.iconSize0,
                                ),
                                SizedBox(
                                  width: SizeConfig.padding8,
                                ),
                                Text(
                                  'Apply a coupon code',
                                  style: TextStyles.sourceSans.body2
                                      .colour(UiConstants.kPrimaryColor),
                                ),
                              ],
                            ),
                          ),
              SizedBox(
                height: SizeConfig.padding32,
              ),
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
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Registration in progress..",
                      style: TextStyles.body2.bold
                          .colour(UiConstants.primaryColor),
                    ),
                  ),
                ),
              if (model.augRegFailed &&
                  !model.augOnbRegInProgress &&
                  model.augmontObjectSecondFetchDone)
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
                            style:
                                TextStyles.body4.colour(Colors.red).underline,
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Haptic.vibrate();
                                model.onboardUser();
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!model.augOnbRegInProgress && !model.augRegFailed)
                model.isGoldBuyInProgress
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 20,
                      )
                    : AppPositiveBtn(
                        btnText: model.status == 2
                            ? 'Invest'
                            : (model.status == 0 ? "UNAVAILABLE" : "REGISTER"),
                        onPressed: () async {
                          if (!model.isGoldBuyInProgress) {
                            FocusScope.of(context).unfocus();
                            model.initiateBuy();
                          }
                          // model.onGoingTxn();
                          // await Future.delayed(Duration(seconds: 5));
                          // model.successTxn();
                          // await Future.delayed(Duration(seconds: 5));
                          // model.enableTxn();
                          // AppState.backButtonDispatcher.didPopRoute();
                          // await Future.delayed(Duration(seconds: 5));
                          // BaseUtil.openModalBottomSheet(
                          //   addToScreenStack: true,
                          //   enableDrag: true,
                          //   boxContraints: BoxConstraints(
                          //     maxHeight: SizeConfig.screenHeight,
                          //   ),
                          //   backgroundColor: UiConstants.kBackgroundColor,
                          //   borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(SizeConfig.roundness24),
                          //     topRight: Radius.circular(SizeConfig.roundness24),
                          //   ),
                          //   hapticVibrate: true,
                          //   isBarrierDismissable: true,
                          //   isScrollControlled: true,
                          //   content: CongratoryDialog(),
                          // );

                          // AppState.backButtonDispatcher.didPopRoute();
                        },
                        width: SizeConfig.screenWidth * 0.813,
                      ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
            ],
          );
        });
  }
}

class EnterAmountView extends StatelessWidget {
  EnterAmountView({Key key, @required this.model}) : super(key: key);
  final AugmontGoldBuyViewModel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color:
                  UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding12,
              vertical: SizeConfig.padding20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/temp/digital_gold.svg',
                      width: SizeConfig.screenWidth * 0.12,
                      height: SizeConfig.screenWidth * 0.12,
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      'Digital Gold',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                    Spacer(),
                    NewCurrentGoldPriceWidget(
                      fetchGoldRates: model.fetchGoldRates,
                      goldprice: model.goldRates != null
                          ? model.goldRates.goldBuyPrice
                          : 0.0,
                      isFetching: model.isGoldRateFetching,
                      mini: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                if (model.buyNotice != null && model.buyNotice.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                    decoration: BoxDecoration(
                      color: UiConstants.primaryLight,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness16),
                    ),
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.all(SizeConfig.padding16),
                    child: Text(
                      model.buyNotice,
                      textAlign: TextAlign.center,
                      style: TextStyles.body3.light,
                    ),
                  ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                Container(
                  width: double.infinity,
                  height: SizeConfig.screenWidth * 0.1466,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          focusNode: model.buyFieldNode,
                          textEditingController: model.goldAmountController,
                          isEnabled: !model.isGoldBuyInProgress &&
                              !model.couponApplyInProgress,
                          validator: (val) {
                            return null;
                          },
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness16),
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (String val) {
                            model.onBuyValueChanged(val);
                            // if (val.isEmpty) {
                            //   textEditingController.text = '₹ ';
                            // }
                            // if (val.isNotEmpty) {
                            //   textEditingController.text =
                            //       '₹ ' + val.split('₹')[0];
                            // }
                            // textEditingController.selection =
                            //     TextSelection.fromPosition(
                            //   TextPosition(
                            //     affinity: TextAffinity.downstream,
                            //     offset: textEditingController.text.length,
                            //   ),
                            // );
                            // log(val);
                          },
                          inputDecoration: InputDecoration(
                            prefixText: '₹',
                            prefixStyle: TextStyles.rajdhaniSB.title4,
                            fillColor: UiConstants.kTextFieldColor,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding24,
                              vertical: SizeConfig.padding16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(SizeConfig.roundness12),
                                bottomLeft:
                                    Radius.circular(SizeConfig.roundness12),
                              ),
                              borderSide: BorderSide(
                                color: UiConstants.kTextColor.withOpacity(0.1),
                                width: SizeConfig.border1,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(SizeConfig.roundness12),
                                bottomLeft:
                                    Radius.circular(SizeConfig.roundness12),
                              ),
                              borderSide: BorderSide(
                                color: UiConstants.kTextColor.withOpacity(0.1),
                                width: SizeConfig.border1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(SizeConfig.roundness12),
                                bottomLeft:
                                    Radius.circular(SizeConfig.roundness12),
                              ),
                              borderSide: BorderSide(
                                color: UiConstants.kTextColor.withOpacity(0.1),
                                width: SizeConfig.border1,
                              ),
                            ),
                          ),
                          textStyle: TextStyles.rajdhaniSB.title4,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: SizeConfig.screenWidth * 0.2666,
                        decoration: BoxDecoration(
                          color: UiConstants.kBackgroundColor.withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(SizeConfig.roundness12),
                            bottomRight:
                                Radius.circular(SizeConfig.roundness12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${model.goldAmountInGrams.toStringAsFixed(4)} gm",
                            style: TextStyles.sourceSansSB.body2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (model.showMaxCapText)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                    child: Text(
                      "Upto ₹ 50,000 can be invested at one go.",
                      style: TextStyles.sourceSans.body4.bold
                          .colour(UiConstants.primaryColor),
                    ),
                  ),
                if (model.showMinCapText)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding4),
                    child: Text(
                      "Minimum purchase amount is ₹ 10",
                      style: TextStyles.sourceSans.body4.bold
                          .colour(Colors.red[400]),
                    ),
                  ),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'YOU GET',
                      style: TextStyles.sourceSans.body3,
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    SvgPicture.asset(
                      'assets/temp/Tokens.svg',
                      width: SizeConfig.iconSize0,
                      height: SizeConfig.iconSize0,
                    ),
                    SizedBox(
                      width: SizeConfig.padding6,
                    ),
                    Text(
                      model.goldAmountController.text == ''
                          ? '0'
                          : model.goldAmountController.text,
                      style: TextStyles.sourceSans.body3,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              model.amoutChip(0),
              model.amoutChip(1),
              model.amoutChip(2),
              model.amoutChip(3),
            ],
          ),
        ],
      ),
    );
  }
}

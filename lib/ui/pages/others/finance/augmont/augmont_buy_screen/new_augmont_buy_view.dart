import "dart:math" as math;

import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/util/assets.dart';
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
  final int amount;
  final bool skipMl;
  final TransactionService txnService;
  final AugmontGoldBuyViewModel model;
  const NewAugmontBuyView(
      {Key key,
      this.amount,
      this.skipMl,
      this.model,
      @required this.txnService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: SizeConfig.padding16),
        RechargeModalSheetAppBar(
          model: model,
          txnService: txnService,
        ),
        SizedBox(height: SizeConfig.padding32),
        EnterAmountView(
          model: model,
          txnService: txnService,
        ),
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
                        SizedBox(width: SizeConfig.padding10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding8),
                          child: Text(
                            model.appliedCoupon.code,
                            style: TextStyles.sourceSansSB.body2,
                          ),
                        ),
                        SizedBox(width: SizeConfig.padding4),
                        Text(
                          "applied",
                          style: TextStyles.sourceSans.body3.setOpecity(0.6),
                        ),
                        SizedBox(
                          width: SizeConfig.padding8,
                        ),
                        InkWell(
                          onTap: () {
                            if (txnService.isGoldBuyInProgress) return;
                            model.appliedCoupon = null;
                          },
                          child: Icon(Icons.cancel,
                              color: Colors.grey, size: SizeConfig.iconSize1),
                        ),
                      ],
                    )
                  : txnService.isGoldBuyInProgress
                      ? SizedBox()
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
                style: TextStyles.body2.bold.colour(UiConstants.primaryColor),
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
                      style: TextStyles.body4.colour(Colors.red).underline,
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
          txnService.isGoldBuyInProgress
              ? SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20,
                )
              : AppPositiveBtn(
                  btnText: model.status == 2
                      ? 'Invest'
                      : (model.status == 0 ? "UNAVAILABLE" : "REGISTER"),
                  onPressed: () async {
                    if (!txnService.isGoldBuyInProgress) {
                      FocusScope.of(context).unfocus();
                      model.initiateBuy();
                    }
                  },
                  width: SizeConfig.screenWidth * 0.813,
                ),
        SizedBox(
          height: SizeConfig.padding24,
        ),
      ],
    );
  }
}

class RechargeModalSheetAppBar extends StatelessWidget {
  final AugmontGoldBuyViewModel model;
  final TransactionService txnService;
  RechargeModalSheetAppBar({@required this.model, @required this.txnService});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: SizeConfig.screenWidth * 0.168,
        height: SizeConfig.screenWidth * 0.168,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              UiConstants.primaryColor.withOpacity(0.4),
              UiConstants.primaryColor.withOpacity(0.2),
              UiConstants.primaryColor.withOpacity(0.04),
              Colors.transparent,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Image.asset(
            Assets.digitalGoldBar,
            width: SizeConfig.screenWidth * 0.12,
            height: SizeConfig.screenWidth * 0.12,
          ),
        ),
      ),
      title: Text('Digital Gold', style: TextStyles.rajdhaniSB.body2),
      subtitle: Text(
        "Safest Digital Investment",
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
      ),
      trailing: txnService.isGoldBuyInProgress
          ? SizedBox()
          : IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                AppState.backButtonDispatcher.didPopRoute();
              },
            ),
    );
  }
}

class EnterAmountView extends StatelessWidget {
  EnterAmountView({Key key, @required this.model, @required this.txnService})
      : super(key: key);
  final AugmontGoldBuyViewModel model;
  final TransactionService txnService;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding12,
              vertical: SizeConfig.padding20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text("One Time",
                          style: TextStyles.sourceSansSB.body2),
                      onPressed: () {},
                    ),
                    TextButton(
                      child: Text("Auto SIP",
                          style: TextStyles.sourceSans.body2
                              .colour(UiConstants.kTextColor3)),
                      onPressed: () {},
                    ),
                  ],
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹",
                      style: TextStyles.rajdhaniB.title0.colour(
                          model.goldAmountController.text == "0"
                              ? UiConstants.kTextColor2
                              : UiConstants.kTextColor),
                    ),
                    SizedBox(width: SizeConfig.padding10),
                    AnimatedContainer(
                      duration: Duration(seconds: 0),
                      curve: Curves.easeIn,
                      width: model.fieldWidth,
                      child: TextFormField(
                        controller: model.goldAmountController,
                        focusNode: model.buyFieldNode,
                        enabled: !txnService.isGoldBuyInProgress &&
                            !model.couponApplyInProgress,
                        validator: (val) {
                          return null;
                        },
                        onChanged: (val) {
                          model.onBuyValueChanged(val);
                        },
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          // isCollapsed: true,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyles.rajdhaniB.title68.colour(
                          model.goldAmountController.text == "0"
                              ? UiConstants.kTextColor2
                              : UiConstants.kTextColor,
                        ),
                      ),
                    ),
                  ],
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
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              model.amoutChip(0),
              model.amoutChip(1),
              model.amoutChip(2),
              model.amoutChip(3),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          Container(
            width: SizeConfig.screenWidth * 0.72,
            decoration: BoxDecoration(
              color: UiConstants.darkPrimaryColor,
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            ),
            height: SizeConfig.padding64,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            child: IntrinsicHeight(
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                    child: Text(
                      "${model.goldAmountInGrams} gm",
                      style: TextStyles.sourceSansSB.body1,
                    ),
                  ),
                ),
                VerticalDivider(
                    color: UiConstants
                        .kRechargeModalSheetAmountSectionBackgroundColor,
                    width: 4),
                Expanded(
                  child: Center(
                    child: NewCurrentGoldPriceWidget(
                      fetchGoldRates: model.fetchGoldRates,
                      goldprice: model.goldRates != null
                          ? model.goldRates.goldBuyPrice
                          : 0.0,
                      isFetching: model.isGoldRateFetching,
                      mini: true,
                    ),
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

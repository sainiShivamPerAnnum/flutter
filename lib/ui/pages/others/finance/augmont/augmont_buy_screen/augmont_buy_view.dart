import 'dart:io';

import 'package:app_install_date/utils.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
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
// import 'package:upi_pay/upi_pay.dart';

class AugmontBuyCard extends StatefulWidget {
  final AugmontGoldBuyViewModel model;

  AugmontBuyCard({this.model, Key key}) : super(key: key);

  @override
  State<AugmontBuyCard> createState() => _AugmontBuyCardState();
}

class _AugmontBuyCardState extends State<AugmontBuyCard>
    with WidgetsBindingObserver {
  List<String> events = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    events.add(state.toString());
    setState(() {});
  }

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
          if (widget.model.buyNotice != null &&
              widget.model.buyNotice.isNotEmpty)
            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.padding16),
              decoration: BoxDecoration(
                color: UiConstants.primaryLight,
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              ),
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.all(SizeConfig.padding16),
              child: Text(
                widget.model.buyNotice,
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
                    enabled: !widget.model.isGoldBuyInProgress &&
                        !widget.model.couponApplyInProgress,
                    focusNode: widget.model.buyFieldNode,
                    enableInteractiveSelection: false,
                    controller: widget.model.goldAmountController,
                    cursorWidth: 1,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    style: TextStyles.body2.bold,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'^0+(?!$)')),
                    ],
                    onChanged: (val) {
                      widget.model.onBuyValueChanged(val);
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
                          "${widget.model.goldAmountInGrams.toStringAsFixed(4)} gm",
                          style: TextStyles.body2.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (widget.model.showMaxCapText)
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
              child: Text(
                "Upto ₹ 50,000 can be invested at one go.",
                style: TextStyles.body4.bold.colour(UiConstants.primaryColor),
              ),
            ),
          if (widget.model.showMinCapText)
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
              child: Text(
                "Minimum purchase amount is ₹ 10",
                style: TextStyles.body4.bold.colour(Colors.red[400]),
              ),
            ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.model.amoutChip(0),
              widget.model.amoutChip(1),
              widget.model.amoutChip(2),
              widget.model.amoutChip(3),
            ],
          ),
          SizedBox(height: SizeConfig.padding12),
          if (widget.model.showCoupons)
            Container(
              margin: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
              child: widget.model.couponApplyInProgress
                  ? SpinKitThreeBounce(
                      size: SizeConfig.body2,
                      color: UiConstants.felloBlue,
                    )
                  : (widget.model.appliedCoupon != null
                      ? CouponItem(
                          model: widget.model,
                          couponCode: widget.model.appliedCoupon.code,
                          desc: widget.model.appliedCoupon.desc,
                          onTap: () {},
                          trailingWidget: InkWell(
                            onTap: () => widget.model.appliedCoupon = null,
                            child: Icon(Icons.cancel,
                                color: Colors.grey, size: SizeConfig.iconSize1),
                          ),
                        )
                      : Container(
                          child: InkWell(
                              onTap: () =>
                                  widget.model.showOfferModal(widget.model),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Apply a',
                                        style: TextStyles.body3
                                            .colour(UiConstants.felloBlue)),
                                    TextSpan(
                                      text: ' Coupon',
                                      style: TextStyles.body3
                                          .colour(UiConstants.felloBlue)
                                          .bold,
                                    ),
                                  ],
                                ),
                              )),
                        )),
            ),
          SizedBox(height: SizeConfig.padding12),
          if (widget.model.augOnbRegInProgress)
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
          if (widget.model.augRegFailed &&
              !widget.model.augOnbRegInProgress &&
              widget.model.augmontObjectSecondFetchDone)
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
                          widget.model.onboardUser();
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
          if (!widget.model.augOnbRegInProgress && !widget.model.augRegFailed)
            FelloButtonLg(
              child: widget.model.isGoldBuyInProgress
                  ? SpinKitThreeBounce(
                      color: Colors.white,
                      size: 20,
                    )
                  : Text(
                      widget.model.status == 2
                          ? "BUY"
                          : (widget.model.status == 0
                              ? "UNAVAILABLE"
                              : "REGISTER"),
                      style: TextStyles.body2.colour(Colors.white).bold,
                    ),
              onPressed: () async {
                if (!widget.model.isGoldBuyInProgress) {
                  FocusScope.of(context).unfocus();
                  if (Platform.isAndroid) {
                    //Android - RazorpayPG
                    if (BaseRemoteConfig.remoteConfig
                            .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID) ==
                        'RZP-PG') {
                      widget.model.initiateRzpGatewayTxn();
                    }
                    //Android - PaytmPG
                    if (BaseRemoteConfig.remoteConfig
                            .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID) ==
                        'PAYTM-PG') {
                      widget.model.initiatePaytmPgTxn();
                    }
                    //Android - Paytm(UPI Intent)
                    if (BaseRemoteConfig.remoteConfig
                            .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID) ==
                        'PAYTM') {
                      bool isAllowed = await widget.model.initChecks();
                      if (isAllowed) {
                        BaseUtil.openModalBottomSheet(
                            addToScreenStack: true,
                            backgroundColor: Colors.transparent,
                            isBarrierDismissable: false,
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(SizeConfig.roundness12),
                                topRight:
                                    Radius.circular(SizeConfig.roundness12)),
                            content: UPIAppsBottomSheet(
                              model: widget.model,
                            ));
                      }
                    }
                  } else if (Platform.isIOS) {
                    //iOS - RazorpayPG
                    if (BaseRemoteConfig.remoteConfig
                            .getString(BaseRemoteConfig.ACTIVE_PG_IOS) ==
                        'RZP-PG') {
                      widget.model.initiateRzpGatewayTxn();
                    }
                    //iOS - PaytmPG
                    if (BaseRemoteConfig.remoteConfig
                            .getString(BaseRemoteConfig.ACTIVE_PG_IOS) ==
                        'PAYTM-PG') {
                      widget.model.initiatePaytmPgTxn();
                    }
                    //iOS - Paytm(UPI Intent)
                    if (BaseRemoteConfig.remoteConfig
                            .getString(BaseRemoteConfig.ACTIVE_PG_IOS) ==
                        'PAYTM') {
                      bool isAllowed = await widget.model.initChecks();
                      if (isAllowed) {
                        BaseUtil.openModalBottomSheet(
                            addToScreenStack: true,
                            backgroundColor: Colors.transparent,
                            isBarrierDismissable: false,
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(SizeConfig.roundness12),
                                topRight:
                                    Radius.circular(SizeConfig.roundness12)),
                            content: UPIAppsBottomSheet(
                              model: widget.model,
                            ));
                      }
                    }
                  }
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

class UPIAppsBottomSheet extends StatelessWidget {
  final AugmontGoldBuyViewModel model;

  const UPIAppsBottomSheet({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenWidth * 0.5,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness12),
            topRight: Radius.circular(SizeConfig.roundness12)),
      ),
      child: Padding(
          padding: EdgeInsets.all(SizeConfig.padding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              model.appMetaList.length > 0
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Please select an UPI App',
                            style: TextStyles.body1.bold,
                          ),
                          GestureDetector(
                              onTap: () {
                                AppState.backButtonDispatcher.didPopRoute();
                              },
                              child: Icon(Icons.close))
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 20),
              model.appMetaList.length <= 0
                  ? Center(
                      child: Text('Please Install UPI applications to proceed',
                          style: TextStyles.body1))
                  : Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: model.appMetaList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              BaseUtil.openDialog(
                                  addToScreenStack: true,
                                  isBarrierDismissable: false,
                                  content: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Dialog(
                                      child: Container(
                                          height: SizeConfig.screenWidth * 0.2,
                                          width: SizeConfig.screenWidth,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(children: [
                                              Text(
                                                'Processing',
                                                style: TextStyles.title5,
                                              ),
                                              Spacer(),
                                              CircularProgressIndicator()
                                            ]),
                                          )),
                                    ),
                                  ));
                              AppState.screenStack.add(ScreenItem.loader);
                              model.upiApplication =
                                  model.appMetaList[index].upiApplication;
                              model.processTransaction(model
                                  .appMetaList[index].upiApplication.appName);
                              // AppState.backButtonDispatcher.didPopRoute();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: model.appMetaList[index]
                                              .iconImage(40)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        model.appMetaList[index].upiApplication
                                            .appName,
                                        style: TextStyles.body4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                      ),
                    ),
            ],
          )),
    );
  }
}

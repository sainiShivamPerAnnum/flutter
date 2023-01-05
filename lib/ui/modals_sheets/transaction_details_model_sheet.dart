import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_buy/gold_buy_success_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

// ignore: must_be_immutable
class TransactionDetailsBottomSheet extends StatefulWidget {
  final UserTransaction? transaction;
  TransactionDetailsBottomSheet({Key? key, this.transaction}) : super(key: key);

  @override
  State<TransactionDetailsBottomSheet> createState() =>
      _TransactionDetailsBottomSheetState();
}

class _TransactionDetailsBottomSheetState
    extends State<TransactionDetailsBottomSheet> {
  bool _showInvoiceButton = false;
  bool _showAppliedCoupon = false;
  final AugmontService? augmontProvider = locator<AugmontService>();
  final TransactionHistoryService? _txnHistoryService =
      locator<TransactionHistoryService>();
  S locale = locator<S>();
  final BaseUtil? baseProvider = locator<BaseUtil>();
  bool _isInvoiceLoading = false;
  ValueNotifier<bool> _showOrderSummary = ValueNotifier(false);

  @override
  void initState() {
    if (widget.transaction!.subType ==
            UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
        widget.transaction!.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
        widget.transaction!.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE)
      _showInvoiceButton = true;

    if (widget.transaction!.subType ==
            UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
        widget.transaction!.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
        widget.transaction!.tranStatus ==
            UserTransaction.TRAN_STATUS_COMPLETE &&
        widget.transaction!.couponCode != null &&
        widget.transaction!.couponCode!.isNotEmpty) _showAppliedCoupon = true;

    if (widget.transaction?.tranStatus == "PENDING" ||
        widget.transaction?.tranStatus == "FAILED" ||
        !(widget.transaction!.subType ==
            UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD)) {
      _showOrderSummary.value = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogContent(context);
  }

  String _getAugmontGoldGrams(double gms) =>
      (gms == null || gms == 0) ? locale.na : gms.toStringAsFixed(4);

  Widget dialogContent(BuildContext context) {
    S locale = S.of(context);
    final isGold = widget.transaction!.subType ==
        UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD;
    return WillPopScope(
      onWillPop: () async {
        AppState.screenStack.removeLast();
        return Future.value(true);
      },
      child: Container(
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: UiConstants.kModalSheetBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness32),
            topRight: Radius.circular(SizeConfig.roundness32),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding24,
        ),
        margin: EdgeInsets.only(top: SizeConfig.viewInsets.top * 2),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,

              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.txnDetailsTitle,
                        style: TextStyles.rajdhaniB.title3,
                      ),
                      GestureDetector(
                        onTap: () {
                          AppState.backButtonDispatcher!.didPopRoute();
                        },
                        child: Icon(
                          Icons.close,
                          color: UiConstants.kTextColor,
                          size: SizeConfig.padding24,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      isGold ? Assets.digitalGoldBar : Assets.felloFlo,
                      height: SizeConfig.screenWidth! * 0.12,
                      width: SizeConfig.screenWidth! * 0.12,
                    ),
                    SizedBox(
                      width: SizeConfig.padding16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            isGold
                                ? locale.digitalGoldText
                                : locale.felloFloText,
                            style: TextStyles.rajdhaniM.body2,
                          ),
                        ),
                        Text(
                          locale.txnDetailsTitle,
                          style: TextStyles.rajdhani.body4.colour(
                            UiConstants.kTextColor2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                Text(
                  _txnHistoryService!
                      .getFormattedTxnAmount(widget.transaction!.amount),
                  style: TextStyles.rajdhaniB.title0
                      .colour(UiConstants.kTextColor),
                ),
                Text(locale.txnAmountTitle,
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor2)),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.padding16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.brightness_1_rounded,
                          size: SizeConfig.padding12,
                          color: _txnHistoryService!
                              .getTileColor(widget.transaction!.tranStatus)),
                      SizedBox(
                        width: SizeConfig.padding2,
                      ),
                      Text(
                        widget.transaction!.tranStatus!,
                        style: TextStyles.sourceSans.body3.colour(
                            _txnHistoryService!
                                .getTileColor(widget.transaction!.tranStatus)),
                      ),
                    ],
                  ),
                ),
                if (widget.transaction!.subType ==
                        UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                    widget.transaction!.type ==
                        UserTransaction.TRAN_TYPE_DEPOSIT)
                  Row(
                    children: [
                      referralTile(
                          locale.purchaseRate,
                          widget.transaction!.augmnt![
                                      UserTransaction.subFldAugLockPrice] !=
                                  null
                              ? '₹ ${widget.transaction!.augmnt![UserTransaction.subFldAugLockPrice]}/' +
                                  locale.gm
                              : locale.refUnAvailable,
                          UiConstants.primaryColor),
                      referralTile(
                          locale.goldPurchased,
                          '${_getAugmontGoldGrams(BaseUtil.toDouble(widget.transaction!.augmnt![UserTransaction.subFldAugCurrentGoldGm]) ?? 'N/A' as double)} grams',
                          UiConstants.primaryColor)
                    ],
                  ),
                if (widget.transaction!.subType ==
                        UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                    widget.transaction!.type ==
                        UserTransaction.TRAN_TYPE_WITHDRAW)
                  Row(
                    children: [
                      referralTile(
                        locale.sellRate,
                        '₹ ${widget.transaction!.augmnt![UserTransaction.subFldAugLockPrice] ?? locale.na}/' +
                            locale.gm,
                        Colors.redAccent.withOpacity(0.6),
                      ),
                      referralTile(
                        locale.goldSold,
                        '${_getAugmontGoldGrams(BaseUtil.toDouble(widget.transaction!.augmnt![UserTransaction.subFldAugCurrentGoldGm]) ?? 'N/A' as double)} grams',
                        Colors.redAccent.withOpacity(0.6),
                      )
                    ],
                  ),
                if (widget.transaction!.subType ==
                        UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                    widget.transaction!.type ==
                        UserTransaction.TRAN_STATUS_PROCESSING)
                  Row(
                    children: [
                      referralTile(
                        locale.sellRate,
                        '₹ ${widget.transaction!.augmnt![UserTransaction.subFldAugLockPrice] ?? locale.na}/' +
                            locale.gm,
                        Colors.redAccent.withOpacity(0.6),
                      ),
                      referralTile(
                        locale.goldSold,
                        '${_getAugmontGoldGrams(BaseUtil.toDouble(widget.transaction!.augmnt![UserTransaction.subFldAugCurrentGoldGm]) ?? 'N/A' as double)} grams',
                        Colors.redAccent.withOpacity(0.6),
                      )
                    ],
                  ),
                if (widget.transaction!.transactionUpdatesMap != null &&
                    widget.transaction!.transactionUpdatesMap!.isNotEmpty)
                  Container(
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.transaction?.misMap
                                ?.containsKey("happyHourGtId") ??
                            false) ...[
                          SizedBox(height: SizeConfig.padding12),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 4, bottom: 8),
                              child: Text(locale.txnHappyHours,
                                  textAlign: TextAlign.center,
                                  style: TextStyles.sourceSans.body2
                                      .colour(Color(0xffB5CDCB))),
                            ),
                          ),
                        ],
                        if (widget.transaction?.misMap
                                ?.containsKey("happyHourErrorMessage") ??
                            false) ...[
                          SizedBox(height: SizeConfig.padding12),
                          Text(
                              widget.transaction
                                      ?.misMap?["happyHourErrorMessage"] ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyles.sourceSans.body2
                                  .colour(Color(0xffB5CDCB)))
                        ],
                        SizedBox(height: SizeConfig.padding12),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.padding16,
                    bottom: SizeConfig.padding6,
                  ),
                  child: GestureDetector(
                    onTap: () =>
                        _showOrderSummary.value = !_showOrderSummary.value,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        locale.orderSummary,
                        style: TextStyles.sourceSans.body2.underline.bold,
                      ),
                      trailing: ValueListenableBuilder<bool>(
                        valueListenable: _showOrderSummary,
                        builder: (context, snapshot, _) {
                          return Transform.rotate(
                            angle: snapshot ? pi / 2 : pi * 1.5,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: SizeConfig.padding16,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: _showOrderSummary,
                    builder: (context, snapshot, _) {
                      return snapshot
                          ? TransactionSummary(
                              summary:
                                  widget.transaction!.transactionUpdatesMap)
                          : SizedBox();
                    }),
                // SizedBox(height: SizeConfig.padding8),
                if (_showAppliedCoupon) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Other benefits on this transaction:",
                      style: TextStyles.sourceSans.body2.colour(Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      WinningChips(
                        title: "Fello\nTokens",
                        asset: Assets.token,
                        qty: widget.transaction!.amount.round(),
                        color: Colors.black,
                        tooltip: "",
                      ),
                      SizedBox(
                        width: SizeConfig.padding8,
                      ),
                      if ((widget.transaction?.couponMap
                              ?.containsKey("goldAmount") ??
                          false)) ...[
                        WinningChips(
                          title: "Gold\nWon",
                          asset: Assets.digitalGold,
                          qty: widget.transaction?.couponMap!["goldAmount"],
                          color: Colors.black,
                          tooltip: '',
                        ),
                        SizedBox(
                          width: SizeConfig.padding8,
                        )
                      ],
                      WinningChips(
                        title: "Tambola\nticket",
                        asset: Assets.singleTmbolaTicket,
                        qty: 1,
                        color: Colors.black,
                        tooltip: '',
                      ),
                    ],
                  )
                ],
                SizedBox(height: SizeConfig.padding16),
                if (_showInvoiceButton)
                  Container(
                    padding: EdgeInsets.only(
                        bottom: min(SizeConfig.pageHorizontalMargins,
                            SizeConfig.viewInsets.bottom)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppPositiveCustomChildBtn(
                          child: _isInvoiceLoading
                              ? SpinKitThreeBounce(
                                  size: SizeConfig.padding20,
                                  color: Colors.white,
                                  duration: Duration(milliseconds: 500),
                                )
                              : Text(locale.btnDownloadInvoice.toUpperCase(),
                                  style: TextStyles.rajdhaniSB.body1),
                          onPressed: () async {
                            if (widget.transaction!
                                    .augmnt![UserTransaction.subFldAugTranId] !=
                                null) {
                              setState(() {
                                _isInvoiceLoading = true;
                              });
                              String? trnId = widget.transaction!
                                  .augmnt![UserTransaction.subFldAugTranId];
                              augmontProvider!
                                  .generatePurchaseInvoicePdf(trnId, null)
                                  .then((generatedPdfFilePath) {
                                _isInvoiceLoading = false;
                                setState(() {});
                                if (generatedPdfFilePath != null) {
                                  OpenFilex.open(generatedPdfFilePath);
                                } else {
                                  BaseUtil.showNegativeAlert(
                                      locale.txnInvoiceFailed,
                                      locale.txnTryAfterSomeTime);
                                }
                              });
                            } else {
                              BaseUtil.showNegativeAlert(
                                  locale.txnInvoiceFailed,
                                  locale.txnTryAfterSomeTime);
                            }
                          },
                          width: SizeConfig.screenWidth! / 2,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: SizeConfig.padding24)
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getRedeemTypeValue(String redeemtype) {
    switch (redeemtype) {
      case UserTransaction.TRAN_REDEEMTYPE_AUGMONT_GOLD:
        return "Augmont Digital Gold";
        break;
      case UserTransaction.TRAN_REDEEMTYPE_AMZ_VOUCHER:
        return "Amazon Gift Voucher";
        break;
      default:
        return "Fello Rewards";
    }
  }

  Duration getOfferDuration(int totalMins) {
    Duration difference;
    DateTime tTime = DateTime.fromMillisecondsSinceEpoch(
            widget.transaction!.timestamp!.millisecondsSinceEpoch)
        .add(Duration(minutes: totalMins));
    difference = tTime.difference(DateTime.now());
    return difference;
    //return Duration(minutes: 15); //FOR TESTING
  }

  String _getFormattedTime(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('h:mm a').format(now);
  }

  String _getFormattedDate(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('dd MMM yyyy').format(now);
  }

  Widget referralTile(String title, String value, Color color) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 12.0, horizontal: SizeConfig.blockSizeHorizontal * 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.sourceSans.body3
                  .colour(UiConstants.kModalSheetSecondaryBackgroundColor),
            ),
            SizedBox(height: 4),
            Text(value,
                style:
                    TextStyles.sourceSans.body2.colour(UiConstants.kTextColor)),
          ],
        ),
      ),
    );
  }
}

class TransactionSummary extends StatelessWidget {
  final List<TransactionStatusMapItemModel>? summary;
  final TransactionHistoryService? _txnHistoryService =
      locator<TransactionHistoryService>();
  TransactionSummary({this.summary});
  bool isTBD = false;
  int naPoint = 0;

  @override
  Widget build(BuildContext context) {
    summary!.forEach((sum) {
      print("${sum.toString()}");
    });
    naPoint = summary!.length;
    for (int i = 0; i < summary!.length; i++) {
      if (summary![i].value != null && summary![i].value == 'NA') {
        naPoint = i;
      }
    }
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: naPoint,
        itemBuilder: (ctx, i) {
          return leadWidget(summary, i, naPoint);
        });
  }

  Widget leadWidget(
      List<TransactionStatusMapItemModel>? summary, int index, int length) {
    Widget mainWidget = SizedBox();
    Color leadColor = Colors.white;
    bool showThread = true;
    String? subtitle;
    if (isTBD) {
      mainWidget = Container(
        height: SizeConfig.padding28,
        width: SizeConfig.padding28,
        padding: EdgeInsets.all(SizeConfig.padding8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: UiConstants.gameCardColor),
        ),
      );
      subtitle = '-';
      leadColor = UiConstants.gameCardColor;
    } else if (summary![index].timestamp != null) {
      mainWidget = Container(
        height: SizeConfig.padding28,
        width: SizeConfig.padding28,
        // padding: EdgeInsets.all(SizeConfig.padding8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: UiConstants.primaryColor),
        ),
        child: Icon(Icons.check_rounded,
            color: UiConstants.primaryColor, size: SizeConfig.padding20),
      );

      leadColor = UiConstants.primaryColor;
    } else if (summary[index].value == "NA") {
      mainWidget = SizedBox();
      leadColor = Colors.transparent;
      showThread = false;
    } else if (summary[index].value == "TBD") {
      mainWidget = Container(
        height: SizeConfig.padding28,
        width: SizeConfig.padding28,
        padding: EdgeInsets.all(SizeConfig.padding8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: UiConstants.tertiarySolid),
        ),
        child: CircularProgressIndicator(
            color: UiConstants.tertiarySolid, strokeWidth: 1),
      );
      leadColor = UiConstants.tertiarySolid;
      isTBD = true;
      subtitle = '-';
    }

    return Row(
      children: [
        Container(
          width: SizeConfig.padding32,
          height: SizeConfig.padding70,
          child: Column(children: [
            Expanded(
              child: VerticalDivider(
                color: index == 0 ? Colors.transparent : leadColor,
                thickness: 1,
              ),
            ),
            mainWidget,
            Expanded(
              child: VerticalDivider(
                color: index == length - 1 ? Colors.transparent : leadColor,
                thickness: 1,
              ),
            )
          ]),
        ),
        if (showThread)
          Expanded(
            child: Container(
              height: SizeConfig.padding70,
              child: ListTile(
                title: Text(
                  summary![index].title!,
                  style: TextStyles.sourceSans.body2,
                ),
                subtitle: Text(
                  subtitle ??
                      (summary[index].timestamp != null
                          ? "${_txnHistoryService!.getFormattedDateAndTime(summary[index].timestamp!)}"
                          : summary[index].value!),
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kTextColor2),
                ),
              ),
            ),
          )
      ],
    );
  }
}

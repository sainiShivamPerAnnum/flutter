import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:timelines/timelines.dart';

// ignore: must_be_immutable
class TransactionDetailsBottomSheet extends StatefulWidget {
  final UserTransaction transaction;
  TransactionDetailsBottomSheet({Key key, this.transaction}) : super(key: key);

  @override
  State<TransactionDetailsBottomSheet> createState() =>
      _TransactionDetailsBottomSheetState();
}

class _TransactionDetailsBottomSheetState
    extends State<TransactionDetailsBottomSheet> {
  bool _showInvoiceButton = false;
  final AugmontService augmontProvider = locator<AugmontService>();
  final TransactionHistoryService _txnHistoryService =
      locator<TransactionHistoryService>();
  final BaseUtil baseProvider = locator<BaseUtil>();
  bool _isInvoiceLoading = false;

  @override
  void initState() {
    if (widget.transaction.subType ==
            UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
        widget.transaction.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
        widget.transaction.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE)
      _showInvoiceButton = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogContent(context);
  }

  String _getAugmontGoldGrams(double gms) =>
      (gms == null || gms == 0) ? 'N/A' : gms.toStringAsFixed(4);

  Widget dialogContent(BuildContext context) {
    final isGold =
        widget.transaction.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD;
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
                        'Transaction Details',
                        style: TextStyles.sourceSans.body2,
                      ),
                      GestureDetector(
                        onTap: () {
                          AppState.backButtonDispatcher.didPopRoute();
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
                      height: SizeConfig.screenWidth * 0.12,
                      width: SizeConfig.screenWidth * 0.12,
                    ),
                    SizedBox(
                      width: SizeConfig.padding16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            isGold ? 'Digital Gold' : 'Fello Flo',
                            style: TextStyles.rajdhaniM.body2,
                          ),
                        ),
                        Text(
                          'Safest digital investment',
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
                  _txnHistoryService
                      .getFormattedTxnAmount(widget.transaction.amount),
                  style: TextStyles.rajdhaniB.title0
                      .colour(UiConstants.kTextColor),
                ),
                Text("Transaction Amount",
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor2)),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.padding16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.brightness_1_rounded,
                          size: SizeConfig.padding12,
                          color: _txnHistoryService
                              .getTileColor(widget.transaction.tranStatus)),
                      SizedBox(
                        width: SizeConfig.padding2,
                      ),
                      Text(
                        widget.transaction.tranStatus,
                        style: TextStyles.sourceSans.body3.colour(
                            _txnHistoryService
                                .getTileColor(widget.transaction.tranStatus)),
                      ),
                    ],
                  ),
                ),
                if (widget.transaction.subType ==
                        UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                    widget.transaction.type ==
                        UserTransaction.TRAN_TYPE_DEPOSIT)
                  Row(
                    children: [
                      referralTile(
                          'Purchase Rate:',
                          widget.transaction.augmnt[
                                      UserTransaction.subFldAugLockPrice] !=
                                  null
                              ? '₹ ${widget.transaction.augmnt[UserTransaction.subFldAugLockPrice]}/gm'
                              : "Unavailable",
                          UiConstants.primaryColor),
                      referralTile(
                          'Gold Purchased:',
                          '${_getAugmontGoldGrams(BaseUtil.toDouble(widget.transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm]) ?? 'N/A')} grams',
                          UiConstants.primaryColor)
                    ],
                  ),
                if (widget.transaction.subType ==
                        UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                    widget.transaction.type ==
                        UserTransaction.TRAN_TYPE_WITHDRAW)
                  Row(
                    children: [
                      referralTile(
                        'Sell Rate:',
                        '₹ ${widget.transaction.augmnt[UserTransaction.subFldAugLockPrice] ?? 'N/A'}/gm',
                        Colors.redAccent.withOpacity(0.6),
                      ),
                      referralTile(
                        'Gold Sold:',
                        '${_getAugmontGoldGrams(BaseUtil.toDouble(widget.transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm]) ?? 'N/A')} grams',
                        Colors.redAccent.withOpacity(0.6),
                      )
                    ],
                  ),
                if (widget.transaction.subType ==
                        UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                    widget.transaction.type ==
                        UserTransaction.TRAN_STATUS_PROCESSING)
                  Row(
                    children: [
                      referralTile(
                        'Sell Rate:',
                        '₹ ${widget.transaction.augmnt[UserTransaction.subFldAugLockPrice] ?? 'N/A'}/gm',
                        Colors.redAccent.withOpacity(0.6),
                      ),
                      referralTile(
                        'Gold Sold:',
                        '${_getAugmontGoldGrams(BaseUtil.toDouble(widget.transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm]) ?? 'N/A')} grams',
                        Colors.redAccent.withOpacity(0.6),
                      )
                    ],
                  ),
                Row(
                  children: [
                    referralTile(
                        "Date",
                        "${_getFormattedDate(widget.transaction.timestamp)}",
                        Colors.black),
                    referralTile(
                        "Time",
                        "${_getFormattedTime(widget.transaction.timestamp)}",
                        Colors.black),
                  ],
                ),
                if (widget.transaction.miscMap != null)
                  Container(
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: SizeConfig.padding12),
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.padding16,
                            bottom: SizeConfig.padding6,
                          ),
                          child: Text(
                            "Order Summary",
                            style: TextStyles.sourceSans.body2.underline.bold,
                          ),
                        ),
                        TransactionSummary(summary: widget.transaction.miscMap)
                      ],
                    ),
                  ),
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
                              : Text('Download Invoice'.toUpperCase(),
                                  style: TextStyles.rajdhaniSB.body1),
                          onPressed: () async {
                            if (widget.transaction
                                    .augmnt[UserTransaction.subFldAugTranId] !=
                                null) {
                              setState(() {
                                _isInvoiceLoading = true;
                              });
                              String trnId = widget.transaction
                                  .augmnt[UserTransaction.subFldAugTranId];
                              augmontProvider
                                  .generatePurchaseInvoicePdf(trnId, null)
                                  .then((generatedPdfFilePath) {
                                _isInvoiceLoading = false;
                                setState(() {});
                                if (generatedPdfFilePath != null) {
                                  OpenFilex.open(generatedPdfFilePath);
                                } else {
                                  setState(() {});
                                  BaseUtil.showNegativeAlert(
                                      'Invoice could not be loaded',
                                      'Please try again in some time');
                                }
                              });
                            } else {
                              setState(() {});
                              BaseUtil.showNegativeAlert(
                                  'Invoice could not be loaded',
                                  'Please try again in some time');
                            }
                          },
                          width: SizeConfig.screenWidth / 2,
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
            widget.transaction.timestamp.millisecondsSinceEpoch)
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
  final List<TransactionStatusMapItemModel> summary;
  final _txnHistoryService = locator<TransactionHistoryService>();
  TransactionSummary({this.summary});
  bool isTBD = false;
  int naPoint = 0;
  @override
  Widget build(BuildContext context) {
    naPoint = summary.length;
    for (int i = 0; i < summary.length; i++) {
      if (summary[i].value != null && summary[i].value == 'NA') {
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
      List<TransactionStatusMapItemModel> summary, int index, int length) {
    Widget mainWidget = SizedBox();
    Color leadColor = Colors.white;
    bool showThread = true;
    String subtitle;
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
    } else if (summary[index].timestamp != null) {
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
                  summary[index].title,
                  style: TextStyles.sourceSans.body2,
                ),
                subtitle: Text(
                  subtitle ??
                      (summary[index].timestamp != null
                          ? "${_txnHistoryService.getFormattedDate(summary[index].timestamp)} ${_txnHistoryService.getFormattedTime(summary[index].timestamp)}"
                          : summary[index].value),
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

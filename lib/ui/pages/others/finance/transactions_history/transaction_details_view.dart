import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/modals_sheets/transaction_details_model_sheet.dart';
import 'package:felloapp/ui/pages/others/finance/transactions_history/transactions_history_view.dart';
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

import '../../../../../base_util.dart';

class TransactionDetailsPage extends StatefulWidget {
  TransactionDetailsPage({Key? key, required this.txn}) : super(key: key);
  final UserTransaction txn;

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  bool _showInvoiceButton = false;

  bool _showAppliedCoupon = false;

  final AugmontService? augmontProvider = locator<AugmontService>();

  final TransactionHistoryService? _txnHistoryService =
      locator<TransactionHistoryService>();

  S locale = locator<S>();

  final BaseUtil? baseProvider = locator<BaseUtil>();

  bool _isInvoiceLoading = false;
  @override
  void initState() {
    if (widget.txn.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
        widget.txn.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
        widget.txn.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE)
      _showInvoiceButton = true;

    if (widget.txn.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
        widget.txn.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
        widget.txn.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE &&
        widget.txn.couponCode != null &&
        widget.txn.couponCode!.isNotEmpty) _showAppliedCoupon = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isGold =
        widget.txn.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD;
    return Scaffold(
      backgroundColor: Color(0xff151D22),
      appBar: AppBar(
        backgroundColor: Color(0xff151D22),
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IconButton(
                  //   onPressed: () async {
                  //     await AppState.backButtonDispatcher!.didPopRoute();
                  //   },
                  //   icon: Icon(
                  //     Icons.arrow_back_ios,
                  //     size: 15,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        isGold ? Assets.digitalGoldBar : Assets.felloFlo,
                        height: SizeConfig.screenWidth! * 0.12,
                        width: SizeConfig.screenWidth! * 0.12,
                      ),
                      Text(
                        isGold ? locale.digitalGoldText : locale.felloFloText,
                        style: TextStyles.rajdhaniSB.body2,
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      _txnHistoryService!
                          .getFormattedTxnAmount(widget.txn.amount),
                      style: TextStyles.rajdhaniSB.title50,
                    ),
                  ),

                  SizedBox(
                    height: SizeConfig.padding8,
                  ),
                  Center(
                    child: Text(
                      getFormattedDate + " at " + formattedTime,
                      style:
                          TextStyles.rajdhaniSB.body2.colour(Color(0xffA0A0A0)),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding32,
                  ),
                  Divider(
                    color: Color(0xff3E3E3E),
                  ),
                  if (widget.txn.transactionUpdatesMap != null &&
                      widget.txn.transactionUpdatesMap!.isNotEmpty)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status",
                              style: TextStyles.sourceSans
                                  .colour(Color(0xffA9C6D6)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.brightness_1_rounded,
                                    size: SizeConfig.padding12,
                                    color: _txnHistoryService!
                                        .getTileColor(widget.txn.tranStatus)),
                                SizedBox(
                                  width: SizeConfig.padding2,
                                ),
                                Text(
                                  widget.txn.tranStatus!.substring(0, 1) +
                                      widget.txn.tranStatus!
                                          .substring(
                                              1, widget.txn.tranStatus!.length)
                                          .toLowerCase(),
                                  style: TextStyles.sourceSans.body3.colour(
                                      _txnHistoryService!
                                          .getTileColor(widget.txn.tranStatus)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TransactionSummary(
                            summary: widget.txn.transactionUpdatesMap),
                        Divider(
                          color: Color(0xff3E3E3E),
                        ),
                        if (isGold &&
                            widget.txn.tranStatus ==
                                UserTransaction.TRAN_STATUS_COMPLETE) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Purchase Rate",
                                  style: TextStyles.sourceSans.body3
                                      .colour(Color(0xffA9C6D6)),
                                ),
                                Text(
                                    "₹" +
                                        (widget.txn.augmnt?["aLockPrice"] ?? 0)
                                            .toString() +
                                        " /gm",
                                    style: TextStyles.sourceSans.body3)
                              ],
                            ),
                          ),
                          Divider(
                            color: Color(0xff3E3E3E),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Gold purchased ",
                                  style: TextStyles.sourceSans.body3
                                      .colour(Color(0xffA9C6D6)),
                                ),
                                Text(
                                    widget.txn.augmnt!["aGoldInTxn"]
                                            .toString() +
                                        " gms",
                                    style: TextStyles.sourceSans.body3)
                              ],
                            ),
                          ),
                          Divider(
                            color: Color(0xff3E3E3E),
                          ),
                          if (widget.txn.couponCode != null ||
                              widget.txn.couponCode!.isEmpty) ...[
                            if (_showAppliedCoupon) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(Assets.couponsAsset),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          widget.txn.couponCode ?? "",
                                          style: TextStyles.sourceSansSB.body3
                                              .colour(Color(0xffA5FCE7)),
                                        ),
                                        Text(
                                          " coupon applied",
                                          style: TextStyles.sourceSansL.body3
                                              .colour(Color(0xffA5FCE7)),
                                        ),
                                      ],
                                    ),
                                    if (widget.txn.couponMap
                                            ?.containsKey("goldQty") ??
                                        false)
                                      Text(
                                          "+ " +
                                              (widget.txn.couponMap?["goldQty"]
                                                      .toString() ??
                                                  "") +
                                              " gms",
                                          style: TextStyles.sourceSans.body3
                                              .colour(Color(0xffA5FCE7))),
                                    if (widget.txn.couponMap
                                            ?.containsKey("gtId") ??
                                        false)
                                      Text("+ 1 Tambola Ticket",
                                          style: TextStyles.sourceSans.body3
                                              .colour(Color(0xffA5FCE7)))
                                  ],
                                ),
                              ),
                              Divider(
                                color: Color(0xff3E3E3E),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Gold (in grams) ",
                                    style: TextStyles.sourceSansB.body3.colour(
                                      Color(0xffE3CD95),
                                    ),
                                  ),
                                  Text(
                                    (widget.txn.couponMap!
                                                .containsKey("goldQty")
                                            ? (widget.txn
                                                        .augmnt!["aGoldInTxn"] +
                                                    widget.txn
                                                        .couponMap!["goldQty"])
                                                .toString()
                                            : widget.txn.augmnt!["aGoldInTxn"]
                                                .toString()) +
                                        " gms",
                                    style: TextStyles.sourceSansB.body3.colour(
                                      Color(0xffE3CD95),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              color: Color(0xff3E3E3E),
                            ),
                          ]
                        ],
                        if (widget.txn.tranStatus == "COMPLETE") ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.txn.type ==
                                      UserTransaction.TRAN_TYPE_WITHDRAW
                                  ? "Rewards Deducted:"
                                  : "Rewards Credited:",
                              style: TextStyles.sourceSans.body3
                                  .colour(Color(0XFF9AB5C4)),
                            ),
                          ),
                          if (widget.txn.type ==
                              UserTransaction.TRAN_TYPE_WITHDRAW)
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: SizeConfig.screenWidth! * 0.7,
                                child: Text(
                                  "Tokens and Tambola Tickets will be deducted whenever you withdraw",
                                  style: TextStyles.sourceSans
                                      .colour(UiConstants.kBlogTitleColor),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: SizeConfig.padding12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xff212B31),
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  margin: EdgeInsets.only(right: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            Assets.token,
                                            height: SizeConfig.padding16,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.padding4,
                                          ),
                                          Text(
                                            widget.txn.amount
                                                .toString()
                                                .split(".")
                                                .first
                                                .replaceAll("-", ""),
                                            style: TextStyles.rajdhaniSB.body2,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding4,
                                      ),
                                      Text(
                                        "Game Tokens",
                                        style: TextStyles.rajdhaniSB.body4,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              if ((widget.txn.misMap?.containsKey("tickets") ??
                                      false) &&
                                  widget.txn.misMap!["tickets"] != 0)
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Color(0xff212B31),
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    margin: EdgeInsets.only(right: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              Assets.tambolaTicket,
                                              height: SizeConfig.padding16,
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding4,
                                            ),
                                            Text(
                                              widget.txn.misMap!["tickets"]
                                                  .toString(),
                                              style:
                                                  TextStyles.rajdhaniSB.body2,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: SizeConfig.padding4,
                                        ),
                                        Text(
                                          "Tambola Ticket",
                                          textAlign: TextAlign.center,
                                          style: TextStyles.rajdhaniSB.body4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if ((widget.txn.misMap?.containsKey("gtId") ??
                                      false) ||
                                  (widget.txn.couponMap?.containsKey("gtId") ??
                                      false))
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xff212B31),
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              Assets.scratchCard,
                                              height: SizeConfig.padding16,
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding4,
                                            ),
                                            Text(
                                              "${1 + (widget.txn.couponMap!.containsKey("gtId") ? 1 : 0)}",
                                              style:
                                                  TextStyles.rajdhaniSB.body2,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: SizeConfig.padding4,
                                        ),
                                        Text(
                                          "Scratch Card",
                                          style: TextStyles.rajdhaniSB.body4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  // Spacer(),
                  if (widget.txn.misMap?.containsKey("happyHourGtId") ??
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
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.16,
                  ),
                ],
              ),
            ),
          ),
          if (_showInvoiceButton)
            Container(
              height: SizeConfig.screenHeight! * 0.15,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.4),
                ],
              )),
              alignment: Alignment.center,
              child: AppPositiveCustomChildBtn(
                child: _isInvoiceLoading
                    ? SpinKitThreeBounce(
                        size: SizeConfig.padding20,
                        color: Colors.white,
                        duration: Duration(milliseconds: 500),
                      )
                    : Text(locale.btnDownloadInvoice.toUpperCase(),
                        style: TextStyles.rajdhaniSB.body1),
                onPressed: () async {
                  if (widget.txn.augmnt![UserTransaction.subFldAugTranId] !=
                      null) {
                    setState(() {
                      _isInvoiceLoading = true;
                    });
                    String? trnId =
                        widget.txn.augmnt![UserTransaction.subFldAugTranId];
                    augmontProvider!
                        .generatePurchaseInvoicePdf(trnId, null)
                        .then((generatedPdfFilePath) {
                      _isInvoiceLoading = false;
                      setState(() {});
                      if (generatedPdfFilePath != null) {
                        OpenFilex.open(generatedPdfFilePath);
                      } else {
                        BaseUtil.showNegativeAlert(locale.txnInvoiceFailed,
                            locale.txnTryAfterSomeTime);
                      }
                    });
                  } else {
                    BaseUtil.showNegativeAlert(
                        locale.txnInvoiceFailed, locale.txnTryAfterSomeTime);
                  }
                },
                width: SizeConfig.screenWidth! * 0.8,
              ),
            ),
        ],
      ),
    );
  }

  String _getAugmontGoldGrams(double gms) =>
      (gms == 0) ? locale.na : gms.toStringAsFixed(4);

  String get getFormattedDate =>
      DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(
          widget.txn.timestamp!.millisecondsSinceEpoch));

  String get formattedTime =>
      DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
          widget.txn.timestamp!.millisecondsSinceEpoch));
}

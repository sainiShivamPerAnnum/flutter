import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/modalsheets/transaction_details_model_sheet.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/rewards_card.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../base_util.dart';
import 'package:felloapp/util/styles/styles.dart';

class TransactionDetailsPage extends StatefulWidget {
  const TransactionDetailsPage({required this.txn, Key? key}) : super(key: key);
  final UserTransaction txn;

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage>
    with SingleTickerProviderStateMixin {
  bool _showInvoiceButton = false;

  bool _showAppliedCoupon = false;

  final AugmontService? augmontProvider = locator<AugmontService>();

  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();

  S locale = locator<S>();

  final BaseUtil? baseProvider = locator<BaseUtil>();

  bool _isInvoiceLoading = false;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    // _playLottieAnimation();
    if (widget.txn.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
        widget.txn.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
        widget.txn.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE) {
      _showInvoiceButton = true;
    }

    if (widget.txn.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
        widget.txn.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
        widget.txn.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE &&
        widget.txn.couponCode != null &&
        widget.txn.couponCode!.isNotEmpty) _showAppliedCoupon = true;
    super.initState();
  }

  String floSubtype() {
    if (widget.txn.subType == "LENDBOXP2P") {
      switch (widget.txn.lbMap.fundType) {
        case Constants.ASSET_TYPE_FLO_FIXED_6:
          return "12% Flo";
        case Constants.ASSET_TYPE_FLO_FIXED_3:
          return "10% Flo";
        case Constants.ASSET_TYPE_FLO_FELXI:
          if (locator<UserService>()
              .userSegments
              .contains(Constants.US_FLO_OLD)) {
            return "10% Flo";
          } else {
            return "8% Flo";
          }
        default:
          return "10% Flo";
      }
    }
    return "";
  }

  late AnimationController _animationController;
  bool _showLottie = false;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playLottieAnimation() {
    if (AppConfig.getValue(AppConfigKey.specialEffectsOnTxnDetailsView) ??
        false) {
      AppState.blockNavigation();
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (mounted)
            // ignore: curly_braces_in_flow_control_structures
            _showLottie = true;
        });
      });
    }
  }

  bool get ticketsPresent =>
      (widget.txn.misMap?.containsKey("tickets") ?? false) &&
      widget.txn.misMap!["tickets"] != 0;
  bool get goldPresent =>
      (widget.txn.misMap?.containsKey("gtId") ?? false) ||
      ((widget.txn.misMap?.containsKey("gtIds") ?? false) &&
          widget.txn.misMap?["gtIds"].length > 0) ||
      (widget.txn.couponMap?.containsKey("gtIds") ?? false) ||
      (widget.txn.misMap?.containsKey("happyHourGtId") ?? false);

  @override
  Widget build(BuildContext context) {
    final isGold =
        widget.txn.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD ||
            widget.txn.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD_FD;
    return Scaffold(
      backgroundColor: const Color(0xff151D22),
      appBar: FAppBar(
        title: null,
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
        action: !(widget.txn.tranStatus !=
                    UserTransaction.TRAN_STATUS_COMPLETE &&
                widget.txn.type == UserTransaction.TRAN_TYPE_WITHDRAW)
            ? Container(
                height: SizeConfig.avatarRadius * 2,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: Colors.transparent,
                ),
                child: TextButton(
                  child: Text(
                    'Need help?',
                    style: TextStyles.sourceSans.body3,
                  ),
                  onPressed: () {
                    Haptic.vibrate();
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addPage,
                      page: FreshDeskHelpPageConfig,
                    );
                  },
                ),
              )
            : const SizedBox(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        isGold ? locale.digitalGoldText : floSubtype(),
                        style: TextStyles.rajdhaniSB.body2,
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      _txnHistoryService
                          .getFormattedTxnAmount(widget.txn.amount),
                      style: TextStyles.rajdhaniSB.title50,
                    ),
                  ),

                  SizedBox(
                    height: SizeConfig.padding8,
                  ),
                  Center(
                    child: Text(
                      "$getFormattedDate at $formattedTime",
                      style: TextStyles.sourceSansSB.body2
                          .colour(const Color(0xffA0A0A0)),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding4,
                  ),

                  if (widget.txn.misMap?.containsKey("happyHourGtId") ??
                      false) ...[
                    SizedBox(height: SizeConfig.padding12),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(locale.txnHappyHours,
                            textAlign: TextAlign.center,
                            style: TextStyles.sourceSans.body2
                                .colour(const Color(0xffB5CDCB))),
                      ),
                    ),
                  ],
                  const Divider(
                    color: Color(0xff3E3E3E),
                  ),

                  if (widget.txn.transactionUpdatesMap != null &&
                      widget.txn.transactionUpdatesMap!.isNotEmpty)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Status",
                                style: TextStyles.sourceSans
                                    .colour(const Color(0xffA9C6D6)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.brightness_1_rounded,
                                      size: SizeConfig.padding8,
                                      color: _txnHistoryService
                                          .getTileColor(widget.txn.tranStatus)),
                                  SizedBox(
                                    width: SizeConfig.padding2,
                                  ),
                                  Text(
                                    widget.txn.tranStatus?.capitalizeFirst ??
                                        '',
                                    style: TextStyles.sourceSans.colour(
                                        _txnHistoryService.getTileColor(
                                            widget.txn.tranStatus)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // ignore: lines_longer_than_80_chars
                          TransactionSummary(
                              assetType: isGold
                                  ? InvestmentType.AUGGOLD99
                                  : InvestmentType.LENDBOXP2P,
                              txnType: widget.txn.type,
                              lbMap: !isGold ? widget.txn.lbMap : null,
                              createdOn: TimestampModel.fromTimestamp(
                                widget.txn.timestamp ??
                                    Timestamp.fromDate(
                                      DateTime.now(),
                                    ),
                              ),
                              summary: widget.txn.transactionUpdatesMap),
                          const Divider(
                            color: Color(0xff3E3E3E),
                          ),
                          if (isGold &&
                              widget.txn.tranStatus ==
                                  UserTransaction.TRAN_STATUS_COMPLETE) ...[
                            if (widget.txn.augmnt?["aLockPrice"] != null &&
                                !(widget.txn.subType ==
                                    UserTransaction
                                        .TRAN_SUBTYPE_AUGMONT_GOLD_FD)) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Purchase Rate",
                                      style: TextStyles.sourceSans.body3
                                          .colour(const Color(0xffA9C6D6)),
                                    ),
                                    Text(
                                        "₹${widget.txn.augmnt?["aLockPrice"] ?? 0} /gm",
                                        style: TextStyles.sourceSans.body3)
                                  ],
                                ),
                              ),
                              const Divider(
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
                                    "Gold purchased ",
                                    style: TextStyles.sourceSans.body3
                                        .colour(const Color(0xffA9C6D6)),
                                  ),
                                  Text(
                                      "${widget.txn.augmnt!["aGoldInTxn"]} gms",
                                      style: TextStyles.sourceSans.body3)
                                ],
                              ),
                            ),
                            const Divider(
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
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            widget.txn.couponCode ?? "",
                                            style: TextStyles.sourceSansSB.body3
                                                .colour(
                                                    const Color(0xffA5FCE7)),
                                          ),
                                          Text(
                                            " coupon applied",
                                            style: TextStyles.sourceSansL.body3
                                                .colour(
                                                    const Color(0xffA5FCE7)),
                                          ),
                                        ],
                                      ),
                                      if (widget.txn.couponMap
                                              ?.containsKey("goldQty") ??
                                          false)
                                        Text(
                                            "+ ${BaseUtil.digitPrecision(widget.txn.couponMap?["goldQty"], 4, false)} gms",
                                            style: TextStyles.sourceSans.body3
                                                .colour(
                                                    const Color(0xffA5FCE7))),
                                      if (widget.txn.couponMap
                                              ?.containsKey("gtId") ??
                                          false)
                                        Text("+ 1 Ticket",
                                            style: TextStyles.sourceSans.body3
                                                .colour(
                                                    const Color(0xffA5FCE7)))
                                    ],
                                  ),
                                ),
                                const Divider(
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
                                      style:
                                          TextStyles.sourceSansB.body3.colour(
                                        const Color(0xffE3CD95),
                                      ),
                                    ),
                                    Text(
                                      "${widget.txn.couponMap!.containsKey("goldQty") ? (BaseUtil.digitPrecision(widget.txn.augmnt!["aGoldInTxn"] + widget.txn.couponMap!["goldQty"], 6, false)).toString() : BaseUtil.digitPrecision(widget.txn.augmnt!["aGoldInTxn"], 6, false).toString()} gms",
                                      style:
                                          TextStyles.sourceSansB.body3.colour(
                                        const Color(0xffE3CD95),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Color(0xff3E3E3E),
                              ),
                            ]
                          ],
                          if (widget.txn.tranStatus == "COMPLETE") ...[
                            if (goldPresent || ticketsPresent)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.txn.showRewardsTextValue,
                                  style: TextStyles.sourceSans.body3
                                      .colour(const Color(0XFF9AB5C4)),
                                ),
                              ),
                            if (widget.txn.type ==
                                UserTransaction.TRAN_TYPE_WITHDRAW)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Tickets are deducted for withdrawals",
                                  style: TextStyles.sourceSans.body4
                                      .colour(const Color(0xffA0A0A0)),
                                ),
                              ),
                            SizedBox(
                              height: SizeConfig.padding12,
                            ),
                            Row(
                              children: [
                                if (ticketsPresent)
                                  RewardsCard(
                                      rewardType: RewardType.tt,
                                      rewardQuantity: widget
                                          .txn.misMap!["tickets"]
                                          .toString(),
                                      txnType: widget.txn.type ?? '',
                                      isRewardTypeTicket: true),
                                if (goldPresent)
                                  RewardsCard(
                                      rewardType: RewardType.sc,
                                      rewardQuantity: widget.txn.rewardQuantity,
                                      txnType: widget.txn.type ?? '')
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  // Spacer(),

                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.16,
                  ),
                ],
              ),
            ),
          ),
          if (_showInvoiceButton && widget.txn.augmnt?["aLockPrice"] != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.padding20),
                child: AppPositiveCustomChildBtn(
                  onPressed: () async {
                    if (widget.txn.augmnt![UserTransaction.subFldAugTranId] !=
                        null) {
                      setState(() {
                        _isInvoiceLoading = true;
                      });
                      String? trnId =
                          widget.txn.augmnt![UserTransaction.subFldAugTranId];
                      unawaited(augmontProvider!
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
                      }));
                    } else {
                      BaseUtil.showNegativeAlert(
                          locale.txnInvoiceFailed, locale.txnTryAfterSomeTime);
                    }
                  },
                  width: SizeConfig.screenWidth! * 0.8,
                  child: _isInvoiceLoading
                      ? SpinKitThreeBounce(
                          size: SizeConfig.padding20,
                          color: Colors.white,
                          duration: const Duration(milliseconds: 500),
                        )
                      : Text(locale.btnDownloadInvoice.toUpperCase(),
                          style: TextStyles.rajdhaniSB.body1),
                ),
              ),
            ),
          if (widget.txn.tranStatus != UserTransaction.TRAN_STATUS_COMPLETE &&
              widget.txn.type == UserTransaction.TRAN_TYPE_WITHDRAW)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: AppPositiveBtn(
                  onPressed: () async {
                    Haptic.vibrate();
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addPage,
                      page: FreshDeskHelpPageConfig,
                    );
                  },
                  width: SizeConfig.screenWidth!,
                  btnText: "NEED HELP ?",
                ),
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

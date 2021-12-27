import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/modals/octfest_info_modal.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class TransactionDetailsDialog extends StatefulWidget {
  final UserTransaction _transaction;
  final bool showBeerBanner;

  TransactionDetailsDialog(this._transaction, this.showBeerBanner);

  @override
  State createState() => TransactionDetailsDialogState();
}

class TransactionDetailsDialogState extends State<TransactionDetailsDialog> {
  final Log log = new Log('TransactionDetailsDialog');
  double _width;
  AugmontModel augmontProvider;
  BaseUtil baseProvider;
  bool _showInvoiceButton = false;
  bool _isInvoiceLoading = false;
  int _timeoutMins;
  double dialogHeight = SizeConfig.screenHeight * 0.54;
  final txnService = locator<TransactionService>();

  @override
  void initState() {
    super.initState();

    String _timeoutStr = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.OCT_FEST_OFFER_TIMEOUT);
    if (_timeoutStr == null || _timeoutStr.isEmpty) _timeoutStr = '10';
    _timeoutMins = int.tryParse(_timeoutStr);

    if (widget._transaction.subType ==
            UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
        widget._transaction.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
        widget._transaction.tranStatus ==
            UserTransaction.TRAN_STATUS_COMPLETE) {
      _showInvoiceButton = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher.didPopRoute();
        return true;
      },
      child: Dialog(
        insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      ),
    );
  }

  String _getTileTitle(String type) {
    if (type == UserTransaction.TRAN_SUBTYPE_ICICI) {
      return "ICICI Prudential Fund";
    } else if (type == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD) {
      return "Digital Gold";
    } else if (type == UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN) {
      return "Tambola Win";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REF_BONUS) {
      return "Referral Bonus";
    } else if (type == UserTransaction.TRAN_SUBTYPE_GLDN_TCK) {
      return "Golden Ticket";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REWARD_REDEEM) {
      return "Rewards Redeemed";
    }
    return 'Fello Rewards';
  }

  String _getAugmontGoldGrams(double gms) =>
      (gms == null || gms == 0) ? 'N/A' : gms.toStringAsFixed(4);

  Color getFlagColor() {
    if (widget._transaction.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE)
      return UiConstants.primaryColor;
    if (widget._transaction.tranStatus == UserTransaction.TRAN_STATUS_CANCELLED)
      return Colors.red;
    if (widget._transaction.tranStatus == UserTransaction.TRAN_STATUS_PENDING ||
        widget._transaction.tranStatus ==
            UserTransaction.TRAN_STATUS_PROCESSING)
      return UiConstants.tertiarySolid;
    if (widget._transaction.type == UserTransaction.TRAN_TYPE_PRIZE)
      return Colors.blue;
    return UiConstants.primaryColor;
  }

  getDialogCardHeight() {
    if (widget._transaction.type == UserTransaction.TRAN_TYPE_PRIZE)
      dialogHeight = SizeConfig.screenHeight * 0.24;
    else if (widget.showBeerBanner)
      dialogHeight = SizeConfig.screenHeight * 0.34;
  }

  Widget dialogContent(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: SizeConfig.largeTextSize * 4,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              color: Colors.white,
              // border: Border(
              //   bottom: BorderSide(color: Colors.black, width: 2),
              // ),

              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              _getTileTitle(widget._transaction.subType),
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.largeTextSize * 1.2,
              ),
            ),
          ),
        ),
        Container(
          height: getDialogCardHeight(),
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView(
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Transaction Amount",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: SizeConfig.smallTextSize,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      txnService
                          .getFormattedTxnAmount(widget._transaction.amount),
                      // '₹ ${widget._transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.cardTitleTextSize * 2,
                      ),
                    ),
                  ),
                  Divider(
                    color: getFlagColor().withOpacity(0.7),
                    height: 0,
                    endIndent: SizeConfig.screenWidth * 0.1,
                    indent: SizeConfig.screenWidth * 0.1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: getFlagColor().withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget._transaction.type.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    if (widget._transaction.subType ==
                            UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                        widget._transaction.type ==
                            UserTransaction.TRAN_TYPE_DEPOSIT)
                      Row(
                        children: [
                          referralTile(
                              'Purchase Rate:',
                              widget._transaction.augmnt[
                                          UserTransaction.subFldAugLockPrice] !=
                                      null
                                  ? '₹ ${widget._transaction.augmnt[UserTransaction.subFldAugLockPrice]}/gm'
                                  : "Unavailable",
                              UiConstants.primaryColor),
                          referralTile(
                              'Gold Purchased:',
                              '${_getAugmontGoldGrams(BaseUtil.toDouble(widget._transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm]) ?? 'N/A')} grams',
                              UiConstants.primaryColor)
                        ],
                      ),
                    if (widget._transaction.subType ==
                            UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                        widget._transaction.type ==
                            UserTransaction.TRAN_TYPE_WITHDRAW)
                      Row(
                        children: [
                          referralTile(
                            'Sell Rate:',
                            '₹ ${widget._transaction.augmnt[UserTransaction.subFldAugLockPrice] ?? 'N/A'}/gm',
                            Colors.redAccent.withOpacity(0.6),
                          ),
                          referralTile(
                            'Gold Sold:',
                            '${_getAugmontGoldGrams(BaseUtil.toDouble(widget._transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm]) ?? 'N/A')} grams',
                            Colors.redAccent.withOpacity(0.6),
                          )
                        ],
                      ),
                    (widget._transaction.tranStatus != null)
                        ? referralTileWide('Transaction Status:',
                            widget._transaction.tranStatus, getFlagColor())
                        : referralTileWide('Transaction Status:', "COMPLETED",
                            UiConstants.primaryColor),
                    if (widget._transaction.redeemType != null &&
                        widget._transaction.redeemType != "")
                      referralTileWide(
                          "Redeem type:",
                          getRedeemTypeValue(widget._transaction.redeemType),
                          UiConstants.tertiarySolid),
                    referralTileWide(
                        "Date & Time",
                        "${_getFormattedDate(widget._transaction.timestamp)}, ${_getFormattedTime(widget._transaction.timestamp)}",
                        Colors.black)
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (_showInvoiceButton && !_isInvoiceLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          'Download Invoice',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.mediumTextSize),
                        ),
                      ),
                      onPressed: () async {
                        if (widget._transaction
                                .augmnt[UserTransaction.subFldAugTranId] !=
                            null) {
                          _isInvoiceLoading = true;
                          setState(() {});
                          String trnId = widget._transaction
                              .augmnt[UserTransaction.subFldAugTranId];
                          augmontProvider
                              .generatePurchaseInvoicePdf(trnId)
                              .then((generatedPdfFilePath) {
                            _isInvoiceLoading = false;
                            setState(() {});
                            if (generatedPdfFilePath != null) {
                              OpenFile.open(generatedPdfFilePath);
                            } else {
                              BaseUtil.showNegativeAlert(
                                  'Invoice could\'nt be loaded',
                                  'Please try again in some time');
                            }
                          });
                        } else {
                          BaseUtil.showNegativeAlert(
                              'Invoice could\'nt be loaded',
                              'Please try again in some time');
                        }
                      },
                    ),
                  ],
                ),
              if (_showInvoiceButton && _isInvoiceLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: SpinKitThreeBounce(
                        color: UiConstants.primaryColor,
                        size: 18.0,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: SizeConfig.padding12)
            ],
          ),
        ),
        if (widget.showBeerBanner)
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenWidth * 0.5,
            decoration: BoxDecoration(
              color: UiConstants.primaryColor,
              borderRadius: BorderRadius.circular(12),
              // gradient: new LinearGradient(colors: [
              //   UiConstants.primaryColor,
              //   UiConstants.primaryColor.withBlue(190),
              // ], begin: Alignment.centerLeft, end: Alignment.bottomRight),
            ),
            padding: EdgeInsets.only(
                right: SizeConfig.globalMargin,
                left: SizeConfig.globalMargin * 2),
            child: Stack(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BeerTicketItem(
                            label: "Name", value: baseProvider.myUser.name),
                        BeerTicketItem(
                            label: "Mobile",
                            value: "+91 ${baseProvider.myUser.mobile}"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date & Time",
                              style: TextStyle(
                                fontSize: SizeConfig.smallTextSize,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              "${_getFormattedDate(widget._transaction.timestamp)}, ${_getFormattedTime(widget._transaction.timestamp)}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.mediumTextSize,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Offer ends in:  ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.smallTextSize,
                                  fontWeight: FontWeight.w500),
                            ),
                            TweenAnimationBuilder<Duration>(
                                duration: getOfferDuration(_timeoutMins),
                                tween: Tween(
                                    begin: getOfferDuration(_timeoutMins),
                                    end: Duration.zero),
                                onEnd: () {
                                  print('Timer ended');
                                  BaseUtil.showNegativeAlert(
                                    "Offer Closed",
                                    "Stay tuned for more such fun offers!",
                                  );
                                  AppState.backButtonDispatcher.didPopRoute();
                                },
                                builder: (BuildContext context, Duration value,
                                    Widget child) {
                                  final minutes = (value.inMinutes)
                                      .toString()
                                      .padLeft(2, '0');
                                  final seconds = (value.inSeconds % 60)
                                      .toString()
                                      .padLeft(2, '0');

                                  return Text(
                                    "$minutes:$seconds",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.largeTextSize,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Transform.scale(
                      scale: 1.4,
                      child: Lottie.asset("images/lottie/beer.json",
                          height: SizeConfig.screenHeight * 0.14,
                          width: SizeConfig.screenWidth * 0.24),
                    ),
                    SizedBox(
                      width: SizeConfig.globalMargin * 2,
                    )
                  ],
                ),
                Positioned(
                  top: 0,
                  right: -10,
                  child: IconButton(
                    icon: Icon(Icons.info, color: Colors.white),
                    onPressed: () {
                      AppState.screenStack.add(ScreenItem.dialog);
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness24),
                            topRight: Radius.circular(SizeConfig.roundness24),
                          )),
                          context: context,
                          builder: (ctx) {
                            return OctFestInfoModal();
                          });
                    },
                  ),
                )
              ],
            ),
          ),
      ],
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
            widget._transaction.timestamp.millisecondsSinceEpoch)
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

  Widget referralTileWide(String title, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 12.0, horizontal: SizeConfig.blockSizeHorizontal * 5),
      child: Row(
        children: [
          Icon(
            Icons.brightness_1_outlined,
            size: 12,
            color: color,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyles.body3.colour(Colors.black45),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyles.body3.bold),
          ),
        ],
      ),
    );
  }

  Widget referralTile(String title, String value, Color color) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 12.0, horizontal: SizeConfig.blockSizeHorizontal * 5),
        child: Row(
          children: [
            Icon(
              Icons.brightness_1_outlined,
              size: 12,
              color: color,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.body3.colour(Colors.black45),
                ),
                SizedBox(height: 4),
                Text(value, style: TextStyles.body3.bold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BeerTicketItem extends StatelessWidget {
  final String label, value;

  BeerTicketItem({this.label, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (label != null)
            Text(
              "$label:",
              style: TextStyles.body4.colour(
                Colors.white.withOpacity(0.5),
              ),
            ),
          Container(
            width: SizeConfig.screenWidth * 0.5,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.body1.bold.colour(Colors.white),
            ),
          ),
        ]);
  }
}

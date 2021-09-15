
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class TransactionDetailsDialog extends StatefulWidget {
  final UserTransaction _transaction;

  TransactionDetailsDialog(this._transaction);

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

  @override
  void initState() {
    super.initState();

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
      return "Augmont Digital Gold";
    } else if (type == UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN) {
      return "Tambola Win";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REF_BONUS) {
      return "Referral Bonus";
    } else if (type == UserTransaction.TRAN_SUBTYPE_GLDN_TCK) {
      return "Golden Ticket";
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
    if (widget._transaction.tranStatus == UserTransaction.TRAN_STATUS_PENDING)
      return Colors.orange;
    if (widget._transaction.type == UserTransaction.TRAN_TYPE_PRIZE)
      return Colors.blue;
    return UiConstants.primaryColor;
  }

  Widget dialogContent(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: SizeConfig.screenHeight * 0.12,
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
          height: SizeConfig.screenHeight * 0.4,
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
                      '₹ ${widget._transaction.amount.toStringAsFixed(2)}',
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
                    (widget._transaction.subType ==
                                UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                            widget._transaction.type ==
                                UserTransaction.TRAN_TYPE_DEPOSIT)
                        ? Row(
                            children: [
                              referralTile(
                                  'Purchase Rate:',
                                  '₹ ${widget._transaction.augmnt[UserTransaction.subFldAugLockPrice]}/gm',
                                  UiConstants.primaryColor),
                              referralTile(
                                  'Gold Purchased:',
                                  '${_getAugmontGoldGrams(widget._transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm])} grams',
                                  UiConstants.primaryColor)
                            ],
                          )
                        : Container(),
                    (widget._transaction.subType ==
                                UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
                            widget._transaction.type ==
                                UserTransaction.TRAN_TYPE_WITHDRAW)
                        ? Row(
                            children: [
                              referralTile(
                                'Sell Rate:',
                                '₹ ${widget._transaction.augmnt[UserTransaction.subFldAugLockPrice] ?? "N/A"}/gm',
                                Colors.redAccent.withOpacity(0.6),
                              ),
                              referralTile(
                                'Gold Sold:',
                                '${_getAugmontGoldGrams(widget._transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm] ?? 'N/A')} grams',
                                Colors.redAccent.withOpacity(0.6),
                              )
                            ],
                          )
                        : Container(),
                    (widget._transaction.type !=
                            UserTransaction.TRAN_TYPE_WITHDRAW)
                        ? referralTileWide(
                            'Tickets Added:',
                            '${widget._transaction.ticketUpCount ?? 'Unavailable'}',
                            UiConstants.primaryColor)
                        : referralTileWide(
                            'Tickets Reduced:',
                            '${widget._transaction.ticketUpCount ?? 'Unavailable'}',
                            Colors.redAccent.withOpacity(0.6),
                          ),
                    (widget._transaction.subType ==
                            UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD)
                        ? referralTileWide(
                            'Closing Gold Balance:',
                            widget._transaction.augmnt[
                                        UserTransaction.subFldAugTotalGoldGm] ==
                                    null
                                ? "Unavailable"
                                : '${widget._transaction.augmnt[UserTransaction.subFldAugTotalGoldGm] ?? 'Unavailable'} grams',
                            UiConstants.primaryColor)
                        : Container(),
                    (widget._transaction.closingBalance > 0)
                        ? referralTileWide(
                            'Overall Closing Balance:',
                            '₹${widget._transaction.closingBalance.toStringAsFixed(2) ?? 'Unavailable'}',
                            UiConstants.primaryColor)
                        : Container(),
                    widget._transaction.tranStatus != null
                        ? referralTileWide('Transaction Status',
                            widget._transaction.tranStatus, getFlagColor())
                        : Container()
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
        if (_showInvoiceButton)
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: !_isInvoiceLoading
                        ? Text(
                            'Download Invoice',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.mediumTextSize),
                          )
                        : SpinKitThreeBounce(
                            color: Colors.white,
                            size: 18.0,
                          ),
                  ),
                  onPressed: () async {
                    if (widget._transaction
                            .augmnt[UserTransaction.subFldAugTranId] !=
                        null) {
                      _isInvoiceLoading = true;
                      setState(() {});
                      String trnId = widget
                          ._transaction.augmnt[UserTransaction.subFldAugTranId];
                      augmontProvider
                          .generatePurchaseInvoicePdf(trnId)
                          .then((generatedPdfFilePath) {
                        _isInvoiceLoading = false;
                        setState(() {});
                        if (generatedPdfFilePath != null) {
                          OpenFile.open(generatedPdfFilePath);
                        } else {
                          baseProvider.showNegativeAlert(
                              'Invoice could\'nt be loaded',
                              'Please try again in some time',
                              context);
                        }
                      });
                    } else {
                      baseProvider.showNegativeAlert(
                          'Invoice could\'nt be loaded',
                          'Please try again in some time',
                          context);
                    }
                  },
                ),
                // if (_showInvoiceButton && _isInvoiceLoading)
                //   Padding(
                //     padding: EdgeInsets.all(20),
                //     child: SpinKitThreeBounce(
                //       color: Colors.white,
                //       size: 18.0,
                //     ),
                //   ),
              ],
            ),
          ),
      ],
    );
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
              style: GoogleFonts.montserrat(
                  fontSize: SizeConfig.mediumTextSize, color: Colors.black45),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.mediumTextSize),
            ),
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
                  style: GoogleFonts.montserrat(
                      fontSize: SizeConfig.mediumTextSize, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.mediumTextSize),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

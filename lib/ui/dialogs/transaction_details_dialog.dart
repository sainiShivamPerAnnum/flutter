import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/main.dart';
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
        widget._transaction.type == UserTransaction.TRAN_TYPE_DEPOSIT) {
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
        backButtonDispatcher.didPopRoute();
        return true;
      },
      child: Dialog(
        insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent2(context),
      ),
    );
  }

  // dialogContent(BuildContext context) {
  //   return Container(
  //     color: Colors.white,
  //     child: Stack(
  //         overflow: Overflow.visible,
  //         alignment: Alignment.topCenter,
  //         children: <Widget>[
  //           SingleChildScrollView(
  //             physics: BouncingScrollPhysics(),
  //             child: Padding(
  //                 padding:
  //                     EdgeInsets.only(top: 30, bottom: 40, left: 35, right: 35),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       'Transaction Details',
  //                       style: TextStyle(
  //                           fontSize: SizeConfig.largeTextSize,
  //                           color: UiConstants.accentColor),
  //                     ),
  //                     Divider(),
  //                     _addListField('Fund Name:',
  //                         _getTileTitle(widget._transaction.subType)),
  //                     _addListField(
  //                         'Transaction Type:', widget._transaction.type),
  //                     _addListField('Transaction Amount:',
  //                         '₹${widget._transaction.amount.toStringAsFixed(2)}'),
  //                     (widget._transaction.closingBalance > 0)
  //                         ? _addListField('Overall Closing Balance:',
  //                             '₹${widget._transaction.closingBalance.toStringAsFixed(2)}')
  //                         : Container(),
  //                     (widget._transaction.type !=
  //                             UserTransaction.TRAN_TYPE_WITHDRAW)
  //                         ? _addListField('Tickets Added:',
  //                             '${widget._transaction.ticketUpCount}')
  //                         : _addListField('Tickets Reduced:',
  //                             '${widget._transaction.ticketUpCount}'),
  //                     // _addListField('Transaction ID:',
  //                     //     '${widget._transaction.docKey}'),
  //                     (widget._transaction.subType ==
  //                                 UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
  //                             widget._transaction.type ==
  //                                 UserTransaction.TRAN_TYPE_DEPOSIT)
  //                         ? _addListField('Purchase Rate:',
  //                             '₹${widget._transaction.augmnt[UserTransaction.subFldAugLockPrice]}/gm')
  //                         : Container(),
  //                     (widget._transaction.subType ==
  //                                 UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
  //                             widget._transaction.type ==
  //                                 UserTransaction.TRAN_TYPE_WITHDRAW)
  //                         ? _addListField('Sell Rate:',
  //                             '₹${widget._transaction.augmnt[UserTransaction.subFldAugLockPrice]}/gm')
  //                         : Container(),
  //                     (widget._transaction.subType ==
  //                                 UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
  //                             widget._transaction.type ==
  //                                 UserTransaction.TRAN_TYPE_DEPOSIT)
  //                         ? _addListField('Gold Purchased:',
  //                             '${_getAugmontGoldGrams(widget._transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm])} grams')
  //                         : Container(),
  //                     (widget._transaction.subType ==
  //                                 UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD &&
  //                             widget._transaction.type ==
  //                                 UserTransaction.TRAN_TYPE_WITHDRAW)
  //                         ? _addListField('Gold Sold:',
  //                             '${_getAugmontGoldGrams(widget._transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm])} grams')
  //                         : Container(),
  //                     (widget._transaction.subType ==
  //                             UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD)
  //                         ? _addListField('Closing Gold Balance:',
  //                             '${widget._transaction.augmnt[UserTransaction.subFldAugTotalGoldGm]} grams')
  //                         : Container(),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     (_showInvoiceButton && !_isInvoiceLoading)
  //                         ? InkWell(
  //                             child: Padding(
  //                               padding: EdgeInsets.all(20),
  //                               child: Text(
  //                                 'Download Invoice',
  //                                 style: TextStyle(
  //                                     color: UiConstants.primaryColor,
  //                                     fontSize: SizeConfig.mediumTextSize),
  //                               ),
  //                             ),
  //                             onTap: () async {
  //                               if (widget._transaction.augmnt[
  //                                       UserTransaction.subFldAugTranId] !=
  //                                   null) {
  //                                 _isInvoiceLoading = true;

  //                                 setState(() {});
  //                                 String trnId = widget._transaction
  //                                     .augmnt[UserTransaction.subFldAugTranId];
  //                                 augmontProvider
  //                                     .generatePurchaseInvoicePdf(trnId)
  //                                     .then((generatedPdfFilePath) {
  //                                   _isInvoiceLoading = false;
  //                                   setState(() {});
  //                                   if (generatedPdfFilePath != null) {
  //                                     OpenFile.open(generatedPdfFilePath);
  //                                   } else {
  //                                     baseProvider.showNegativeAlert(
  //                                         'Invoice could\'nt be loaded',
  //                                         'Please try again in some time',
  //                                         context);
  //                                   }
  //                                 });
  //                               } else {
  //                                 baseProvider.showNegativeAlert(
  //                                     'Invoice could\'nt be loaded',
  //                                     'Please try again in some time',
  //                                     context);
  //                               }
  //                             },
  //                           )
  //                         : Container(),
  //                     (_showInvoiceButton && _isInvoiceLoading)
  //                         ? Padding(
  //                             padding: EdgeInsets.all(20),
  //                             child: SpinKitThreeBounce(
  //                               color: UiConstants.spinnerColor2,
  //                               size: 18.0,
  //                             ))
  //                         : Container()
  //                   ],
  //                 )),
  //           )
  //         ]),
  //   );
  // }

  // Widget _addListField(String title, String value) {
  //   return ListTile(
  //     contentPadding: EdgeInsets.symmetric(
  //       horizontal: SizeConfig.blockSizeHorizontal * 8,
  //       vertical: SizeConfig.blockSizeVertical * 0.4,
  //     ),
  //     title: Container(
  //       width: SizeConfig.screenWidth * 0.2,
  //       child: Text(
  //         title,
  //         style: TextStyle(
  //           color: UiConstants.accentColor,
  //           fontSize: SizeConfig.mediumTextSize,
  //         ),
  //       ),
  //     ),
  //     trailing: Container(
  //       width: SizeConfig.screenWidth * 0.3,
  //       child: Text(
  //         value,
  //         overflow: TextOverflow.clip,
  //         style: TextStyle(
  //           color: Colors.black54,
  //           fontSize: SizeConfig.largeTextSize,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  String _getTileTitle(String type) {
    if (type == UserTransaction.TRAN_SUBTYPE_ICICI) {
      return "ICICI Prudential Fund";
    } else if (type == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD) {
      return "Augmont Digital Gold";
    } else if (type == UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN) {
      return "Tambola Win";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REF_BONUS) {
      return "Referral Bonus";
    }
    return 'Fund Name';
  }

  String _getAugmontGoldGrams(double gms) =>
      (gms == null || gms == 0) ? 'N/A' : gms.toStringAsFixed(4);

  Widget dialogContent2(BuildContext context) {
    return Wrap(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                height: 80,
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
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: UiConstants.primaryColor.withOpacity(0.7),
                        height: 0,
                        endIndent: SizeConfig.screenWidth * 0.1,
                        indent: SizeConfig.screenWidth * 0.1,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        margin: EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: UiConstants.primaryColor.withOpacity(0.7),
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
                      Container(
                        padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 5),
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            (widget._transaction.subType ==
                                        UserTransaction
                                            .TRAN_SUBTYPE_AUGMONT_GOLD &&
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
                                        UserTransaction
                                            .TRAN_SUBTYPE_AUGMONT_GOLD &&
                                    widget._transaction.type ==
                                        UserTransaction.TRAN_TYPE_WITHDRAW)
                                ? Row(
                                    children: [
                                      referralTile(
                                        'Sell Rate:',
                                        '₹ ${widget._transaction.augmnt[UserTransaction.subFldAugLockPrice]}/gm',
                                        Colors.redAccent.withOpacity(0.6),
                                      ),
                                      referralTile(
                                        'Gold Sold:',
                                        '${_getAugmontGoldGrams(widget._transaction.augmnt[UserTransaction.subFldAugCurrentGoldGm])} grams',
                                        Colors.redAccent.withOpacity(0.6),
                                      )
                                    ],
                                  )
                                : Container(),
                            (widget._transaction.type !=
                                    UserTransaction.TRAN_TYPE_WITHDRAW)
                                ? referralTileWide(
                                    'Tickets Added:',
                                    '${widget._transaction.ticketUpCount}',
                                    UiConstants.primaryColor)
                                : referralTileWide(
                                    'Tickets Reduced:',
                                    '${widget._transaction.ticketUpCount}',
                                    Colors.redAccent.withOpacity(0.6),
                                  ),
                            (widget._transaction.subType ==
                                    UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD)
                                ? referralTileWide(
                                    'Closing Gold Balance:',
                                    '${widget._transaction.augmnt[UserTransaction.subFldAugTotalGoldGm]} grams',
                                    UiConstants.primaryColor)
                                : Container(),
                            (widget._transaction.closingBalance > 0)
                                ? referralTileWide(
                                    'Overall Closing Balance:',
                                    '₹${widget._transaction.closingBalance.toStringAsFixed(2)}',
                                    UiConstants.primaryColor)
                                : Container(),
                          ],
                        ),
                      ),
                      (_showInvoiceButton && !_isInvoiceLoading)
                          ? ElevatedButton(
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
                                if (widget._transaction.augmnt[
                                        UserTransaction.subFldAugTranId] !=
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
                            )
                          : Container(),
                      (_showInvoiceButton && _isInvoiceLoading)
                          ? Padding(
                              padding: EdgeInsets.all(20),
                              child: SpinKitThreeBounce(
                                color: UiConstants.primaryColor,
                                size: 18.0,
                              ))
                          : Container(),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              )
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AutosaveTransactionDetailsDialog extends StatefulWidget {
  final AutosaveTransactionModel _transaction;

  AutosaveTransactionDetailsDialog(this._transaction);

  @override
  State createState() => AutosaveTransactionDetailsDialogState();
}

class AutosaveTransactionDetailsDialogState
    extends State<AutosaveTransactionDetailsDialog> {
  final Log log = new Log('AutosaveAutosaveTransactionDetailsDialog');
  final txnService = locator<TransactionService>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  String _getAugmontGoldGrams(double gms) =>
      (gms == null || gms == 0) ? 'N/A' : gms.toStringAsFixed(4);

  Widget dialogContent(BuildContext context) {
    return Wrap(
      children: [
        Container(
          height: SizeConfig.largeTextSize * 4,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              txnService
                  .getTileTitle(UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD),
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.largeTextSize * 1.2,
              ),
            ),
          ),
        ),
        Container(
          // height: dialogHeight,
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
                    color: txnService
                        .getTileColor(widget._transaction.status)
                        .withOpacity(0.7),
                    height: 0,
                    endIndent: SizeConfig.screenWidth * 0.1,
                    indent: SizeConfig.screenWidth * 0.1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: txnService
                          .getTileColor(widget._transaction.status)
                          .withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      UserTransaction.TRAN_TYPE_DEPOSIT.toUpperCase(),
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
                    if (widget._transaction.status ==
                        UserTransaction.TRAN_STATUS_COMPLETE)
                      Row(
                        children: [
                          referralTile(
                            'Purchase Rate:',
                            '₹ ${widget._transaction.augmontMap.aLockPrice ?? 'N/A'}/gm',
                            Colors.redAccent.withOpacity(0.6),
                          ),
                          referralTile(
                            'Gold Purchased:',
                            '${_getAugmontGoldGrams(BaseUtil.toDouble(widget._transaction.augmontMap.aGoldBalance) ?? 'N/A')} grams',
                            Colors.redAccent.withOpacity(0.6),
                          )
                        ],
                      ),
                    (widget._transaction.status != null)
                        ? referralTileWide(
                            'Transaction Status:',
                            widget._transaction.status,
                            txnService.getTileColor(widget._transaction.status),
                          )
                        : referralTileWide('Transaction Status:', "COMPLETED",
                            UiConstants.primaryColor),
                    referralTileWide(
                        "Date & Time",
                        "${_getFormattedDate(widget._transaction.createdOn)}, ${_getFormattedTime(widget._transaction.createdOn)}",
                        Colors.black)
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(height: SizeConfig.padding12)
            ],
          ),
        ),
      ],
    );
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

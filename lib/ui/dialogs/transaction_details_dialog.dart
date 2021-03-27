import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD) {
      _showInvoiceButton = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    _width = MediaQuery
        .of(context)
        .size
        .width;
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
                padding:
                EdgeInsets.only(top: 30, bottom: 40, left: 35, right: 35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'To be entered',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: UiConstants.primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    (_showInvoiceButton && !_isInvoiceLoading) ? InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('Download Invoice',
                          style: TextStyle(
                              color: UiConstants.primaryColor,
                              fontSize: SizeConfig.mediumTextSize
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (widget._transaction.augmnt[UserTransaction
                            .subFldAugTranId] != null) {
                          _isInvoiceLoading = true;
                          setState(() {});
                          String trnId = widget._transaction
                              .augmnt[UserTransaction.subFldAugTranId];
                          augmontProvider
                              .generatePurchaseInvoicePdf(trnId).then((generatedPdfFilePath) {
                             _isInvoiceLoading = false;
                             setState(() {});
                            if (generatedPdfFilePath != null) {
                              OpenFile.open(generatedPdfFilePath);
                            } else {
                              baseProvider.showNegativeAlert(
                                  'Invoice could\'nt be loaded',
                                  'Please try again in some time', context);
                            }
                          });
                        }else{
                          baseProvider.showNegativeAlert(
                              'Invoice could\'nt be loaded',
                              'Please try again in some time', context);
                        }
                      },
                    ) : Container(),
                    (_showInvoiceButton && _isInvoiceLoading) ? Padding(
                      padding: EdgeInsets.all(20),
                      child:SpinKitThreeBounce(
                        color: UiConstants.spinnerColor2,
                        size: 18.0,
                      )
                    ): Container()
                  ],
                )),
          )
        ]);
  }
}

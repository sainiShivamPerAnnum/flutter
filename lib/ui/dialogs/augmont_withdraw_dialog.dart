import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AugmontWithdrawDialog extends StatefulWidget {
  final double balance;
  final double sellRate;
  final String bankHolderName;
  final String bankAccNo;
  final String bankIfsc;
  final ValueChanged<Map<String, double>> onAmountConfirmed;

  AugmontWithdrawDialog(
      {Key key,
      this.balance,
      this.sellRate,
      this.bankHolderName,
      this.bankAccNo,
      this.bankIfsc,
      this.onAmountConfirmed})
      : super(key: key);

  @override
  State createState() => AugmontWithdrawDialogState();
}

class AugmontWithdrawDialogState extends State<AugmontWithdrawDialog> {
  final Log log = new Log('AugmontWithdrawDialog');
  TextEditingController _amountController = TextEditingController();
  BaseUtil baseProvider;
  String _amountError;
  String _errorMessage;
  bool _isLoading = true;
  bool _isButtonEnabled = false;
  double _width;
  final TextStyle tTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final TextStyle gTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
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
                    SizedBox(
                      child: Image(
                        image: AssetImage(Assets.onboardingSlide[1]),
                        fit: BoxFit.contain,
                      ),
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'WITHDRAW',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: UiConstants.primaryColor),
                    ),
                    (_isLoading)
                        ? Padding(
                            padding: EdgeInsets.all(30),
                            child: SpinKitWave(
                              color: UiConstants.primaryColor,
                            ))
                        : Container(),
                    (_errorMessage != null && !_isLoading)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: _width * 0.7,
                                child: Text('Error: $_errorMessage',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 16)),
                              )
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    (!_isLoading)
                        ? Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    readOnly: false,
                                    enabled: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Amount',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    (!_isLoading && _amountError != null)
                        ? Container(
                            margin: EdgeInsets.only(top: 4, left: 12),
                            child: Text(
                              _amountError,
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 15,
                    ),
                    (!_isLoading) ? _buildSubmitButton(context) : Container(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
          )
        ]);
  }

  onTransactionProcessed(bool flag) {
    _isLoading = false;
    setState(() {});
    Navigator.of(context).pop();
    if (!flag) {
      baseProvider.showNegativeAlert('Withdrawal Failed',
          'Please try again in some time or contact us for assistance', context,
          seconds: 5);
    } else {
      baseProvider.showPositiveAlert('Withdrawal Request is now processing',
          'We will inform you once the withdrawal is complete!', context);
    }
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 50.0,
      decoration: BoxDecoration(
        gradient: new LinearGradient(colors: [
          UiConstants.primaryColor,
          UiConstants.primaryColor.withBlue(190),
        ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: new Material(
        child: MaterialButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WITHDRAW ',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          onPressed: () async {
            HapticFeedback.vibrate();
            final amtErr = _validateAmount(_amountController.text);
            if (amtErr != null) {
              setState(() {
                _amountError = amtErr;
              });
              return;
            }
            setState(() {
              _amountError = null;
            });
            if (_amountError == null) {
              double amt = double.parse(_amountController.text);
              String _confirmMsg =
                  "Are you sure you want to continue? ₹$amt worth of digital gold shall be processed.";
              showDialog(
                context: context,
                builder: (ctx) => ConfirmActionDialog(
                  title: "Please confirm your action",
                  description: _confirmMsg,
                  buttonText: "Withdraw",
                  cancelBtnText: 'Cancel',
                  confirmAction: () {
                    Navigator.of(context).pop();
                    _isLoading = true;
                    setState(() {});
                    widget.onAmountConfirmed({
                      'withdrawal_amount': amt,
                    });
                    return true;
                  },
                  cancelAction: () {
                    Navigator.of(context).pop();
                    return false;
                  },
                ),
              );
            }
          },
          highlightColor: Colors.orange.withOpacity(0.5),
          splashColor: Colors.orange.withOpacity(0.5),
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }

  String _validateAmount(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid amount';
    }
    try {
      double amount = double.parse(value);
      if (amount > widget.balance) return 'Insufficient balance';
      if (amount < 5)
        return 'Please enter value more than ₹5';
      else
        return null;
    } catch (e) {
      return 'Please enter a valid amount';
    }
  }
}

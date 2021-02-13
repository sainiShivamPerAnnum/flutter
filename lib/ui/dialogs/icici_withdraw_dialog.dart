import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class IciciWithdrawDialog extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onAmountConfirmed;
  final ValueChanged<bool> onOptionConfirmed;

  IciciWithdrawDialog(
      {Key key,
      this.currentBalance,
      this.onAmountConfirmed,
      this.onOptionConfirmed})
      : super(key: key);

  @override
  State createState() => IciciWithdrawDialogState();
}

class IciciWithdrawDialogState extends State<IciciWithdrawDialog> {
  final Log log = new Log('IciciWithdrawDialog');
  TextEditingController _amountController = TextEditingController();
  TextEditingController _upiAddressController = TextEditingController();
  String _amountError;
  String _errorMessage;
  String _upiAddressError;
  bool _isLoading = true;
  bool _isBalanceAvailble = false;
  bool _isButtonEnabled = false;
  double _width;
  double _instantBalance = 0;
  double _totalBalance = 0;
  final TextStyle tTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final TextStyle gTextStyle =
  TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
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
                    (_isLoading)?Padding(
                        padding: EdgeInsets.all(30),
                        child: SpinKitWave(
                          color: UiConstants.primaryColor,
                        )
                    ):Container(),
                    (!_isLoading && _isBalanceAvailble)
                        ? _buildBalanceTextWidget(
                            _instantBalance, _totalBalance)
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

  onDetailsReceived(double instantBalance, double totalBalance,
      bool isIMPSAllowed, String errMsg) {
    _isLoading = false;
    if (!isIMPSAllowed) {
      _errorMessage =
          errMsg ?? 'Unknown error occured. Please try again in a while';
    }

    if (instantBalance != null && totalBalance != null) {
      _instantBalance = instantBalance;
      _totalBalance = totalBalance;
      _isBalanceAvailble = true;
    }
    setState(() {});
  }

  onShowLoadDialog() {}

  Widget _buildBalanceTextWidget(double instantBalance, double totalBalance) {
    final DateTime tomorrow = DateTime.now().add(new Duration(hours: 24));
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(tomorrow);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _width*0.7,
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total balance: ',
                  textAlign: TextAlign.center,
                  style: tTextStyle,
                ),
                Text(
                  '₹${totalBalance.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: gTextStyle,
                ),
              ],
            ),
          ),
          Container(
            width: _width*0.7,
            child: Wrap(
             // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Available for immediate withdrawal: ',
                  textAlign: TextAlign.center,
                  style: tTextStyle,
                ),
                Text(
                  '₹${instantBalance.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: gTextStyle,
                ),
              ],
            ),
          ),
          Container(
            width: _width*0.7,
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Available by $formatted: ',
                  textAlign: TextAlign.center,
                  style: tTextStyle,
                ),
                Text(
                  '₹${(totalBalance - instantBalance).toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: gTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              _isLoading = true;
              setState(() {});
              return widget
                  .onAmountConfirmed(double.parse(_amountController.text));
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
      if (amount > widget.currentBalance ||
          (_totalBalance != 0 && amount > _totalBalance))
        return 'Insufficient balance';
      if (amount < 1)
        return 'Please enter value more than ₹1';
      //else if(amount > 1500) return 'We are currently only accepting deposits below ₹1500';
      else
        return null;
    } catch (e) {
      return 'Please enter a valid amount';
    }
  }

  String _validateUPIAddress(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid UPI address';
    }
    return null;
  }
}

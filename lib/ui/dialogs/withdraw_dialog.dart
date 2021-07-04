import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WithdrawDialog extends StatefulWidget {
  final int balance;
  final Function withdrawAction;

  WithdrawDialog({this.balance, this.withdrawAction});

  @override
  State createState() => WithdrawDialogState();
}

class WithdrawDialogState extends State<WithdrawDialog> {
  final Log log = new Log('WithdrawDialog');
  TextEditingController _amountController = TextEditingController();
  TextEditingController _upiAddressController = TextEditingController();
  String _amountError;
  String _upiAddressError;

  @override
  Widget build(BuildContext context) {
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
                      width: 180,
                      height: 180,
                    ),
                    Text(
                      'WITHDRAW',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: UiConstants.primaryColor),
                    ),
                    Text(
                        'All withdrawal requests are manually verified and processed everyday at 10PM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            height: 1.2,
                            color: UiConstants.accentColor,
                            fontWeight: FontWeight.w300)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 32),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _amountController,
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
                    ),
                    if (_amountError != null)
                      Container(
                        margin: EdgeInsets.only(top: 4, left: 12),
                        child: Text(
                          _amountError,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _upiAddressController,
                              readOnly: false,
                              enabled: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Your UPI address',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_upiAddressError != null)
                      Container(
                        margin: EdgeInsets.only(top: 4, left: 12),
                        child: Text(
                          _upiAddressError,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    _buildSubmitButton(context),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        '* Only users who have previously saved at least ₹100 are eligible for withdrawals',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            height: 1.2,
                            color: UiConstants.accentColor,
                            fontWeight: FontWeight.w300)),
                    Padding(
                        padding: const EdgeInsets.all(0),
                        child: RichText(
                          text: TextSpan(
                              text:
                                  "* To read more about about the eligibility rules, please refer to our ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                    text: 'Referral Policy',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        HapticFeedback.vibrate();
                                        Navigator.of(context)
                                            .pushNamed('/refpolicy');
                                      }),
                              ]),
                        )),
                  ],
                )),
          )
        ]);
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
            final upiErr = _validateUPIAddress(_upiAddressController.text);
            if (amtErr != null) {
              setState(() {
                _amountError = amtErr;
              });
              return;
            }
            setState(() {
              _amountError = null;
            });
            if (upiErr != null) {
              setState(() {
                _upiAddressError = upiErr;
              });
              return;
            }
            setState(() {
              _upiAddressError = null;
            });

            if (_amountError == null && _upiAddressError == null) {
              return widget.withdrawAction(
                  _amountController.text, _upiAddressController.text);
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

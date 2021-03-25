import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/dialogs/icici_withdraw_dialog.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:felloapp/ui/elements/faq_card.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class ICICIWithdrawal extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<Map<String, double>> onAmountConfirmed;
  final ValueChanged<bool> onOptionConfirmed;
  ICICIWithdrawal(
      {Key key,
      this.currentBalance,
      this.onAmountConfirmed,
      this.onOptionConfirmed})
      : super(key: key);
  @override
  _ICICIWithdrawalState createState() => _ICICIWithdrawalState();
}

class _ICICIWithdrawalState extends State<ICICIWithdrawal> {
  TextEditingController _amountController = TextEditingController();
  String _amountError;
  String _errorMessage;
  String _upiAddressError;
  bool _isLoading = true;
  bool _isBalanceAvailble = false;
  bool _isButtonEnabled = false;
  double _width;
  double _instantBalance = 0;
  double _totalBalance = 0;
  double _userWithdrawInstantAmount = 0;
  double _userWithdrawNonInstantAmount = 0;
  final TextStyle tTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final TextStyle gTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  updateAmount() {
    double amount = double.tryParse(_amountController.text ?? 0);
    setState(() {
      if (amount <= 100) {
        _userWithdrawInstantAmount = amount;
        _userWithdrawNonInstantAmount = 0;
      } else {
        _userWithdrawInstantAmount = 0.9 * amount;
        _userWithdrawNonInstantAmount = 0.1 * amount;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime tomorrow = DateTime.now().add(new Duration(hours: 24));
    final DateFormat formatter = DateFormat.MMMEd();
    final String formatted = formatter.format(tomorrow);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Withdrawal",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Total Available Balance",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w300,
                          fontSize: SizeConfig.smallTextSize,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                          bottom: 10,
                        ),
                        child: Text(
                          "₹ ${widget.currentBalance.toStringAsFixed(2)}",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            color: UiConstants.primaryColor,
                            fontSize: SizeConfig.cardTitleTextSize,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical,
                          left: SizeConfig.blockSizeHorizontal * 4,
                          right: SizeConfig.blockSizeHorizontal * 4,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                readOnly: false,
                                enabled: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Withdrawal Amount',
                                ),
                                onChanged: (_) => updateAmount(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      (!_isLoading && _amountError != null)
                          ? Container(
                              margin: EdgeInsets.only(top: 4, left: 12),
                              child: Text(
                                _amountError,
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : Container(),
                      Container(
                        padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical,
                          left: SizeConfig.blockSizeHorizontal * 4,
                          right: SizeConfig.blockSizeHorizontal * 4,
                        ),
                        height: SizeConfig.screenWidth / 2,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      UiConstants.primaryColor.withOpacity(0.2),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: SizeConfig.screenWidth * 0.12,
                                      child: SvgPicture.asset(
                                        "images/svgs/thunderbolt.svg",
                                      ),
                                    ),
                                    Text(
                                      "Instantly",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.largeTextSize,
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        "₹ ${_userWithdrawInstantAmount.toStringAsFixed(2)}",
                                        style: GoogleFonts.montserrat(
                                          color: UiConstants.primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: SizeConfig.largeTextSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.amber.withOpacity(0.2),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: SizeConfig.screenWidth * 0.12,
                                      child: LottieBuilder.asset(
                                        'images/lottie/timer.json',
                                      ),
                                    ),
                                    Text(
                                      "By $formatted *",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.largeTextSize,
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        "₹ ${_userWithdrawNonInstantAmount.toStringAsFixed(2)}",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.w700,
                                          fontSize: SizeConfig.largeTextSize,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FAQCard(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    Colors.blueGrey,
                    Colors.blueGrey[800],
                  ],
                  begin: Alignment(0.5, -1.0),
                  end: Alignment(0.5, 1.0),
                ),
              ),
              child: (!_isLoading)
                  ? new Material(
                      child: MaterialButton(
                        child: Text(
                          "WITHDRAW",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white),
                        ),
                        onPressed: () async {
                          HapticFeedback.vibrate();
                          final amtErr =
                              _validateAmount(_amountController.text);
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
                                "Are you sure you want to continue? ";
                            if (amt <= _instantBalance) {
                              _userWithdrawInstantAmount = amt;
                              _confirmMsg = _confirmMsg +
                                  '₹${_userWithdrawInstantAmount.round()} will be withdrawn immediately.';
                            } else {
                              _userWithdrawInstantAmount = _instantBalance;
                              _userWithdrawNonInstantAmount =
                                  amt - _instantBalance;
                              _confirmMsg = _confirmMsg +
                                  '₹${_userWithdrawInstantAmount.round()} will be withdrawn immediately, and ₹${_userWithdrawNonInstantAmount.round()} will be withdrawn within 1 business day';
                            }
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
                                    'instant_amount':
                                        _userWithdrawInstantAmount,
                                    'non_instant_amount':
                                        _userWithdrawNonInstantAmount
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
                        highlightColor: Colors.white30,
                        splashColor: Colors.white30,
                      ),
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.circular(20.0),
                    )
                  : SpinKitThreeBounce(
                      color: Colors.white,
                      size: 18.0,
                    ),
            )
          ],
        ),
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
}

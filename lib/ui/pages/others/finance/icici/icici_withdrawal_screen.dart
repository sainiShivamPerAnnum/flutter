import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/dialogs/icici_redemption_otp_dialog.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ICICIWithdrawal extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<Map<String, double>> onAmountConfirmed;
  final ValueChanged<bool> onOptionConfirmed;
  final ValueChanged<Map<String, String>> onOtpConfirmed;

  ICICIWithdrawal(
      {Key key,
      this.currentBalance,
      this.onAmountConfirmed,
      this.onOptionConfirmed,
      this.onOtpConfirmed})
      : super(key: key);

  @override
  ICICIWithdrawalState createState() => ICICIWithdrawalState();
}

class ICICIWithdrawalState extends State<ICICIWithdrawal> {
  TextEditingController _amountController = TextEditingController();
  String _amountError;
  String _errorMessage;
  bool _isLoading = true;
  BaseUtil baseProvider;
  bool _isBalanceAvailble = false;
  bool _isButtonEnabled = false;
  double _instantBalance = 0;
  double _currentTotalBalance = 0;
  double _userWithdrawInstantAmount = 0;
  double _userWithdrawNonInstantAmount = 0;
  final TextStyle tTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final TextStyle gTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  PaymentService payService;
  GlobalKey<IciciRedemptionOtpDialogState> _withdrawalDialogKey3 = GlobalKey();

  getDetails() {
    payService.getWithdrawalDetails().then((withdrawalDetailsMap) {
      _isBalanceAvailble = true;
      //refresh dialog state once balance received
      if (!withdrawalDetailsMap['flag']) {
        onDetailsReceived(0, 0, false, withdrawalDetailsMap['reason']);
      } else {
        onDetailsReceived(
            withdrawalDetailsMap['instant_balance'],
            withdrawalDetailsMap['total_balance'],
            withdrawalDetailsMap['is_imps_allowed'],
            withdrawalDetailsMap['reason']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentTotalBalance = widget.currentBalance;
  }

  _updateAmount() {
    double amount = double.tryParse(_amountController.text ?? 0);
    setState(() {
      if (amount == 0 || amount == null) {
        _userWithdrawInstantAmount = 0;
        _userWithdrawNonInstantAmount = 0;
      } else if (amount <= _currentTotalBalance * 0.9) {
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
    payService = Provider.of<PaymentService>(context, listen: false);
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    if (!_isBalanceAvailble) getDetails();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Withdrawal",
          style: TextStyle(
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
                        style: TextStyle(
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
                          "₹ ${_currentTotalBalance.toStringAsFixed(2)}",
                          style: TextStyle(
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
                                onChanged: (_) => _updateAmount(),
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
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.largeTextSize,
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        "₹ ${_userWithdrawInstantAmount.toStringAsFixed(2)}",
                                        style: TextStyle(
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
                                      child: SvgPicture.asset(
                                        "images/svgs/stopwatch.svg",
                                      ),
                                    ),
                                    Text(
                                      "By $formatted *",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.largeTextSize,
                                      ),
                                    ),
                                    Text(
                                      "Presently unavailable",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w300,
                                        fontSize: SizeConfig.mediumTextSize,
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        "₹ ${_userWithdrawNonInstantAmount.toStringAsFixed(2)}",
                                        style: TextStyle(
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
                      FAQCardView(
                        category: 'icici',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _errorMessage != null
                ? Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                : Container(),
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
                          Haptic.vibrate();
                          _onWithdrawalClicked();
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

  Future<void> _onWithdrawalClicked() async {
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
      String _confirmMsg = "Are you sure you want to continue? ";
      if (_userWithdrawNonInstantAmount == 0) {
        _confirmMsg = _confirmMsg +
            '₹${_userWithdrawInstantAmount.round()} will be withdrawn immediately.';
      } else {
        _confirmMsg = _confirmMsg +
            '₹${_userWithdrawInstantAmount.floor()} will be withdrawn immediately, and ₹${_userWithdrawNonInstantAmount.ceil()} will be withdrawn within 1 business day';
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
            double instantAmount = _userWithdrawInstantAmount ?? 0;
            double nonInstantAmount = _userWithdrawNonInstantAmount ?? 0;
            if (instantAmount == 0 && nonInstantAmount == 0) return false;

            ///preprocess to get bank details and exit load flag status
            payService
                .preProcessWithdrawal(instantAmount.toString())
                .then((combDetailsMap) {
              if (combDetailsMap['flag']) {
                var _withdrawalRequestDetails = combDetailsMap;

                ///everything looks good, now move to main withdrawal apis
                _onInitiateWithdrawal(
                    _withdrawalRequestDetails, instantAmount, nonInstantAmount);
                //TODO GET EXIT LOAD check if dialog required
                // if (combDetailsMap[GetExitLoad.resPopUpFlag] ==
                //     GetExitLoad.SHOW_POPUP) {
                //   showDialog(
                //       context: context,
                //       builder: (ctx) => AlertDialog(
                //             title: Text(combDetailsMap['flag']),
                //             actions: [
                //               TextButton(
                //                 onPressed: () => Navigator.pop(context),
                //                 child: Text("OK"),
                //               )
                //             ],
                //           ));
                // } else {
                //
                // }
              } else {
                Navigator.of(context).pop();
                BaseUtil.showNegativeAlert(
                    'Withdrawal Failed', 'Error: ${combDetailsMap['reason']}');
              }
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
  }

  String _validateAmount(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid amount';
    }
    try {
      double amount = double.parse(value);
      if (amount > baseProvider.userFundWallet.iciciBalance)
        return 'Insufficient balance';
      if (amount < 1)
        return 'Please enter value more than ₹1';
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
      _currentTotalBalance = totalBalance;
      _isBalanceAvailble = true;
    }
    setState(() {});
  }

  _onInitiateWithdrawal(Map<String, dynamic> fieldMap, double instantWithdraw,
      double nonInstantWithdraw) {
    payService
        .processWithdrawal(fieldMap, instantWithdraw, nonInstantWithdraw)
        .then((wMap) {
      if (wMap['instant_flag'] == null || !wMap['instant_flag']) {
        Navigator.of(context).pop();
        BaseUtil.showNegativeAlert('Transaction failed',
            wMap['instant_fail_reason'] ?? 'Please try again.');
      }
      if (wMap['non_instant_flag'] != null) {
        ///check if the non instant transaction worked correctly
        if (!wMap['non_instant_flag']) {
          Navigator.of(context).pop();
          BaseUtil.showNegativeAlert('Transaction failed',
              wMap['non_instant_fail_reason'] ?? 'Please try again.');
        } else {
          ///show the otp entering dialog. the transaction is already stored as a global variable
          onShowOtpDialog();
        }
      }
    });
  }

  onShowOtpDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => IciciRedemptionOtpDialog(
              key: _withdrawalDialogKey3,
              otpEntered: (otp) {
                payService.verifyWithdrawalOtp(otp).then((flag) {
                  _withdrawalDialogKey3.currentState.onOtpVerifyComplete(flag);
                });
              },
            ));
  }
}

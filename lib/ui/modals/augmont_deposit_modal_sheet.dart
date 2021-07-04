import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/AugGoldRates.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/dialogs/success-dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class AugmontDepositModalSheet extends StatefulWidget {
  final ValueChanged<double> onDepositConfirmed;
  final AugmontRates currentRates;

  AugmontDepositModalSheet(
      {Key key, this.onDepositConfirmed, this.currentRates})
      : super(key: key);

  AugmontDepositModalSheetState createState() =>
      AugmontDepositModalSheetState();
}

class AugmontDepositModalSheetState extends State<AugmontDepositModalSheet>
    with SingleTickerProviderStateMixin {
  AugmontDepositModalSheetState();

  Log log = new Log('AugmontDepositModalSheet');
  var heightOfModalBottomSheet = 100.0;
  bool _isDepositsEnabled = true;
  BaseUtil baseProvider;
  final _amtController = new TextEditingController();
  final depositformKey3 = GlobalKey<FormState>();
  bool _isInitialized = false;
  bool _isDepositInProgress = false;
  String _errorMessage;
  double _width;
  AugmontModel augmontProvider;

  _initFields() {
    if (baseProvider != null) {
      String _isEnabledStr = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.AUGMONT_DEPOSITS_ENABLED);
      try {
        int t = (_isEnabledStr != null) ? int.parse(_isEnabledStr) : 1;
        _isDepositsEnabled = (t == 1);
      } catch (e) {
        _isDepositsEnabled = true;
      }
      _isInitialized = true;
    }
  }

  onErrorReceived(String msg) {
    _isDepositInProgress = false;
    _errorMessage = msg;
    setState(() {});
  }

  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    _width = MediaQuery.of(context).size.width;
    if (!_isInitialized) _initFields();
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      margin: EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: new Wrap(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
            child: _depositDialog(),
          ),
        ],
      ),
    );
  }

  Widget _depositDialog() {
    return Container(
      child: Form(
        key: depositformKey3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "images/svgs/gold.svg",
                    height: SizeConfig.largeTextSize,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Gold Deposit",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      fontSize: SizeConfig.largeTextSize,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            Divider(
              endIndent: SizeConfig.screenWidth * 0.3,
            ),
            _buildRateCard(),
            InputField(
              child: TextFormField(
                autofocus: false,
                controller: _amtController,
                keyboardType: TextInputType.number,
                decoration: inputFieldDecoration("Enter an amount"),
                validator: (value) {
                  Pattern pattern = "^[0-9]*\$";
                  RegExp amRegex = RegExp(pattern);
                  if (value.isEmpty)
                    return 'Please enter an amount';
                  else if (!amRegex.hasMatch(value))
                    return 'Please enter a valid amount';

                  int amount = int.parse(value);
                  if (amount < 10)
                    return 'Minimum deposit amount is ₹10 per transaction';
                  else if (amount > 20000)
                    return 'Max deposit of ₹20000 allowed per transaction';
                  else
                    return null;
                },
                onChanged: (String val) {
                  setState(() {});
                },
              ),
            ),
            _buildPurchaseDescriptionCard(_getDouble(_amtController.text)),
            Wrap(
              spacing: 20,
              children: [
                ActionChip(
                  label: Text("How does this work?"),
                  backgroundColor: UiConstants.chipColor,
                  onPressed: () {
                    HapticFeedback.vibrate();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => MoreInfoDialog(
                              text: Assets.infoAugmontTxnHow,
                              title: 'How does the transaction work?',
                            ));
                  },
                ),
                ActionChip(
                  label: Text("How long does it take?"),
                  backgroundColor: UiConstants.chipColor,
                  onPressed: () {
                    HapticFeedback.vibrate();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => MoreInfoDialog(
                              text: Assets.infoAugmontTime,
                              title: 'How long does it take?',
                            ));
                  },
                ),
              ],
            ),
            (_errorMessage != null)
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
              height: 20,
            ),
            (_isDepositsEnabled && !_isDepositInProgress)
                ? Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: SliderButton(
                      action: () {
                        //widget.onDepositConfirmed();
                        if (depositformKey3.currentState.validate()) {
                          _isDepositInProgress = true;
                          setState(() {});
                          widget.onDepositConfirmed(
                              _getTaxIncludedAmount(_amtController.text));
                        }
                      },
                      alignLabel: Alignment.center,
                      label: Text(
                        'Slide to confirm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff4a4a4a),
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                      buttonSize: 50,
                      height: 50,
                      radius: 16,
                      width: double.infinity,
                      dismissible: false,
                      dismissThresholds: 0.8,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: UiConstants.primaryColor,
                      ),
                    ),
                  )
                : Container(),
            (_isDepositInProgress)
                ? Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: SpinKitRing(
                      color: UiConstants.primaryColor,
                      size: 38.0,
                    ),
                  )
                : Container(),
            (!_isDepositsEnabled)
                ? Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                      width: _width,
                      child: Text(
                          'We are currently not accepting deposits for ' +
                              'Augmont Digital Gold',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: UiConstants.accentColor)),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  double _getTaxIncludedAmount(String amt) {
    if (amt == null || amt.isEmpty) return null;
    double t = 0;
    try {
      t = double.parse(amt);
      double netTax =
          widget.currentRates.sgstPercent + widget.currentRates.cgstPercent;
      return t + augmontProvider.getTaxOnAmount(t, netTax);
    } catch (e) {
      return null;
    }
  }

  double _getDouble(String amt) {
    if (amt == null || amt.isEmpty) return null;
    double t = 0;
    try {
      t = double.parse(amt);
      return t;
    } catch (e) {
      return null;
    }
  }

  Widget _buildRateCard() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRateRow(
              'Rate per gram:',
              '₹${widget.currentRates.goldBuyPrice.toStringAsFixed(2)}',
              'This is the current price of 1 gram of gold'),
          _buildRateRow(
              'CGST:',
              '${widget.currentRates.cgstPercent.toString()}%',
              'This is the Goods and Services Tax(GST) charged by the central government'),
          _buildRateRow(
              'SGST:',
              '${widget.currentRates.sgstPercent.toString()}%',
              'This is the Goods and Services Tax(GST) charged by the state government'),
        ],
      ),
    );
  }

  Widget _buildRateRow(String title, String value, String info) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: SizeConfig.mediumTextSize*1.2),
            ),
          ),
          Expanded(
              child: Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: SizeConfig.mediumTextSize*1.2),
              ),
              SizedBox(
                width: 4,
              ),
              InkWell(
                child: Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: SizeConfig.mediumTextSize*1.4,
                ),
                onTap: () {
                  HapticFeedback.vibrate();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => MoreInfoDialog(
                            title: title,
                            text: info,
                          ));
                },
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildPurchaseDescriptionCard(double amt) {
    double netTax =
        widget.currentRates.sgstPercent + widget.currentRates.cgstPercent;
    double rate = widget.currentRates.goldBuyPrice;

    if (amt == null || amt < 5) {
      return Container();
    }
    double taxIncluded = amt + augmontProvider.getTaxOnAmount(amt, netTax);
    // double taxDeducted = augmontProvider.getAmountPostTax(amt, netTax);
    double grams = augmontProvider.getGoldQuantityFromTaxedAmount(amt, rate);

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '+ GST = ₹${taxIncluded.toStringAsFixed(2)}',
            style: TextStyle(fontSize: SizeConfig.mediumTextSize * 1.2),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            'Gold amount: ${grams.toStringAsFixed(4)} grams',
            style: TextStyle(fontSize: SizeConfig.mediumTextSize * 1.2),
          )
        ],
      ),
    );
  }

  onDepositComplete(bool flag) {
    _isDepositInProgress = false;
    setState(() {});
    Navigator.of(context).pop();
    if (flag) {
      // baseProvider.showPositiveAlert(
      //     'SUCCESS', 'You gold deposit was confirmed!', context);
      HapticFeedback.vibrate();
      showDialog(
        context: context,
        builder: (BuildContext context) => SuccessDialog(),
      );
    } else
      baseProvider.showNegativeAlert(
          'Failed',
          'Your gold deposit failed. Please try again or contact us if you are facing issues',
          context,
          seconds: 5);
  }
}

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class DepositModalSheet extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onDepositConfirmed;

  DepositModalSheet({Key key, this.onDepositConfirmed}) : super(key: key);

  DepositModalSheetState createState() => DepositModalSheetState();
}

class DepositModalSheetState extends State<DepositModalSheet>
    with SingleTickerProviderStateMixin {
  DepositModalSheetState();

  Log log = new Log('DepositModalSheet');
  var heightOfModalBottomSheet = 100.0;
  bool _isDepositRequested = false;
  bool _isFirstInvestment = true;
  bool _isPendingTransaction = false;
  bool _isDepositsEnabled = true;
  BaseUtil baseProvider;
  final _amtController = new TextEditingController();
  final _vpaController = new TextEditingController();
  final depositformKey2 = GlobalKey<FormState>();
  bool _isInitialized = false;
  bool _isDepositInProgress = false;
  String _errorMessage;
  double _width;

  _initFields() {
    if (baseProvider != null) {
      if (baseProvider.iciciDetail.vpa != null &&
          baseProvider.iciciDetail.vpa.isNotEmpty)
        _vpaController.text = baseProvider.iciciDetail.vpa;
      _isFirstInvestment = (!baseProvider.iciciDetail.firstInvMade) ?? true;
      _isPendingTransaction = (baseProvider.myUser.pendingTxnId != null);
      String isEnabledStr = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.ICICI_DEPOSITS_ENABLED);
      try {
        int t = (isEnabledStr != null) ? int.parse(isEnabledStr) : 1;
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
    _width = MediaQuery.of(context).size.width;
    if (!_isInitialized) _initFields();
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
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
        key: depositformKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  if (_isFirstInvestment && amount < 100)
                    return 'Your first investment has to be atleast ₹100';
                  else if (!_isFirstInvestment && amount < 1)
                    return 'Please enter a valid amount';
                  else if (amount > 2000)
                    return 'We are currently only accepting a max deposit of ₹2000 per transaction';
                  else
                    return null;
                },
              ),
            ),
            InputField(
              child: TextFormField(
                autofocus: false,
                controller: _vpaController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputFieldDecoration("Enter your UPI Id"),
                validator: (value) {
                  RegExp upiRegex =
                      RegExp('[-a-zA-Z0-9._]{2,256}@[a-zA-Z]{2,64}');
                  if (value == null || value.isEmpty)
                    return 'Please enter your UPI ID';
                  else if (!upiRegex.hasMatch(value))
                    return 'Please enter a valid UPI ID';
                  else
                    return null;
                },
              ),
            ),
            Wrap(
              spacing: 20,
              children: [
                ActionChip(
                  label: Text("What is my UPI ID?"),
                  backgroundColor: UiConstants.chipColor,
                  onPressed: () {
                    Haptic.vibrate();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => MoreInfoDialog(
                              text: Assets.infoWhatUPI,
                              title: 'Why is my UPI ID?',
                            ));
                  },
                ),
                ActionChip(
                  label: Text("Where do I find it?"),
                  backgroundColor: UiConstants.chipColor,
                  onPressed: () {
                    Haptic.vibrate();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => MoreInfoDialog(
                              text: Assets.infoWhereUPI,
                              title: 'Where can i find my UPI Id?',
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
            (_isDepositsEnabled &&
                    !_isDepositInProgress &&
                    !_isPendingTransaction)
                ? Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: SliderButton(
                      action: () {
                        //widget.onDepositConfirmed();
                        if (depositformKey2.currentState.validate()) {
                          _isDepositInProgress = true;
                          setState(() {});
                          widget.onDepositConfirmed({
                            'amount': _amtController.text,
                            'vpa': _vpaController.text
                          });
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
            (_isPendingTransaction)
                ? Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                      width: _width,
                      child: Text(
                          'A previous deposit is currently pending.\n Please ' +
                              'wait until it has been successfully processed.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: UiConstants.accentColor)),
                    ))
                : Container(),
            (!_isDepositsEnabled)
                ? Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                      width: _width,
                      child: Text(
                          'We are currently not accepting deposits for ' +
                              'the ICICI Prudential Liquid Fund - Growth',
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
}

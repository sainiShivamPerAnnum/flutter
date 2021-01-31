import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/elements/more_info_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class DepositModalSheet extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onDepositConfirmed;
  final depositForm;
  DepositModalSheet({this.depositForm, this.onDepositConfirmed});

  _DepositModalSheetState createState() => _DepositModalSheetState();
}

class _DepositModalSheetState extends State<DepositModalSheet> with SingleTickerProviderStateMixin {
  _DepositModalSheetState();

  Log log = new Log('DepositModalSheet');
  var heightOfModalBottomSheet = 100.0;
  bool _isDepositRequested = false;
  bool _isFirstInvestment = true;
  BaseUtil baseProvider;
  final _amtController = new TextEditingController();
  final _vpaController = new TextEditingController();
  final depositformKey2 = GlobalKey<FormState>();
  bool _isInitialized = false;

  _initFields() {
    if(baseProvider != null) {
      if(baseProvider.iciciDetail.vpa != null && baseProvider.iciciDetail.vpa.isNotEmpty)
        _vpaController.text = baseProvider.iciciDetail.vpa;
      _isFirstInvestment = baseProvider.iciciDetail.firstInvMade??true;
      _isInitialized = true;
    }
  }

  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    if(!_isInitialized)_initFields();
    return Container(
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
            child: _costConfirmDialog(),
          ),
        ],
      ),
    );
  }

  Widget _costConfirmDialog() {
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
                decoration: inputFieldDecoration(
                    "Enter an amount"
                ),
                validator: (value) {
                  RegExp amRegex = RegExp(r"[0-9]");
                  if(value.isEmpty) return 'Please enter an amount';
                  else if(!amRegex.hasMatch(value))return 'Please enter a valid amount';

                  int amount = int.parse(value);
                  if(_isFirstInvestment && amount<100) return 'Your first investment has to be atleast ₹100';
                  else if(amount > 2000) return 'We are currently only accepting a max deposit of ₹2000 per transaction';
                  else return null;
                },
              ),
            ),
            InputField(
              child: TextFormField(
                autofocus: false,
                controller: _vpaController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputFieldDecoration(
                    "Enter your UPI id"
                ),
                validator: (value) {
                  RegExp upiRegex = RegExp('[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}');
                  if(value == null || value.isEmpty)return 'Please enter your UPI ID';
                  else if(!upiRegex.hasMatch(value))return 'Please enter a valid UPI ID';
                  else return null;
                },
              ),
            ),
            Wrap(
              spacing: 20,
              children: [
                ActionChip(
                  label: Text("What is my UPI?"),
                  backgroundColor: UiConstants.chipColor,
                  onPressed: () {
                    HapticFeedback.vibrate();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => MoreInfoDialog(
                          text: Assets.infoWhyPan,
                          title: 'Why is my UPI?',
                        ));
                  },
                ),
                ActionChip(
                  label: Text("Where do I find it?"),
                  backgroundColor: UiConstants.chipColor,
                  onPressed: () {
                    HapticFeedback.vibrate();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => MoreInfoDialog(
                          text: Assets.infoWherePan,
                          title: 'Where can i find UPI Id?',
                          imagePath: Assets.dummyPanCard,
                        ));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: SliderButton(
                action: () {
                  //widget.onDepositConfirmed();
                  if(depositformKey2.currentState.validate()) {
                    widget.onDepositConfirmed({});
                  }
                },
                alignLabel: Alignment.center,
                label: Text('Slide to confirm',
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
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/augmont_state_list.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AugmontOnboarding extends StatefulWidget {
  final Function onSubmit;

  AugmontOnboarding({Key key, this.onSubmit}) : super(key: key);

  @override
  State createState() => AugmontOnboardingState();
}

class AugmontOnboardingState extends State<AugmontOnboarding> {
  final Log log = new Log('AugmontOnboarding');
  BaseUtil baseProvider;
  double _width;
  static TextEditingController _panInput = new TextEditingController();
  static TextEditingController _bankHolderNameInput =
      new TextEditingController();
  static TextEditingController _bankAccountNumberInput =
      new TextEditingController();
  static TextEditingController _bankIfscInput = new TextEditingController();
  bool _isInit = false;
  static String stateChosenValue;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    if (!_isInit) {
      _panInput.text = baseProvider.myUser.pan ?? '';
      _isInit = true;
    }
    return Scaffold(
      appBar: BaseUtil.getAppBar(),
      body: SafeArea(child: _bodyContent(context)),
    );
  }

  _bodyContent(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: <Widget>[
      Opacity(
        child: _formContent(context),
        opacity: (baseProvider.isAugmontRegnInProgress ||
                baseProvider.isAugmontRegnCompleteAnimateInProgress)
            ? 0.3
            : 1,
      ),
      (baseProvider.isAugmontRegnCompleteAnimateInProgress)
          ? Align(
              alignment: Alignment.center,
              child: Container(
                height: 100,
                width: 100,
                child: Lottie.asset(Assets.checkmarkLottie),
              ),
            )
          : Container(),
      (baseProvider.isAugmontRegnInProgress)
          ? Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 4,
                          width: double.infinity,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.blueGrey[200],
                            valueColor: AlwaysStoppedAnimation(
                                UiConstants.primaryColor),
                            minHeight: 4,
                          )),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            'Processing',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: UiConstants.accentColor, fontSize: 20),
                          ))
                    ],
                  )),
            )
          : Container()
    ]);
  }

  Widget _formContent(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 40, left: 35, right: 35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: SizedBox(
                child: Image(
                  image: AssetImage(Assets.onboardingSlide[2]),
                  fit: BoxFit.contain,
                ),
                width: 180,
                height: 150,
              )),
              Center(
                  child: Text(
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: UiConstants.primaryColor),
              )),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Mobile No"),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  top: 5,
                ),
                padding:
                    EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 11, top: 11, right: 15),
                  child: Text(
                    baseProvider.myUser.mobile,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("PAN Card Number"),
              ),
              InputField(
                child: TextFormField(
                  decoration: inputFieldDecoration('PAN Number'),
                  controller: _panInput,
                  textCapitalization: TextCapitalization.characters,
                  enabled: true,
                  validator: (value) {
                    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
                    if (value.isEmpty) {
                      return 'PAN field cannot be empty';
                    } else if (panCheck.hasMatch(value)) {
                      return null;
                    } else {
                      return "invalid PAN Number";
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Residential State"),
              ),
              InputField(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  iconEnabledColor: UiConstants.primaryColor,
                  hint: Text("Which state do you live in?"),
                  value: stateChosenValue,
                  onChanged: (String newVal) {
                    setState(() {
                      stateChosenValue = newVal;
                      print(newVal);
                    });
                  },
                  items: AugmontResources.augmontStateList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e["id"],
                          child: Text(
                            e["name"],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  "Bank Details",
                  style: TextStyle(color: Colors.blueGrey[600]),
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text("Account Holder Name"),
              ),
              InputField(
                child: TextFormField(
                  decoration:
                      inputFieldDecoration('Your name as per your bank'),
                  controller: _bankHolderNameInput,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.characters,
                  enabled: true,
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Bank Account Number"),
              ),
              InputField(
                child: TextFormField(
                  decoration: inputFieldDecoration('Your bank account number'),
                  controller: _bankAccountNumberInput,
                  keyboardType: TextInputType.number,
                  enabled: true,
                  validator: (value) => null,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Bank IFSC"),
              ),
              InputField(
                child: TextFormField(
                  decoration: inputFieldDecoration('Your bank\'s IFSC code'),
                  controller: _bankIfscInput,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.characters,
                  enabled: true,
                  validator: (value) => null,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 50.0,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(colors: [
                    UiConstants.primaryColor,
                    UiConstants.primaryColor.withBlue(200),
                  ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Material(
                  child: MaterialButton(
                    child: (!baseProvider.isAugmontRegnInProgress &&
                            !baseProvider
                                .isAugmontRegnCompleteAnimateInProgress)
                        ? Text(
                            'REGISTER',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white),
                          )
                        : SpinKitThreeBounce(
                            color: UiConstants.spinnerColor2,
                            size: 18.0,
                          ),
                    onPressed: () {
                      RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
                      if (_panInput.text.isEmpty) {
                        baseProvider.showNegativeAlert('Invalid Pan',
                            'Kindly enter a valid PAN Number', context);
                        return;
                      } else if (!panCheck.hasMatch(_panInput.text)) {
                        baseProvider.showNegativeAlert('Invalid Pan',
                            'Kindly enter a valid PAN Number', context);
                        return;
                      } else if (stateChosenValue == null ||
                          stateChosenValue.isEmpty) {
                        baseProvider.showNegativeAlert(
                            'State missing',
                            'Kindly enter your current residential state',
                            context);
                        return;
                      } else if (_bankHolderNameInput.text.isEmpty) {
                        baseProvider.showNegativeAlert(
                            'Name missing',
                            'Kindly enter your name as per your your bank',
                            context);
                        return;
                      } else if (_bankAccountNumberInput.text.isEmpty) {
                        baseProvider.showNegativeAlert('Account missing',
                            'Kindly enter your bank account number', context);
                        return;
                      } else if (_bankIfscInput.text.isEmpty) {
                        baseProvider.showNegativeAlert('Name missing',
                            'Kindly enter your bank IFSC code', context);
                        return;
                      }
                      widget.onSubmit({
                        'pan_number': _panInput.text,
                        'state_id': stateChosenValue,
                        'bank_holder_name': _bankHolderNameInput.text,
                        'bank_acc_no': _bankAccountNumberInput.text,
                        'bank_ifsc': _bankIfscInput.text
                      });
                      baseProvider.isAugmontRegnInProgress = true;
                      setState(() {});
                    },
                    highlightColor: Colors.white30,
                    splashColor: Colors.white30,
                  ),
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              )
            ],
          )),
    );
  }

  regnComplete(Map<String, dynamic> response) {
    baseProvider.isAugmontRegnInProgress = false;
    if (response['flag']) {
      baseProvider.isAugmontRegnCompleteAnimateInProgress = true;
      setState(() {});
      new Timer(const Duration(milliseconds: 1000), () {
        baseProvider.isAugmontRegnCompleteAnimateInProgress = false;
        setState(() {});
        Navigator.of(context).pop();
        baseProvider.showPositiveAlert(
            'Registration Successful', 'You can now make a deposit!', context);
      });
    } else {
      setState(() {});
      baseProvider.showNegativeAlert(
          'Registration Failed', response['reason'], context);
    }
  }
}

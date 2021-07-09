import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserAugmontDetail.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
import 'package:felloapp/ui/dialogs/augmont_regn_security_dialog.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/augmont_state_list.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fundPalettes.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AugmontOnboarding extends StatefulWidget {
  AugmontOnboarding({Key key}) : super(key: key);

  @override
  State createState() => AugmontOnboardingState();
}

class AugmontOnboardingState extends State<AugmontOnboarding> {
  final Log log = new Log('AugmontOnboarding');
  BaseUtil baseProvider;
  AugmontModel augmontProvider;
  ICICIModel iProvider;
  DBModel dbProvider;
  AppState appState;
  double _width;

  static TextEditingController _panInput = new TextEditingController();
  static TextEditingController _panHolderNameInput =
      new TextEditingController();

  // static TextEditingController _bankHolderNameInput =
  //     new TextEditingController();
  // static TextEditingController _bankAccountNumberInput =
  //     new TextEditingController();
  // static TextEditingController _reenterbankAccountNumberInput =
  //     new TextEditingController();
  // static TextEditingController _bankIfscInput = new TextEditingController();
  bool _isInit = false;
  static String stateChosenValue;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    iProvider = Provider.of<ICICIModel>(context, listen: false);
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    if (!_isInit) {
      _panInput.text = baseProvider.myUser.pan ?? '';
      _isInit = true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Image(
          image: AssetImage('images/aug-logo.png'),
          height: SizeConfig.blockSizeVertical * 3,
          fit: BoxFit.contain,
        ),
        shadowColor: augmontGoldPalette.primaryColor.withOpacity(0.5),
        centerTitle: true,
      ),
      body: _bodyContent(context),
    );
  }

  _bodyContent(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
          textTheme: GoogleFonts.montserratTextTheme(),
          colorScheme:
              ColorScheme.light(primary: augmontGoldPalette.primaryColor)),
      child: Stack(alignment: Alignment.topCenter, children: <Widget>[
        Opacity(
          child: _formContent(context),
          opacity: (baseProvider.isAugmontRegnInProgress ||
                  baseProvider.isAugmontRegnCompleteAnimateInProgress)
              ? 0.3
              : 1,
        ),
        // Row(
        //   children: [
        //     IconButton(
        //       onPressed: () => backButtonDispatcher.didPopRoute(),
        //       icon: Icon(Icons.arrow_back_rounded),
        //     ),
        //   ],
        // ),
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
                                  augmontGoldPalette.primaryColor),
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
      ]),
    );
  }

  Widget _formContent(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Digital Gold Registration',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: augmontGoldPalette.primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: Text("Mobile No"),
              // ),
              // Container(
              //   padding:
              //       EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 15),
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.only(bottom: 14, top: 14, right: 15),
              //     child: Text(
              //       baseProvider.myUser.mobile,
              //       style: TextStyle(
              //         color: Colors.black54,
              //       ),
              //     ),
              //   ),
              // ),
              TextFormField(
                decoration:
                    augmontFieldInputDecoration(baseProvider.myUser.mobile),
                enabled: false,
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: Text("PAN Card Number"),
              // ),
              SizedBox(height: 16),
              TextFormField(
                cursorColor: augmontGoldPalette.primaryColor,
                decoration: augmontFieldInputDecoration("PAN Card Number"),
                controller: _panInput,
                autofocus: false,
                textCapitalization: TextCapitalization.characters,
                enabled: true,
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 10, left: 10),
              //   child: Text("Name on PAN Card"),
              // ),
              SizedBox(height: 16),

              TextFormField(
                decoration: augmontFieldInputDecoration(
                    'Your name as per your PAN Card'),
                controller: _panHolderNameInput,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.characters,
                enabled: true,
                autofocus: false,
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: Text("Residential State"),
              // ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: augmontGoldPalette.primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                  iconEnabledColor: augmontGoldPalette.primaryColor,
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
              // Padding(
              //   padding: EdgeInsets.only(top: 10, left: 10),
              //   child: Text(
              //     "Bank Details",
              //     style: TextStyle(color: Colors.blueGrey[600]),
              //   ),
              // ),
              // Divider(
              //   indent: 10,
              //   endIndent: 10,
              // ),
              // Padding(
              //   padding: EdgeInsets.only(top: 10, left: 10),
              //   child: Text("Account Holder Name"),
              // ),
              // InputField(
              //   child: TextFormField(
              //     decoration:
              //         inputFieldDecoration('Your name as per your bank'),
              //     controller: _bankHolderNameInput,
              //     keyboardType: TextInputType.name,
              //     textCapitalization: TextCapitalization.characters,
              //     enabled: true,
              //     autofocus: false,
              //     validator: (value) {
              //       return null;
              //     },
              //   ),
              // ),
              // SizedBox(height: 10),
              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: Text("Bank Account Number"),
              // ),
              // InputField(
              //   child: TextFormField(
              //     decoration: inputFieldDecoration('Your bank account number'),
              //     controller: _bankAccountNumberInput,
              //     autofocus: false,
              //     keyboardType: TextInputType.number,
              //     enabled: true,
              //     validator: (value) => null,
              //   ),
              // ),
              // SizedBox(height: 10),
              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: Text("Confirm Bank Account Number"),
              // ),
              // InputField(
              //   child: TextFormField(
              //     decoration:
              //         inputFieldDecoration('Re-enter bank account number'),
              //     controller: _reenterbankAccountNumberInput,
              //     autofocus: false,
              //     obscureText: true,
              //     keyboardType: TextInputType.number,
              //     enabled: true,
              //     validator: (value) => null,
              //   ),
              // ),
              // SizedBox(height: 10),
              // Padding(
              //   padding: EdgeInsets.only(left: 10),
              //   child: Text("Bank IFSC"),
              // ),
              // InputField(
              //   child: TextFormField(
              //     decoration: inputFieldDecoration('Your bank\'s IFSC code'),
              //     controller: _bankIfscInput,
              //     autofocus: false,
              //     keyboardType: TextInputType.streetAddress,
              //     textCapitalization: TextCapitalization.characters,
              //     enabled: true,
              //     validator: (value) => null,
              //   ),
              // ),
              SizedBox(height: 24),
              Container(
                width: SizeConfig.screenWidth,
                height: 50.0,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(colors: [
                    augmontGoldPalette.primaryColor,
                    augmontGoldPalette.primaryColor2
                    // UiConstants.primaryColor,
                    // UiConstants.primaryColor.withBlue(200),
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
                    onPressed: () async {
                      ///check if all fields are valid
                      if (_preVerifyInputs()) {
                        baseProvider.isAugmontRegnInProgress = true;
                        setState(() {});

                        ///next get all details required for registration
                        Map<String, dynamic> veriDetails =
                            await _getVerifiedDetails(
                                _panInput.text, _panHolderNameInput.text);
                        //  _bankIfscInput.text);

                        if (veriDetails != null &&
                            veriDetails['flag'] != null &&
                            veriDetails['flag']) {
                          AppState.screenStack.add(ScreenItem.dialog);

                          ///show confirmation dialog to user
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) =>
                                AugmontConfirmRegnDialog(
                              panNumber: _panInput.text,
                              panName: _panHolderNameInput.text,
                              bankHolderName: "",
                              bankBranchName: "",
                              bankAccNo: "",
                              bankIfsc: "",
                              bankName: "",
                              onAccept: () async {
                                ///finally now register the augmont user
                                UserAugmontDetail detail =
                                    await augmontProvider.createUser(
                                        baseProvider.myUser.mobile,
                                        _panInput.text,
                                        stateChosenValue,
                                        "",
                                        "",
                                        "");
                                if (detail == null) {
                                  baseProvider.showNegativeAlert(
                                      'Registration Failed',
                                      'Failed to regsiter at the moment. Please try again.',
                                      context);
                                  baseProvider.isAugmontRegnInProgress = false;
                                  setState(() {});
                                  return;
                                } else {
                                  ///show completion animation
                                  _regnComplete();
                                }
                              },
                              onReject: () {
                                baseProvider.showNegativeAlert(
                                    'Registration Cancelled',
                                    'Please try again',
                                    context);
                                baseProvider.isAugmontRegnInProgress = false;
                                setState(() {});
                                return;
                              },
                            ),
                          );
                        } else {
                          print('inside failed name');
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => MoreInfoDialog(
                                    text: veriDetails['reason'],
                                    imagePath: Assets.dummyPanCardShowNumber,
                                    title: 'Invalid Details',
                                  ));
                          baseProvider.showNegativeAlert(
                              'Invalid Details',
                              veriDetails['reason'] ?? 'Please try again',
                              context);
                          baseProvider.isAugmontRegnInProgress = false;
                          setState(() {});
                          return;
                        }
                      } else
                        return;
                    },
                    highlightColor: Colors.white30,
                    splashColor: Colors.white30,
                  ),
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.vibrate();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AugmontRegnSecurityDialog(
                            text: Assets.infoAugmontRegnSecurity,
                            imagePath: 'images/aes256.png',
                            title: 'Security > Rest',
                          ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        'Note on Security 🔒',
                        style: TextStyle(
                            fontSize: SizeConfig.smallTextSize * 1.3,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  HapticFeedback.vibrate();
                  const url = "https://www.augmont.com/about-us";
                  if (await canLaunch(url))
                    await launch(url);
                  else
                    baseProvider.showNegativeAlert('Failed to launch URL',
                        'Please try again in sometime', context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        'More about Augmont 💰',
                        style: TextStyle(
                            fontSize: SizeConfig.smallTextSize * 1.3,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  bool _preVerifyInputs() {
    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
    if (_panInput.text.isEmpty) {
      baseProvider.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number', context);
      return false;
    } else if (!panCheck.hasMatch(_panInput.text) ||
        _panInput.text.length != 10) {
      baseProvider.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number', context);
      return false;
    } else if (_panHolderNameInput.text.isEmpty) {
      baseProvider.showNegativeAlert('Name missing',
          'Kindly enter your name as per your pan card', context);
      return false;
    } else if (stateChosenValue == null || stateChosenValue.isEmpty) {
      baseProvider.showNegativeAlert('State missing',
          'Kindly enter your current residential state', context);
      return false;
    }
    // else if (_bankHolderNameInput.text.isEmpty) {
    //   baseProvider.showNegativeAlert(
    //       'Name missing', 'Kindly enter your name as per your bank', context);
    //   return false;
    // } else if (_bankAccountNumberInput.text.isEmpty) {
    //   baseProvider.showNegativeAlert(
    //       'Account missing', 'Kindly enter your bank account number', context);
    //   return false;
    // } else if (_bankAccountNumberInput.text !=
    //     _reenterbankAccountNumberInput.text) {
    //   baseProvider.showNegativeAlert('Account number mismatch',
    //       'The bank account numbers did not match', context);
    //   return false;
    // } else if (_bankIfscInput.text.isEmpty) {
    //   baseProvider.showNegativeAlert(
    //       'Name missing', 'Kindly enter your bank IFSC code', context);
    //   return false;
    // }
    return true;
  }

  Future<Map<String, dynamic>> _getVerifiedDetails(
      String enteredPan, String enteredPanName) async {
    if (enteredPan == null || enteredPan.isEmpty)
      return {'flag': false, 'reason': 'Invalid Details'};
    bool _flag = true;
    String _reason = '';
    if (!iProvider.isInit()) await iProvider.init();

    ///test pan number using icici api and verify if the name entered by user matches name fetched
    var kObj = await iProvider.getKycStatus(enteredPan);
    if (kObj == null ||
        kObj[QUERY_SUCCESS_FLAG] == QUERY_FAILED ||
        kObj[GetKycStatus.resStatus] == null ||
        kObj[GetKycStatus.resName] == null ||
        kObj[GetKycStatus.resName] == '') {
      log.error('Couldnt fetch an appropriate response');

      ///set name test to true as we couldnt find it in the cams database
      _flag = true;
    } else {
      ///remove all whitespaces before comparing as icici apis returns poorly spaced name values
      String recvdPanName = kObj[GetKycStatus.resName];
      String _r = recvdPanName.replaceAll(new RegExp(r"\s"), "");
      String _e = enteredPanName.replaceAll(new RegExp(r"\s"), "");
      if (_r.toUpperCase() != _e.toUpperCase()) {
        await dbProvider.logFailure(
            baseProvider.myUser.uid, FailType.UserAugmontRegnFailed, {
          'entered_pan_name': enteredPanName,
          'recvd_pan_name': recvdPanName,
          'pan_number': enteredPan
        });
        _flag = false;
        _reason =
            'The name on your PAN card does not match with the entered name. Please try again.';
      }
    }
    if (!_flag) {
      print('returning false flag');
      return {'flag': _flag, 'reason': _reason};
    }

    ///test ifsc code using icici api
    // var bankDetail = await iProvider.getBankInfo(aPan, aIfsc);
    // if (bankDetail == null ||
    //     bankDetail[QUERY_SUCCESS_FLAG] == QUERY_FAILED ||
    //     bankDetail[GetBankDetail.resBankName] == null) {
    //   log.error('Couldnt fetch an appropriate response');
    //   _flag = false;
    //   _reason = 'Invalid IFSC Code';
    // }
    // if (!_flag) {
    //   return {'flag': _flag, 'reason': _reason};
    // }

    return {
      'flag': true,
      'pan_name': kObj[GetKycStatus.resName],
      // 'bank_name': bankDetail[GetBankDetail.resBankName],
      // 'bank_branch': bankDetail[GetBankDetail.resBranchName]
    };
  }

  _regnComplete() {
    baseProvider.isAugmontRegnInProgress = false;
    baseProvider.isAugmontRegnCompleteAnimateInProgress = true;
    setState(() {});
    new Timer(const Duration(milliseconds: 1000), () {
      baseProvider.isAugmontRegnCompleteAnimateInProgress = false;
      setState(() {});
      backButtonDispatcher.didPopRoute();
      baseProvider.showPositiveAlert(
          'Registration Successful', 'You can now make a deposit!', context);
    });
  }
}

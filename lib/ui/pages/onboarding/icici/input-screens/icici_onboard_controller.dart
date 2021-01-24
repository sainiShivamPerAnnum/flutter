import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserIciciDetail.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/data_provider.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/error_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/submit_button.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/bank_details.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/income_details.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/kyc_invalid.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/pan_details.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/personal_details.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class IciciOnboardController extends StatefulWidget {
  IciciOnboardController({this.startIndex});
  final int startIndex;

  @override
  _IciciOnboardControllerState createState() => _IciciOnboardControllerState();
}

class _IciciOnboardControllerState extends State<IciciOnboardController> {
  final Log log = new Log('IciciOnboardController');
  _IciciOnboardControllerState([this._pageIndex = PANPage.index]);
  PageController _pageController;
  int _pageIndex;
  final personalDetailsformKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  double _height, _width;
  IDP ipProvider = new IDP();
  String controllerBtnText = 'VERIFY';
  BaseUtil baseProvider;
  DBModel dbProvider;
  ICICIModel iProvider;
  bool _isProcessing = false;
  bool _isProcessingComplete = false;


  @override
  void initState() {
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

// VIEWPAGER FUNCTIONS
  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 2000), curve: Curves.easeInOut);
  }

  checkPage() {
    if(_isProcessing || _isProcessingComplete)return;

    if (_pageIndex == PANPage.index) {
      verifyPan();
    } else if (_pageIndex == PersonalPage.index) {
      verifyPersonalDetails();
    } else if (_pageIndex == IncomeDetailsInputScreen.index) {
      verifyIncomeDetails();
    } else if (_pageIndex == BankDetailsInputScreen.index) {
      verifyBankDetails();
    }
  }

  verifyPan() {
    String panText = IDP.panInput.text;
    panText = panText.toUpperCase();
    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
    if (panText.isEmpty) {
      showErrorDialog("Oops!", "Field cannot be empty!", context);
    } else if (panCheck.hasMatch(panText) && panText.length == 10) {
      _isProcessing = true;
      setState(() {});
      onPanEntered(panText).then((kycStatus) {
        switch(kycStatus) {
          case GetKycStatus.KYC_STATUS_VALID: {
            _isProcessingComplete = true;
            _isProcessing = false;
            setState(() {});
            new Timer(const Duration(milliseconds: 1000), () {
              _isProcessingComplete = false;
              _isProcessing = false;
              setState(() {});
              new Timer(const Duration(milliseconds: 1000), () {
                onTabTapped(PersonalPage.index);
                setState(() {});
              });
            });
            break;
          }
          case GetKycStatus.KYC_STATUS_ALLOW_VIDEO: {
            onTabTapped(KYCInvalid.index);
            break;
          }
          case GetKycStatus.KYC_STATUS_FETCH_FAILED:
          case GetKycStatus.KYC_STATUS_SERVICE_DOWN:
          case GetKycStatus.KYC_STATUS_INVALID:  {
            //TODO add message and counter to try again
            break;
          }
          case '$QUERY_FAILED': {
            //TODO
            _isProcessing = false;
            _isProcessingComplete = false;
            setState(() {});
            break;
          }
          default: {

          }
        }
      });
    } else {
      showErrorDialog("Oops!", "Invalid PAN!", context);
    }
  }

  verifyPersonalDetails() {
    if (personalDetailsformKey.currentState.validate()) {
      log.debug("All Cool");
      onTabTapped(2);
    }
  }

  verifyIncomeDetails() {
    if (IDP.occupationChosenValue != null &&
        IDP.wealthChosenValue != null &&
        IDP.exposureChosenValue != null) {
      onTabTapped(3);
    } else {
      showErrorDialog("Oops!", "All Fields are necessary bruh!", context);
    }
  }

  verifyBankDetails() {
    if (IDP.accNo.text == "" ||
        IDP.cnfAccNo.text == "" ||
        IDP.ifsc.text == "") {
      showErrorDialog("Oops!", "All fields are necessary", context);
    } else if (IDP.accNo.text != IDP.cnfAccNo.text) {
      showErrorDialog("Oops", "Please confirm account numbers", context);
    } else {
      showErrorDialog("Hurry", "All Good,Now you can Invest", context);
      log.debug(IDP.panInput.text);
      log.debug(IDP.name.text);
      log.debug(IDP.email.text);
      log.debug(IDP.selectedDate);
      log.debug(IDP.wealthChosenValue);
      log.debug(IDP.exposureChosenValue);
      log.debug(IDP.occupationChosenValue);
      log.debug(IDP.accNo.text);
      log.debug(IDP.ifsc.text);
    }
  }

  Future<String> onPanEntered(String panNumber) async{
    if(baseProvider == null || dbProvider == null || iProvider == null) {
      log.error('Providers not initialised');
      return GetKycStatus.KYC_STATUS_SERVICE_DOWN;
    }
    if(!iProvider.isInit())await iProvider.init();

    var kObj = await iProvider.getKycStatus(panNumber);
    if(kObj == null || kObj[QUERY_SUCCESS_FLAG] == QUERY_FAILED
        || kObj[GetKycStatus.resStatus] == null) {
      log.error('Couldnt fetch an appropriate response');
      log.error(kObj[QUERY_FAIL_REASON]);
      return '$QUERY_FAILED';
    }
    String fKycStatus = kObj[GetKycStatus.resStatus];
    String fKycName = kObj[GetKycStatus.resName];
    if(fKycStatus == GetKycStatus.KYC_STATUS_VALID) {
      log.debug('User is KYC verified!');
      //create user icici obj
      if(baseProvider.iciciDetail == null) {
        baseProvider.iciciDetail = UserIciciDetail.newApplication(null, panNumber, fKycStatus);
      }else {
        baseProvider.iciciDetail.panNumber = panNumber;
        baseProvider.iciciDetail.kycStatus = fKycStatus;
      }
      if(fKycName != null || fKycStatus.isNotEmpty) baseProvider.iciciDetail.panName = fKycName;
      //update user icici obj
      bool iciciUpdated = await dbProvider.updateUserIciciDetails(baseProvider.myUser.uid, baseProvider.iciciDetail);
      //update flags in user document
      baseProvider.myUser.isKycVerified = BaseUtil.KYC_VALID;
      bool userFlagUpdated = await dbProvider.updateUser(baseProvider.myUser);
      log.debug('Flags for icici update and user update: $iciciUpdated, $userFlagUpdated');
    }else if(fKycStatus == GetKycStatus.KYC_STATUS_ALLOW_VIDEO) {
      log.debug('User is NOT KYC verified');
      baseProvider.myUser.isKycVerified = BaseUtil.KYC_INVALID;
      bool userFlagUpdated = await dbProvider.updateUser(baseProvider.myUser);
      log.debug('Flags for icici update:$userFlagUpdated');
    }else{
      log.debug('KYC fetch ran into service issue');
      var failData = {
        'kyc_status': fKycStatus
      };
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserKYCFlagFetchFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
    }
    return fKycStatus;
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    iProvider = Provider.of<ICICIModel>(context);    
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: _width,
            height: _height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10,0,10,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          Assets.iciciGraphic,
                          fit: BoxFit.contain,
                          height: 100,
                          width: 100,
                        ),
                        Row(
                          children: [
                            Text('Need Help? '),
                            Icon(
                              Icons.info_outline,
                              color: UiConstants.accentColor,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ),
                (!_isProcessing && !_isProcessingComplete)?PageView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: [
                    PANPage(),
                    PersonalPage(
                      personalForm: personalDetailsformKey,
                    ),
                    IncomeDetailsInputScreen(),
                    BankDetailsInputScreen(),
                  ],
                  onPageChanged: onPageChanged,
                  controller: _pageController,
                ):Container(),
                Positioned(
                  bottom: _height * 0.02,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
                    width: _width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: _width * 0.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: UiConstants.primaryColor,
                              ),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: _pageIndex > 0
                                    ? UiConstants.primaryColor
                                    : UiConstants.spinnerColor,
                              ),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: _pageIndex > 1
                                    ? UiConstants.primaryColor
                                    : UiConstants.spinnerColor,
                              ),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: _pageIndex > 2
                                    ? UiConstants.primaryColor
                                    : UiConstants.spinnerColor,
                              ),
                            ],
                          ),
                        ),
                        SubmitButton(action: checkPage, title: controllerBtnText,
                          isDisabled: (_isProcessing||_isProcessingComplete)),
                      ],
                    ),
                  ),
                ),
                (_isProcessingComplete)?Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Lottie.asset(Assets.checkmarkLottie),
                  ),
                ):Container(),
                (_isProcessing)?Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40,0,40,0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 4,
                            width: double.infinity,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.blueGrey[200],
                              valueColor: AlwaysStoppedAnimation(UiConstants.primaryColor),
                              minHeight: 4,
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('Processing',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: UiConstants.accentColor,
                              fontSize: 20
                            ),
                          )
                        )
                      ],
                    )
                  ),
                ):Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

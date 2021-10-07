import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/user_icici_detail_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/ui/dialogs/contact_dialog.dart';
import 'package:felloapp/ui/elements/milestone_progress.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/data_provider.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/error_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/submit_button.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/bank_details.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/income_details.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/otp_verification.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/pan_details.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-screens/personal_details.dart';
import 'package:intl/intl.dart';
import '../../../tabs/finance/icici/mf_details_page.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// import 'package:http/http.dart' as http;
class IciciOnboardController extends StatefulWidget {
  IciciOnboardController({this.startIndex, this.appIdExists = false});

  final int startIndex;
  final bool appIdExists;

  @override
  _IciciOnboardControllerState createState() =>
      _IciciOnboardControllerState(startIndex);
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
  BaseUtil baseProvider;
  DBModel dbProvider;
  ICICIModel iProvider;
  bool _isProcessing = false;
  bool _isProcessingComplete = false;
  String _errorMessage;

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
        duration: const Duration(milliseconds: 1000), curve: Curves.easeInOut);
  }

  checkPage() {
    if (_isProcessing || _isProcessingComplete) return;
    if (_errorMessage != null) _errorMessage = null;

    if (_pageIndex == PANPage.index) {
      verifyPan();
    } else if (_pageIndex == PersonalPage.index) {
      verifyPersonalDetails();
    } else if (_pageIndex == IncomeDetailsInputScreen.index) {
      verifyIncomeDetails();
    } else if (_pageIndex == BankDetailsInputScreen.index) {
      verifyBankDetails();
    } else if (_pageIndex == OtpVerification.index) {
      verifyOtpDetails();
    }
  }

  verifyPan() {
    String panText = IDP.panInput.text;
    panText = panText.toUpperCase();
    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
    if (panText.isEmpty) {
      showErrorDialog("Error", "Please enter your PAN number", context);
    } else if (panCheck.hasMatch(panText) && panText.length == 10) {
      _isProcessing = true;
      setState(() {});
      onPanEntered(panText).then((kycStatus) {
        switch (kycStatus) {
          case GetKycStatus.KYC_STATUS_VALID:
            {
              _isProcessingComplete = true;
              _isProcessing = false;
              setState(() {});
              new Timer(const Duration(milliseconds: 1000), () {
                _isProcessingComplete = false;
                _isProcessing = false;
                setState(() {});
                new Timer(const Duration(milliseconds: 1000), () {
                  onTabTapped(PersonalPage.index);
                  //setState(() {});
                });
              });
              break;
            }
          case GetKycStatus.KYC_STATUS_ALLOW_VIDEO:
            {
              _isProcessingComplete = false;
              _isProcessing = false;
              setState(() {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/initkyc');
              });
              break;
            }
          case GetKycStatus.KYC_STATUS_FETCH_FAILED:
          case GetKycStatus.KYC_STATUS_INVALID:
            {
              _errorMessage =
                  'Error: Your PAN number could not be verified. Please check and try again.';
              _isProcessing = false;
              _isProcessingComplete = false;
              setState(() {});
              break;
            }
          case GetKycStatus.KYC_STATUS_SERVICE_DOWN:
            {
              _errorMessage =
                  'The ICICI verification services are currently down. Please try again in sometime';
              _isProcessing = false;
              _isProcessingComplete = false;
              setState(() {});
              break;
            }
          case '$QUERY_FAILED':
            {
              _errorMessage =
                  'Error: The ICICI verification services did not respond correctly. Please try again';
              _isProcessing = false;
              _isProcessingComplete = false;
              setState(() {});
              break;
            }
          default:
            {}
        }
      });
    } else {
      showErrorDialog("Valid PAN required",
          "Please input your correct PAN Number", context);
    }
  }

  /// - first create an application id if doesnt exist
  /// - next, add in the basic details to that application
  /// - next check the fatca flag returned checkKYC
  /// - decide whether income screen is required and move accordingly
  verifyPersonalDetails() {
    if (personalDetailsformKey.currentState.validate()) {
      DateTime dt = IDP.selectedDate;
      if (dt == null) {
        showErrorDialog(
            'Date of Birth', 'Please enter your date of birth', context);
        return;
      } else if (dt != null && !isAdult(dt)) {
        showErrorDialog('Date of Birth',
            'You need to be 18 years and above to be eligible', context);
        return;
      }
      _isProcessing = true;
      setState(() {});
      if (widget.appIdExists) {
        //dont generate a new app id again
        runBasicDetailsAndFatcaApi();
      } else {
        //first generate an app id using name and pannumber
        //then start adding in the details
        onNameEntered(IDP.name.text).then((nameResObj) {
          if (!nameResObj['flag']) {
            _isProcessing = false;
            if (nameResObj['reason'] != null) {
              _errorMessage = 'Error: ${nameResObj['reason']}';
            } else {
              _errorMessage =
                  'Error: Unknown error occurred. Please try again.';
            }
            setState(() {});
          } else {
            runBasicDetailsAndFatcaApi();
          }
        });
      }
    }
  }

  Future<bool> runBasicDetailsAndFatcaApi() {
    onBasicDetailsEntered(
            baseProvider.myUser.mobile, IDP.email.text, IDP.selectedDate)
        .then((basicObj) {
      if (!basicObj['flag']) {
        _isProcessing = false;
        if (basicObj['reason'] != null) {
          _errorMessage = 'Error: ${basicObj['reason']}';
        } else {
          _errorMessage = 'Error: Unknown error occurred. Please try again.';
        }
        setState(() {});
      } else {
        //success
        //now before moving to next screen, confirm fatca
        runFatcaCheck().then((moveToIncomeScreen) {
          _isProcessing = false;
          setState(() {});
          if (moveToIncomeScreen) {
            new Timer(const Duration(milliseconds: 1000), () {
              onTabTapped(IncomeDetailsInputScreen.index);
            });
          } else {
            getBankAccountTypes(baseProvider.iciciDetail.panNumber)
                .then((userAcctList) {
              if (userAcctList != null) IDP.userAcctTypes = userAcctList;
              new Timer(const Duration(milliseconds: 500), () {
                onTabTapped(BankDetailsInputScreen.index);
              });
            });
          }
        });
      }
    });
  }

  Future<bool> runFatcaCheck() async {
    bool flag = true;
    bool fatcaFlag = true;
    if (baseProvider.iciciDetail.fatcaFlag == null ||
        baseProvider.iciciDetail.fatcaFlag.isEmpty) {
      //fatca status unknown. disregard it
      return flag;
    }
    switch (baseProvider.iciciDetail.fatcaFlag) {
      case GetKycStatus.FATCA_FLAG_NN:
        {
          //move directly to bank screen
          flag = false;
          fatcaFlag = true; //make fatca true
          break;
        }
      case GetKycStatus.FATCA_FLAG_YY:
        {
          bool data = await showDialog(
                context: context,
                builder: (BuildContext context) => new AlertDialog(
                  title: new Text(
                      'Is any of the applicant\'s/guardian/Power of Attorney ' +
                          'holder\'s country of birth/citizenship/nationality/tax residency'
                              ' status other than India?'),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text('No'),
                    ),
                    new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: new Text('Yes'),
                    ),
                  ],
                ),
              ) ??
              false;

          fatcaFlag = data;
          flag = false; //move directly to bank screen
          break;
        }
      case GetKycStatus.FATCA_FLAG_YN:
        {
          bool data = await showDialog(
                context: context,
                builder: (BuildContext context) => new AlertDialog(
                  title: new Text(
                      'As per ICICI, FATCA Status for your record is \'Unable to confirm\'' +
                          '. Do you wish to update the FATCA?'),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text('No'),
                    ),
                    new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: new Text('Yes'),
                    ),
                  ],
                ),
              ) ??
              false;

          flag = data;
          fatcaFlag = data;
          break;
        }
      case GetKycStatus.FATCA_FLAG_UC:
        {
          bool data = await showDialog(
                context: context,
                builder: (BuildContext context) => new AlertDialog(
                  title: new Text('US/Canada Person(s) are not allowed ' +
                      'to do the subscription/Switch In transaction.'),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text('Okay'),
                    ),
                  ],
                ),
              ) ??
              false;

          flag = true;
          fatcaFlag = true;
          break;
        }
      case GetKycStatus.FATCA_FLAG_PC:
        {
          bool data = await showDialog(
                context: context,
                builder: (BuildContext context) => new AlertDialog(
                  title: new Text('As per ICICI, your additional KYC, FATCA ' +
                      'and CRS Self declaration information is not ' +
                      'available, Kindly submit the same.'),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text('Okay'),
                    ),
                  ],
                ),
              ) ??
              false;

          flag = true;
          fatcaFlag = true;
          break;
        }
    }
    //not update fatca to icici
    var resMap = await iProvider.submitFatcaDetails(
        baseProvider.iciciDetail.appId,
        baseProvider.iciciDetail.panNumber,
        fatcaFlag);
    if (resMap == null || resMap[SubmitFatca.resStatus] != 'Y') {
      Map<String, dynamic> failData = {
        'appid': baseProvider.iciciDetail.appId,
        'fatcaKey': baseProvider.iciciDetail.fatcaFlag
      };
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserICICIFatcaFieldUpdateFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
    }

    return flag;
  }

  verifyIncomeDetails() {
    if (IDP.occupationChosenValue == null ||
        IDP.incomeChosenValue == null ||
        IDP.exposureChosenValue == null) {
      showErrorDialog("Error", "Please input all the fields", context);
    } else {
      _isProcessing = true;
      setState(() {});

      onIncomeDetailsEntered(IDP.occupationChosenValue, IDP.incomeChosenValue,
              IDP.exposureChosenValue, '01')
          .then((incomeObj) {
        if (!incomeObj['flag']) {
          _isProcessing = false;
          if (incomeObj['reason'] != null) {
            _errorMessage = 'Error: ${incomeObj['reason']}';
          } else {
            _errorMessage = 'Error: Unknown error occurred. Please try again.';
          }
          setState(() {});
        } else {
          _isProcessing = false;
          setState(() {});
          List<Map<String, String>> userAcctList = incomeObj['userAccts'];
          if (userAcctList != null) IDP.userAcctTypes = userAcctList;
          new Timer(const Duration(milliseconds: 1000), () {
            onTabTapped(BankDetailsInputScreen.index);
          });
        }
      });
    }
  }

  verifyBankDetails() {
    if (IDP.accNo.text == "" ||
        IDP.cnfAccNo.text == "" ||
        IDP.ifsc.text == "") {
      showErrorDialog(
          "Error", "Please provide a valid input for all the fields.", context);
    } else if (IDP.accNo.text != IDP.cnfAccNo.text) {
      showErrorDialog(
          "Error", "The account numbers provided do not match.", context);
    } else {
      // showErrorDialog("Hurry", "All Good,Now you can Invest", context);
      _isProcessing = true;
      setState(() {});

      onBankAccEntered(IDP.accNo.text, IDP.acctTypeChosenValue, IDP.ifsc.text)
          .then((resObj) {
        if (!resObj['flag']) {
          _isProcessing = false;
          if (resObj['reason'] != null) {
            _errorMessage = 'Error: ${resObj['reason']}';
          } else {
            _errorMessage = 'Error: Unknown error occurred. Please try again.';
          }
          setState(() {});
        } else {
          sendOtp(baseProvider.myUser.mobile, baseProvider.iciciDetail.email)
              .then((otpObj) {
            if (!otpObj['flag']) {
              _isProcessing = false;
              if (otpObj['reason'] != null) {
                _errorMessage = 'Error: ${otpObj['reason']}';
              } else {
                _errorMessage =
                    'Error: Unknown error occurred. Please try again.';
              }
              setState(() {});
            } else {
              _isProcessing = false;
              setState(() {});
              if (otpObj['status'] == SendOtp.STATUS_SENT_MOBILE)
                IDP.otpChannels = 'mobile';
              else if (otpObj['status'] == SendOtp.STATUS_SENT_EMAIL)
                IDP.otpChannels = 'email';
              else if (otpObj['status'] == SendOtp.STATUS_SENT_EMAIL_MOBILE)
                IDP.otpChannels = 'mobile and your email';
              onTabTapped(OtpVerification.index);
            }
          });
        }
      });
    }
  }

  verifyOtpDetails() {
    if (IDP.otpInput.text == null ||
        IDP.otpInput.text.isEmpty ||
        IDP.otpInput.text.length != 5) {
      showErrorDialog(
          "Error", "Please provide a valid input for all the fields", context);
    } else {
      _isProcessing = true;
      setState(() {});
      if (baseProvider.iciciDetail.verifiedOtpId != null) {
        //OTP has already been verified. Only attempt portfolio creation
        onOtpVerified().then((rObj) {
          if (!rObj['flag']) {
            _isProcessing = false;
            if (rObj['reason'] != null) {
              _errorMessage = 'Error: ${rObj['reason']}';
            } else {
              _errorMessage =
                  'Error: Unknown error occurred. Please try again.';
            }
            setState(() {});
          } else {
            _isProcessingComplete = true;
            _isProcessing = false;
            setState(() {});
            new Timer(const Duration(milliseconds: 1000), () {
              _isProcessingComplete = false;
              _isProcessing = false;
              setState(() {});
              new Timer(const Duration(milliseconds: 1000), () {
                Navigator.of(context).pop();
                //setState(() {});
              });
            });
          }
        });
      } else {
        onOtpEntered(IDP.otpInput.text).then((resObj) {
          if (!resObj['flag']) {
            _isProcessing = false;
            if (resObj['reason'] != null) {
              _errorMessage = 'Error: ${resObj['reason']}';
            } else {
              _errorMessage =
                  'Error: Unknown error occurred. Please try again.';
            }
            setState(() {});
          } else {
            _isProcessingComplete = true;
            _isProcessing = false;
            setState(() {});
            new Timer(const Duration(milliseconds: 1000), () {
              _isProcessingComplete = false;
              _isProcessing = false;
              setState(() {});
              new Timer(const Duration(milliseconds: 1000), () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => MFDetailsPage(),
                  ),
                );
                //setState(() {});
              });
            });
          }
        });
      }
    }
  }

  Future<String> onPanEntered(String panNumber) async {
    if (baseProvider == null || dbProvider == null || iProvider == null) {
      log.error('Providers not initialised');
      return GetKycStatus.KYC_STATUS_SERVICE_DOWN;
    }
    if (!iProvider.isInit()) await iProvider.init();

    var kObj = await iProvider.getKycStatus(panNumber);
    if (kObj == null ||
        kObj[QUERY_SUCCESS_FLAG] == QUERY_FAILED ||
        kObj[GetKycStatus.resStatus] == null) {
      log.error('Couldnt fetch an appropriate response');
      log.error(kObj[QUERY_FAIL_REASON]);
      return '$QUERY_FAILED';
    }
    String fKycStatus = kObj[GetKycStatus.resStatus];
    String fKycName = kObj[GetKycStatus.resName];
    String fAppMode = kObj[GetKycStatus.resAppMode];
    String fFatcaFlag = kObj[GetKycStatus.resFatcaStatus];
    if (fKycStatus == GetKycStatus.KYC_STATUS_VALID) {
      log.debug('User is KYC verified!');
      //create user icici obj
      if (baseProvider.iciciDetail == null) {
        baseProvider.iciciDetail = UserIciciDetail.newApplication(
            null, panNumber, fKycStatus, fAppMode, fFatcaFlag);
      } else {
        baseProvider.iciciDetail.panNumber = panNumber;
        baseProvider.iciciDetail.kycStatus = fKycStatus;
      }
      if (fKycName != null && fKycName.isNotEmpty)
        baseProvider.iciciDetail.panName = fKycName;
      if (fFatcaFlag != null && fFatcaFlag.isNotEmpty)
        baseProvider.iciciDetail.fatcaFlag = fFatcaFlag;
      //update user icici obj
      bool iciciUpdated = await dbProvider.updateUserIciciDetails(
          baseProvider.myUser.uid, baseProvider.iciciDetail);
      //update flags in user document
      baseProvider.myUser.isKycVerified = Constants.KYC_VALID;
      // baseProvider.myUser.pan = panNumber; //TODO change pan field to vX
      bool userFlagUpdated = await dbProvider.updateUser(baseProvider.myUser);
      log.debug(
          'Flags for icici update and user update: $iciciUpdated, $userFlagUpdated');
    } else if (fKycStatus == GetKycStatus.KYC_STATUS_ALLOW_VIDEO) {
      log.debug('User is NOT KYC verified');
      baseProvider.myUser.isKycVerified = Constants.KYC_INVALID;
      // baseProvider.myUser.pan = panNumber; //TODO change pan field to vX
      bool userFlagUpdated = await dbProvider.updateUser(baseProvider.myUser);
      log.debug('Flags for icici update:$userFlagUpdated');
    } else {
      log.debug('KYC fetch ran into service issue');
      Map<String, dynamic> failData = {
        'kyc_status': fKycStatus,
        'pan': panNumber
      };
      bool failureLogged = await dbProvider.logFailure(
          baseProvider.myUser.uid, FailType.UserKYCFlagFetchFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
    }
    return fKycStatus;
  }

  /**
   * Return obj: {flag: true/false, response: ''}
   * */
  Future<Map<String, dynamic>> onNameEntered(String name) async {
    if (baseProvider == null || dbProvider == null || iProvider == null) {
      log.error('Providers not initialised');
      return {'flag': false, 'reason': 'App restart required'};
    }
    if (!iProvider.isInit()) await iProvider.init();

    String panNumber = baseProvider.iciciDetail.panNumber;
    var valMap = await iProvider.submitPanDetails(panNumber, name);
    if (valMap == null || valMap[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      log.error('Couldnt fetch an appropriate response');
      return {
        'flag': false,
        'reason': (valMap[QUERY_FAIL_REASON] != null)
            ? valMap[QUERY_FAIL_REASON]
            : 'Unknown'
      };
    } else {
      String resStatus = valMap[SubmitPanDetail.resStatus];
      String resId = valMap[SubmitPanDetail.resId];
      if (resStatus == null ||
          resStatus.isEmpty ||
          resId == null ||
          resId.isEmpty) {
        log.error('Couldnt fetch an appropriate response');
        return {
          'flag': false,
          'reason': 'Application creation failed. Please try again'
        };
      } else if (resStatus != 'Y') {
        log.error('Couldnt fetch an appropriate response');
        Map<String, dynamic> failData = {'res_status': resStatus};
        bool failureLogged = await dbProvider.logFailure(
            baseProvider.myUser.uid,
            FailType.UserICICAppCreationFailed,
            failData);
        log.debug('Failure logged correctly: $failureLogged');
        return {
          'flag': false,
          'reason': 'Application creation failed. Please try again'
        };
      } else {
        log.debug('ResID and ResStatus validated: $resStatus $resId');
        baseProvider.iciciDetail.appId = resId;
        bool icicUpFlag = await dbProvider.updateUserIciciDetails(
            baseProvider.myUser.uid, baseProvider.iciciDetail);
        log.debug('Application ID added successfully');
        return {'flag': true};
      }
    }
  }

  Future<Map<String, dynamic>> onBasicDetailsEntered(
      String mobile, String email, DateTime dob) async {
    if (baseProvider == null || dbProvider == null || iProvider == null) {
      log.error('Providers not initialised');
      return {'flag': false, 'reason': 'App restart required'};
    }
    if (!iProvider.isInit()) await iProvider.init();

    baseProvider.iciciDetail.email = email.trim();
    String appid = baseProvider.iciciDetail.appId;
    String panNumber = baseProvider.iciciDetail.panNumber;
    String dobStr = (dob != null)
        ? DateFormat('dd-MMM-yyyy').format(DateTime.now())
        : null; //29-Aug-1996
    if (appid != null &&
        panNumber != null &&
        mobile != null &&
        email != null &&
        dobStr != null) {
      var bValMap = await iProvider.submitBasicDetails(
          appid, panNumber, mobile, email, dobStr);
      if (bValMap == null || bValMap[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
        log.error('Couldnt fetch an appropriate response');
        return {
          'flag': false,
          'reason': (bValMap[QUERY_FAIL_REASON] != null)
              ? bValMap[QUERY_FAIL_REASON]
              : 'Unknown'
        };
      } else {
        String resStatus = bValMap[SubmitInvoiceDetail.resStatus];
        if (resStatus == null || resStatus.isEmpty) {
          log.error('Couldnt fetch an appropriate response');
          return {
            'flag': false,
            'reason': 'Field Update failed. Please try again'
          };
        } else if (resStatus != 'Y') {
          log.error('Couldnt fetch an appropriate response');
          Map<String, dynamic> failData = {'res_status': resStatus};
          bool failureLogged = await dbProvider.logFailure(
              baseProvider.myUser.uid,
              FailType.UserICICIBasicFieldUpdateFailed,
              failData);
          log.debug('Failure logged correctly: $failureLogged');
          return {
            'flag': false,
            'reason': 'Field update failed. Please try again'
          };
        } else {
          log.debug('ResStatus validated: $resStatus');
          //baseProvider.iciciDetail.appId = resId;
          //bool icicUpFlag = await dbProvider.updateUserIciciDetails(baseProvider.myUser.uid, baseProvider.iciciDetail);;
          log.debug('Application ID added successfully');
          return {'flag': true};
        }
      }
    } else {
      return {'flag': false, 'reason': 'Field were invalid. Please try again'};
    }
  }

  /**
   * Return obj: {flag: false, reason: ...} OR
   * {flag: true, userAccts: [Acct type list]}
   * */
  Future<Map<String, dynamic>> onIncomeDetailsEntered(String occupationCode,
      String incomeCode, String polCode, srcWealth) async {
    if (baseProvider == null || dbProvider == null || iProvider == null) {
      log.error('Providers not initialised');
      return {'flag': false, 'reason': 'App restart required'};
    }
    if (!iProvider.isInit()) await iProvider.init();

    String appid = baseProvider.iciciDetail.appId;
    String panNumber = baseProvider.iciciDetail.panNumber;
    if (appid != null &&
        panNumber != null &&
        occupationCode != null &&
        incomeCode != null &&
        polCode != null &&
        srcWealth != null) {
      var bValMap = await iProvider.submitSecondaryDetails(
          appid, occupationCode, incomeCode, polCode, panNumber, srcWealth);
      if (bValMap == null || bValMap[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
        log.error('Couldnt fetch an appropriate response');
        return {
          'flag': false,
          'reason': (bValMap[QUERY_FAIL_REASON] != null)
              ? bValMap[QUERY_FAIL_REASON]
              : 'Unknown'
        };
      } else {
        String resStatus = bValMap[SubmitInvoiceDetail.resStatus];
        if (resStatus == null || resStatus.isEmpty) {
          log.error('Couldnt fetch an appropriate response');
          return {
            'flag': false,
            'reason': 'Field Update failed. Please try again'
          };
        } else if (resStatus != 'Y') {
          log.error('Couldnt fetch an appropriate response');
          Map<String, dynamic> failData = {'res_status': resStatus};
          bool failureLogged = await dbProvider.logFailure(
              baseProvider.myUser.uid,
              FailType.UserICICIIncomeFieldUpdateFailed,
              failData);
          log.debug('Failure logged correctly: $failureLogged');
          return {
            'flag': false,
            'reason': 'Field update failed. Please try again'
          };
        } else {
          log.debug('ResStatus validated: $resStatus');
          //baseProvider.iciciDetail.appId = resId;
          //bool icicUpFlag = await dbProvider.updateUserIciciDetails(baseProvider.myUser.uid, baseProvider.iciciDetail);;
          log.debug('Application ID added successfully');
          //get and update user Bank accounts
          var accTypes =
              await getBankAccountTypes(baseProvider.iciciDetail.panNumber);
          return {'flag': true, 'userAccts': accTypes};
        }
      }
    } else {
      return {'flag': false, 'reason': 'Field were invalid. Please try again'};
    }
  }

  Future<Map<String, dynamic>> onBankAccEntered(
      String accNo, String accTypeCde, String ifsc) async {
    if (baseProvider == null || dbProvider == null || iProvider == null) {
      log.error('Providers not initialised');
      return {'flag': false, 'reason': 'App restart required'};
    }
    if (!iProvider.isInit()) await iProvider.init();

    String panNumber = baseProvider.iciciDetail.panNumber;
    var bankDetail = await iProvider.getBankInfo(panNumber, ifsc);
    if (bankDetail == null || bankDetail[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      log.error('Couldnt fetch an appropriate response');
      log.error('Couldnt fetch an appropriate response');
      Map<String, dynamic> failData = {'ifsc': ifsc};
      bool failureLogged = await dbProvider.logFailure(
          baseProvider.myUser.uid, FailType.UserIFSCNotFound, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return {
        'flag': false,
        'reason': (bankDetail[QUERY_FAIL_REASON] != null)
            ? bankDetail[QUERY_FAIL_REASON]
            : 'We could not fetch the bank details from the given IFSC Code. Please verify and try again'
      };
    } else if (bankDetail[GetBankDetail.resBankCode] == null ||
        bankDetail[GetBankDetail.resBankName] == null) {
      log.error('Couldnt fetch an appropriate response');
      return {
        'flag': false,
        'reason':
            'We could not fetch the bank details from the given IFSC Code. Please verify and try again'
      };
    } else {
      String bankCode = bankDetail[GetBankDetail.resBankCode];
      String bankName = bankDetail[GetBankDetail.resBankName];
      String bankBranchName = bankDetail[GetBankDetail.resBranchName];
      String bankAddress = bankDetail[GetBankDetail.resAddress];
      String bankCity = bankDetail[GetBankDetail.resCity];
      log.debug('BankDetails fetched: ${bankCode ?? ''}, ${bankName ?? ''},' +
          ' ${bankBranchName ?? ''}, ${bankAddress ?? ''}, ${bankCity ?? ''} ');
      if (bankCode == null ||
          bankName == null ||
          bankBranchName == null ||
          bankCode.isEmpty ||
          bankName.isEmpty ||
          bankBranchName.isEmpty) {
        log.error('Couldnt fetch an appropriate response');
        Map<String, dynamic> failData = {'ifsc': ifsc};
        bool failureLogged = await dbProvider.logFailure(
            baseProvider.myUser.uid,
            FailType.UserInsufficientBankDetailFailed,
            failData);
        log.debug('Failure logged correctly: $failureLogged');
        return {
          'flag': false,
          'reason':
              'We could not fetch the bank details from the provided IFSC Code. Please verify and try again'
        };
      } else {
        //submit all details
        String appid = baseProvider.iciciDetail.appId;

        baseProvider.iciciDetail.bankAccNo = accNo;
        baseProvider.iciciDetail.bankCode = bankCode;
        baseProvider.iciciDetail.bankName = bankName;
        baseProvider.iciciDetail.bankCity = bankCity;
        var upObj = await dbProvider.updateUserIciciDetails(
            baseProvider.myUser.uid, baseProvider.iciciDetail);
        log.debug(
            'Succesfuly updated bank details to obj: ${upObj.toString()}');

        var bankSubmitResponse = await iProvider.submitBankDetails(
            appid,
            panNumber,
            PAYMODE,
            accTypeCde,
            accNo,
            bankName,
            bankCode,
            ifsc,
            bankCity,
            bankBranchName,
            bankAddress);
        if (bankSubmitResponse == null ||
            bankSubmitResponse[QUERY_SUCCESS_FLAG] == QUERY_FAILED ||
            bankSubmitResponse[SubmitBankDetails.resStatus] != 'Y') {
          log.error('Couldnt fetch an appropriate response');
          Map<String, dynamic> failData = {
            'appid': appid,
            'address': bankAddress,
            'bankCode': bankCode,
            'branchName': bankBranchName,
            'ifsc': ifsc
          };
          bool failureLogged = await dbProvider.logFailure(
              baseProvider.myUser.uid,
              FailType.UserICICIBankFieldUpdateFailed,
              failData);
          log.debug('Failure logged correctly: $failureLogged');
          return {
            'flag': false,
            'reason': (bankSubmitResponse[QUERY_FAIL_REASON] != null)
                ? bankSubmitResponse[QUERY_FAIL_REASON]
                : 'Unknown'
          };
        } else {
          log.debug('Bank Details submission:: All good');
          return {'flag': true};
        }
      }
    }
  }

  /**
   * Return obj: {flag: false, reason: ..} OR
   * {flag: true, status: otpstatus}
   * */
  Future<Map<String, dynamic>> sendOtp(String mobile, String email) async {
    if (baseProvider == null || dbProvider == null || iProvider == null) {
      log.error('Providers not initialised');
      return {'flag': false, 'reason': 'App restart required'};
    }
    if (!iProvider.isInit()) await iProvider.init();

    var otpResObj = await iProvider.sendOtp(mobile, email);
    if (otpResObj == null || otpResObj[QUERY_SUCCESS_FLAG] == false) {
      log.error('Couldnt send otp');
      return {
        'flag': false,
        'reason': (otpResObj[QUERY_FAIL_REASON] != null)
            ? otpResObj[QUERY_FAIL_REASON]
            : 'Unknown error occurred. Please try again'
      };
    } else if (otpResObj[SendOtp.resStatus] == null ||
        otpResObj[SendOtp.resStatus] == SendOtp.STATUS_NOT_SENT) {
      log.error('Couldnt send otp');
      log.error('Couldnt fetch an appropriate response');
      Map<String, dynamic> failData = {'mobile': mobile, 'email': email};
      bool failureLogged = await dbProvider.logFailure(
          baseProvider.myUser.uid, FailType.UserICICIOTPSendFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return {
        'flag': false,
        'reason': (otpResObj[QUERY_FAIL_REASON] != null)
            ? otpResObj[QUERY_FAIL_REASON]
            : 'Couldn\'t send an otp to provided email/mobile. Please try again.'
      };
    } else {
      log.debug('Otp Success');
      baseProvider.iciciDetail.unverifiedOtpId = otpResObj[SendOtp.resOtpId];
      return {'flag': true, 'status': otpResObj[SendOtp.resStatus]};
    }
  }

  /**
   * Return obj: {flag: false, reason: ..} OR
   * {flag: true, status: otpstatus}
   * */
  Future<Map<String, dynamic>> onResendOtp() async {
    if (_pageIndex != OtpVerification.index ||
        baseProvider.myUser.mobile.isEmpty ||
        baseProvider.iciciDetail.email == null ||
        baseProvider.iciciDetail.email.isEmpty ||
        baseProvider.iciciDetail.unverifiedOtpId == null ||
        baseProvider.iciciDetail.unverifiedOtpId.isEmpty) {
      log.error('Error in fetching all details required to send the otp');
      return {
        'flag': false,
        'reason': 'Couldnt resend otp to provided details. Kindly try again'
      };
    } else {
      var resendObj = await iProvider.resendOtp(
          baseProvider.iciciDetail.unverifiedOtpId,
          baseProvider.myUser.mobile,
          baseProvider.iciciDetail.email);
      if (resendObj == null || resendObj[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
        log.error('Couldnt send otp');
        return {
          'flag': false,
          'reason': (resendObj[QUERY_FAIL_REASON] != null)
              ? resendObj[QUERY_FAIL_REASON]
              : 'Unknown error occurred. Please try again'
        };
      } else if (resendObj[SendOtp.resStatus] == null ||
          resendObj[SendOtp.resStatus] == SendOtp.STATUS_NOT_SENT) {
        log.error('Couldnt send otp');
        log.error('Couldnt fetch an appropriate response');
        Map<String, dynamic> failData = {
          'otpid': baseProvider.iciciDetail.unverifiedOtpId,
          'mobile': baseProvider.myUser.mobile,
          'email': baseProvider.iciciDetail.email
        };
        bool failureLogged = await dbProvider.logFailure(
            baseProvider.myUser.uid,
            FailType.UserICICIOTPResendFailed,
            failData);
        log.debug('Failure logged correctly: $failureLogged');
        return {
          'flag': false,
          'reason': (resendObj[QUERY_FAIL_REASON] != null)
              ? resendObj[QUERY_FAIL_REASON]
              : 'Couldn\'t send an otp to provided email/mobile'
        };
      } else {
        log.debug('Otp Success');
        baseProvider.iciciDetail.unverifiedOtpId = resendObj[SendOtp.resOtpId];
        return {'flag': true, 'status': resendObj[SendOtp.resStatus]};
      }
    }
  }

  Future<Map<String, dynamic>> onOtpEntered(String otp) async {
    if (baseProvider == null || dbProvider == null || iProvider == null) {
      log.error('Providers not initialised');
      return {'flag': false, 'reason': 'App restart required'};
    }
    if (!iProvider.isInit()) await iProvider.init();

    var verifyOtpObj = await iProvider.verifyOtp(
        baseProvider.iciciDetail.unverifiedOtpId, otp);
    if (verifyOtpObj == null ||
        verifyOtpObj[QUERY_SUCCESS_FLAG] == QUERY_FAILED ||
        verifyOtpObj[VerifyOtp.resStatus] == null) {
      log.error('Couldnt send otp');
      return {
        'flag': false,
        'reason': (verifyOtpObj[QUERY_FAIL_REASON] != null)
            ? verifyOtpObj[QUERY_FAIL_REASON]
            : 'Unknown error occurred. Please try again'
      };
    } else if (verifyOtpObj[VerifyOtp.resStatus] ==
        VerifyOtp.STATUS_OTP_INVALID) {
      log.debug('Invalid otp entered');
      return {'flag': false, 'reason': 'Invalid OTP entered. Please try again'};
    } else if (verifyOtpObj[VerifyOtp.resStatus] ==
        VerifyOtp.STATUS_OTP_EXPIRED) {
      log.debug('Invalid otp entered');
      return {
        'flag': false,
        'reason':
            'The entered otp has expired. Please request a new otp and retry'
      };
    } else if (verifyOtpObj[VerifyOtp.resStatus] ==
        VerifyOtp.STATUS_TRIES_EXCEEDED) {
      log.debug('Invalid otp entered');
      return {
        'flag': false,
        'reason':
            'You have exceeded the number of allowed tries. Please try again in a while'
      };
    } else if (verifyOtpObj[VerifyOtp.resStatus] ==
        VerifyOtp.STATUS_OTP_VALID) {
      log.debug('OTP validated');
      baseProvider.iciciDetail.verifiedOtpId = verifyOtpObj[VerifyOtp.resOtpId];
      var upObj = await dbProvider.updateUserIciciDetails(
          baseProvider.myUser.uid, baseProvider.iciciDetail);
      log.debug(
          'Succesfuly updated verified otp it to obj: ${upObj.toString()}');

      var finObj = await onOtpVerified();
      return finObj;
      // return {
      //   'flag': true,
      //   'status': VerifyOtp.STATUS_OTP_VALID
      // };
    } else {
      //should never reach here
      return {'flag': false, 'reason': 'Unknown'};
    }
  }

  Future<Map<String, dynamic>> onOtpVerified() async {
    if (baseProvider == null || dbProvider == null || iProvider == null) {
      log.error('Providers not initialised');
      return {'flag': false, 'reason': 'App restart required'};
    }
    if (!iProvider.isInit()) await iProvider.init();

    if (baseProvider.iciciDetail.appId == null ||
        baseProvider.iciciDetail.verifiedOtpId == null) {
      return {'flag': false, 'reason': 'Invalid details. Please try again'};
    }

    var createObj = await iProvider.createPortfolio(
        baseProvider.iciciDetail.appId, baseProvider.iciciDetail.verifiedOtpId);
    if (createObj == null ||
        createObj[QUERY_SUCCESS_FLAG] == QUERY_FAILED ||
        createObj[CreatePortfolio.resReturnCode] == null) {
      return {
        'flag': false,
        'reason': (createObj[QUERY_FAIL_REASON] != null)
            ? createObj[QUERY_FAIL_REASON]
            : 'Unknown error occurred. Please try again'
      };
    } else {
      if (createObj[CreatePortfolio.resReturnCode] !=
          CreatePortfolio.STATUS_PORTFOLIO_CREATED) {
        log.error('Portfolio creation failed');
        Map<String, dynamic> failData = {
          'appid': baseProvider.iciciDetail.appId,
          'returnCode': createObj[CreatePortfolio.resReturnCode],
          'returnMsg': createObj[CreatePortfolio.resRetMessage]
        };
        bool failureLogged = await dbProvider.logFailure(
            baseProvider.myUser.uid,
            FailType.UserICICIPfCreationFailed,
            failData);
        log.debug('Failure logged correctly: $failureLogged');
        return {
          'flag': false,
          'reason':
              'Portfolio couldnt be created due to the following reason: ${createObj[CreatePortfolio.resRetMessage]}'
        };
      } else {
        log.debug('OTP validated');
        if (createObj[CreatePortfolio.resFolioNo] != null) {
          baseProvider.iciciDetail.folioNo =
              createObj[CreatePortfolio.resFolioNo];
          baseProvider.iciciDetail.expDate =
              createObj[CreatePortfolio.resExpiryDate];
          baseProvider.iciciDetail.amcRefNo =
              createObj[CreatePortfolio.resAMCRefNo];
          baseProvider.iciciDetail.payoutId =
              createObj[CreatePortfolio.resPayoutId];
          baseProvider.iciciDetail.chkDigit =
              createObj[CreatePortfolio.resChkDigit];
          var upObj = await dbProvider.updateUserIciciDetails(
              baseProvider.myUser.uid, baseProvider.iciciDetail);
          baseProvider.myUser.isIciciOnboarded = true;
          var userUpObj = await dbProvider.updateUser(baseProvider.myUser);
          log.debug(
              'Succesfuly updated user icici obj and user obj: ${upObj.toString()}, ${userUpObj.toString()}');
          return {
            'flag': true,
          };
        } else {
          //portfolio created but folio no not returned??
          Map<String, dynamic> failData = {
            'appid': baseProvider.iciciDetail.appId,
            'otpid': baseProvider.iciciDetail.verifiedOtpId,
          };
          bool failureLogged = await dbProvider.logFailure(
              baseProvider.myUser.uid,
              FailType.UserPfCreatedButFolioFailed,
              failData);
          log.debug('Failure logged correctly: $failureLogged');
          return {
            'flag': false,
            'reason':
                'Portfolio couldnt be created due to the following reason: ${createObj[CreatePortfolio.resRetMessage]}'
          };
        }
      }
    }
  }

  Future<List<Map<String, String>>> getBankAccountTypes(
      String panNumber) async {
    var defaultAcctTypes = [
      {'CODE': 'SB', 'NAME': 'Savings Account'},
      {'CODE': 'CA', 'NAME': 'Current Account'},
    ];
    var userAcctTypes = await iProvider.getBankAcctTypes(panNumber);

    return userAcctTypes ?? defaultAcctTypes;
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    iProvider = Provider.of<ICICIModel>(context, listen: false);
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: _width,
            height: _height,
            child: Stack(
              children: [
                Opacity(
                  opacity: (!_isProcessing && !_isProcessingComplete) ? 1 : 0.3,
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      PANPage(),
                      PersonalPage(
                        personalForm: personalDetailsformKey,
                        isNameDisabled: widget
                            .appIdExists, //use previously entered name if appid exists
                      ),
                      IncomeDetailsInputScreen(),
                      BankDetailsInputScreen(),
                      OtpVerification(
                        action: onResendOtp,
                      )
                    ],
                    onPageChanged: onPageChanged,
                    controller: _pageController,
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            Assets.iciciGraphic,
                            fit: BoxFit.contain,
                            height: 100,
                            width: 100,
                          ),
                          InkWell(
                            child: Row(
                              children: [
                                Text('Need Help? '),
                                Icon(
                                  Icons.info_outline,
                                  color: UiConstants.accentColor,
                                )
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) =>
                                      ContactUsDialog(
                                        isResident:
                                            (baseProvider.isSignedIn() &&
                                                baseProvider.isActiveUser()),
                                        isUnavailable: false,
                                        onClick: () {
                                          if (baseProvider.isSignedIn() &&
                                              baseProvider.isActiveUser()) {
                                            // dbProvider
                                            //     .addCallbackRequest(
                                            //         baseProvider
                                            //             .firebaseUser.uid,
                                            //         baseProvider.myUser.name,
                                            //         baseProvider.myUser.mobile)
                                            //     .then((flag) {
                                            //   if (flag) {
                                            //     Navigator.of(context).pop();
                                            //     baseProvider.showPositiveAlert(
                                            //         'Callback placed!',
                                            //         'We\'ll contact you soon on your registered mobile',
                                            //         context);
                                            //   }
                                            // });
                                          } else {
                                            baseProvider.showNegativeAlert(
                                                'Unavailable',
                                                'Callbacks are reserved for active users',
                                                context);
                                          }
                                        },
                                      ));
                            },
                          )
                        ],
                      ),
                    )),
                Positioned(
                  bottom: _height * 0.02,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
                    width: _width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (_errorMessage != null)
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Text(
                                  _errorMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.redAccent),
                                ),
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: _width * 0.40,
                              child: MilestoneProgress(
                                completedMilestone: _pageIndex,
                                maxIconSize: 30,
                                totalMilestones: 4,
                                width: _width * 0.40,
                                completedIconData: Icons.check_circle,
                                //optional
                                completedIconColor: UiConstants.primaryColor,
                                //optional
                                nonCompletedIconData:
                                    Icons.check_circle_outline,
                                //optional
                                incompleteIconColor: Colors.grey, //optional
                              ),
                            ),
                            SubmitButton(
                                action: checkPage,
                                title: _getButtonTitle(),
                                isDisabled:
                                    (_isProcessing || _isProcessingComplete)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                (_isProcessingComplete)
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Lottie.asset(Assets.checkmarkLottie),
                        ),
                      )
                    : Container(),
                (_isProcessing)
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
                                          color: UiConstants.accentColor,
                                          fontSize: 20),
                                    ))
                              ],
                            )),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getButtonTitle() {
    if (_pageIndex == PANPage.index)
      return 'VERIFY';
    else if (_pageIndex == OtpVerification.index)
      return 'COMPLETE';
    else
      return 'NEXT';
  }

  bool isAdult(DateTime dt) {
    // Current time - at this moment
    DateTime today = DateTime.now();
    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      dt.year + 18,
      dt.month,
      dt.day,
    );

    return adultDate.isBefore(today);
  }
}

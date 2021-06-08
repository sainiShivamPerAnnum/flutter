import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input_screen.dart';
import 'package:felloapp/ui/pages/login/screens/name_input_screen.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input_screen.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoginController extends StatefulWidget {
  final int initPage;

  LoginController({this.initPage});

  @override
  State<StatefulWidget> createState() => _LoginControllerState(initPage);
}

class _LoginControllerState extends State<LoginController> {
  final Log log = new Log("LoginController");
  final int initPage;
  double _formProgress = 0.2;

  _LoginControllerState(this.initPage);

  PageController _controller;
  static BaseUtil baseProvider;
  static DBModel dbProvider;
  static FcmListener fcmProvider;
  static LocalDBModel lclDbProvider;

  String userMobile;
  String _verificationId;
  String _augmentedVerificationId;
  static List<Widget> _pages;
  int _currentPage;
  final _mobileScreenKey = new GlobalKey<MobileInputScreenState>();
  final _otpScreenKey = new GlobalKey<OtpInputScreenState>();
  final _nameScreenKey = new GlobalKey<NameInputScreenState>();

  @override
  void initState() {
    super.initState();
    _currentPage = (initPage != null) ? initPage : MobileInputScreen.index;
    _formProgress = 0.2 * (_currentPage + 1);
    _controller = new PageController(initialPage: _currentPage);
    _pages = [
      MobileInputScreen(key: _mobileScreenKey),
      OtpInputScreen(
          key: _otpScreenKey,
          otpEntered: _onOtpFilled,
          resendOtp: _onOtpResendRequested),
      NameInputScreen(key: _nameScreenKey),
      // AddressInputScreen(key: _addressScreenKey),
    ];
  }

  Future<void> _verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      log.debug("Phone number hasnt been auto verified yet");
      _otpScreenKey.currentState.onOtpAutoDetectTimeout();
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this._augmentedVerificationId = verId;
      log.debug(
          "User mobile number format verified. Sending otp and verifying");
      if (baseProvider.isOtpResendCount == 0) {
        ///this is the first time that the otp was requested
        baseProvider.isLoginNextInProgress = false;
        _controller.animateToPage(OtpInputScreen.index,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        setState(() {});
      } else {
        ///the otp was requested to be resent
        _otpScreenKey.currentState.onOtpResendConfirmed(true);
      }
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential user) async {
      log.debug("Verified automagically!");
      if (!baseProvider.isLoginNextInProgress) {
        baseProvider.isLoginNextInProgress = true;
        setState(() {});
      }
      if (_currentPage == OtpInputScreen.index) {
        _otpScreenKey.currentState.onOtpReceived();
      }
      log.debug("Now verifying user");
      bool flag = await baseProvider.authenticateUser(user); //.then((flag) {
      if (flag) {
        log.debug("User signed in successfully");
        _onSignInSuccess();
      } else {
        log.error("User auto sign in didnt work");
        baseProvider.isLoginNextInProgress = false;
        baseProvider.showNegativeAlert('Sign In Failed',
            'Please check your network or number and try again', context);
        setState(() {});
      }
    };

    final PhoneVerificationFailed veriFailed =
        (FirebaseAuthException exception) {
      //codes: 'quotaExceeded'
      if (exception.code == 'quotaExceeded') {
        log.error("Quota for otps exceeded");
      }
      log.error("Verification process failed:  ${exception.message}");
      baseProvider.showNegativeAlert('Sign In Failed',
          'Please check your network or number and try again', context);
      baseProvider.isLoginNextInProgress = false;
      setState(() {});
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this._verificationId,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    lclDbProvider = Provider.of<LocalDBModel>(context, listen: false);
    fcmProvider = Provider.of<FcmListener>(context, listen: false);
    return Scaffold(
      // appBar: BaseUtil.getAppBar(),
      backgroundColor: Color(0xfff1f1f1),
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          LinearProgressIndicator(
              value: _formProgress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                  UiConstants.primaryColor.withBlue(150))),
          new PageView.builder(
            physics: new NeverScrollableScrollPhysics(),
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (BuildContext context, int index) {
              return _pages[index % _pages.length];
            },
            onPageChanged: (int index) {
              setState(() {
                _formProgress = 0.2 * (index + 1);
                _currentPage = index;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (_currentPage == MobileInputScreen.index)
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: RichText(
                          text: new TextSpan(
                            children: [
                              new TextSpan(
                                text: 'By continuing, you agree to our ',
                                style: new TextStyle(color: Colors.black45),
                              ),
                              new TextSpan(
                                text: 'Terms of Service',
                                style: new TextStyle(
                                    color: Colors.black45,
                                    decoration: TextDecoration.underline),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    HapticFeedback.vibrate();
                                    Navigator.of(context).pushNamed('/tnc');
                                  },
                              ),
                            ],
                          ),
                        ))
                    : Container(),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 50.0,
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                UiConstants.primaryColor,
                                UiConstants.primaryColor.withBlue(200),
                              ],
                              begin: Alignment(0.5, -1.0),
                              end: Alignment(0.5, 1.0)),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Material(
                          child: MaterialButton(
                            child: (!baseProvider.isLoginNextInProgress)
                                ? Text(
                                    'NEXT',
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
                              if (!baseProvider.isLoginNextInProgress)
                                _processScreenInput(_currentPage);
                            },
                            highlightColor: Colors.white30,
                            splashColor: Colors.white30,
                          ),
                          color: Colors.transparent,
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  _processScreenInput(int currentPage) async {
    switch (currentPage) {
      case MobileInputScreen.index:
        {
          //in mobile input screen. Get and set mobile/ set error interface if not correct
          if (_mobileScreenKey.currentState.formKey.currentState.validate()) {
            log.debug(
                'Mobile number validated: ${_mobileScreenKey.currentState.getMobile()}');
            this.userMobile = _mobileScreenKey.currentState.getMobile();
            this._verificationId = '+91' + this.userMobile;
            _verifyPhone();
            baseProvider.isLoginNextInProgress = true;
            FocusScope.of(_mobileScreenKey.currentContext).unfocus();
            setState(() {});
          }
          break;
        }
      case OtpInputScreen.index:
        {
          String otp = _otpScreenKey.currentState.otp; //otpInScreen.getOtp();
          if (otp != null && otp.isNotEmpty && otp.length == 6) {
            baseProvider.isLoginNextInProgress = true;
            setState(() {});
            bool flag = await baseProvider.authenticateUser(baseProvider
                .generateAuthCredential(_augmentedVerificationId, otp));
            //.then((flag) {
            if (flag) {
//                otpInScreen.onOtpReceived();
              _otpScreenKey.currentState.onOtpReceived();
              _onSignInSuccess();
            } else {
              baseProvider.showNegativeAlert(
                  'Invalid Otp', 'Please enter a valid otp', context);
              baseProvider.isLoginNextInProgress = false;
              FocusScope.of(_otpScreenKey.currentContext).unfocus();
              setState(() {});
            }
//            });
          } else {
            baseProvider.showNegativeAlert(
                'Enter OTP', 'Please enter a valid one time password', context);
          }
          break;
        }
      case NameInputScreen.index:
        {
          //if(nameInScreen.validate()) {
          if (_nameScreenKey.currentState.formKey.currentState.validate()) {
            if (_nameScreenKey.currentState.selectedDate == null) {
              baseProvider.showNegativeAlert('Invalid details',
                  'Please enter your date of birth', context);
              return false;
            } else if (!_isAdult(_nameScreenKey.currentState.selectedDate)) {
              baseProvider.showNegativeAlert('Invalid details',
                  'You need to be above 18 to join', context);
              return false;
            }
            if (_nameScreenKey.currentState.gen == null ||
                _nameScreenKey.currentState.isInvested == null) {
              baseProvider.showNegativeAlert(
                  'Invalid details', 'Please enter all the fields', context);
              return false;
            }
            baseProvider.isLoginNextInProgress = true;
            setState(() {});
            if (baseProvider.myUser == null) {
              //firebase user should never be null at this point
              baseProvider.myUser = BaseUser.newUser(
                  baseProvider.firebaseUser.uid,
                  formatMobileNumber(baseProvider.firebaseUser.phoneNumber));
            }
            //baseProvider.myUser.name = nameInScreen.getName();
            baseProvider.myUser.name = _nameScreenKey.currentState.name;
            print(baseProvider.myUser.name);
            //String email = nameInScreen.getEmail();
            String email = _nameScreenKey.currentState.email;
            if (email != null && email.isNotEmpty) {
              baseProvider.myUser.email = email;
            }

            String dob = "${_nameScreenKey.currentState.selectedDate.toLocal()}"
                .split(" ")[0];

            baseProvider.myUser.dob = dob;

            int gender = _nameScreenKey.currentState.gen;
            if (gender != null) {
              if (gender == 1) {
                baseProvider.myUser.gender = "M";
              } else if (gender == 0) {
                baseProvider.myUser.gender = "F";
              } else
                baseProvider.myUser.gender = "O";
            }

            bool isInv = _nameScreenKey.currentState.isInvested;
            if (isInv != null) baseProvider.myUser.isInvested = isInv;
            //currentPage = AddressInputScreen.index;
            bool flag = await dbProvider.updateUser(baseProvider.myUser);
            if (flag) {
              log.debug("User object saved successfully");
              _onSignUpComplete();
            } else {
              baseProvider.showNegativeAlert(
                  'Update failed', 'Please try again in sometime', context);
            }
            // _controller.animateToPage(AddressInputScreen.index,
            //     duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          }
          break;
        }
    }
  }

  String formatMobileNumber(String pNumber) {
    if (pNumber != null && pNumber.isNotEmpty) {
      if (RegExp("^[0-9+]*\$").hasMatch(pNumber)) {
        if (pNumber.length == 13 && pNumber.startsWith("+91")) {
          pNumber = pNumber.substring(3);
        } else if (pNumber.length == 12 && pNumber.startsWith("91")) {
          pNumber = pNumber.substring(2);
        }
        if (pNumber.length != 10) return null;
        return pNumber;
      }
    }
    return null;
  }

  bool _isAdult(DateTime dt) {
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

  void _onSignInSuccess() async {
    log.debug("User authenticated. Now check if details previously available.");
    baseProvider.firebaseUser = FirebaseAuth.instance.currentUser;
    log.debug("User is set: " + baseProvider.firebaseUser.uid);
    BaseUser user = await dbProvider.getUser(baseProvider.firebaseUser.uid);
    //user variable is pre cast into User object
    //dbProvider.logDeviceId(fUser.uid); //TODO do someday
    if (baseProvider.isLoginNextInProgress == true) {
      baseProvider.isLoginNextInProgress = false;
      setState(() {});
    }
    if (user == null || (user != null && user.hasIncompleteDetails())) {
      ///First time user!
      log.debug(
          "No existing user details found or found incomplete details for user. Moving to details page");
      baseProvider.myUser = user ??
          BaseUser.newUser(baseProvider.firebaseUser.uid, this.userMobile);
      //Move to name input page
      //set 'tutorial shown' flag to false to ensure tutorial gets shown to the user
      lclDbProvider.saveHomeTutorialComplete = false;
      _controller.animateToPage(NameInputScreen.index,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      ///Existing user
      await BaseAnalytics.analytics.logLogin(loginMethod: 'phonenumber');
      log.debug("User details available: Name: " + user.name);
      baseProvider.myUser = user;
      _onSignUpComplete();
    }
  }

  _onOtpFilled() {
    if (!baseProvider.isLoginNextInProgress) _processScreenInput(_currentPage);
  }

  _onOtpResendRequested() {
    if (baseProvider.isOtpResendCount < 2) {
      baseProvider.isOtpResendCount++;
      _verifyPhone();
    } else {
      _otpScreenKey.currentState.onOtpResendConfirmed(false);
    }
  }

  Future _onSignUpComplete() async {
    baseProvider.isLoginNextInProgress = false;
    await BaseAnalytics.analytics.logSignUp(signUpMethod: 'phonenumber');
    await BaseAnalytics.logUserProfile(baseProvider.myUser);

    await baseProvider.init();
    await fcmProvider.setupFcm();
    Navigator.of(context).pushReplacementNamed('/approot');
    baseProvider.showPositiveAlert(
        'Sign In Complete',
        'Welcome to ${Constants.APP_NAME}, ${baseProvider.myUser.name}',
        context);
    //process complete
    //TODO move to home through animation
  }
}

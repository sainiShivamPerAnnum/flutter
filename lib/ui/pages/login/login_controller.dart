import 'dart:async';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/Buttons/large_button.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input_screen.dart';
import 'package:felloapp/ui/pages/login/screens/name_input_screen.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input_screen.dart';
import 'package:felloapp/ui/pages/login/screens/username.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginController extends StatefulWidget {
  final int initPage;
  static String mobileno;

  LoginController({this.initPage});

  @override
  State<StatefulWidget> createState() => _LoginControllerState(initPage);
}

class _LoginControllerState extends State<LoginController>
    with TickerProviderStateMixin {
  final Log log = new Log("LoginController");
  final int initPage;
  double _formProgress = 0.2;

  _LoginControllerState(this.initPage);

  PageController _controller;
  static BaseUtil baseProvider;
  static DBModel dbProvider;
  static FcmListener fcmProvider;
  static LocalDBModel lclDbProvider;
  static AppState appStateProvider;
  AnimationController animationController;

  String userMobile;
  String _verificationId;
  String _augmentedVerificationId;
  ValueNotifier<double> _pageNotifier;
  static List<Widget> _pages;
  int _currentPage;
  final _mobileScreenKey = new GlobalKey<MobileInputScreenState>();
  final _otpScreenKey = new GlobalKey<OtpInputScreenState>();
  final _nameScreenKey = new GlobalKey<NameInputScreenState>();
  final _usernameKey = new GlobalKey<UsernameState>();

  @override
  void initState() {
    super.initState();
    _currentPage = (initPage != null) ? initPage : MobileInputScreen.index;
    _formProgress = 0.2 * (_currentPage + 1);
    _controller = new PageController(initialPage: _currentPage);
    _controller.addListener(_pageListener);
    _pageNotifier = ValueNotifier(0.0);
    _pages = [
      MobileInputScreen(key: _mobileScreenKey),
      OtpInputScreen(
        key: _otpScreenKey,
        otpEntered: _onOtpFilled,
        resendOtp: _onOtpResendRequested,
        changeNumber: _onChangeNumberRequest,
        mobileNo: this.userMobile,
      ),
      NameInputScreen(key: _nameScreenKey),
      Username(key: _usernameKey)
      // AddressInputScreen(key: _addressScreenKey),
    ];
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )
      ..forward()
      ..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.removeListener(_pageListener);
    _controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  void _pageListener() {
    _pageNotifier.value = _controller.page;
  }

  Future<void> _verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      log.debug('::AUTO_RETRIEVE::INVOKED');
      log.debug("Phone number hasnt been auto verified yet");
      if (_otpScreenKey.currentState != null)
        _otpScreenKey.currentState.onOtpAutoDetectTimeout();
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      log.debug('::SMS_CODE_SENT::INVOKED');
      this._augmentedVerificationId = verId;
      log.debug(
          "User mobile number format verified. Sending otp and verifying");
      if (baseProvider.isOtpResendCount == 0) {
        ///this is the first time that the otp was requested
        baseProvider.isLoginNextInProgress = false;
        _controller.animateToPage(OtpInputScreen.index,
            duration: Duration(milliseconds: 1500), curve: Curves.easeInToLinear);
        setState(() {});
      } else {
        ///the otp was requested to be resent
        _otpScreenKey.currentState.onOtpResendConfirmed(true);
      }
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential user) async {
      log.debug('::VERIFIED_SUCCESS::INVOKED');
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
      log.debug('::VERIFIED_FAILED::INVOKED');
      log.error(exception.stackTrace.toString());
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
    appStateProvider = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Positioned(
            top: kToolbarHeight / 3,
            child: Container(
              alignment: Alignment.center,
              width: SizeConfig.screenWidth,
              child: Image.asset("images/fello_logo.png", height: 40),
            ),
          ),
          new PageView.builder(
            physics: new NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (BuildContext context, int index) {
              //print(index - _controller.page);
              return ValueListenableBuilder(
                  valueListenable: _pageNotifier,
                  builder: (ctx, value, _) {
                    final factorChange = value - index;
                    return Padding(
                      padding: EdgeInsets.only(
                          top: kToolbarHeight * 1.5,
                          left: SizeConfig.blockSizeHorizontal * 16,
                          right: SizeConfig.blockSizeHorizontal * 5),
                      child: Opacity(
                          opacity: (1 - factorChange.abs()).clamp(0.0, 1.0),
                          child: _pages[index % _pages.length]),
                    );
                  });
            },
            onPageChanged: (int index) {
              setState(() {
                _formProgress = 0.2 * (index + 1);
                _currentPage = index;
              });
            },
          ),
          ValueListenableBuilder<double>(
              valueListenable: _pageNotifier,
              builder: (ctx, value, child) {
                return Stack(
                  children: [
                    Positioned(
                      left: SizeConfig.blockSizeHorizontal * 4 + 14,
                      top: kToolbarHeight * 2 + 8,
                      width: 1,
                      child: Container(
                        height:
                            ((SizeConfig.screenHeight - kToolbarHeight * 2) /
                                    4) *
                                value,
                        color: UiConstants.primaryColor,
                      ),
                    ),
                    ProgressBarItem(value: value, index: 0, icon: Icons.phone),
                    ProgressBarItem(
                        value: value, index: 1, icon: Icons.password),
                    ProgressBarItem(
                        value: value,
                        index: 2,
                        icon: Icons.account_circle_rounded),
                    ProgressBarItem(
                        value: value, index: 3, icon: Icons.alternate_email),
                  ],
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (_currentPage == MobileInputScreen.index)
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: RichText(
                          text: new TextSpan(
                            children: [
                              new TextSpan(
                                text: 'By continuing, you agree to our ',
                                style: GoogleFonts.montserrat(
                                    fontSize: SizeConfig.smallTextSize * 1.2,
                                    color: Colors.black45),
                              ),
                              new TextSpan(
                                text: 'Terms of Service',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black45,
                                    fontSize: SizeConfig.smallTextSize * 1.2,
                                    decoration: TextDecoration.underline),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    Haptic.vibrate();
                                    BaseUtil.launchUrl(
                                        'https://fello.in/policy/tnc');
                                    // appStateProvider.currentAction = PageAction(
                                    //     state: PageState.addPage,
                                    //     page: TncPageConfig);
                                  },
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                        width: SizeConfig.screenWidth -
                            SizeConfig.blockSizeHorizontal * 10,
                        child: LargeButton(
                          child: (!baseProvider.isLoginNextInProgress)
                              ? Text(
                                  _currentPage == Username.index
                                      ? 'FINISH'
                                      : 'NEXT',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.white),
                                )
                              : SpinKitThreeBounce(
                                  color: UiConstants.spinnerColor2,
                                  size: 18.0,
                                ),
                          onTap: () {
                            if (!baseProvider.isLoginNextInProgress)
                              _processScreenInput(_currentPage);
                          },
                        ),

                        // Material(
                        //   child: MaterialButton(
                        //     child: (!baseProvider.isLoginNextInProgress)
                        //         ? Text(
                        //             _currentPage == Username.index
                        //                 ? 'FINISH'
                        //                 : 'NEXT',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .button
                        //                 .copyWith(color: Colors.white),
                        //           )
                        //         : SpinKitThreeBounce(
                        //             color: UiConstants.spinnerColor2,
                        //             size: 18.0,
                        //           ),
                        //     onPressed: () {
                        //       if (!baseProvider.isLoginNextInProgress)
                        //         _processScreenInput(_currentPage);
                        //     },
                        //     highlightColor: Colors.white30,
                        //     splashColor: Colors.white30,
                        //   ),
                        //   color: Colors.transparent,
                        //   borderRadius: new BorderRadius.circular(30.0),
                        // ),
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
    FocusScope.of(context).unfocus();
    switch (currentPage) {
      case MobileInputScreen.index:
        {
          //in mobile input screen. Get and set mobile/ set error interface if not correct
          if (_mobileScreenKey.currentState.formKey.currentState.validate()) {
            log.debug(
                'Mobile number validated: ${_mobileScreenKey.currentState.getMobile()}');
            this.userMobile = _mobileScreenKey.currentState.getMobile();

            setState(() {
              LoginController.mobileno = this.userMobile;
            });
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
            if (flag) {
              AppState.isOnboardingInProgress = true;
              _otpScreenKey.currentState.onOtpReceived();
              _onSignInSuccess();
            } else {
              baseProvider.showNegativeAlert(
                  'Invalid Otp', 'Please enter a valid otp', context);
              baseProvider.isLoginNextInProgress = false;
              FocusScope.of(_otpScreenKey.currentContext).unfocus();
              setState(() {});
            }
          } else {
            baseProvider.showNegativeAlert(
                'Enter OTP', 'Please enter a valid one time password', context);
          }
          break;
        }
      case NameInputScreen.index:
        {
          //if(nameInScreen.validate()) {

          if (_nameScreenKey.currentState.formKey.currentState.validate() &&
              _nameScreenKey.currentState.isValidDate()) {
            if (!_nameScreenKey.currentState.isEmailEntered) {
              baseProvider.showNegativeAlert(
                  'Email field empty', 'Please enter a valid email', context);
              return false;
            }

            if (_nameScreenKey.currentState.selectedDate == null) {
              baseProvider.showNegativeAlert('Invalid Date of Birth',
                  'Please enter a valid date of birth', context);
              return false;
            } else if (!_isAdult(_nameScreenKey.currentState.selectedDate)) {
              baseProvider.showNegativeAlert(
                  'Ineligible', 'You need to be above 18 to join', context);
              return false;
            }
            if (_nameScreenKey.currentState.gen == null ||
                _nameScreenKey.currentState.isInvested == null) {
              baseProvider.showNegativeAlert(
                  'Invalid details', 'Please enter all the fields', context);
              return false;
            }
            FocusScope.of(_nameScreenKey.currentContext).unfocus();
            baseProvider.isLoginNextInProgress = true;
            setState(() {});
            if (baseProvider.myUser == null) {
              //firebase user should never be null at this point
              baseProvider.myUser = BaseUser.newUser(
                  baseProvider.firebaseUser.uid,
                  formatMobileNumber(baseProvider.firebaseUser.phoneNumber));
            }
            //baseProvider.myUser.name = nameInScreen.getName();
            baseProvider.myUser.name = _nameScreenKey.currentState.name.trim();
            String email = _nameScreenKey.currentState.email.trim();
            if (email != null && email.isNotEmpty) {
              baseProvider.myUser.email = email;
            }

            String dob = "${_nameScreenKey.currentState.selectedDate.toLocal()}"
                .split(" ")[0];

            baseProvider.myUser.dob = dob.trim();

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

            Future.delayed(Duration(seconds: 1), () {
              baseProvider.isLoginNextInProgress = false;
              setState(() {});
            }).then((value) {
              _controller.animateToPage(Username.index,
                  duration: Duration(seconds: 1), curve: Curves.easeInToLinear);
            });
          }
          break;
        }

      case Username.index:
        {
          if (_usernameKey.currentState.formKey.currentState.validate()) {
            if (!await _usernameKey.currentState.validate()) {
              return false;
            }
            if (!_usernameKey.currentState.isLoading &&
                _usernameKey.currentState.isValid) {
              baseProvider.isLoginNextInProgress = true;
              setState(() {});

              String username =
                  _usernameKey.currentState.username.replaceAll('.', '@');
              if (await dbProvider.checkIfUsernameIsAvailable(username)) {
                bool res = await dbProvider.setUsername(
                    username, baseProvider.firebaseUser.uid);
                if (res) {
                  baseProvider.myUser.username = username;
                  bool flag = await dbProvider.updateUser(baseProvider.myUser);
                  if (flag) {
                    log.debug("User object saved successfully");
                    _onSignUpComplete();
                  } else {
                    baseProvider.showNegativeAlert('Update failed',
                        'Please try again in sometime', context);
                    baseProvider.isLoginNextInProgress = false;
                    setState(() {});
                  }
                } else {
                  baseProvider.showNegativeAlert('Username update failed',
                      'Please try again in sometime', context);
                  baseProvider.isLoginNextInProgress = false;
                  setState(() {});
                }
              } else {
                baseProvider.showNegativeAlert('username not available',
                    'Please choose another username', context);
                baseProvider.isLoginNextInProgress = false;
                setState(() {});
              }
            } else {
              baseProvider.showNegativeAlert(
                  "Error", "Please try again", context);
            }
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
      lclDbProvider.setShowHomeTutorial = true;
      lclDbProvider.setShowTambolaTutorial = true;
      _controller.animateToPage(NameInputScreen.index,
          duration: Duration(seconds: 1), curve: Curves.easeInToLinear);
      //_nameScreenKey.currentState.showEmailOptions();
    } else {
      ///Existing user
      await BaseAnalytics.analytics.logLogin(loginMethod: 'phonenumber');
      lclDbProvider.setShowHomeTutorial = false;
      lclDbProvider.setShowTambolaTutorial = false;
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

  _onChangeNumberRequest() {
    if (!baseProvider.isLoginNextInProgress) {
      AppState.isOnboardingInProgress = false;
      _controller.animateToPage(MobileInputScreen.index,
          duration: Duration(milliseconds: 300), curve: Curves.easeInToLinear);
    }
  }

  Future _onSignUpComplete() async {
    baseProvider.isLoginNextInProgress = false;
    await BaseAnalytics.analytics.logSignUp(signUpMethod: 'phonenumber');
    await BaseAnalytics.logUserProfile(baseProvider.myUser);

    await baseProvider.init();
    await fcmProvider.setupFcm();
    AppState.isOnboardingInProgress = false;
    appStateProvider.currentAction =
        PageAction(state: PageState.replaceAll, page: RootPageConfig);
    baseProvider.showPositiveAlert(
        'Sign In Complete',
        'Welcome to ${Constants.APP_NAME}, ${baseProvider.myUser.name}',
        context);
    //process complete
    //TODO move to home through animation
  }
}

class ProgressBarItem extends StatelessWidget {
  final double value;
  final int index;
  final IconData icon;

  const ProgressBarItem({this.value, this.index, this.icon});

  @override
  Widget build(BuildContext context) {
    final topPos = kToolbarHeight * 2 +
        5 +
        ((SizeConfig.screenHeight - kToolbarHeight * 2) / 4) * index;
    return Positioned(
      left: SizeConfig.blockSizeHorizontal * 4.5,
      top: topPos,
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value > index ? UiConstants.primaryColor : Colors.white,
          border: Border.all(color: UiConstants.primaryColor),
        ),
        child: Icon(
          icon,
          size: 16,
          color: value > index ? Colors.white : UiConstants.primaryColor,
        ),
      ),
    );
  }
}

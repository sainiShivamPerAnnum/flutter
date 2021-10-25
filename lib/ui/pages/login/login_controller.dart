//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input_screen.dart';
import 'package:felloapp/ui/pages/login/screens/name_input_screen.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input_screen.dart';
import 'package:felloapp/ui/pages/login/screens/username.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

//Dart and Flutter Imports
import 'dart:async';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//Pub Imports
import 'package:firebase_auth/firebase_auth.dart';
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
  // static FcmListener fcmProvider;
  static LocalDBModel lclDbProvider;
  static AppState appStateProvider;
  final UserService userService = locator<UserService>();
  final FcmListener fcmListener = locator<FcmListener>();
  final AugmontModel augmontProvider = locator<AugmontModel>();
  AnimationController animationController;

  String userMobile;
  String _verificationId;
  String _augmentedVerificationId;
  String state;
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
            duration: Duration(milliseconds: 1500),
            curve: Curves.easeInToLinear);
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
        BaseUtil.showNegativeAlert(
          'Sign In Failed',
          'Please check your network or number and try again',
        );
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
      BaseUtil.showNegativeAlert(
        'Sign In Failed',
        'Please check your network or number and try again',
      );
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
    // fcmProvider = Provider.of<FcmListener>(context, listen: false);
    appStateProvider = Provider.of<AppState>(context, listen: false);
    S locale = S.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: UiConstants.primaryColor,
      body: HomeBackground(
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight / 2,
                color: Colors.white,
              ),
            ),
            SafeArea(
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: Column(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: _pageNotifier,
                        builder: (ctx, value, child) {
                          return value < 2.0
                              ? SizedBox(
                                  height: kToolbarHeight,
                                )
                              : FelloAppBar(
                                  leading:
                                      FelloAppBarBackButton(onBackPress: () {
                                    if (value == 3)
                                      _controller.previousPage(
                                          duration: Duration(milliseconds: 600),
                                          curve: Curves.easeInOut);
                                    else
                                      AppState.delegate.appState.currentAction =
                                          PageAction(
                                              state: PageState.replaceAll,
                                              page: SplashPageConfig);
                                  }),
                                  title: value < 3
                                      ? locale.abCompleteYourProfile
                                      : locale.abGamingName,
                                );
                        }),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.padding40),
                          topRight: Radius.circular(SizeConfig.padding40),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: PageView.builder(
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
                                    return Opacity(
                                        opacity: (1 - factorChange.abs())
                                            .clamp(0.0, 1.0),
                                        child: _pages[index % _pages.length]);
                                  });
                            },
                            onPageChanged: (int index) {
                              setState(() {
                                _formProgress = 0.2 * (index + 1);
                                _currentPage = index;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Container(
                          width: SizeConfig.screenWidth -
                              SizeConfig.pageHorizontalMargins * 2,
                          child: FelloButtonLg(
                            child: (!baseProvider.isLoginNextInProgress)
                                ? Text(
                                    _currentPage == Username.index
                                        ? 'FINISH'
                                        : 'NEXT',
                                    style:
                                        TextStyles.body2.colour(Colors.white),
                                  )
                                : SpinKitThreeBounce(
                                    color: UiConstants.spinnerColor2,
                                    size: 18.0,
                                  ),
                            onPressed: () {
                              if (!baseProvider.isLoginNextInProgress)
                                _processScreenInput(_currentPage);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
              _otpScreenKey.currentState.pinEditingController.text = "";
              BaseUtil.showNegativeAlert(
                  'Invalid Otp', 'Please enter a valid otp');
              baseProvider.isLoginNextInProgress = false;
              FocusScope.of(_otpScreenKey.currentContext).unfocus();
              setState(() {});
            }
          } else {
            BaseUtil.showNegativeAlert(
                'Enter OTP', 'Please enter a valid one time password');
          }
          break;
        }
      case NameInputScreen.index:
        {
          //if(nameInScreen.validate()) {

          if (_nameScreenKey.currentState.formKey.currentState.validate() &&
              _nameScreenKey.currentState.isValidDate()) {
            if (!_nameScreenKey.currentState.isEmailEntered) {
              BaseUtil.showNegativeAlert(
                  'Email field empty', 'Please enter a valid email');
              return false;
            }

            if (_nameScreenKey.currentState.selectedDate == null) {
              BaseUtil.showNegativeAlert(
                'Invalid Date of Birth',
                'Please enter a valid date of birth',
              );
              return false;
            } else if (!_isAdult(_nameScreenKey.currentState.selectedDate)) {
              BaseUtil.showNegativeAlert(
                'Ineligible',
                'You need to be above 18 to join',
              );
              return false;
            }
            if (_nameScreenKey.currentState.gen == null ||
                _nameScreenKey.currentState.isInvested == null) {
              BaseUtil.showNegativeAlert(
                'Invalid details',
                'Please enter all the fields',
              );
              return false;
            }
            if (_nameScreenKey.currentState.state == null) {
              BaseUtil.showNegativeAlert(
                'Invalid details',
                'Please enter your state of residence',
              );
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
            state = _nameScreenKey.currentState.state;
            baseProvider.myUser.isAugmontOnboarded = true;

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
                _usernameKey.currentState.enabled = false;
                setState(() {});
                bool res = await dbProvider.setUsername(
                    username, baseProvider.firebaseUser.uid);
                if (res) {
                  baseProvider.myUser.username = username;
                  bool flag = await dbProvider.updateUser(baseProvider.myUser);
                  UserAugmontDetail detail = await augmontProvider
                      .createSimpleUser(baseProvider.myUser.mobile, state);
                  if (detail != null && flag) {
                    log.debug("User object saved successfully");
                    _onSignUpComplete();
                  }
                  // if (detail == null) {
                  //   BaseUtil.showNegativeAlert('Registration Failed',
                  //       'Failed to regsiter at the moment. Please try again.');
                  //   return;
                  // } else {
                  //   ///show completion animation
                  //   BaseUtil.showPositiveAlert('Registration Successful',
                  //       'You are successfully registered!');
                  //   // AppState.delegate.appState.currentAction =
                  //   //     PageAction(state: PageState.addPage, page: AugmontGoldBuyPageConfig);
                  // }
                  // if (flag) {
                  // }
                  else {
                    BaseUtil.showNegativeAlert(
                      'Update failed',
                      'Please try again in sometime',
                    );
                    _usernameKey.currentState.enabled = false;

                    baseProvider.isLoginNextInProgress = false;
                    setState(() {});
                  }
                } else {
                  BaseUtil.showNegativeAlert(
                    'Username update failed',
                    'Please try again in sometime',
                  );
                  _usernameKey.currentState.enabled = false;

                  baseProvider.isLoginNextInProgress = false;
                  setState(() {});
                }
              } else {
                BaseUtil.showNegativeAlert(
                  'username not available',
                  'Please choose another username',
                );
                _usernameKey.currentState.enabled = false;

                baseProvider.isLoginNextInProgress = false;
                setState(() {});
              }
            } else {
              BaseUtil.showNegativeAlert(
                "Error",
                "Please try again",
              );
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
    //userService.baseUser = FirebaseAuth.instance.currentUser;
    log.debug("User is set: " + baseProvider.firebaseUser.uid);
    BaseUser user = await dbProvider.getUser(baseProvider.firebaseUser.uid);
    //user variable is pre cast into User object
    //dbProvider.logDeviceId(fUser.uid); //TODO do someday
    if (user == null || (user != null && user.hasIncompleteDetails())) {
      if (baseProvider.isLoginNextInProgress == true) {
        baseProvider.isLoginNextInProgress = false;
        setState(() {});
      }

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
    await BaseAnalytics.analytics.logSignUp(signUpMethod: 'phonenumber');
    await BaseAnalytics.logUserProfile(baseProvider.myUser);
    await userService.init();
    await baseProvider.init();
    await fcmListener.setupFcm();
    AppState.isOnboardingInProgress = false;
    if (baseProvider.isLoginNextInProgress == true) {
      baseProvider.isLoginNextInProgress = false;
      setState(() {});
    }
    appStateProvider.currentAction =
        PageAction(state: PageState.replaceAll, page: RootPageConfig);
    BaseUtil.showPositiveAlert(
      'Sign In Complete',
      'Welcome to ${Constants.APP_NAME}, ${baseProvider.myUser.name}',
    );
    //process complete
    //TODO move to home through animation
  }
}

// (_currentPage == MobileInputScreen.index)
//     ? Padding(
//         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//         child: RichText(
//           text: new TextSpan(
//             children: [
//               new TextSpan(
//                 text: 'By continuing, you agree to our ',
//                 style: GoogleFonts.montserrat(
//                     fontSize: SizeConfig.smallTextSize * 1.2,
//                     color: Colors.black45),
//               ),
//               new TextSpan(
//                 text: 'Terms of Service',
//                 style: GoogleFonts.montserrat(
//                     color: Colors.black45,
//                     fontSize: SizeConfig.smallTextSize * 1.2,
//                     decoration: TextDecoration.underline),
//                 recognizer: new TapGestureRecognizer()
//                   ..onTap = () {
//                     Haptic.vibrate();
//                     BaseUtil.launchUrl(
//                         'https://fello.in/policy/tnc');
//                     // appStateProvider.currentAction = PageAction(
//                     //     state: PageState.addPage,
//                     //     page: TncPageConfig);
//                   },
//               ),
//             ],
//           ),
//         ),
//       )
//     : Container(),

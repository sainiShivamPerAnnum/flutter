import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/golden_ticket_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/login/login_controller_view.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input/otp_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/username_input/username_input_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

enum LoginSource { FIREBASE, TRUECALLER }

class LoginControllerViewModel extends BaseModel {
  //Locators
  final fcmListener = locator<FcmListener>();
  final augmontProvider = locator<AugmontModel>();
  final _analyticsService = locator<AnalyticsService>();
  final userService = locator<UserService>();
  final logger = locator<CustomLogger>();
  final apiPaths = locator<ApiPath>();
  final baseProvider = locator<BaseUtil>();
  final dbProvider = locator<DBModel>();
  final _userRepo = locator<UserRepository>();
  static LocalDBModel lclDbProvider = locator<LocalDBModel>();

  //Controllers
  PageController _controller;

  // static appStateProvider
  static AppState appStateProvider = AppState.delegate.appState;

  //Screen States
  final _mobileScreenKey = new GlobalKey<MobileInputScreenViewState>();
  final _otpScreenKey = new GlobalKey<OtpInputScreenState>();
  final _nameScreenKey = new GlobalKey<NameInputScreenState>();
  final _usernameKey = new GlobalKey<UsernameState>();

//Private Variables
  double _formProgress = 0.2;
  bool _isSignup = false;
  bool _loginUsingTrueCaller = false;
  get loginUsingTrueCaller => this._loginUsingTrueCaller;

  set loginUsingTrueCaller(value) {
    this._loginUsingTrueCaller = value;
    notifyListeners();
  }

  String userMobile;
  String _verificationId;
  String _augmentedVerificationId;
  String cstate;
  int _currentPage;
  ValueNotifier<double> _pageNotifier;
  StreamSubscription streamSubscription;
  static List<Widget> _pages;

//Getters and Setters
  get controller => _controller;
  get pageNotifier => _pageNotifier;
  get pages => _pages;
  get currentPage => _currentPage;
  get formProgress => _formProgress;

  set currentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  set formProgress(double progress) {
    _formProgress = progress;
    notifyListeners();
  }

  init(initPage) {
    _currentPage = (initPage != null) ? initPage : MobileInputScreenView.index;
    _formProgress = 0.2 * (_currentPage + 1);
    _controller = new PageController(initialPage: _currentPage);
    _controller.addListener(_pageListener);
    _pageNotifier = ValueNotifier(0.0);
    _pages = [
      MobileInputScreenView(key: _mobileScreenKey),
      OtpInputScreen(
        key: _otpScreenKey,
        otpEntered: _onOtpFilled,
        resendOtp: _onOtpResendRequested,
        changeNumber: _onChangeNumberRequest,
        mobileNo: this.userMobile,
      ),
      NameInputScreen(key: _nameScreenKey),
      Username(key: _usernameKey)
    ];
  }

  processScreenInput(int currentPage) async {
    FocusScope.of(AppState.delegate.navigatorKey.currentContext).unfocus();
    switch (currentPage) {
      case MobileInputScreenView.index:
        {
          //in mobile input screen. Get and set mobile/ set error interface if not correct
          if (_mobileScreenKey.currentState.model.formKey.currentState
              .validate()) {
            logger.d(
                'Mobile number validated: ${_mobileScreenKey.currentState.model.getMobile()}');
            this.userMobile = _mobileScreenKey.currentState.model.getMobile();

            LoginControllerView.mobileno = this.userMobile;
            notifyListeners();

            ///disable regular numbers for QA
            if (FlavorConfig.isQA() &&
                !this.userMobile.startsWith('999990000')) {
              BaseUtil.showNegativeAlert('Mobile number not allowed',
                  'Only dummy numbers are allowed in QA mode');
              break;
            }
            _analyticsService.track(
              eventName: AnalyticsEvents.signupEnterMobile,
            );
            this._verificationId = '+91' + this.userMobile;
            _verifyPhone();
            FocusScope.of(_mobileScreenKey.currentContext).unfocus();
            setState(ViewState.Busy);
          }
          break;
        }
      case OtpInputScreen.index:
        {
          String otp =
              _otpScreenKey.currentState.model.otp; //otpInScreen.getOtp();
          if (otp != null && otp.isNotEmpty && otp.length == 6) {
            setState(ViewState.Busy);
            bool flag = await baseProvider.authenticateUser(baseProvider
                .generateAuthCredential(_augmentedVerificationId, otp));
            if (flag) {
              _analyticsService.track(eventName: AnalyticsEvents.mobileOtpDone);
              AppState.isOnboardingInProgress = true;
              _otpScreenKey.currentState.model.onOtpReceived();

              _onSignInSuccess(LoginSource.FIREBASE);
            } else {
              _otpScreenKey.currentState.model.pinEditingController.text = "";
              BaseUtil.showNegativeAlert(
                  'Invalid Otp', 'Please enter a valid otp');

              FocusScope.of(_otpScreenKey.currentContext).unfocus();
              setState(ViewState.Idle);
            }
          } else {
            BaseUtil.showNegativeAlert(
                'Enter OTP', 'Please enter a valid one time password');
          }
          break;
        }
      case NameInputScreen.index:
        {
          if (_nameScreenKey.currentState.model.formKey.currentState
                  .validate() &&
              _nameScreenKey.currentState.model.isValidDate()) {
            if (!_nameScreenKey.currentState.model.isEmailEntered) {
              BaseUtil.showNegativeAlert(
                  'Email field empty', 'Please enter a valid email');
              return false;
            }

            if (_nameScreenKey.currentState.model.selectedDate == null) {
              BaseUtil.showNegativeAlert(
                'Invalid Date of Birth',
                'Please enter a valid date of birth',
              );
              return false;
            } else if (!_isAdult(
                _nameScreenKey.currentState.model.selectedDate)) {
              BaseUtil.showNegativeAlert(
                'Ineligible',
                'You need to be above 18 to join',
              );
              return false;
            }
            if (_nameScreenKey.currentState.gen == null) {
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
            setState(ViewState.Busy);
            if (userService.baseUser == null) {
              //firebase user should never be null at this point
              userService.baseUser = BaseUser.newUser(
                  userService.firebaseUser.uid,
                  _formatMobileNumber(LoginControllerView.mobileno));
            }

            userService.baseUser.name =
                _nameScreenKey.currentState.model.name.trim();

            String email = _nameScreenKey.currentState.model.email.trim();

            if (email != null && email.isNotEmpty) {
              userService.baseUser.email = email;
            }

            userService.baseUser.isEmailVerified =
                _nameScreenKey.currentState.model.isEmailVerified;

            String dob =
                "${_nameScreenKey.currentState.model.selectedDate.toLocal()}"
                    .split(" ")[0];

            userService.baseUser.dob = dob.trim();

            int gender = _nameScreenKey.currentState.gen;
            if (gender != null) {
              if (gender == 1) {
                userService.baseUser.gender = "M";
              } else if (gender == 0) {
                userService.baseUser.gender = "F";
              } else
                userService.baseUser.gender = "O";
            }

            cstate = _nameScreenKey.currentState.state;

            await CacheManager.writeCache(
                key: "UserAugmontState", value: cstate, type: CacheType.string);

            setState(ViewState.Idle);

            _analyticsService.track(
              eventName: AnalyticsEvents.profileInformationAdded,
              properties: {'userId': userService?.baseUser?.uid},
            );

            _controller
                .animateToPage(Username.index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInToLinear)
                .then((value) =>
                    _usernameKey.currentState.focusNode.requestFocus());
          }
          break;
        }

      case Username.index:
        {
          if (_usernameKey.currentState.model.formKey.currentState.validate()) {
            if (!await _usernameKey.currentState.model.validate()) {
              return false;
            }

            String refCode = _usernameKey.currentState.model.getReferralCode();
            if (refCode != null && refCode.isNotEmpty)
              BaseUtil.manualReferralCode = refCode;

            if (!_usernameKey.currentState.model.isLoading &&
                _usernameKey.currentState.model.isValid) {
              setState(ViewState.Busy);

              String username =
                  _usernameKey.currentState.model.username.replaceAll('.', '@');

              if (await dbProvider.checkIfUsernameIsAvailable(username)) {
                _usernameKey.currentState.model.enabled = false;
                notifyListeners();
                bool res = await dbProvider.setUsername(
                    username, userService.firebaseUser.uid);
                if (res) {
                  userService.baseUser.username = username;
                  bool flag = false;
                  logger.d(userService.baseUser.toJson().toString());

                  try {
                    final token = await _getBearerToken();
                    final ApiResponse response =
                        await _userRepo.setNewUser(userService.baseUser, token);

                    final gtId = response.model['gtId'];
                    response.model['flag'] ? flag = true : flag = false;

                    logger.d("Is Golden Ticket Rewarded: $gtId");
                    if (gtId != null && gtId.toString().isNotEmpty)
                      GoldenTicketService.goldenTicketId = gtId;
                  } catch (e) {
                    logger.d(e);
                    _usernameKey.currentState.model.enabled = false;
                    flag = false;
                  }

                  if (flag) {
                    _analyticsService.track(
                      eventName: AnalyticsEvents.userNameAdded,
                      properties: {'userId': userService?.baseUser?.uid},
                    );
                    logger.d("User object saved successfully");
                    userService.showOnboardingTutorial = true;
                    _onSignUpComplete();
                  } else {
                    BaseUtil.showNegativeAlert(
                      'Update failed',
                      'Please try again in sometime',
                    );
                    _usernameKey.currentState.model.enabled = false;

                    setState(ViewState.Idle);
                  }
                } else {
                  BaseUtil.showNegativeAlert(
                    'Username update failed',
                    'Please try again in sometime',
                  );
                  _usernameKey.currentState.model.enabled = false;

                  setState(ViewState.Idle);
                }
              } else {
                BaseUtil.showNegativeAlert(
                  'username not available',
                  'Please choose another username',
                );
                _usernameKey.currentState.model.enabled = false;

                setState(ViewState.Idle);
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

  void _onSignInSuccess(LoginSource source) async {
    logger.d("User authenticated. Now check if details previously available.");
    userService.firebaseUser = FirebaseAuth.instance.currentUser;
    logger.d("User is set: " + userService.firebaseUser.uid);
    ApiResponse<BaseUser> user =
        await dbProvider.getUser(userService.firebaseUser.uid);
    if (user.code == 400) {
      BaseUtil.showNegativeAlert('Your account is under maintenance',
          'Please reach out to customer support');
      setState(ViewState.Idle);
      _controller.animateToPage(MobileInputScreenView.index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInToLinear);
    } else if (user.model == null ||
        (user.model != null && user.model.hasIncompleteDetails())) {
      setState(ViewState.Idle);

      ///First time user!
      _isSignup = true;
      logger.d(
          "No existing user details found or found incomplete details for user. Moving to details page");

      //Move to name input page
      BaseUtil.isNewUser = true;
      BaseUtil.isFirstFetchDone = false;
      if (source == LoginSource.FIREBASE)
        _controller.animateToPage(NameInputScreen.index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInToLinear);
      else if (source == LoginSource.TRUECALLER)
        _controller.jumpToPage(
          NameInputScreen.index,
        );
      loginUsingTrueCaller = false;
      //_nameScreenKey.currentState.showEmailOptions();
    } else {
      ///Existing user
      await BaseAnalytics.analytics.logLogin(loginMethod: 'phonenumber');
      logger.d("User details available: Name: " + user.model.name);
      userService.baseUser = user.model;
      _onSignUpComplete();
    }
  }

  Future _onSignUpComplete() async {
    if (_isSignup) {
      await BaseAnalytics.analytics.logSignUp(signUpMethod: 'phonenumber');
      _analyticsService.track(eventName: AnalyticsEvents.signupComplete);
      _analyticsService.trackSignup(userService.baseUser.uid);
    }

    await BaseAnalytics.logUserProfile(userService.baseUser);
    await userService.init();
    await baseProvider.init();
    await fcmListener.setupFcm();
    logger.i("Calling analytics init for new onborded user");
    await _analyticsService.login(
      isOnboarded: userService.isUserOnborded,
      baseUser: userService.baseUser,
    );
    AppState.isOnboardingInProgress = false;
    setState(ViewState.Idle);
    appStateProvider.rootIndex = 1;

    ///check if the account is blocked
    if (userService.baseUser != null && userService.baseUser.isBlocked) {
      AppState.isUpdateScreen = true;
      appStateProvider.currentAction =
          PageAction(state: PageState.replaceAll, page: BlockedUserPageConfig);
      return;
    }
    appStateProvider.currentAction =
        PageAction(state: PageState.replaceAll, page: RootPageConfig);
    BaseUtil.showPositiveAlert(
      'Sign In Complete',
      'Welcome to ${Constants.APP_NAME}, ${userService.baseUser.name}',
    );
    //process complete
  }

  Future<void> _verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      logger.d('::AUTO_RETRIEVE::INVOKED');
      logger.d("Phone number hasnt been auto verified yet");
      if (_otpScreenKey.currentState != null)
        _otpScreenKey.currentState.model.onOtpAutoDetectTimeout();
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      logger.d('::SMS_CODE_SENT::INVOKED');
      this._augmentedVerificationId = verId;
      logger.d("User mobile number format verified. Sending otp and verifying");
      if (baseProvider.isOtpResendCount == 0) {
        ///this is the first time that the otp was requested

        _controller.animateToPage(OtpInputScreen.index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInToLinear);
        setState(ViewState.Idle);
      } else {
        ///the otp was requested to be resent
        _otpScreenKey.currentState.model.onOtpResendConfirmed(true);
      }
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential user) async {
      logger.d('::VERIFIED_SUCCESS::INVOKED');
      logger.d("Verified automagically!");
      setState(ViewState.Busy);
      if (_currentPage == OtpInputScreen.index) {
        _otpScreenKey.currentState.model.onOtpReceived();
      }
      logger.d("Now verifying user");
      bool flag = await baseProvider.authenticateUser(user); //.then((flag) {
      if (flag) {
        logger.d("User signed in successfully");
        _onSignInSuccess(LoginSource.FIREBASE);
      } else {
        logger.e("User auto sign in didnt work");

        BaseUtil.showNegativeAlert(
          'Sign In Failed',
          'Please check your network or number and try again',
        );
        setState(ViewState.Idle);
      }
    };

    final PhoneVerificationFailed veriFailed =
        (FirebaseAuthException exception) {
      logger.d('::VERIFIED_FAILED::INVOKED');
      logger.e(exception.stackTrace.toString());
      String exceptionMessage =
          'Please check your network or number and try again';
      //codes: 'quotaExceeded'
      if (exception.code == 'too-many-requests') {
        logger.e("Quota for otps exceeded");
        exceptionMessage =
            "You have exceeded the number of allowed OTP attempts. Please try again in sometime";
      }
      logger.e(exception.code);
      logger.e("Verification process failed:  ${exception.message}");
      BaseUtil.showNegativeAlert(
        'Sign In Failed',
        exceptionMessage,
      );
      setState(ViewState.Idle);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this._verificationId,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  Future<String> _getBearerToken() async {
    String token = await userService.firebaseUser.getIdToken();
    logger.d("BearerToken: $token");
    return token;
  }

  String _formatMobileNumber(String pNumber) {
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

  _onOtpFilled() {
    if (this.state == ViewState.Idle) processScreenInput(_currentPage);
  }

  _onOtpResendRequested() {
    if (baseProvider.isOtpResendCount < 2) {
      _verifyPhone();
    } else {
      _otpScreenKey.currentState.model.onOtpResendConfirmed(false);
      BaseUtil.showNegativeAlert(
        'Sign In Failed',
        "You have exceeded the number of allowed OTP attempts. Please try again in sometime",
      );
    }
  }

  _onChangeNumberRequest() {
    if (this.state == ViewState.Idle) {
      AppState.isOnboardingInProgress = false;
      _controller.animateToPage(MobileInputScreenView.index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInToLinear);
    }
  }

  void _pageListener() {
    _pageNotifier.value = _controller.page;
  }

  void initTruecaller() async {
    TruecallerSdk.initializeSDK(
        sdkOptions: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP);
    TruecallerSdk.isUsable.then((isUsable) {
      isUsable ? TruecallerSdk.getProfile : print("***Not usable***");
    });

    streamSubscription =
        TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
      switch (truecallerSdkCallback.result) {
        case TruecallerSdkCallbackResult.success:
          String phNo = truecallerSdkCallback.profile?.phoneNumber;
          loginUsingTrueCaller = true;
          logger.d("Truecaller no: $phNo");

          _analyticsService.track(
              eventName: AnalyticsEvents.truecallerVerified);
          AppState.isOnboardingInProgress = true;
          _authenticateTrucallerUser(phNo);
          break;
        case TruecallerSdkCallbackResult.failure:
          int errorCode = truecallerSdkCallback.error?.code;
          logger.e(errorCode);
          break;
        case TruecallerSdkCallbackResult.verification:
          print("Verification Required!!");
          break;
        default:
          print("Invalid result");
      }
    });
  }

  Future<void> _authenticateTrucallerUser(String phno) async {
    //Make api call to get custom token
    final ApiResponse<String> tokenRes =
        await _userRepo.getCustomUserToken(phno);

    if (tokenRes.code == 400) {
      BaseUtil.showNegativeAlert(
          "Authentication failed", tokenRes.errorMessage);
    }

    final String token = tokenRes.model;
    LoginControllerView.mobileno = phno;
    _mobileScreenKey.currentState.model.mobileController.text =
        _formatMobileNumber(phno);
    //Authenticate using custom token
    FirebaseAuth.instance.signInWithCustomToken(token).then((res) {
      logger.i("New Firebase User: ${res.additionalUserInfo.isNewUser}");
      //on successful authentication
      _onSignInSuccess(LoginSource.TRUECALLER);
    }).catchError((e) {
      logger.e(e);
      BaseUtil.showNegativeAlert("Authentication failed",
          "Please enter your mobile number to authenticate.");
      loginUsingTrueCaller = false;
    });
  }

  exit() {
    _controller.removeListener(_pageListener);
    _controller.dispose();
    streamSubscription?.cancel();
  }
}

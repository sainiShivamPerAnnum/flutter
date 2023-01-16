import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/login/login_controller_view.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input/otp_input_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

import '../../../util/haptic.dart';

enum LoginSource { FIREBASE, TRUECALLER }

class LoginControllerViewModel extends BaseViewModel {
  //Locators
  final FcmListener? fcmListener = locator<FcmListener>();
  final AugmontService? augmontProvider = locator<AugmontService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final UserService userService = locator<UserService>();
  final UserCoinService? _userCoinService = locator<UserCoinService>();
  final CustomLogger? logger = locator<CustomLogger>();
  final ApiPath? apiPaths = locator<ApiPath>();
  final BaseUtil? baseProvider = locator<BaseUtil>();
  final DBModel? dbProvider = locator<DBModel>();
  final UserRepository? _userRepo = locator<UserRepository>();
  final JourneyService? _journeyService = locator<JourneyService>();
  final JourneyRepository? _journeyRepo = locator<JourneyRepository>();
  S locale = locator<S>();

  // static LocalDBModel? lclDbProvider = locator<LocalDBModel>();
  final InternalOpsService? _internalOpsService = locator<InternalOpsService>();

  //Controllers
  PageController? _controller;

  // static appStateProvider
  static AppState appStateProvider = AppState.delegate!.appState;

  //Screen States
  final _mobileScreenKey = new GlobalKey<LoginMobileViewState>();
  final _otpScreenKey = new GlobalKey<LoginOtpViewState>();
  final _nameKey = new GlobalKey<LoginUserNameViewState>();

//Private Variables
  bool _isSignup = false;
  bool _loginUsingTrueCaller = false;
  get loginUsingTrueCaller => this._loginUsingTrueCaller;

  set loginUsingTrueCaller(value) {
    this._loginUsingTrueCaller = value;
    notifyListeners();
  }

  String? userMobile;
  String? _verificationId;
  int? _currentPage;
  ValueNotifier<double?>? _pageNotifier;
  StreamSubscription? streamSubscription;
  static List<Widget>? _pages;
  ScrollController nameViewScrollController = ScrollController();

//Getters and Setters
  get controller => _controller;
  get pageNotifier => _pageNotifier;
  get pages => _pages;
  int? get currentPage => _currentPage;

  set currentPage(int? page) {
    _currentPage = page;
    notifyListeners();
  }

  init(initPage, loginModelInstance) {
    _currentPage = (initPage != null) ? initPage : LoginMobileView.index;
    // _formProgress = 0.2 * (_currentPage + 1);
    _controller = new PageController(initialPage: _currentPage!);
    _controller!.addListener(_pageListener);
    _pageNotifier = ValueNotifier(0.0);
    _pages = [
      LoginMobileView(
        key: _mobileScreenKey,
        loginModel: this,
      ),
      LoginOtpView(
        key: _otpScreenKey,
        otpEntered: _onOtpFilled,
        resendOtp: _onOtpResendRequested,
        changeNumber: _onChangeNumberRequest,
        mobileNo: this.userMobile,
        loginModel: loginModelInstance,
      ),
      LoginNameInputView(key: _nameKey, loginModel: this),
    ];
  }

  processScreenInput(int? currentPage) async {
    if (BaseUtil.showNoInternetAlert()) return;
    if (state == ViewState.Busy) return;
    switch (currentPage) {
      case LoginMobileView.index:
        {
          //in mobile input screen. Get and set mobile/ set error interface if not correct
          if (_mobileScreenKey.currentState!.model.formKey.currentState
              .validate()) {
            logger!.d(
                'Mobile number validated: ${_mobileScreenKey.currentState!.model.getMobile()}');
            this.userMobile = _mobileScreenKey.currentState!.model.getMobile();

            LoginControllerView.mobileno = this.userMobile;
            notifyListeners();

            ///disable regular numbers for QA
            if (FlavorConfig.isQA() &&
                !this.userMobile!.startsWith('999990000')) {
              BaseUtil.showNegativeAlert(
                  locale.mbNoNotAllowed, locale.dummyNoAlert);
              break;
            }
            _analyticsService!.track(
                eventName: AnalyticsEvents.signupEnterMobile,
                properties: {'mobile': this.userMobile});
            this._verificationId = '+91' + this.userMobile!;
            _verifyPhone();
            // FocusScope.of(_mobileScreenKey.currentContext).unfocus();
            setState(ViewState.Busy);
          }
          break;
        }
      case LoginOtpView.index:
        {
          String otp = _otpScreenKey.currentState!.model!.otp;
          if (otp != null && otp.isNotEmpty && otp.length == 6) {
            logger!.d("OTP is $otp");
            setState(ViewState.Busy);
            final verifyOtp =
                await this._userRepo!.verifyOtp(this._verificationId, otp);
            if (verifyOtp.isSuccess()) {
              _analyticsService!.track(
                  eventName: AnalyticsEvents.mobileOtpDone,
                  properties: {'mobile': this.userMobile});
              AppState.isOnboardingInProgress = true;
              _otpScreenKey.currentState!.model!.onOtpReceived();
              FirebaseAuth.instance
                  .signInWithCustomToken(verifyOtp.model!)
                  .then((res) {
                _onSignInSuccess(LoginSource.FIREBASE);
              }).catchError((e) {
                print(e.toString());
                setState(ViewState.Idle);
                _otpScreenKey.currentState!.model!.otpFieldEnabled = true;
                BaseUtil.showNegativeAlert(locale.authFailed, locale.tryLater);
              });
            } else {
              _otpScreenKey.currentState!.model!.pinEditingController.clear();
              _otpScreenKey.currentState!.model!.otpFieldEnabled = true;
              _otpScreenKey.currentState!.model!.otpFocusNode.requestFocus();
              BaseUtil.showNegativeAlert(
                  verifyOtp.errorMessage ?? locale.obInValidOTP,
                  locale.obEnterValidOTP);

              // FocusScope.of(_otpScreenKey.currentContext).unfocus();
              setState(ViewState.Idle);
            }
          } else {
            _otpScreenKey.currentState!.model!.otpFieldEnabled = true;

            BaseUtil.showNegativeAlert(locale.obEnterOTP, locale.obOneTimePass);
          }
          break;
        }

      case LoginNameInputView.index:
        {
          if (_nameKey.currentState!.model.formKey.currentState.validate()) {
            String refCode = _nameKey.currentState!.model.getReferralCode();
            if (refCode != null && refCode.isNotEmpty)
              BaseUtil.manualReferralCode = refCode;

            setState(ViewState.Busy);

            String name = _nameKey.currentState!.model.nameController.text
                .trim()
                .replaceAll(new RegExp(r"\s+\b|\b\s"), " ");
            String gender =
                _formatGender(_nameKey.currentState!.model.genderValue);
            if (userService.baseUser == null) {
              //firebase user should never be null at this point
              userService.baseUser = BaseUser.newUser(
                  userService.firebaseUser!.uid,
                  _formatMobileNumber(LoginControllerView.mobileno)!);
            }

            _nameKey.currentState?.model.enabled = false;
            notifyListeners();

            userService.baseUser!.name = name;
            userService.baseUser!.gender = gender;
            userService.baseUser!.avatarId = "AV1";

            bool flag = false;
            String message = "Please try again in sometime";
            log(userService.baseUser!.toJson().toString());
            try {
              final token = await _getBearerToken();
              userService.baseUser!.mobile = userMobile;
              final ApiResponse response =
                  await _userRepo!.setNewUser(userService.baseUser!, token);
              logger!.i(response.toString());
              if (response.code == 400) {
                message = response.errorMessage ??
                    "Unable to create account, please try again later.";
                _nameKey.currentState!.model.enabled = true;
                setState(ViewState.Idle);
                flag = false;
              } else {
                final gtId = response.model['gtId'];
                response.model['flag'] ? flag = true : flag = false;

                logger!.d("Is Scratch Card Rewarded: $gtId");
                if (gtId != null && gtId.toString().isNotEmpty)
                  ScratchCardService.scratchCardId = gtId;
              }
            } catch (e) {
              logger!.d(e);
              _nameKey.currentState!.model.enabled = true;
              flag = false;
              setState(ViewState.Idle);
            }

            if (flag) {
              _analyticsService!.track(
                eventName: AnalyticsEvents.proceedToSignUp,
                properties: {
                  'username': name ?? "",
                  'referralCode': refCode ?? ""
                },
              );
              logger!.d("User object saved successfully");
              // userService.showOnboardingTutorial = true;
              _onSignUpComplete();
            } else {
              BaseUtil.showNegativeAlert(
                locale.updateFailed,
                message,
              );
              _nameKey.currentState!.model.enabled = true;

              setState(ViewState.Idle);
            }
          }

          break;
        }
    }
  }

  void _onSignInSuccess(LoginSource source) async {
    logger!.d("User authenticated. Now check if details previously available.");
    userService.firebaseUser = FirebaseAuth.instance.currentUser;
    logger!.d("User is set: " + userService.firebaseUser!.uid);
    _otpScreenKey.currentState?.model?.otpFocusNode.requestFocus();
    await CacheService.invalidateByKey(CacheKeys.USER);
    ApiResponse<BaseUser> user =
        await _userRepo!.getUserById(id: userService.firebaseUser!.uid);
    logger!.d("User data found: ${user.model}");
    if (user.code == 400) {
      BaseUtil.showNegativeAlert(
          locale.accountMaintenance, locale.customerSupportText);
      setState(ViewState.Idle);
      _controller!.animateToPage(LoginMobileView.index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInToLinear);
    } else if (user.model == null ||
        (user.model != null && user.model!.hasIncompleteDetails())) {
      if (user.model == null) {
        logger!.d("New User, initializing BaseUser");
        userService.baseUser =
            BaseUser.newUser(userService!.firebaseUser!.uid, userMobile!);
      }

      ///First time user!
      _isSignup = true;
      logger!.d(
          "No existing user details found or found incomplete details for user. Moving to details page");
      AppState.isFirstTime = true;

      if (source == LoginSource.TRUECALLER)
        _analyticsService!.track(eventName: AnalyticsEvents.truecallerSignup);
      //Move to name input page
      BaseUtil.isNewUser = true;
      BaseUtil.isFirstFetchDone = false;
      if (source == LoginSource.FIREBASE)
        _controller!
            .animateToPage(
          LoginNameInputView.index,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInToLinear,
        )
            .then((_) {
          setState(ViewState.Idle);
          if (LoginControllerView.mobileno!.startsWith("88888")) {
            _otpScreenKey.currentState?.model?.pinEditingController.text =
                "123456";
          }
        });
      else if (source == LoginSource.TRUECALLER) {
        _controller!.jumpToPage(
          LoginNameInputView.index,
        );
        setState(ViewState.Idle);
      }

      loginUsingTrueCaller = false;
      Future.delayed(Duration(seconds: 1), () {
        nameViewScrollController.animateTo(
            nameViewScrollController.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.easeIn);
      });
      //_nameScreenKey.currentState.showEmailOptions();
    } else {
      ///Existing user
      await BaseAnalytics.analytics?.logLogin(loginMethod: 'phonenumber');
      logger!.d("User details available: Name: " + user.model!.name!);
      if (source == LoginSource.TRUECALLER)
        _analyticsService!.track(eventName: AnalyticsEvents.truecallerLogin);
      userService!.baseUser = user.model;

      _onSignUpComplete();
    }
  }

  Future _onSignUpComplete() async {
    if (_isSignup) {
      _userRepo!.updateUserAppFlyer(
          userService!.baseUser!, await userService.firebaseUser!.getIdToken());
      await _analyticsService!.login(
          isOnBoarded: userService.isUserOnboarded,
          baseUser: userService.baseUser);

      BaseAnalytics.analytics!.logSignUp(signUpMethod: 'phoneNumber');
      _analyticsService!.trackSignup(userService.baseUser!.uid);
    }

    BaseAnalytics.logUserProfile(userService.baseUser!);
    await userService.init();
    _userCoinService!.init();
    baseProvider!.init();
    AnalyticsProperties().init();
    userService.userBootUpEE();
    if (userService.isUserOnboarded) await _journeyService!.init();

    fcmListener!.setupFcm();
    logger!.i("Calling analytics init for new onboarded user");
    await _analyticsService!.login(
      isOnBoarded: userService.isUserOnboarded,
      baseUser: userService.baseUser,
    );

    AppState.isOnboardingInProgress = false;
    appStateProvider.rootIndex = 0;

    Map<String, dynamic> response = await _internalOpsService!.initDeviceInfo();
    logger!.d("Device Details: $response");
    if (response != {}) {
      final String? deviceId = response["deviceId"];
      final String? platform = response["platform"];
      final String? model = response["model"];
      final String? brand = response["brand"];
      final bool? isPhysicalDevice = response["isPhysicalDevice"];
      final String? version = response["version"];
      _userRepo!.setNewDeviceId(
        uid: userService.baseUser!.uid,
        deviceId: deviceId,
        platform: platform,
        model: model,
        brand: brand,
        version: version,
        isPhysicalDevice: isPhysicalDevice,
      );
    }

    setState(ViewState.Idle);

    ///check if the account is blocked
    if (userService.baseUser != null && userService.baseUser!.isBlocked!) {
      AppState.isUpdateScreen = true;
      appStateProvider.currentAction =
          PageAction(state: PageState.replaceAll, page: BlockedUserPageConfig);
      return;
    }

    appStateProvider.currentAction =
        PageAction(state: PageState.replaceAll, page: RootPageConfig);
    BaseUtil.showPositiveAlert(
      'Sign In Complete',
      'Welcome to ${Constants.APP_NAME}, ${userService.baseUser!.name}',
    );
    //process complete
  }

  Future<void> _verifyPhone() async {
    final hash = await SmsAutoFill().getAppSignature;
    final res = await this._userRepo!.sendOtp(this._verificationId, hash);

    if (res.isSuccess()) {
      if (baseProvider!.isOtpResendCount == 0) {
        ///this is the first time that the otp was requested

        _controller!
            .animateToPage(
          LoginOtpView.index,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInToLinear,
        )
            .then((_) {
          setState(ViewState.Idle);
        });
        Future.delayed(Duration(seconds: 1), () {
          _otpScreenKey.currentState!.model!.otpFocusNode.requestFocus();
        });
      } else {
        ///the otp was requested to be resent
        _otpScreenKey.currentState!.model!.onOtpResendConfirmed(true);
      }
    } else {
      String exceptionMessage = locale.checkNetwork;

      BaseUtil.showNegativeAlert(
        locale.sendingOtpFailed,
        exceptionMessage,
      );
      // _otpScreenKey.currentState.model.otpFieldEnabled = true;

      setState(ViewState.Idle);
    }
  }

  Future<String> _getBearerToken() async {
    String token = await userService!.firebaseUser!.getIdToken();
    logger!.d("BearerToken: $token");
    return token;
  }

  String? _formatMobileNumber(String? pNumber) {
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

  String _formatGender(int genderValue) {
    switch (genderValue) {
      case 0:
        return "M";
      case 1:
        return "F";
      case 2:
        return "O";
      default:
        return "M";
    }
  }

  Color getCTATextColor() {
    if (currentPage == 0) {
      if (_mobileScreenKey.currentState!.model.mobileController.text.length ==
          10)
        return UiConstants.primaryColor;
      else
        return UiConstants.gameCardColor;
    }
    return UiConstants.gameCardColor;
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
    if (baseProvider!.isOtpResendCount < 2) {
      _verifyPhone();
      _analyticsService!.track(
          eventName: AnalyticsEvents.resendOtpTapped,
          properties: {'mobile': this.userMobile});
    } else {
      _otpScreenKey.currentState!.model!.onOtpResendConfirmed(false);
      BaseUtil.showNegativeAlert(locale.signInFailedText, locale.exceededOTPs);
    }
  }

  _onChangeNumberRequest() {
    if (this.state == ViewState.Idle) {
      AppState.isOnboardingInProgress = false;
      _controller!.animateToPage(LoginMobileView.index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInToLinear);
    }
  }

  void _pageListener() {
    _pageNotifier!.value = _controller!.page;
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
          String? phNo = truecallerSdkCallback.profile?.phoneNumber;
          loginUsingTrueCaller = true;
          logger!.d("Truecaller no: $phNo");

          _analyticsService!
              .track(eventName: AnalyticsEvents.truecallerVerified);
          AppState.isOnboardingInProgress = true;
          _authenticateTrucallerUser(phNo);
          break;
        case TruecallerSdkCallbackResult.failure:
          int? errorCode = truecallerSdkCallback.error?.code;
          logger!.e(errorCode);
          break;
        case TruecallerSdkCallbackResult.verification:
          print("Verification Required!!");
          break;
        default:
          print("Invalid result");
      }
    });
  }

  Future<void> _authenticateTrucallerUser(String? phno) async {
    //Make api call to get custom token

    final ApiResponse<String> tokenRes =
        await _userRepo!.getCustomUserToken(phno);

    if (tokenRes.code == 400) {
      BaseUtil.showNegativeAlert(locale.authFailed, tokenRes.errorMessage);
    }

    final String token = tokenRes.model!;
    LoginControllerView.mobileno = phno;
    userMobile = phno;
    _mobileScreenKey.currentState!.model.mobileController.text =
        _formatMobileNumber(phno)!;
    //Authenticate using custom token
    FirebaseAuth.instance.signInWithCustomToken(token).then((res) {
      logger!.i("New Firebase User: ${res.additionalUserInfo!.isNewUser}");
      //on successful authentication
      _onSignInSuccess(LoginSource.TRUECALLER);
    }).catchError((e) {
      logger!.e(e);
      BaseUtil.showNegativeAlert(locale.authFailed, locale.authenticateNumber);
      loginUsingTrueCaller = false;
    });
  }

  void onTermsAndConditionsClicked() {
    Haptic.vibrate();
    BaseUtil.launchUrl('https://fello.in/policy/tnc');
    _analyticsService!.track(eventName: AnalyticsEvents.termsAndConditions);
  }

  exit() {
    _controller!.removeListener(_pageListener);
    _controller!.dispose();
    nameViewScrollController.dispose();
    streamSubscription?.cancel();
  }
}

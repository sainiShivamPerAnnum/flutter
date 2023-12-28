import 'dart:async';
import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:app_set_id/app_set_id.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/analytics_repo.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
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
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

enum LoginSource { FIREBASE, TRUECALLER }

class LoginControllerViewModel extends BaseViewModel {
  //Locators
  final FcmListener? fcmListener = locator<FcmListener>();
  final AugmontService? augmontProvider = locator<AugmontService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final UserService userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final CustomLogger logger = locator<CustomLogger>();
  final ApiPath? apiPaths = locator<ApiPath>();
  final BaseUtil? baseProvider = locator<BaseUtil>();
  final DBModel? dbProvider = locator<DBModel>();
  final UserRepository _userRepo = locator<UserRepository>();
  final AnalyticsRepository _analyticsRepo = locator<AnalyticsRepository>();
  final JourneyService _journeyService = locator<JourneyService>();
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final ReferralService _referralService = locator<ReferralService>();

  S locale = locator<S>();

  // static LocalDBModel? lclDbProvider = locator<LocalDBModel>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();

  //Controllers
  PageController? _controller;

  // static appStateProvider
  static AppState appStateProvider = AppState.delegate!.appState;

  //Screen States
  final _mobileScreenKey = GlobalKey<LoginMobileViewState>();
  final _otpScreenKey = GlobalKey<LoginOtpViewState>();
  final _nameKey = GlobalKey<LoginUserNameViewState>();

//Private Variables
  bool _isSignup = false;
  bool _loginUsingTrueCaller = false;

  get loginUsingTrueCaller => _loginUsingTrueCaller;

  set loginUsingTrueCaller(value) {
    _loginUsingTrueCaller = value;
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

  void init(initPage, loginModelInstance) {
    _currentPage = (initPage != null) ? initPage : LoginMobileView.index;
    // _formProgress = 0.2 * (_currentPage + 1);
    _controller = PageController(initialPage: _currentPage!);
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
        mobileNo: userMobile,
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
          _analyticsService.track(eventName: "Mobile Screen next tapped");
          //in mobile input screen. Get and set mobile/ set error interface if not correct
          if (_mobileScreenKey.currentState!.model.formKey.currentState
              .validate()) {
            logger.d(
                'Mobile number validated: ${_mobileScreenKey.currentState!.model.getMobile()}');
            userMobile = _mobileScreenKey.currentState!.model.getMobile();

            LoginControllerView.mobileno = userMobile;
            notifyListeners();

            ///disable regular numbers for QA
            if (FlavorConfig.isQA() && !userMobile!.startsWith('999990000')) {
              BaseUtil.showNegativeAlert(
                  locale.mbNoNotAllowed, locale.dummyNoAlert);
              break;
            }
            _analyticsService.track(
                eventName: AnalyticsEvents.signupEnterMobile,
                properties: {'mobile': userMobile});
            _verificationId = '+91${userMobile!}';
            _verifyPhone();
            // FocusScope.of(_mobileScreenKey.currentContext).unfocus();
            setState(ViewState.Busy);
          }
          break;
        }
      case LoginOtpView.index:
        {
          _analyticsService.track(eventName: "OTP screen next tapped");

          String? otp = _otpScreenKey.currentState?.model?.otp;
          logger.d("qwertyuiop OTP is $otp");
          if (otp == null) return;
          if (otp.isNotEmpty && otp.length == 6) {
            logger.d("OTP is $otp");
            setState(ViewState.Busy);
            final verifyOtp = await _userRepo.verifyOtp(_verificationId, otp);
            if (verifyOtp.isSuccess()) {
              _analyticsService.track(
                  eventName: AnalyticsEvents.mobileOtpDone,
                  properties: {'mobile': userMobile});

              _otpScreenKey.currentState!.model!.onOtpReceived();
              await FirebaseAuth.instance
                  .signInWithCustomToken(verifyOtp.model!)
                  .then((res) {
                _onSignInSuccess(LoginSource.FIREBASE);
              }).catchError((e) {
                debugPrint(e.toString());
                setState(ViewState.Idle);
                _otpScreenKey.currentState!.model!.otpFieldEnabled = true;
                BaseUtil.showNegativeAlert(locale.authFailed, locale.tryLater);
              });
            } else {
              _otpScreenKey.currentState!.model!.pinEditingController.clear();
              _otpScreenKey.currentState!.model!.otpFieldEnabled = true;
              _otpScreenKey.currentState!.model!.otpFocusNode.requestFocus();
              logger.e("Invalid OTP");
              BaseUtil.showNegativeAlert(
                  verifyOtp.errorMessage ?? locale.obInValidOTP,
                  locale.obEnterValidOTP);

              // FocusScope.of(_otpScreenKey.currentContext).unfocus();
              setState(ViewState.Idle);
            }
          } else {
            _otpScreenKey.currentState?.model?.otpFieldEnabled = true;

            BaseUtil.showNegativeAlert(locale.obEnterOTP, locale.obOneTimePass);
          }
          break;
        }

      case LoginNameInputView.index:
        {
          _analyticsService.track(eventName: "Name screen finish tapped");

          if (_nameKey.currentState!.model.formKey.currentState!.validate()) {
            String refCode = _nameKey.currentState!.model.getReferralCode();
            if (refCode.isNotEmpty) {
              BaseUtil.manualReferralCode = refCode;
            }

            setState(ViewState.Busy);

            String name = _nameKey.currentState!.model.nameController.text
                .trim()
                .replaceAll(RegExp(r"\s+\b|\b\s"), " ");
            String gender =
                _formatGender(_nameKey.currentState!.model.genderValue);

            userService.baseUser ??= BaseUser.newUser(
                userService.firebaseUser!.uid,
                _formatMobileNumber(LoginControllerView.mobileno)!);

            _nameKey.currentState?.model.enabled = false;
            notifyListeners();

            userService.baseUser!.name = name;
            userService.baseUser!.gender = gender;
            userService.baseUser!.avatarId = "AV1";

            bool flag = false;
            String message = "Please try again in sometime";

            try {
              userService.baseUser!.mobile = userMobile;
              final ApiResponse response =
                  await _userRepo.setNewUser(userService.baseUser!);
              logger.i(response.toString());
              if (response.code == 400) {
                _analyticsService.track(
                    eventName: "Signup: setNewUser responded with 400");

                message = response.errorMessage ??
                    "Unable to create account, please try again later.";
                _nameKey.currentState!.model.enabled = true;
                setState(ViewState.Idle);
                flag = false;
              } else {
                _analyticsService.track(
                    eventName: "Signup: setNewUser responded with 200");
                final gtId = response.model['gtId'];
                response.model['flag'] ? flag = true : flag = false;

                logger.d("Is Scratch Card Rewarded: $gtId");
                if (gtId != null && gtId.toString().isNotEmpty) {
                  ScratchCardService.scratchCardId = gtId;
                }
              }
            } catch (e) {
              _analyticsService.track(
                  eventName: "Signup: setNewUser failed with exception");
              logger.d(e);
              _nameKey.currentState!.model.enabled = true;
              flag = false;
              setState(ViewState.Idle);
            }

            if (flag) {
              _analyticsService.track(
                eventName: AnalyticsEvents.proceedToSignUp,
                properties: {
                  'username': name ?? "",
                  'referralCode': refCode ?? ""
                },
              );
              logger.d("User object saved successfully");
              // userService.showOnboardingTutorial = true;
              await _onSignUpComplete();
            } else {
              BaseUtil.showNegativeAlert(
                locale.updateFailed,
                message,
              );
              _nameKey.currentState!.model.enabled = true;

              setState(ViewState.Idle);
            }
          } else {
            _analyticsService.track(eventName: "Name screen validation failed");
          }

          break;
        }
    }
  }

  Future<void> sendInstallInformation() async {
    String? appSetId;
    String? androidId;
    String? advertisingId;
    String? osVersion;
    String? installReferrerData;
    const BASE_CHANNEL = 'methodChannel/deviceData';
    const platform = MethodChannel(BASE_CHANNEL);
    try {
      appSetId = await AppSetId().getIdentifier();
      logger.d('AppSetId: Package found an appropriate ID value: $appSetId');
    } catch (e) {
      logger.e('AppSetId: Package failed to set an appropriate ID value');
      unawaited(_internalOpsService.logFailure(
          userService.baseUser!.uid,
          FailType.InstallInformationFetchFailed,
          {"information": "app_set_id"}));
    }
    if (Platform.isAndroid) {
      try {
        androidId = await platform.invokeMethod('getAndroidId');
        logger.d('AndroidId: Service found an Android Id: $androidId');
      } catch (e) {
        logger.e('AndroidId: Service failed to find a Android Id');
        unawaited(_internalOpsService.logFailure(
            userService.baseUser!.uid,
            FailType.InstallInformationFetchFailed,
            {"information": "android_id"}));
      }
    }
    try {
      advertisingId = await AdvertisingId.id(true);
      logger
          .d('AdvertisingId: Service found an Advertising Id: $advertisingId');
    } catch (e) {
      logger.e('AdvertisingId: Service failed to find a Advertising Id');
      unawaited(_internalOpsService.logFailure(
          userService.baseUser!.uid,
          FailType.InstallInformationFetchFailed,
          {"information": "advertising_id"}));
    }
    try {
      if (!_internalOpsService.isDeviceInfoInitiated) {
        await _internalOpsService.initDeviceInfo();
      }
      osVersion = _internalOpsService.osVersion;
    } catch (e) {
      logger.e('DeviceData: Service failed to find a Device Data');
      unawaited(_internalOpsService.logFailure(
          userService.baseUser!.uid,
          FailType.InstallInformationFetchFailed,
          {"information": "device_data"}));
    }
    try {
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;
      //cleanup data
      RegExp nullPattern = RegExp(r'null');
      installReferrerData =
          referrerDetails.toString().replaceAll(nullPattern, '');
    } catch (e) {
      logger
          .e('InstallReferrer: Service failed to find a Install Referrer Data');
      unawaited(
        _internalOpsService.logFailure(
          userService.baseUser!.uid,
          FailType.InstallInformationFetchFailed,
          {"information": "install_referrer_id"},
        ),
      );
    }
    logger.d(
        'Received the following information: {InstallReferrerData: $installReferrerData,'
        'AppSetId: $appSetId, AndroidId: $androidId, AdvertisingId: $advertisingId, OSVersion: $osVersion}');
    final ApiResponse response = await _analyticsRepo.setInstallInfo(
      userService.baseUser!,
      installReferrerData,
      appSetId,
      androidId,
      osVersion,
      advertisingId,
    );
    logger.d('Data sent to API with the following response: ${response.model}');
  }

  void _onSignInSuccess(LoginSource source) async {
    logger.d("User authenticated. Now check if details previously available.");
    userService.firebaseUser = FirebaseAuth.instance.currentUser;
    logger.d("User is set: ${userService.firebaseUser!.uid}");
    _otpScreenKey.currentState?.model?.otpFocusNode.requestFocus();
    await CacheService.invalidateByKey(CacheKeys.USER);
    ApiResponse<BaseUser> user =
        await _userRepo.getUserById(id: userService.firebaseUser!.uid);
    logger.d("User data found: ${user.model}");
    if (user.code == 400) {
      BaseUtil.showNegativeAlert(user.errorMessage ?? locale.accountMaintenance,
          locale.customerSupportText);
      setState(ViewState.Idle);
      unawaited(_controller!.animateToPage(LoginMobileView.index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInToLinear));
    } else if (user.model == null ||
        (user.model != null && user.model!.hasIncompleteDetails())) {
      if (user.model == null) {
        logger.d("New User, initializing BaseUser");
        userService.baseUser =
            BaseUser.newUser(userService.firebaseUser!.uid, userMobile!);
      }

      ///First time user!
      _isSignup = true;
      logger.d(
          "No existing user details found or found incomplete details for user. Moving to details page");
      AppState.isFirstTime = true;

      if (source == LoginSource.TRUECALLER) {
        _analyticsService.track(eventName: AnalyticsEvents.truecallerSignup);
      }
      //Move to name input page
      BaseUtil.isNewUser = true;
      BaseUtil.isFirstFetchDone = false;
      if (source == LoginSource.FIREBASE) {
        unawaited(_controller!
            .animateToPage(
          LoginNameInputView.index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInToLinear,
        )
            .then((_) {
          setState(ViewState.Idle);
          if (LoginControllerView.mobileno!.startsWith("88888")) {
            _otpScreenKey.currentState?.model?.pinEditingController.text =
                "123456";
          }
        }));
      } else if (source == LoginSource.TRUECALLER) {
        _controller!.jumpToPage(
          LoginNameInputView.index,
        );
        setState(ViewState.Idle);
      }

      loginUsingTrueCaller = false;
      Future.delayed(const Duration(seconds: 1), () {
        nameViewScrollController.animateTo(
            nameViewScrollController.position.maxScrollExtent,
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn);
      });
      AppState.isOnboardingInProgress = true;
      //_nameScreenKey.currentState.showEmailOptions();
    } else {
      ///Existing user

      await BaseAnalytics.analytics?.logLogin(loginMethod: 'phonenumber');
      logger.d("User details available: Name: ${user.model!.name!}");
      if (source == LoginSource.TRUECALLER) {
        _analyticsService.track(eventName: AnalyticsEvents.truecallerLogin);
      }
      userService.baseUser = user.model;

      _onSignUpComplete();
    }
  }

  Future _onSignUpComplete() async {
    _analyticsService.track(eventName: "SignIn: user service init called");
    await userService.init();
    _analyticsService.track(eventName: "SignIn: base util  init called");
    baseProvider!.init();
    _analyticsService.track(eventName: "SignIn: referral service init called");
    _referralService.init();

    if (_isSignup) {
      await _analyticsService.login(
          isOnBoarded: userService.isUserOnboarded,
          baseUser: userService.baseUser);

      unawaited(
        BaseAnalytics.analytics!.logSignUp(signUpMethod: 'phoneNumber'),
      );

      logger.d(
          'invoke an API to send device related and install referrer related information to the server');
      _analyticsService.track(
          eventName: "SignUp: sendInstallInformation called called");
      unawaited(sendInstallInformation());

      unawaited(userService.logUserInstalledApps().then(
        (value) {
          logger.i(value);
          _analyticsService.track(
            eventName: AnalyticsEvents.installedApps,
            appFlyer: false,
            apxor: false,
            webEngage: false,
            properties: {
              "apps": Map<String, dynamic>.from(value)
                  .keys
                  .map((e) => e.toString())
                  .toList()
            },
          );
        },
      ));
    }

    BaseAnalytics.logUserProfile(userService.baseUser!);
    unawaited(fcmListener!.setupFcm());
    unawaited(locator<GameRepo>().getGameTiers());
    logger.i("Calling analytics init for new onboarded user");
    unawaited(_analyticsService.login(
      isOnBoarded: userService.isUserOnboarded,
      baseUser: userService.baseUser,
    ));

    AppState.isOnboardingInProgress = false;
    appStateProvider.rootIndex = 0;
    _analyticsService.track(eventName: "SignUp: initDeviceInfo called called");
    unawaited(_internalOpsService
        .initDeviceInfo()
        .then((Map<String, dynamic> response) {
      logger.d("Device Details: $response");
      if (response != {}) {
        final String? deviceId = response["deviceId"];
        final String? platform = response["platform"];
        final String? model = response["model"];
        final String? brand = response["brand"];
        final bool? isPhysicalDevice = response["isPhysicalDevice"];
        final String? version = response["version"];
        final String? integrity = response["integrity"];
        _userRepo.setNewDeviceId(
            uid: userService.baseUser!.uid,
            deviceId: deviceId,
            platform: platform,
            model: model,
            brand: brand,
            version: version,
            isPhysicalDevice: isPhysicalDevice,
            integrity: integrity);
      }
    }));
    setState(ViewState.Idle);

    ///check if the account is blocked
    if (userService.baseUser != null && userService.baseUser!.isBlocked!) {
      _analyticsService.track(
          eventName: "SignIn: moving user to blocked screen");

      AppState.isUpdateScreen = true;
      appStateProvider.currentAction =
          PageAction(state: PageState.replaceAll, page: BlockedUserPageConfig);
      return;
    }

    _analyticsService.track(eventName: "SignIn: moving user to home screen");

    appStateProvider.currentAction =
        PageAction(state: PageState.replaceAll, page: RootPageConfig);
    BaseUtil.showPositiveAlert(
      'Sign In Complete',
      'Welcome to ${Constants.APP_NAME}, ${userService.baseUser!.name}',
    );
    //process complete
  }

  Future<void> editPhone() async {
    setState(ViewState.Busy);
    unawaited(_controller!
        .animateToPage(
          LoginMobileView.index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInToLinear,
        )
        .then(
          (value) => setState(ViewState.Idle),
        ));
    Future.delayed(const Duration(seconds: 1), () {
      _otpScreenKey.currentState!.model!.otpFocusNode.unfocus();
    });
  }

  Future<void> _verifyPhone() async {
    final hash = await SmsAutoFill().getAppSignature;
    final res = await _userRepo.sendOtp(_verificationId, hash);

    if (res.isSuccess()) {
      if (baseProvider!.isOtpResendCount == 0) {
        ///this is the first time that the otp was requested

        _controller!
            .animateToPage(
          LoginOtpView.index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInToLinear,
        )
            .then((_) {
          setState(ViewState.Idle);
        });
        Future.delayed(const Duration(seconds: 1), () {
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
    String token = await userService.firebaseUser!.getIdToken();
    logger.d("BearerToken: $token");
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
          10) {
        return UiConstants.primaryColor;
      } else {
        return UiConstants.gameCardColor;
      }
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
    processScreenInput(_currentPage);
  }

  _onOtpResendRequested() {
    if (baseProvider!.isOtpResendCount < 2) {
      _verifyPhone();
      _analyticsService.track(
          eventName: AnalyticsEvents.resendOtpTapped,
          properties: {'mobile': userMobile});
    } else {
      _otpScreenKey.currentState!.model!.onOtpResendConfirmed(false);
      BaseUtil.showNegativeAlert(locale.signInFailedText, locale.exceededOTPs);
    }
  }

  _onChangeNumberRequest() {
    if (state == ViewState.Idle) {
      AppState.isOnboardingInProgress = false;
      _controller!.animateToPage(LoginMobileView.index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInToLinear);
    }
  }

  void _pageListener() {
    _pageNotifier!.value = _controller!.page;
  }

  Future<void> initTruecaller() async {
    TruecallerSdk.initializeSDK(
        buttonColor: UiConstants.primaryColor.value,
        buttonTextColor: Colors.white.value,
        sdkOptions: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP);
    await TruecallerSdk.isUsable.then((isUsable) {
      isUsable ? TruecallerSdk.getProfile : print("***Not usable***");
    });

    streamSubscription =
        TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
      logger.i("Access Token : ${truecallerSdkCallback.accessToken}");
      switch (truecallerSdkCallback.result) {
        case TruecallerSdkCallbackResult.success:
          String? phNo = truecallerSdkCallback.profile?.phoneNumber;
          loginUsingTrueCaller = true;
          logger.d("Truecaller no: $phNo");

          _analyticsService.track(
              eventName: AnalyticsEvents.truecallerVerified);
          AppState.isOnboardingInProgress = true;
          _authenticateTrucallerUser(phNo);
          break;

        case TruecallerSdkCallbackResult.exception:
          int? errorCode = truecallerSdkCallback.error?.code;
          logger.e("$errorCode");
          break;
        case TruecallerSdkCallbackResult.failure:
          int? errorCode = truecallerSdkCallback.error?.code;
          logger.e("$errorCode");
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
        await _userRepo.getCustomUserToken(phno);

    debugPrint("Token: ${tokenRes.model}");

    if (tokenRes.code == 400) {
      BaseUtil.showNegativeAlert(locale.authFailed, tokenRes.errorMessage);
    }

    final String token = tokenRes.model!;
    LoginControllerView.mobileno = phno;
    userMobile = phno;
    _mobileScreenKey.currentState!.model.mobileController.text =
        _formatMobileNumber(phno)!;
    //Authenticate using custom token
    unawaited(FirebaseAuth.instance.signInWithCustomToken(token).then((res) {
      logger.i("New Firebase User: ${res.additionalUserInfo!.isNewUser}");
      //on successful authentication
      _onSignInSuccess(LoginSource.TRUECALLER);
    }).catchError((e) {
      logger.e(e);
      BaseUtil.showNegativeAlert(locale.authFailed, locale.authenticateNumber);
      loginUsingTrueCaller = false;
    }));
  }

  void onTermsAndConditionsClicked() {
    Haptic.vibrate();
    BaseUtil.launchUrl('https://fello.in/policy/tnc');
    _analyticsService.track(eventName: AnalyticsEvents.termsAndConditions);
  }

  exit() {
    _controller!.removeListener(_pageListener);
    _controller!.dispose();
    nameViewScrollController.dispose();
    streamSubscription?.cancel();
  }
}

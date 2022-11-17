import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/model/page_config_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/user_bootup_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/api_cache_manager.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/error_codes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends PropertyChangeNotifier<UserServiceProperties> {
  final DBModel? _dbModel = locator<DBModel>();
  final CustomLogger _logger = locator<CustomLogger>();
  final ApiCacheManager? _apiCacheManager = locator<ApiCacheManager>();
  final UserRepository? _userRepo = locator<UserRepository>();
  final InternalOpsService? _internalOpsService = locator<InternalOpsService>();
  final JourneyRepository? _journeyRepo = locator<JourneyRepository>();
  final GetterRepository _gettersRepo = locator<GetterRepository>();

  User? _firebaseUser;
  BaseUser? _baseUser;

  String? _myUserDpUrl = '';
  String? _myUserName;
  // String _myUpiId;
  String? _dob;
  String? _gender;
  String? _idToken;
  String? _avatarId;
  String? _email;

  UserFundWallet? _userFundWallet;
  UserJourneyStatsModel? _userJourneyStats;
  UserAugmontDetail? _userAugmontDetails;
  UserBootUpDetailsModel? userBootUp;
  DynamicUI? pageConfigs;

  bool? _isEmailVerified;
  bool? _isSimpleKycVerified;
  bool _isConfirmationDialogOpen = false;
  bool _hasNewNotifications = false;
  // bool showOnboardingTutorial = true;
  bool? showSecurityPrompt;
  bool isAnyUnscratchedGTAvailable = false;

  User? get firebaseUser => _firebaseUser;
  BaseUser? get baseUser => _baseUser;

  String? get avatarId => _avatarId;
  String? get myUserDpUrl => _myUserDpUrl;
  String? get myUserName => _myUserName;
  String? get idToken => _idToken;
  String? get dob => _dob;
  String? get gender => _gender;
  String? get email => _email;
  // String get upiId => _myUpiId;

  bool get isEmailVerified => _isEmailVerified ?? false;
  bool get isSimpleKycVerified => _isSimpleKycVerified ?? false;
  bool get isConfirmationDialogOpen => _isConfirmationDialogOpen;
  bool get hasNewNotifications => _hasNewNotifications;
  // UserAugmontDetail get userAugmontDetails => this._userAugmontDetails;

  set baseUser(baseUser) {
    _baseUser = baseUser;
  }

  set hasNewNotifications(bool val) {
    _hasNewNotifications = val;
    notifyListeners(UserServiceProperties.myNotificationStatus);
    _logger!.d(
        "Notification Status updated in userservice, property listeners notified");
  }

  UserFundWallet? get userFundWallet => _userFundWallet;
  UserJourneyStatsModel? get userJourneyStats => _userJourneyStats;

  set firebaseUser(User? firebaseUser) => _firebaseUser = firebaseUser;

  setMyUserDpUrl(String url) {
    _myUserDpUrl = url;
    notifyListeners(UserServiceProperties.myUserDpUrl);
  }

  setMyAvatarId(String? avId) {
    _avatarId = avId;
    notifyListeners(UserServiceProperties.myAvatarId);
    _logger!.d(
        "My user avatar Id updated in userservice, property listeners notified");
  }

  setMyUserName(String? name) {
    _myUserName = name;
    notifyListeners(UserServiceProperties.myUserName);
    _logger!
        .d("My user name updated in userservice, property listeners notified");
  }

  // setMyUpiId(String upi) {
  //   _myUpiId = upi;
  //   notifyListeners(UserServiceProperties.myUpiId);
  //   _logger.d(
  //       "My user upi Id updated in userservice, property listeners notified");
  // }

  setDateOfBirth(String? dob) {
    _dob = dob;
    notifyListeners(UserServiceProperties.myDob);
    _logger!
        .d("My user dob updated in userservice, property listeners notified");
  }

  setGender(String? gender) {
    _gender = gender;
    notifyListeners(UserServiceProperties.myGender);
    _logger!.d(
        "My user gender updated in userservice, property listeners notified");
  }

  setEmail(String? email) {
    _email = email;
    notifyListeners(UserServiceProperties.myEmail);
    _logger!
        .d("My user email updated in userservice, property listeners notified");
  }

  set userFundWallet(UserFundWallet? wallet) {
    _userFundWallet = wallet;
    notifyListeners(UserServiceProperties.myUserFund);
    _logger!.d("Wallet updated in userservice, property listeners notified");
  }

  set userJourneyStats(UserJourneyStatsModel? stats) {
    if (stats?.prizeSubtype != _userJourneyStats?.prizeSubtype ?? '' as bool)
      GoldenTicketService.previousPrizeSubtype =
          _userJourneyStats?.prizeSubtype ?? '';
    _userJourneyStats = stats;
    notifyListeners(UserServiceProperties.myJourneyStats);
    _logger!
        .d("Journey Stats updated in userservice, property listeners notified");
    _logger!.d(
        "Previous PrizeSubtype : ${GoldenTicketService.previousPrizeSubtype}  Current PrizeSubtype: ${_userJourneyStats?.prizeSubtype} ");
  }

  set augGoldPrinciple(double principle) {
    _userFundWallet!.augGoldPrinciple = principle;
    notifyListeners(UserServiceProperties.myUserFund);
    _logger!.d(
        "Wallet:Aug Gold Quantity updated in userservice, property listeners notified");
  }

  set augGoldQuantity(double quantity) {
    _userFundWallet!.augGoldQuantity = quantity;
    notifyListeners(UserServiceProperties.myUserFund);
    _logger!.d(
        "Wallet:Aug Gold Quantity updated in userservice, property listeners notified");
  }

  set isEmailVerified(bool val) {
    _isEmailVerified = val;
    notifyListeners(UserServiceProperties.myEmailVerification);
    _logger!.d("Email:User email verified, property listeners notified");
  }

  set isSimpleKycVerified(bool val) {
    _isSimpleKycVerified = val;
    notifyListeners(UserServiceProperties.mySimpleKycVerified);
    _logger!.d("Email:User simple kyc verified, property listeners notified");
  }

  setUserAugmontDetails(value) {
    this._userAugmontDetails = value;
    notifyListeners(UserServiceProperties.myAugmontDetails);
    _logger!.d(
        "AgmontDetails :User augmontDetails updated, property listeners notified");
  }

  bool get isUserOnboarded {
    try {
      if (_firebaseUser != null &&
          _baseUser != null &&
          _baseUser!.uid!.isNotEmpty &&
          _baseUser!.mobile!.isNotEmpty &&
          _baseUser!.name!.isNotEmpty) {
        _logger!.d("Onborded User: ${_baseUser!.uid}");
        return true;
      }
    } catch (e) {
      _logger!.e(e.toString());
    }

    return false;
  }

  Future<void> userBootUpEE() async {
    if (FirebaseAuth.instance.currentUser != null) {
      setLastOpened();
      dayOPenCount();

      String? userId, deviceId, platform, appVersion, lastOpened;
      int dayOpenCount;

      userId = FirebaseAuth.instance.currentUser!.uid;

      Map<String, dynamic> response =
          await _internalOpsService!.initDeviceInfo();
      if (response != null) {
        deviceId = response["deviceId"];
        platform = response["platform"];
      }

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.buildNumber;

      lastOpened = PreferenceHelper.getString(Constants.LAST_OPENED) ?? "";
      dayOpenCount = PreferenceHelper.getInt(Constants.DAY_OPENED_COUNT) ?? 0;

      final ApiResponse<UserBootUpDetailsModel> res = await _userRepo!
          .fetchUserBootUpRssponse(
              userId: userId,
              deviceId: deviceId,
              platform: platform,
              appVersion: appVersion,
              lastOpened: lastOpened,
              dayOpenCount: dayOpenCount);
      if (res.isSuccess()) {
        userBootUp = res.model;
      }
    } else {
      //No user logged in
      _logger!.d("No user logged in, exiting user boot up details");
    }
  }

  void dayOPenCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var now = new DateTime.now();
      var formatter = new DateFormat('dd-MM-yyyy');
      String today = formatter.format(now);

      String savedDate = prefs.getString(Constants.DATE_TODAY) ?? "";

      if (savedDate == today) {
        //The count is for today
        //Increase the count
        int current_count = prefs.getInt(Constants.DAY_OPENED_COUNT) ?? 0;
        current_count = current_count + 1;
        prefs.setInt(Constants.DAY_OPENED_COUNT, current_count);
      } else {
        //Date has changed
        prefs.setString(Constants.DATE_TODAY, today);
        prefs.setInt(Constants.DAY_OPENED_COUNT, 0);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void setLastOpened() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var now = new DateTime.now();
      var formatter = new DateFormat('dd-MM-yyyy');
      String formattedTime = DateFormat('kk:mm:ss:a').format(now);
      String formattedDate = formatter.format(now);

      prefs.setString(
          Constants.LAST_OPENED, formattedDate + " " + formattedTime);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> init() async {
    try {
      _firebaseUser = FirebaseAuth.instance.currentUser;
      await setBaseUser();
      if (baseUser != null) {
        await getUserJourneyStats();
        final res = await _gettersRepo.getPageConfigs();
        if (res.isSuccess()) setPageConfigs(res.model!);
      }
    } catch (e) {
      _logger!.e(e.toString());
      _internalOpsService!
          .logFailure(baseUser?.uid ?? '', FailType.UserServiceInitFailed, {
        "title": "UserService initialization Failed",
        "error": e.toString(),
      });
    }
  }

  Future<bool> signOut(Function signOut) async {
    try {
      await _userRepo!.logOut();
      await signOut();
      new CacheService().invalidateAll();
      await FirebaseAuth.instance.signOut();
      await CacheManager.clearCacheMemory();
      await _apiCacheManager!.clearCacheMemory();
      _logger!.d("UserService signout called");
      _userFundWallet = null;
      _firebaseUser = null;
      _baseUser = null;
      _myUserDpUrl = null;
      _myUserName = null;
      _idToken = null;
      _isEmailVerified = false;
      _isSimpleKycVerified = false;
      showSecurityPrompt = false;
      _userAugmontDetails = null;
      // _myUpiId = null;
      return true;
    } catch (e) {
      _logger!.e("Failed to logout user: ${e.toString()}");
      return false;
    }
  }

  Future<void> setBaseUser() async {
    if (_firebaseUser != null) {
      final response = await _userRepo!.getUserById(id: _firebaseUser?.uid);
      if (response.code == 400) {
        _logger!.d("Unable to cast user data object.");
        return;
      }
      _baseUser = response.model;
      _logger!.d("Base user initialized, UID: ${_baseUser?.uid}");

      _idToken = await CacheManager.readCache(key: 'token');

      _idToken == null
          ? _logger!.d("No FCM token in pref")
          : _logger!.d("FCM token from pref: $_idToken");

      _baseUser?.client_token != null
          ? _logger!
              .d("Current FCM token from baseUser : ${_baseUser?.client_token}")
          : _logger!.d("No FCM token in firestored");

      isEmailVerified = baseUser?.isEmailVerified ?? false;
      isSimpleKycVerified = baseUser?.isSimpleKycVerified ?? false;
      setEmail(baseUser!.email);
      setMyAvatarId(baseUser!.avatarId);
      setMyUserName(baseUser?.kycName ?? baseUser!.name);
      setDateOfBirth(baseUser!.dob);
      setGender(baseUser!.gender);
    } else {
      _logger!.d("Firebase User is null");
    }
  }

  getProfilePicture() async {
    if (baseUser!.avatarId == null ||
        baseUser!.avatarId!.isEmpty ||
        baseUser!.avatarId == "CUSTOM") {
      if (!PreferenceHelper.exists('dpUrl')) {
        // try {
        _logger!.d("Fetching profile picture");

        String? myUserDpUrl;
        if (baseUser != null)
          myUserDpUrl = await _dbModel!.getUserDP(baseUser!.uid);
        if (myUserDpUrl != null) {
          await CacheManager.writeCache(
              key: 'dpUrl', value: myUserDpUrl, type: CacheType.string);
          setMyUserDpUrl(myUserDpUrl);
          _logger!.d("No profile picture found in cache, fetched from server");
        }
        // } catch (e) {
        //   _logger.e(e.toString());
        // }
      } else {
        print(PreferenceHelper.getString('dpUrl'));
        setMyUserDpUrl(PreferenceHelper.getString('dpUrl'));
      }
    }
  }

  // Note: Already Setting in Root uneccessary Calling
  // Future<void> setProfilePicture() async {
  //   if (await CacheManager.readCache(key: 'dpUrl') == null) {
  //     try {
  //       if (_baseUser != null) {
  //         setMyUserDpUrl(await _dbModel.getUserDP(baseUser.uid));
  //         _logger.d("No cached profile picture found. updated from server");
  //       }
  //       if (_myUserDpUrl != null) {
  //         await CacheManager.writeCache(
  //             key: 'dpUrl', value: _myUserDpUrl, type: CacheType.string);
  //         _logger.d("Profile picture fetched from server and cached");
  //       }
  //     } catch (e) {
  //       _logger.e(e.toString());
  //     }
  //   } else {
  //     setMyUserDpUrl(await CacheManager.readCache(key: 'dpUrl'));
  //   }
  // }

  Future<void> getUserFundWalletData() async {
    if (baseUser != null) {
      UserFundWallet? temp = (await _userRepo!.getFundBalance()).model;
      if (temp == null)
        _compileUserWallet();
      else
        userFundWallet = temp;
    }
  }

  Future<bool> getUserJourneyStats() async {
    // NOTE: CACHE REQUIRED, FOR CALLED FROM JOURUNY SERVICE AGAIN
    if (baseUser != null) {
      ApiResponse<UserJourneyStatsModel> res =
          await _journeyRepo!.getUserJourneyStats();
      if (res.isSuccess()) {
        userJourneyStats = res.model;
        return true;
      } else {
        _logger!.e("Error fetching User journey stats data");
        return false;
      }
    }
    return false;
  }

  _compileUserWallet() {
    _logger!.d("Creating new fund wallet");
    userFundWallet = (_userFundWallet == null)
        ? UserFundWallet.newWallet()
        : _userFundWallet;
  }

  checkForNewNotifications() {
    _logger!.d("Looking for new notifications");
    _userRepo!.checkIfUserHasNewNotifications().then((value) {
      if (value.code == 200) {
        if (value.model!) hasNewNotifications = true;
      }
    });
  }

  setPageConfigs(DynamicUI dynamicUi) {
    DynamicUiUtils.playViewOrder = dynamicUi.play;
    DynamicUiUtils.saveViewOrder = [
      dynamicUi.save.assets,
      dynamicUi.save.sections
    ];
    DynamicUiUtils.helpFab = dynamicUi.journeyFab;
  }

  diplayUsername(String username) {
    return username.replaceAll('@', '.');
  }

  Future<String> createDynamicLink(bool short, String source) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix:
          '${FlavorConfig.instance!.values.dynamicLinkPrefix}/app/referral',
      link: Uri.parse('https://fello.in/${_baseUser!.uid}'),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Download ${Constants.APP_NAME}',
          description:
              'Fello makes saving fun, and investing a lot more simple!',
          imageUrl: Uri.parse(
              'https://fello-assets.s3.ap-south-1.amazonaws.com/ic_social.png')),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'referrals',
        medium: 'social',
        source: source,
      ),
      androidParameters: AndroidParameters(
        packageName: 'in.fello.felloapp',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'in.fello.felloappiOS',
        minimumVersion: '0',
        appStoreId: '1558445254',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    return url.toString();
  }

  Future<bool?> updateClientToken(String? token) async {
    ApiResponse<bool> response =
        await _userRepo!.updateFcmToken(fcmToken: token);
    return response.model;
  }

  // Future<void> fetchUserAugmontDetail() async {
  //   if (userAugmontDetails == null) {
  //     ApiResponse<UserAugmontDetail> augmontDetailResponse =
  //         await _userRepo.getUserAugmontDetails();
  //     if (augmontDetailResponse.isSuccess())
  //       setUserAugmontDetails(augmontDetailResponse.model);
  //   }
  // }
  // Future<bool> completeOnboarding() async {
  //   ApiResponse response = await _userRepo.completeOnboarding();
  //   return response.model;
  // }

  Future<bool> updateProfilePicture(XFile? selectedProfilePicture) async {
    Directory supportDir;
    UploadTask uploadTask;
    try {
      supportDir = await getApplicationSupportDirectory();
    } catch (e1) {
      _logger!.e('Support Directory not found');
      _logger!.e('$e1');
      return false;
    }

    String imageName = selectedProfilePicture!.path.split("/").last;
    String targetPath = "${supportDir.path}/c-$imageName";
    print("temp path: " + targetPath);
    print("orignal path: " + selectedProfilePicture.path);

    File compressedFile = File(selectedProfilePicture.path);

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("dps/${baseUser!.uid}/image");
      uploadTask = ref.putFile(compressedFile);
    } catch (e2) {
      _logger!.e('putFile Failed. Reference Error');
      _logger!.e('$e2');
      return false;
    }

    try {
      TaskSnapshot res = await uploadTask;
      String url = await res.ref.getDownloadURL();
      setMyAvatarId('CUSTOM');
      final updateUserAvatarResponse = await _userRepo!.updateUser(
          dMap: {BaseUser.fldAvatarId: avatarId}, uid: baseUser!.uid);
      if (url != null &&
          updateUserAvatarResponse.isSuccess() &&
          updateUserAvatarResponse.model!) {
        await CacheManager.writeCache(
            key: 'dpUrl', value: url, type: CacheType.string);
        setMyUserDpUrl(url);
        setMyAvatarId('CUSTOM');
        //_baseUtil.setDisplayPictureUrl(url);
        _logger!.d('Final DP Uri: $url');
        return true;
      } else
        return false;
    } catch (e) {
      if (baseUser!.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Method call to upload picture failed',
        };
        _internalOpsService!.logFailure(
          baseUser!.uid,
          FailType.ProfilePictureUpdateFailed,
          errorDetails,
        );
      }
      print('$e');
      return false;
    }
  }

  authenticateDevice() async {
    try {
      if (baseUser?.userPreferences != null &&
          baseUser?.userPreferences.getPreference(Preferences.APPLOCK) == 1) {
        final LocalAuthentication auth = LocalAuthentication();
        final bool canAuthenticateWithBiometrics =
            await auth.canCheckBiometrics;
        final bool canAuthenticate =
            canAuthenticateWithBiometrics || await auth.isDeviceSupported();
        final List<BiometricType> availableBiometrics =
            await auth.getAvailableBiometrics();
        if (canAuthenticate && availableBiometrics.isNotEmpty) {
          // Some biometrics are enrolled.
          try {
            final bool didAuthenticate = await auth.authenticate(
              localizedReason:
                  'Confirm your phone screen lock pattern,PIN or password',
            );
            if (didAuthenticate) {
              _logger.d("Auth: success");
              return AppState.delegate!.appState.currentAction =
                  PageAction(state: PageState.replaceAll, page: RootPageConfig);
            } else {
              _logger.d("Auth: failed");
              return BaseUtil.openDialog(
                  hapticVibrate: true,
                  isBarrierDismissible: false,
                  content: Platform.isAndroid
                      ? ConfirmationDialog(
                          title: "Please Authenticate",
                          asset: SvgPicture.asset(Assets.securityCheck,
                              width: SizeConfig.screenWidth! * 0.3),
                          description:
                              "Fello protects your data to avoid unauthorized access. Please unlock Fello to continue.",
                          buttonText: "Unlock",
                          confirmAction: () {
                            Navigator.of(AppState
                                    .delegate!.navigatorKey.currentContext!)
                                .pop();
                            authenticateDevice();
                          },
                          cancelAction: () {
                            SystemNavigator.pop();
                          })
                      : CupertinoAlertDialog(
                          title: Column(
                            children: [
                              Text("Please Authenticate"),
                              SizedBox(height: SizeConfig.padding8),
                              SvgPicture.asset(Assets.securityCheck,
                                  width: SizeConfig.screenWidth! * 0.16),
                            ],
                          ),
                          content: Text(
                              "Fello protects your data to avoid unauthorized access. Please unlock Fello to continue."),
                          actions: [
                            CupertinoDialogAction(
                              child: Text("Unlock"),
                              onPressed: () {
                                Navigator.of(AppState
                                        .delegate!.navigatorKey.currentContext!)
                                    .pop();
                                authenticateDevice();
                              },
                            ),
                          ],
                        ));
            }
          } on PlatformException catch (e) {
            if (e.code == passcodeNotSet) {
              _logger.d("Auth: Passcode not set");
            } else if (e.code == notEnrolled) {
              _logger.d("Auth: Not enrolled for biometrics");
            } else if (e.code == notAvailable) {
              _logger.d("Auth: No hardware support for biometrics");
            } else if (e.code == lockedOut) {
              _logger.d("Auth: Incorrect biometrics, try pin/pattern");
            } else if (e.code == permanentlyLockedOut) {
              _logger.d("Auth: Maximum no of tries exceeded");
            } else {
              return BaseUtil.showNegativeAlert(
                  'Authentication Failed', 'Please restart and try again');
            }
          }
        } else {
          BaseUtil.showPositiveAlert('No Device Authentication Found',
              'Logging in, please enable device security to add lock');
          return AppState.delegate!.appState.currentAction =
              PageAction(state: PageState.replaceAll, page: RootPageConfig);
        }
      } else {
        return AppState.delegate!.appState.currentAction =
            PageAction(state: PageState.replaceAll, page: RootPageConfig);
      }
    } catch (e) {
      return BaseUtil.showNegativeAlert(
          'Authentication Failed', 'Please restart and try again');
    }
  }
}

import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/api_cache_manager.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserService extends PropertyChangeNotifier<UserServiceProperties> {
  final _dbModel = locator<DBModel>();
  final _logger = locator<CustomLogger>();
  final _apiCacheManager = locator<ApiCacheManager>();
  final _userRepo = locator<UserRepository>();
  final _internalOpsService = locator<InternalOpsService>();
  final _journeyRepo = locator<JourneyRepository>();

  User _firebaseUser;
  BaseUser _baseUser;

  String _myUserDpUrl;
  String _myUserName;
  String _dob;
  String _gender;
  String _idToken;

  UserFundWallet _userFundWallet;
  UserJourneyStatsModel _userJourneyStats;

  bool _isEmailVerified;
  bool _isSimpleKycVerified;
  bool _isConfirmationDialogOpen = false;
  bool _hasNewNotifications = false;
  // bool showOnboardingTutorial = true;
  bool showSecurityPrompt;
  bool isAnyUnscratchedGTAvailable = false;

  User get firebaseUser => _firebaseUser;
  BaseUser get baseUser => _baseUser;

  String get myUserDpUrl => _myUserDpUrl;
  String get myUserName => _myUserName;
  String get idToken => _idToken;
  String get dob => _dob;
  String get gender => _gender;

  bool get isEmailVerified => _isEmailVerified ?? false;
  bool get isSimpleKycVerified => _isSimpleKycVerified ?? false;
  bool get isConfirmationDialogOpen => _isConfirmationDialogOpen;
  bool get hasNewNotifications => _hasNewNotifications;

  FocusScopeNode buyFieldFocusNode = FocusScopeNode();

  set baseUser(baseUser) {
    _baseUser = baseUser;
  }

  set hasNewNotifications(bool val) {
    _hasNewNotifications = val;
    notifyListeners(UserServiceProperties.myNotificationStatus);
    _logger.d(
        "Notification Status updated in userservice, property listeners notified");
  }

  UserFundWallet get userFundWallet => _userFundWallet;
  UserJourneyStatsModel get userJourneyStats => _userJourneyStats;

  set firebaseUser(User firebaseUser) => _firebaseUser = firebaseUser;

  setMyUserDpUrl(String url) {
    _myUserDpUrl = url;
    notifyListeners(UserServiceProperties.myUserDpUrl);
    _logger.d(
        "My user dp url updated in userservice, property listeners notified");
  }

  setMyUserName(String name) {
    _myUserName = name;
    notifyListeners(UserServiceProperties.myUserName);
    _logger
        .d("My user name updated in userservice, property listeners notified");
  }

  setDateOfBirth(String dob) {
    _dob = dob;
    notifyListeners(UserServiceProperties.myDob);
    _logger
        .d("My user dob updated in userservice, property listeners notified");
  }

  setGender(String gender) {
    _gender = gender;
    notifyListeners(UserServiceProperties.myGender);
    _logger.d(
        "My user gender updated in userservice, property listeners notified");
  }

  setEmail(String email) {
    _baseUser.email = email;
    notifyListeners(UserServiceProperties.myEmail);
    _logger
        .d("My user email updated in userservice, property listeners notified");
  }

  set userFundWallet(UserFundWallet wallet) {
    _userFundWallet = wallet;
    notifyListeners(UserServiceProperties.myUserFund);
    _logger.d("Wallet updated in userservice, property listeners notified");
  }

  set userJourneyStats(UserJourneyStatsModel stats) {
    _userJourneyStats = stats;
    notifyListeners(UserServiceProperties.myJourneyStats);
    _logger
        .d("Journey Stats updated in userservice, property listeners notified");
  }

  set augGoldPrinciple(double principle) {
    _userFundWallet.augGoldPrinciple = principle;
    notifyListeners(UserServiceProperties.myUserFund);
    _logger.d(
        "Wallet:Aug Gold Quantity updated in userservice, property listeners notified");
  }

  set augGoldQuantity(double quantity) {
    _userFundWallet.augGoldQuantity = quantity;
    notifyListeners(UserServiceProperties.myUserFund);
    _logger.d(
        "Wallet:Aug Gold Quantity updated in userservice, property listeners notified");
  }

  set isEmailVerified(bool val) {
    _isEmailVerified = val;
    notifyListeners(UserServiceProperties.myEmailVerification);
    _logger.d("Email:User email verified, property listeners notified");
  }

  set isSimpleKycVerified(bool val) {
    _isSimpleKycVerified = val;
    notifyListeners(UserServiceProperties.mySimpleKycVerified);
    _logger.d("Email:User simple kyc verified, property listeners notified");
  }

  bool get isUserOnborded {
    try {
      if (_firebaseUser != null &&
          _baseUser != null &&
          _baseUser.uid.isNotEmpty &&
          _baseUser.mobile.isNotEmpty &&
          _baseUser.username.isNotEmpty) {
        _logger.d("Onborded User: ${_baseUser.uid}");
        return true;
      }
    } catch (e) {
      _logger.e(e.toString());
    }

    return false;
  }

  Future<void> init() async {
    try {
      _firebaseUser = FirebaseAuth.instance.currentUser;
      await setBaseUser();
      if (baseUser != null) {
        isEmailVerified = baseUser.isEmailVerified ?? false;
        isSimpleKycVerified = baseUser.isSimpleKycVerified ?? false;
        await Future.wait([
          setProfilePicture(),
          getUserFundWalletData(),
          getUserJourneyStats()
        ]);
        checkForNewNotifications();
        checkForUnscratchedGTStatus();
      }
    } catch (e) {
      _logger.e(e.toString());
      _internalOpsService
          .logFailure(baseUser?.uid ?? '', FailType.UserServiceInitFailed, {
        "title": "UserService initialization Failed",
        "error": e.toString(),
      });
    }
  }

  Future<bool> signOut(Function signOut) async {
    try {
      await signOut();
      new CacheService().invalidateAll();
      await FirebaseAuth.instance.signOut();
      await CacheManager.clearCacheMemory();
      await _apiCacheManager.clearCacheMemory();

      _logger.d("UserService signout called");
      _userFundWallet = null;
      _firebaseUser = null;
      _baseUser = null;
      _myUserDpUrl = null;
      _myUserName = null;
      _idToken = null;
      _isEmailVerified = false;
      _isSimpleKycVerified = false;
      showSecurityPrompt = null;
      return true;
    } catch (e) {
      _logger.e("Failed to logout user: ${e.toString()}");
      return false;
    }
  }

  Future<void> setBaseUser() async {
    if (_firebaseUser != null) {
      final response = await _userRepo.getUserById(id: _firebaseUser?.uid);
      if (response.code == 400) {
        _logger.d("Unable to cast user data object.");
        return;
      }
      _baseUser = response.model;
      _logger.d("Base user initialized, UID: ${_baseUser?.uid}");

      _idToken = await CacheManager.readCache(key: 'token');
      _idToken == null
          ? _logger.d("No FCM token in pref")
          : _logger.d("FCM token from pref: $_idToken");

      _baseUser?.client_token != null
          ? _logger
              .d("Current FCM token from baseUser : ${_baseUser?.client_token}")
          : _logger.d("No FCM token in firestored");

      _myUserName = _baseUser?.name;
    } else {
      _logger.d("Firebase User is null");
    }
  }

  Future<void> setProfilePicture() async {
    if (await CacheManager.readCache(key: 'dpUrl') == null) {
      try {
        if (_baseUser != null) {
          setMyUserDpUrl(await _dbModel.getUserDP(baseUser.uid));
          _logger.d("No cached profile picture found. updated from server");
        }
        if (_myUserDpUrl != null) {
          await CacheManager.writeCache(
              key: 'dpUrl', value: _myUserDpUrl, type: CacheType.string);
          _logger.d("Profile picture fetched from server and cached");
        }
      } catch (e) {
        _logger.e(e.toString());
      }
    } else {
      setMyUserDpUrl(await CacheManager.readCache(key: 'dpUrl'));
    }
  }

  Future<void> getUserFundWalletData() async {
    if (baseUser != null) {
      UserFundWallet temp = (await _userRepo.getFundBalance()).model;
      if (temp == null)
        _compileUserWallet();
      else
        userFundWallet = temp;
    }
  }

  Future<void> getUserJourneyStats() async {
    if (baseUser != null) {
      ApiResponse<UserJourneyStatsModel> res =
          await _journeyRepo.getUserJourneyStats();
      if (res.isSuccess())
        userJourneyStats = res.model;
      else
        _logger.e("Error fetching User journey stats data");
    }
  }

  _compileUserWallet() {
    _logger.d("Creating new fund wallet");
    userFundWallet = (_userFundWallet == null)
        ? UserFundWallet.newWallet()
        : _userFundWallet;
  }

  checkForNewNotifications() {
    _logger.d("Looking for new notifications");
    _userRepo.checkIfUserHasNewNotifications().then((value) {
      if (value.code == 200) {
        if (value.model) hasNewNotifications = true;
      }
    });
  }

  checkForUnscratchedGTStatus() {
    _logger.d("Looking for Unscratched GTs");
    _dbModel.checkIfUserHasUnscratchedGT(baseUser.uid).then((value) {
      if (value) isAnyUnscratchedGTAvailable = true;
    });
  }

  diplayUsername(String username) {
    return username.replaceAll('@', '.');
  }

  Future<String> createDynamicLink(bool short, String source) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix:
          '${FlavorConfig.instance.values.dynamicLinkPrefix}/app/referral',
      link: Uri.parse('https://fello.in/${_baseUser.uid}'),
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

  Future<bool> updateClientToken(String token) async {
    ApiResponse<bool> response =
        await _userRepo.updateFcmToken(fcmToken: token);
    return response.model;
  }

  // Future<bool> completeOnboarding() async {
  //   ApiResponse response = await _userRepo.completeOnboarding();
  //   return response.model;
  // }

  Future<bool> checkGalleryPermission() async {
    if (await BaseUtil.showNoInternetAlert()) return false;
    var _status = await Permission.photos.status;
    if (_status.isRestricted || _status.isLimited || _status.isDenied) {
      BaseUtil.openDialog(
        isBarrierDismissable: false,
        addToScreenStack: true,
        content: AppDefaultDialog(
          title: "Request Permission",
          description:
              "Access to the gallery is requested. This is only required for choosing your profile picture 🤳🏼",
          buttonText: "Continue",
          asset: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Image.asset(
              "images/gallery.png",
              height: SizeConfig.screenWidth * 0.24,
            ),
          ),
          confirmAction: () {
            AppState.backButtonDispatcher.didPopRoute();
            return true;
          },
          cancelAction: () {
            AppState.backButtonDispatcher.didPopRoute();
            return false;
          },
        ),
      );
    } else if (_status.isGranted) {
      return true;
    } else {
      BaseUtil.showNegativeAlert(
        'Permission Unavailable',
        'Please enable permission from settings to continue',
      );
      return false;
    }
    return false;
  }

  Future<bool> updateProfilePicture(XFile selectedProfilePicture) async {
    Directory supportDir;
    UploadTask uploadTask;
    try {
      supportDir = await getApplicationSupportDirectory();
    } catch (e1) {
      _logger.e('Support Directory not found');
      _logger.e('$e1');
      return false;
    }

    String imageName = selectedProfilePicture.path.split("/").last;
    String targetPath = "${supportDir.path}/c-$imageName";
    print("temp path: " + targetPath);
    print("orignal path: " + selectedProfilePicture.path);

    File compressedFile = File(selectedProfilePicture.path);

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("dps/${baseUser.uid}/image");
      uploadTask = ref.putFile(compressedFile);
    } catch (e2) {
      _logger.e('putFile Failed. Reference Error');
      _logger.e('$e2');
      return false;
    }

    try {
      TaskSnapshot res = await uploadTask;
      String url = await res.ref.getDownloadURL();
      if (url != null) {
        await CacheManager.writeCache(
            key: 'dpUrl', value: url, type: CacheType.string);
        setMyUserDpUrl(url);
        baseUser.avatarId = 'CUSTOM';
        //_baseUtil.setDisplayPictureUrl(url);
        _logger.d('Final DP Uri: $url');
        return true;
      } else
        return false;
    } catch (e) {
      if (baseUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Method call to upload picture failed',
        };
        _internalOpsService.logFailure(
          baseUser.uid,
          FailType.ProfilePictureUpdateFailed,
          errorDetails,
        );
      }
      print('$e');
      return false;
    }
  }
}

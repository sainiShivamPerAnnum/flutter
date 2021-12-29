import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserService extends PropertyChangeNotifier<UserServiceProperties> {
  final _dbModel = locator<DBModel>();
  final _logger = locator<CustomLogger>();
  final _userRepo = locator<UserRepository>();

  User _firebaseUser;
  BaseUser _baseUser;
  String _myUserDpUrl;
  String _myUserName;
  String _dob;
  String _gender;
  String _idToken;
  UserFundWallet _userFundWallet;
  bool _isEmailVerified;
  bool _isSimpleKycVerified;

  User get firebaseUser => _firebaseUser;
  BaseUser get baseUser => _baseUser;
  String get myUserDpUrl => _myUserDpUrl;
  String get myUserName => _myUserName;
  String get idToken => _idToken;
  String get dob => _dob;
  String get gender => _gender;
  bool get isEmailVerified => _isEmailVerified ?? false;
  bool get isSimpleKycVerified => _isSimpleKycVerified ?? false;

  UserFundWallet get userFundWallet => _userFundWallet;

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

  set userFundWallet(UserFundWallet wallet) {
    _userFundWallet = wallet;
    notifyListeners(UserServiceProperties.myUserFund);
    _logger.d("Wallet updated in userservice, property listeners notified");
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

  set firebaseUser(User firebaseUser) {
    _firebaseUser = firebaseUser;
  }

  set isSimpleKycVerified(bool val) {
    _isSimpleKycVerified = val;
    notifyListeners(UserServiceProperties.mySimpleKycVerified);
    _logger.d("Email:User simple kyc verified, property listeners notified");
  }

  bool get isUserOnborded {
    if (_firebaseUser != null &&
        _baseUser != null &&
        _baseUser.uid.isNotEmpty) {
      _logger.d("Onborded User: ${_baseUser.uid}");
      return true;
    }

    return false;
  }

  Future<void> init() async {
    _firebaseUser = FirebaseAuth.instance.currentUser;
    await setBaseUser();
    if (baseUser != null) {
      isEmailVerified = baseUser.isEmailVerified ?? false;
      isSimpleKycVerified = baseUser.isSimpleKycVerified ?? false;
      await setProfilePicture();
      await getUserFundWalletData();
    }
  }

  Future<bool> signout() async {
    try {
      await _userRepo.removeUserFCM(_baseUser.uid);
      await FirebaseAuth.instance.signOut();
      await CacheManager.clearCacheMemory();
      _logger.d("UserService signout called");
      _firebaseUser = null;
      _baseUser = null;
      _myUserDpUrl = null;
      _myUserName = null;
      _idToken = null;
      _isEmailVerified = false;
      _isSimpleKycVerified = false;
      return true;
    } catch (e) {
      _logger.e("Failed to logout user: ${e.toString()}");
      return false;
    }
  }

  Future<void> setBaseUser() async {
    if (_firebaseUser != null) {
      _baseUser = await _dbModel.getUser(_firebaseUser?.uid);
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
      UserFundWallet temp = await _dbModel.getUserFundWallet(baseUser.uid);
      if (temp == null)
        _compileUserWallet();
      else
        userFundWallet = temp;
    }
  }

  _compileUserWallet() {
    _logger.d("Creating new fund wallet");
    userFundWallet = (_userFundWallet == null)
        ? UserFundWallet.newWallet()
        : _userFundWallet;
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
          appStoreId: '1558445254'),
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
}

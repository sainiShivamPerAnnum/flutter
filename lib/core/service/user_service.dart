import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/user_ticket_wallet_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserService extends PropertyChangeNotifier<UserServiceProperties> {
  final _dbModel = locator<DBModel>();
  final _logger = locator<Logger>();

  User _firebaseUser;
  BaseUser _baseUser;
  String _myUserDpUrl;
  String _myUserName;
  String _idToken;
  UserTicketWallet _userTicketWallet;
  UserFundWallet _userFundWallet;

  User get firebaseUser => _firebaseUser;
  BaseUser get baseUser => _baseUser;
  String get myUserDpUrl => _myUserDpUrl;
  String get myUserName => _myUserName;
  String get idToken => _idToken;

  UserTicketWallet get userTicketWallet => _userTicketWallet;
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

  set userTicketWallet(UserTicketWallet wallet) {
    _userTicketWallet = wallet;
    notifyListeners(UserServiceProperties.myUserWallet);
    _logger.d("Wallet updated in userservice, property listeners notified");
  }

  set userFundWallet(UserFundWallet wallet) {
    _userFundWallet = wallet;
    notifyListeners(UserServiceProperties.myUserFund);
    print(_userFundWallet.augGoldQuantity);
    _logger.d("Wallet updated in userservice, property listeners notified");
  }

  bool get isUserOnborded {
    if (_firebaseUser != null && _baseUser != null && _baseUser.uid.isNotEmpty)
      return true;
    return false;
  }

  // UserService() {}

  Future<void> init() async {
    _firebaseUser = FirebaseAuth.instance.currentUser;
    if (_firebaseUser != null) {
      await setBaseUser();
      setProfilePicture();
      getUserTicketWalletData();
      getUserFundWalletData();
    }
  }

  Future<bool> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await CacheManager.clearCacheMemory();
      _logger.d("Firebase user signed out");
      _firebaseUser = null;
      _baseUser = null;
      _myUserDpUrl = null;
      _myUserName = null;
      _idToken = null;
      return true;
    } catch (e) {
      _logger.e("Failed to logout user: ${e.toString()}");
      return false;
    }
  }

  Future<void> setBaseUser() async {
    _baseUser = await _dbModel.getUser(_firebaseUser?.uid);
    _idToken = await _firebaseUser?.getIdToken();
    _myUserName = _baseUser?.name;
    _logger.d("Base user initialized");
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

  Future<void> getUserTicketWalletData() async {
    userTicketWallet = await _dbModel.getUserTicketWallet(firebaseUser.uid);
    if (_userTicketWallet == null) {
      await _initiateNewTicketWallet();
    }
  }

  Future<bool> _initiateNewTicketWallet() async {
    userTicketWallet = UserTicketWallet.newTicketWallet();
    int _t = userTicketWallet.initTck;
    userTicketWallet = await _dbModel.updateInitUserTicketCount(
        baseUser.uid, _userTicketWallet, Constants.NEW_USER_TICKET_COUNT);
    //updateInitUserTicketCount method returns no change if operations fails
    return (userTicketWallet.initTck != _t);
  }

  Future<void> getUserFundWalletData() async {
    userFundWallet = await _dbModel.getUserFundWallet(firebaseUser.uid);
    if (_userFundWallet == null) _compileUserWallet();
  }

  _compileUserWallet() {
    userFundWallet = (_userFundWallet == null)
        ? UserFundWallet.newWallet()
        : _userFundWallet;
  }
}

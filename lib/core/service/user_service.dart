import 'package:felloapp/core/enums/cache_type.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
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
  UserTicketWallet _userTicketWallet;

  User get firebaseUser => _firebaseUser;
  BaseUser get baseUser => _baseUser;
  String get myUserDpUrl => _myUserDpUrl;
  String get myUserName => _myUserName;

  UserTicketWallet get userTicketWallet => _userTicketWallet;

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

  bool get isUserOnborded {
    if (_firebaseUser != null && _baseUser != null && _baseUser.uid.isNotEmpty)
      return true;
    return false;
  }

  UserService() {
    _firebaseUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> init() async {
    await setBaseUser();
    setProfilePicture();
    getUserTicketWalletData();
  }

  Future<void> setBaseUser() async {
    _baseUser = await _dbModel.getUser(_firebaseUser?.uid);
    _myUserName = _baseUser?.name;
    _logger.d("Base user initialized");
  }

  Future<void> setProfilePicture() async {
    if (await CacheManager.readCache(key: 'dpUrl') == null) {
      try {
        if (_baseUser != null) {
          setMyUserDpUrl(await _dbModel.getUserDP(baseUser.uid));
          _logger.d("Profile picture updated");
        }
        if (_myUserDpUrl != null) {
          await CacheManager.writeCache(
              key: 'dpUrl', value: _myUserDpUrl, type: CacheType.string);
          _logger.d("No profile picture found in cache, fetched from server");
        }
      } catch (e) {
        _logger.e(e.toString());
      }
    } else {
      setMyUserDpUrl(await CacheManager.readCache(key: 'dpUrl'));
    }
  }

  Future<void> getUserTicketWalletData() async {
    _userTicketWallet = await _dbModel.getUserTicketWallet(firebaseUser.uid);
    if (_userTicketWallet == null) {
      await _initiateNewTicketWallet();
    }
  }

  Future<bool> _initiateNewTicketWallet() async {
    _userTicketWallet = UserTicketWallet.newTicketWallet();
    int _t = userTicketWallet.initTck;
    _userTicketWallet = await _dbModel.updateInitUserTicketCount(
        baseUser.uid, _userTicketWallet, Constants.NEW_USER_TICKET_COUNT);
    //updateInitUserTicketCount method returns no change if operations fails
    return (_userTicketWallet.initTck != _t);
  }
}

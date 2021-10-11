import 'package:felloapp/core/enums/cache_type.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/cache_manager.dart';
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

  User get firebaseUser => _firebaseUser;
  BaseUser get baseUser => _baseUser;
  String get myUserDpUrl => _myUserDpUrl;
  String get myUserName => _myUserName;
  String get idToken => _idToken;

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
    await setProfilePicture();
  }

  Future<bool> signout() async {
    try {
      await CacheManager.deleteCache(key: 'token', value: _idToken);
      await FirebaseAuth.instance.signOut();
      _logger.d("Firebase user signed out, Token cleared");
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
    if (_firebaseUser != null) {
      _baseUser = await _dbModel.getUser(_firebaseUser?.uid);
      _idToken = await CacheManager.readCache(key: 'token');
      if (_idToken == null) {
        _idToken = await _firebaseUser?.getIdToken();
        CacheManager.writeCache(
            key: 'token', value: _idToken, type: CacheType.string);
      }
    }

    _idToken = await _firebaseUser?.getIdToken(); //TODO cache
    _myUserName = _baseUser?.name;
    _logger.d("Base user initialized, UID: ${_baseUser?.uid}");
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
      _myUserDpUrl = await CacheManager.readCache(key: 'dpUrl');
    }
  }
}

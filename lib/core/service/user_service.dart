import 'package:felloapp/core/enums/cache_type.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class UserService extends ChangeNotifier {
  final _dbModel = locator<DBModel>();
  final _logger = locator<Logger>();

  User _firebaseUser;
  BaseUser _baseUser;
  String _myUserDpUrl;

  User get firebaseUser => _firebaseUser;
  BaseUser get baseUser => _baseUser;
  String get myUserDpUrl => _myUserDpUrl;

  void setMyUserDpUrl(String url) {
    _myUserDpUrl = url;
    notifyListeners();
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

  Future<void> setBaseUser() async {
    _baseUser = await _dbModel.getUser(_firebaseUser?.uid);
    _logger.d("Base user initialized");
  }

  Future<void> setProfilePicture() async {
    if (await CacheManager.readCache(key: 'dpUrl') == null) {
      try {
        if (_baseUser != null) {
          _myUserDpUrl = await _dbModel.getUserDP(baseUser.uid);
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

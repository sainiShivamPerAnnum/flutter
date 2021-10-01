import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _dbModel = locator<DBModel>();

  User _firebaseUser;
  BaseUser _baseUser;

  User get firebaseUser => _firebaseUser;
  BaseUser get baseUser => _baseUser;

  Future<bool> get isUserOnborded async {
    if (_firebaseUser != null) {
      _baseUser = await _dbModel.getUser(firebaseUser.uid);
      if (_firebaseUser != null &&
          _baseUser != null &&
          _baseUser.uid.isNotEmpty) return true;
    }
    return false;
  }

  UserService() {
    _firebaseUser = FirebaseAuth.instance.currentUser;
  }
}

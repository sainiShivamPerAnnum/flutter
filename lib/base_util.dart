import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'core/model/User.dart';
import 'core/ops/db_ops.dart';

class BaseUtil extends ChangeNotifier {
  final Log log = new Log("BaseUtil");
  DBModel _dbModel = locator<DBModel>();
  FirebaseUser firebaseUser;
  bool isUserOnboarded = false;
  bool isLoginNextInProgress = false;
  User _myUser;

  BaseUtil() {
    //init();
  }

  Future init() async {
    //fetch on-boarding status and User details
    firebaseUser = await FirebaseAuth.instance.currentUser();
    isUserOnboarded = true;
  }

  static Widget getAppBar() {
    return AppBar(
      elevation: 2.0,
      backgroundColor: Colors.white70,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Text('${Constants.APP_NAME}',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 30.0)),
    );
  }

  User get myUser => _myUser;

  set myUser(User value) {
    _myUser = value;
  }

}
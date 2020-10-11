import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'core/ops/db_ops.dart';

class BaseUtil extends ChangeNotifier {
  final Log log = new Log("BaseUtil");
  DBModel _dbModel = locator<DBModel>();
  FirebaseUser firebaseUser;
  bool isUserOnboarded = false;


  BaseUtil() {
    //init();
  }

  Future init() async {
    //fetch on-boarding status and User details
    firebaseUser = await FirebaseAuth.instance.currentUser();
    isUserOnboarded = true;
  }

}
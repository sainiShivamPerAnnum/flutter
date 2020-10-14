import 'package:felloapp/core/model/User.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';


class BaseUtil extends ChangeNotifier {
  final Log log = new Log("BaseUtil");
  DBModel _dbModel = locator<DBModel>();
  LocalDBModel _lModel = locator<LocalDBModel>();
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
    isUserOnboarded = await _lModel.isUserOnboarded()==1;
    _myUser = await _lModel.getUser();
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

  showPositiveAlert(String title, String message, BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        Icons.flag,
        size: 28.0,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
      title: title,
      message: message,
      duration: Duration(seconds: 3),
      backgroundGradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.lightBlueAccent, UiConstants.primaryColor]),
//      backgroundColor: Colors.lightBlueAccent,
      boxShadows: [BoxShadow(color: UiConstants.positiveAlertColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
    )..show(context);
  }

  showNegativeAlert(String title, String message, BuildContext context, {int seconds}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        Icons.assignment_late,
        size: 28.0,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
      title: title,
      message: message,
      duration: Duration(seconds: seconds??3),
      backgroundColor: UiConstants.negativeAlertColor,
      boxShadows: [BoxShadow(color: UiConstants.negativeAlertColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
    )..show(context);
  }

  AuthCredential generateAuthCredential(String verificationId, String smsCode) {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return credential;
  }

  Future<bool> authenticateUser(AuthCredential credential) {
    log.debug("Verification credetials: " + credential.toString());
    return FirebaseAuth.instance.signInWithCredential(credential).then((res) {
      this.firebaseUser = res.user;
      return true;
    }).catchError((e) {
      log.error("User Authentication failed with credential: Error: " + e.toString());
      return false;
    });
  }

  User get myUser => _myUser;

  set myUser(User value) {
    _myUser = value;
  }

}
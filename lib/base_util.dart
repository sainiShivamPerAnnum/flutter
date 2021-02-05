import 'dart:async';

import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/User.dart';
import 'package:felloapp/core/model/UserIciciDetail.dart';
import 'package:felloapp/core/model/UserKycDetail.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'core/model/TambolaBoard.dart';

class BaseUtil extends ChangeNotifier {
  final Log log = new Log("BaseUtil");
  DBModel _dbModel = locator<DBModel>();
  LocalDBModel _lModel = locator<LocalDBModel>();
  PaymentService _payService = locator<PaymentService>();
  FirebaseUser firebaseUser;
  bool isUserOnboarded = false;
  bool isLoginNextInProgress = false;
  bool isDepositRouteLogicInProgress = false;
  User _myUser;
  DailyPick weeklyDigits;
  List<TambolaBoard> userWeeklyBoards;
  UserIciciDetail _iciciDetail;
  UserKycDetail _kycDetail;
  UserTransaction _currentICICITxn;
  int referCount = 0;
  int userTicketsCount = 0;
  bool weeklyDrawFetched = false;
  bool weeklyTicksFetched = false;
  bool referCountFetched = false;
  bool isReferralLinkBuildInProgressWhatsapp = false;
  bool isReferralLinkBuildInProgressOther = false;
  bool isIciciModelInitialized = false;
  static const String dummyTambolaVal =
      '3a21c43e52f71h19k36m56o61p86r9s24u48w65y88A';
  static const int TOTAL_DRAWS = 35;
  static const int NEW_USER_TICKET_COUNT = 5;
  static const int KYC_UNTESTED = 0;
  static const int KYC_INVALID = 1;
  static const int KYC_VALID = 2;
  static const int INVESTMENT_AMOUNT_FOR_TICKET = 100;
  static bool isDeviceOffline = false;
  static bool ticketRequestSent = false;
  static int ticketCountBeforeRequest = NEW_USER_TICKET_COUNT;
  static RemoteConfig remoteConfig;
  static int infoSliderIndex = 0;
  static bool playScreenFirst = true;
  static int BALANCE_TO_TICKET_RATIO = 100;

  BaseUtil() {
    //init();
  }

  Future init() async {
    //fetch on-boarding status and User details
    firebaseUser = await FirebaseAuth.instance.currentUser();
    // isUserOnboarded = await _lModel.isUserOnboarded()==1;
    if (firebaseUser != null)
      _myUser = await _dbModel.getUser(firebaseUser.uid); //_lModel.getUser();
    isUserOnboarded =
        (firebaseUser != null && _myUser != null && _myUser.uid.isNotEmpty);
    if (isUserOnboarded) {
      await initRemoteConfig();
      String _p = remoteConfig.getString('play_screen_first');
      playScreenFirst = !(_p != null && _p.isNotEmpty && _p == 'false');

      if(myUser.isIciciOnboarded)_payService.verifyPaymentsIfAny();
    }
  }

  initRemoteConfig() async {
    remoteConfig = await RemoteConfig.instance;
    remoteConfig.setDefaults(<String, dynamic>{
      'draw_pick_time': '18',
      'deposit_upi_address': '9769637379@okbizaxis',
      'play_screen_first': 'true',
      'tambola_win_corner': '500',
      'tambola_win_top': '1500',
      'tambola_win_middle': '1500',
      'tambola_win_bottom': '1500',
      'tambola_win_full': '10,000',
      'referral_bonus': '25',
      'referral_ticket_bonus': '10',
      'aws_key_index': '1'
    });
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch();
      await remoteConfig.activateFetched();
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }

  _checkPendingTransactions() async {
    if (_myUser.pendingTxnId != null) {
      //there is a pending icici transaction
      iciciDetail = await _dbModel.getUserIciciDetails(_myUser.uid);
      UserTransaction txn =
          await _dbModel.getUserTransaction(_myUser.uid, _myUser.pendingTxnId);
      if (txn != null &&
          txn.tranStatus == UserTransaction.TRAN_STATUS_PENDING) {
      } else {
        //transaction doesnt exist or is no longer in PENDING status

      }
    }
  }

  static Widget getAppBar() {
    return AppBar(
      elevation: 1.0,
      backgroundColor: UiConstants.primaryColor,
      iconTheme: IconThemeData(
        color: UiConstants.accentColor, //change your color here
      ),
      title: Text('${Constants.APP_NAME}',
          style: TextStyle(
              color: UiConstants.accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 30.0)),
      bottom: PreferredSize(
          child: Container(
              color: Colors.blueGrey[100],
              height: 25.0,
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'We are currently in Beta',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.black54,
                      )
                    ],
                  ))),
          preferredSize: Size.fromHeight(25.0)),
    );
  }

  showPositiveAlert(String title, String message, BuildContext context,
      {int seconds}) {
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
      boxShadows: [
        BoxShadow(
          color: UiConstants.positiveAlertColor,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    )..show(context);
  }

  showNegativeAlert(String title, String message, BuildContext context,
      {int seconds}) {
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
      duration: Duration(seconds: seconds ?? 3),
      backgroundColor: UiConstants.negativeAlertColor,
      boxShadows: [
        BoxShadow(
          color: UiConstants.negativeAlertColor,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    )..show(context);
  }

  showNoInternetAlert(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        Icons.error,
        size: 28.0,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
      title: "No Internet",
      message: "Please check your network connection and try again",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
          color: Colors.red[800],
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
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
      log.error(
          "User Authentication failed with credential: Error: " + e.toString());
      return false;
    });
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      log.debug('Signed Out Firebase User');
      await _lModel.deleteLocalAppData();
      log.debug('Cleared local cache');
      return true;
    } catch (e) {
      log.error('Failed to clear data/sign out user: ' + e.toString());
      return false;
    }
  }

  int checkTicketCountValidity(List<TambolaBoard> requestedBoards) {
    if (requestedBoards != null && _myUser.ticket_count > 0) {
      if (requestedBoards.length < _myUser.ticket_count) {
        log.debug('Requested board count is less than needed tickets');
        int ticketCountRequired = _myUser.ticket_count - requestedBoards.length;

        if (ticketCountRequired > 0 && !BaseUtil.ticketRequestSent) {
          BaseUtil.ticketRequestSent = true;
          BaseUtil.ticketCountBeforeRequest = requestedBoards.length;
          return ticketCountRequired;
        }
      }
      if (BaseUtil.ticketRequestSent) {
        if (requestedBoards.length > BaseUtil.ticketCountBeforeRequest) {
          log.debug(
              'Previous request had completed and not the ticket count has increased');
          //BaseUtil.ticketRequestSent = false; //not really needed i think
        }
      }
    }
    return 0;
  }

  static int getWeekNumber() {
    DateTime tdt = new DateTime.now();
    int dayn = tdt.weekday;
    //tdt = new DateTime(tdt.year, tdt.month, tdt.day-dayn+3);
    //tdt.setDate(tdt.getDate() - dayn + 3);
    DateTime firstThursday =
        new DateTime(tdt.year, tdt.month, tdt.day - dayn + 3);
    tdt = new DateTime(tdt.year, 1, 1);
    if (tdt.weekday != DateTime.friday) {
      //tdt.setMonth(0, 1 + ((4 - tdt.getDay()) + 7) % 7);
      int x = tdt.weekday;
      x = (tdt.weekday == 7) ? 0 : tdt.weekday;
      tdt = new DateTime(tdt.year, 1, 1 + ((5 - x) + 7) % 7);
    }
    int n = 1 +
        ((firstThursday.millisecondsSinceEpoch - tdt.millisecondsSinceEpoch) /
                604800000)
            .ceil();
    //log.debug("Current week number: " + n.toString());
    return n;
  }


  User get myUser => _myUser;

  set myUser(User value) {
    _myUser = value;
  }

  UserIciciDetail get iciciDetail => _iciciDetail;

  set iciciDetail(UserIciciDetail value) {
    _iciciDetail = value;
  }

  UserKycDetail get kycDetail => _kycDetail;

  set kycDetail(UserKycDetail value) {
    _kycDetail = value;
  }

  UserTransaction get currentICICITxn => _currentICICITxn;

  set currentICICITxn(UserTransaction value) {
    _currentICICITxn = value;
  }

  bool isSignedIn() => (firebaseUser != null && firebaseUser.uid != null);

  bool isActiveUser() => (_myUser != null && !_myUser.hasIncompleteDetails());
}

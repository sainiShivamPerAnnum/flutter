import 'dart:async';
import 'dart:math';

import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/PrizeLeader.dart';
import 'package:felloapp/core/model/ReferralLeader.dart';
import 'package:felloapp/core/model/UserIciciDetail.dart';
import 'package:felloapp/core/model/UserKycDetail.dart';
import 'package:felloapp/core/model/UserTicketWallet.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/model/TambolaBoard.dart';
import 'core/model/UserAugmontDetail.dart';
import 'util/size_config.dart';

class BaseUtil extends ChangeNotifier {
  final Log log = new Log("BaseUtil");
  DBModel _dbModel = locator<DBModel>();
  LocalDBModel _lModel = locator<LocalDBModel>();
  BaseUser _myUser;
  UserFundWallet _userFundWallet;
  UserTicketWallet _userTicketWallet;
  User firebaseUser;
  FirebaseAnalytics baseAnalytics;
  static RemoteConfig remoteConfig;
  PaymentService _payService;

  ///Tambola global objects
  DailyPick weeklyDigits;
  List<TambolaBoard> userWeeklyBoards;

  ///ICICI global objects
  UserIciciDetail _iciciDetail;
  UserTransaction _currentICICITxn;
  UserTransaction _currentICICINonInstantWthrlTxn;

  ///Augmont global objects
  UserAugmontDetail _augmontDetail;
  UserTransaction _currentAugmontTxn;

  ///KYC global object
  UserKycDetail _kycDetail;
  Map<String, dynamic> currentWeekWinners = {};
  List<PrizeLeader> prizeLeaders = [];
  List<ReferralLeader> referralLeaders = [];
  String myUserDpUrl;
  List<UserTransaction> userMiniTxnList;

  DateTime _userCreationTimestamp;
  int referCount = 0;
  int isOtpResendCount = 0;

  ///Flags in various screens defined as global variables
  bool isUserOnboarded = false;
  bool isLoginNextInProgress = false;
  bool isEditProfileNextInProgress = false;
  bool isRedemptionOtpInProgress = false;
  bool isAugmontRegnInProgress = false;
  bool isAugmontRegnCompleteAnimateInProgress = false;
  bool isIciciDepositRouteLogicInProgress = false;
  bool isEditAugmontBankDetailInProgress = false;
  bool isAugDepositRouteLogicInProgress = false;
  bool isAugWithdrawRouteLogicInProgress = false;
  bool isAugmontRealTimeBalanceFetched = false;
  bool weeklyDrawFetched = false;
  bool weeklyTicksFetched = false;
  bool referCountFetched = false;
  bool isProfilePictureUpdated = false;
  bool isReferralLinkBuildInProgressWhatsapp = false;
  bool isReferralLinkBuildInProgressOther = false;

  static const int TOTAL_DRAWS = 35;
  static const int NEW_USER_TICKET_COUNT = 5;
  static const int KYC_UNTESTED = 0;
  static const int KYC_INVALID = 1;
  static const int KYC_VALID = 2;
  static const int INVESTMENT_AMOUNT_FOR_TICKET = 100;
  static const int BALANCE_TO_TICKET_RATIO = 100;
  static bool isDeviceOffline = false;
  static bool ticketRequestSent = false;
  static int ticketCountBeforeRequest = NEW_USER_TICKET_COUNT;
  static int infoSliderIndex = 0;
  static bool playScreenFirst = true;

  ///STAGES - IMPORTANT
  static const AWSIciciStage activeAwsIciciStage = AWSIciciStage.PROD;
  static const AWSAugmontStage activeAwsAugmontStage = AWSAugmontStage.DEV;
  static const SignzyStage activeSignzyStage = SignzyStage.PROD;
  static const RazorpayStage activeRazorpayStage = RazorpayStage.DEV;

  Future init() async {
    ///analytics
    BaseAnalytics.init();
    BaseAnalytics.analytics.logAppOpen();

    ///fetch on-boarding status and User details
    firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      _myUser = await _dbModel.getUser(firebaseUser.uid); //_lModel.getUser();
    }

    isUserOnboarded =
        (firebaseUser != null && _myUser != null && _myUser.uid.isNotEmpty);
    if (isUserOnboarded) {
      //get user wallet
      _userFundWallet = await _dbModel.getUserFundWallet(firebaseUser.uid);
      if (_userFundWallet == null) _compileUserWallet();

      //get user ticket balance
      _userTicketWallet = await _dbModel.getUserTicketWallet(firebaseUser.uid);
      if(_userTicketWallet == null) {
        await _initiateNewTicketWallet();
      }
      //remote config for various remote variables
      await initRemoteConfig();
      //get user creation time
      _userCreationTimestamp = firebaseUser.metadata.creationTime;
      //check if there are any icici deposits txns in process
      _payService = locator<PaymentService>();
      if (myUser.isIciciOnboarded) _payService.verifyPaymentsIfAny();
    }
  }

  acceptNotificationsIfAny(BuildContext context) {
    //if payment completed in the background:
    if (_payService != null && myUser.pendingTxnId != null) {
      _payService.addPaymentStatusListener((value) {
        if (value == PaymentService.TRANSACTION_COMPLETE) {
          showPositiveAlert('Transaction Complete',
              'Your account balance has been updated!', context,
              seconds: 5);
        } else if (value == PaymentService.TRANSACTION_REJECTED) {
          showPositiveAlert('Transaction Closed',
              'The transaction was not completed', context,
              seconds: 5);
        } else {
          log.debug('Received notif for pending transaction: $value');
        }
      });
    }
    //
  }

  cancelIncomingNotifications() {
    _payService.addPaymentStatusListener(null);
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
      'aws_icici_key_index': '1',
      'aws_augmont_key_index': '1',
      'icici_deposits_enabled': '1',
      'augmont_deposits_enabled': '1',
      'augmont_deposit_permission': '1',
      'kyc_completion_prize': 'You have won ₹50 and 10 Tambola tickets!'
    });
    try {
      // Fetches every 12 hrs
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
          style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.largeTextSize)),
      // bottom: PreferredSize(
      //     child: Container(
      //         color: Colors.blueGrey[100],
      //         height: 25.0,
      //         child: Padding(
      //             padding:
      //                 EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Text(
      //                   'We are currently in Beta',
      //                   style: TextStyle(color: Colors.black54),
      //                 ),
      //                 Icon(
      //                   Icons.info_outline,
      //                   size: 20,
      //                   color: Colors.black54,
      //                 )
      //               ],
      //             ))),
      //     preferredSize: Size.fromHeight(25.0)),
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

  showRefreshIndicator(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        Icons.refresh,
        size: 28.0,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
      title: "Pull to Refresh",
      duration: Duration(seconds: 2),
      message: "Refresh to see the updated balance",
      backgroundColor: UiConstants.negativeAlertColor,
      boxShadows: [
        BoxShadow(
          color: UiConstants.negativeAlertColor.withOpacity(0.5),
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    )..show(context);
  }

  AuthCredential generateAuthCredential(String verificationId, String smsCode) {
    final AuthCredential credential = PhoneAuthProvider.credential(
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
    if (requestedBoards != null && _userTicketWallet.getActiveTickets() > 0) {
      if (requestedBoards.length < _userTicketWallet.getActiveTickets()) {
        log.debug('Requested board count is less than needed tickets');
        int ticketCountRequired = _userTicketWallet.getActiveTickets() - requestedBoards.length;

        if (ticketCountRequired > 0 && !BaseUtil.ticketRequestSent) {
          BaseUtil.ticketRequestSent = true;
          BaseUtil.ticketCountBeforeRequest = requestedBoards.length;
          return ticketCountRequired;
        }
      }
      if (BaseUtil.ticketRequestSent) {
        if (requestedBoards.length > BaseUtil.ticketCountBeforeRequest) {
          log.debug(
              'Previous request had completed and now the ticket count has increased');
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

  int getUpdatedWithdrawalClosingBalance(double investment) =>
      (toDouble(_userFundWallet.iciciBalance) +
              toDouble(_userFundWallet.augGoldBalance) +
              toDouble(_userFundWallet.prizeBalance) -
              investment)
          .round();

  int getUpdatedClosingBalance(double investment) => (investment +
          toDouble(_userFundWallet.iciciBalance) +
          toDouble(_userFundWallet.augGoldBalance) +
          toDouble(_userFundWallet.prizeBalance))
      .round();

  static T _cast<T>(x) => x is T ? x : null;

  static double toDouble(dynamic x) {
    if (x == null) return 0.0;
    try {
      int y = _cast<int>(x);
      if (y != null) return y + .0;
    } catch (e) {}

    try {
      double z = _cast<double>(x);
      if (z != null) return z;
    } catch (e) {}

    return 0.0;
  }

  static int toInt(dynamic x) {
    if (x == null) return 0;
    try {
      int y = _cast<int>(x);
      if (y != null) return y;
    } catch (e) {}

    try {
      String z = _cast<String>(x);
      if (z != null) return int.parse(z);
    } catch (e) {}

    return 0;
  }

  static double digitPrecision(double x, [int offset = 2, bool round = true]) {
    double y = x * pow(10, offset);
    int z = (round) ? y.round() : y.truncate();
    return z / pow(10, offset);
  }

  int getTicketCountForTransaction(double investment) =>
      (investment / BaseUtil.INVESTMENT_AMOUNT_FOR_TICKET).floor();

  //the new wallet logic will be empty for old user.
  //this method will copy the old values to the new wallet
  _compileUserWallet() {
    _userFundWallet =
        (_userFundWallet == null) ? UserFundWallet.newWallet() : _userFundWallet;
    if (_myUser.isIciciOnboarded && _myUser.icici_balance > 0) {
      _userFundWallet.iciciPrinciple = _myUser.icici_balance;
      _userFundWallet.iciciBalance = _myUser.icici_balance;
    }
    if (_myUser.isAugmontOnboarded && _myUser.augmont_balance > 0) {
      _userFundWallet.augGoldPrinciple = _myUser.augmont_balance;
      _userFundWallet.augGoldBalance = _myUser.augmont_balance;
      _userFundWallet.augGoldQuantity = _myUser.augmont_quantity;
    }
    // if (_myUser.prize_balance != null && _myUser.prize_balance > 0) {
    //   _userFundWallet.prizeBalance = _myUser.prize_balance + 0.0;
    // }
    if(_myUser.lifetime_winnings != null && _myUser.lifetime_winnings > 0) {
        _userFundWallet.prizeLifetimeWin = _myUser.lifetime_winnings + 0.0;
        //TODO update balance here
    }
  }

  Future<bool> _initiateNewTicketWallet() async{
    _userTicketWallet = UserTicketWallet.newTicketWallet();
    int _t = userTicketWallet.initTck;
    _userTicketWallet = await _dbModel.updateInitUserTicketCount(myUser.uid, _userTicketWallet, NEW_USER_TICKET_COUNT);
    //updateInitUserTicketCount method returns no change if operations fails
    return (_userTicketWallet.initTck != _t);
  }

  BaseUser get myUser => _myUser;

  set myUser(BaseUser value) {
    _myUser = value;
  }

  UserFundWallet get userFundWallet => _userFundWallet;

  set userFundWallet(UserFundWallet value) {
    _userFundWallet = value;
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

  UserTransaction get currentICICINonInstantWthrlTxn =>
      _currentICICINonInstantWthrlTxn;

  set currentICICINonInstantWthrlTxn(UserTransaction value) {
    _currentICICINonInstantWthrlTxn = value;
  }

  UserAugmontDetail get augmontDetail => _augmontDetail;

  set augmontDetail(UserAugmontDetail value) {
    _augmontDetail = value;
  }

  bool isSignedIn() => (firebaseUser != null && firebaseUser.uid != null);

  bool isActiveUser() => (_myUser != null && !_myUser.hasIncompleteDetails());

  UserTransaction get currentAugmontTxn => _currentAugmontTxn;

  set currentAugmontTxn(UserTransaction value) {
    _currentAugmontTxn = value;
  }

  DateTime get userCreationTimestamp => _userCreationTimestamp;

  UserTicketWallet get userTicketWallet => _userTicketWallet;

  set userTicketWallet(UserTicketWallet value) {
    _userTicketWallet = value;
  }
}

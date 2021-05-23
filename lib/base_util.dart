import 'dart:async';
import 'dart:math';

import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/model/AugGoldRates.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/FeedCard.dart';
import 'package:felloapp/core/model/PrizeLeader.dart';
import 'package:felloapp/core/model/ReferralDetail.dart';
import 'package:felloapp/core/model/ReferralLeader.dart';
import 'package:felloapp/core/model/UserIciciDetail.dart';
import 'package:felloapp/core/model/UserKycDetail.dart';
import 'package:felloapp/core/model/UserTicketWallet.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/ui/elements/week-winners.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:showcaseview/showcase.dart';

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
  List<FeedCard> feedCards;

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
  AugmontRates augmontGoldRates;

  ///KYC global object
  UserKycDetail _kycDetail;
  List<WeekWinner> currentWeekWinners = [];
  List<PrizeLeader> prizeLeaders = [];
  List<ReferralLeader> referralLeaders = [];
  String myUserDpUrl;
  List<UserTransaction> userMiniTxnList;
  List<ReferralDetail> userReferralsList;
  ReferralDetail myReferralInfo;
  String version;

  DateTime _userCreationTimestamp;
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
  bool isWeekWinnersFetched = false;
  bool isPrizeLeadersFetched = false;
  bool isReferralLeadersFetched = false;
  bool weeklyDrawFetched = false;
  bool weeklyTicksFetched = false;
  bool referralsFetched = false;
  bool userReferralInfoFetched = false;
  bool isProfilePictureUpdated = false;
  bool isReferralLinkBuildInProgressWhatsapp = false;
  bool isReferralLinkBuildInProgressOther = false;
  bool isHomeCardsFetched = false;
  bool show_game_tutorial = false;
  bool show_finance_tutorial = false;
  static bool isDeviceOffline = false;
  static bool ticketRequestSent = false;
  static int ticketCountBeforeRequest = Constants.NEW_USER_TICKET_COUNT;
  static int infoSliderIndex = 0;
  static bool playScreenFirst = true;
  static int atomicTicketGenerationLeftCount = 0;
  static int atomicTicketDeletionLeftCount = 0;

  Future init() async {
    ///analytics
    BaseAnalytics.init();
    BaseAnalytics.analytics.logAppOpen();

    ///fetch on-boarding status and User details
    firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      _myUser = await _dbModel.getUser(firebaseUser.uid); //_lModel.getUser();
    }

    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    version = '${_packageInfo.version}+${_packageInfo.buildNumber}';

    isUserOnboarded =
        (firebaseUser != null && _myUser != null && _myUser.uid.isNotEmpty);
    if (isUserOnboarded) {
      //get user wallet
      _userFundWallet = await _dbModel.getUserFundWallet(firebaseUser.uid);
      if (_userFundWallet == null) _compileUserWallet();

      //get user ticket balance
      _userTicketWallet = await _dbModel.getUserTicketWallet(firebaseUser.uid);
      if (_userTicketWallet == null) {
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
  }

  cancelIncomingNotifications() {
    if(_payService != null)_payService.addPaymentStatusListener(null);
  }

  initRemoteConfig() async {
    remoteConfig = await RemoteConfig.instance;
    remoteConfig.setDefaults(<String, dynamic>{
      'draw_pick_time': '18',
      'tambola_header_1': 'Today\'s picks',
      'tambola_header_2': 'Click to see the other picks',
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
      'icici_deposit_permission': '1',
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

      //TODO better fix required
      ///IMP: When a user signs out and attempts
      /// to sign in again without closing the app,
      /// the old variables are still in effect
      /// resetting them like below for now
      _myUser = null;
      _userFundWallet = null;
      _userTicketWallet = null;
      _payService = null;
      feedCards = null;
      weeklyDigits = null;
      userWeeklyBoards = null;
      _iciciDetail = null;
      _currentICICITxn = null;
      _currentICICINonInstantWthrlTxn = null;
      _augmontDetail = null;
      _currentAugmontTxn = null;
      _kycDetail = null;
      currentWeekWinners = null;
      prizeLeaders = null;
      referralLeaders = null;
      myUserDpUrl = null;
      userMiniTxnList = null;
      userReferralsList = null;
      myReferralInfo = null;
      _userCreationTimestamp = null;

      isOtpResendCount = 0;

      isUserOnboarded = false;
      isLoginNextInProgress = false;
      isEditProfileNextInProgress = false;
      isRedemptionOtpInProgress = false;
      isAugmontRegnInProgress = false;
      isAugmontRegnCompleteAnimateInProgress = false;
      isIciciDepositRouteLogicInProgress = false;
      isEditAugmontBankDetailInProgress = false;
      isAugDepositRouteLogicInProgress = false;
      isAugWithdrawRouteLogicInProgress = false;
      isAugmontRealTimeBalanceFetched = false;
      weeklyDrawFetched = false;
      weeklyTicksFetched = false;
      referralsFetched = false;
      userReferralInfoFetched = false;
      isProfilePictureUpdated = false;
      isReferralLinkBuildInProgressWhatsapp = false;
      isReferralLinkBuildInProgressOther = false;
      isHomeCardsFetched = false;
      isDeviceOffline = false;
      ticketRequestSent = false;
      ticketCountBeforeRequest = Constants.NEW_USER_TICKET_COUNT;
      infoSliderIndex = 0;
      playScreenFirst = true;
      atomicTicketGenerationLeftCount = 0;
      atomicTicketDeletionLeftCount = 0;

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
        int ticketCountRequired =
            _userTicketWallet.getActiveTickets() - requestedBoards.length;

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

  static Widget buildShowcaseWrapper(
      GlobalKey showcaseKey, String showcaseMsg, Widget body) {
    return Showcase.withWidget(
        key: showcaseKey,
        description: showcaseMsg,
        contentPadding: EdgeInsets.all(20),
        //descTextStyle: TextStyle(fontSize: 20),
        width: 300,
        height: 140,
        container: Container(
          padding: EdgeInsets.all(20),
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(UiConstants.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Container(
            width: SizeConfig.screenWidth * 0.84,
            child: Text(
              showcaseMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  fontWeight: FontWeight.w300,
                  color: UiConstants.accentColor),
            ),
          ),
        ),
        overlayOpacity: 0.6,
        child: body);
  }

  bool isOldCustomer() {
     //all users before april 2021 are marked old
    if (userCreationTimestamp == null) return false;
    return (userCreationTimestamp.isBefore(Constants.VERSION_2_RELEASE_DATE));
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

  double getUpdatedWithdrawalClosingBalance(double investment) =>
      (toDouble(_userFundWallet.iciciBalance) +
          toDouble(_userFundWallet.augGoldBalance) +
          toDouble(_userFundWallet.prizeBalance) +
          toDouble(_userFundWallet.lockedPrizeBalance) -
          investment);

  double getCurrentTotalClosingBalance() =>
      (toDouble(_userFundWallet.iciciBalance) +
          toDouble(_userFundWallet.augGoldBalance) +
          toDouble(_userFundWallet.prizeBalance) +
          toDouble(_userFundWallet.lockedPrizeBalance));

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
      (investment / Constants.INVESTMENT_AMOUNT_FOR_TICKET).floor();

  //the new wallet logic will be empty for old user.
  //this method will copy the old values to the new wallet
  _compileUserWallet() {
    _userFundWallet = (_userFundWallet == null)
        ? UserFundWallet.newWallet()
        : _userFundWallet;
    // if (_myUser.isIciciOnboarded && _myUser.icici_balance > 0) {
    //   _userFundWallet.iciciPrinciple = _myUser.icici_balance;
    //   _userFundWallet.iciciBalance = _myUser.icici_balance;
    // }
    // if (_myUser.isAugmontOnboarded && _myUser.augmont_balance > 0) {
    //   _userFundWallet.augGoldPrinciple = _myUser.augmont_balance;
    //   _userFundWallet.augGoldBalance = _myUser.augmont_balance;
    //   _userFundWallet.augGoldQuantity = _myUser.augmont_quantity;
    // }
    // if (_myUser.prize_balance != null && _myUser.prize_balance > 0) {
    //   _userFundWallet.prizeBalance = _myUser.prize_balance + 0.0;
    // }
    if (_myUser.lifetime_winnings != null && _myUser.lifetime_winnings > 0) {
      _userFundWallet.prizeLifetimeWin = _myUser.lifetime_winnings + 0.0;
      //TODO update balance here
    }
  }

  Future<bool> _initiateNewTicketWallet() async {
    _userTicketWallet = UserTicketWallet.newTicketWallet();
    int _t = userTicketWallet.initTck;
    _userTicketWallet = await _dbModel.updateInitUserTicketCount(
        myUser.uid, _userTicketWallet, Constants.NEW_USER_TICKET_COUNT);
    //updateInitUserTicketCount method returns no change if operations fails
    return (_userTicketWallet.initTck != _t);
  }

  static String getMonthName(int monthNum) {
    switch (monthNum) {
      case 1:
        return "Jan";
        break;
      case 2:
        return "Feb";
        break;
      case 3:
        return "Mar";
        break;
      case 4:
        return "Apr";
        break;
      case 5:
        return "May";
        break;
      case 6:
        return "June";
        break;
      case 7:
        return "July";
        break;
      case 8:
        return "Aug";
        break;
      case 9:
        return "Sept";
        break;
      case 10:
        return "Oct";
        break;
      case 11:
        return "Nov";
        break;
      case 12:
        return "Dec";
        break;
      default:
        return "Month";
    }
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

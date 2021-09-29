//Project Imports
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/model/AugGoldRates.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/FeedCard.dart';
import 'package:felloapp/core/model/PrizeLeader.dart';
import 'package:felloapp/core/model/ReferralDetail.dart';
import 'package:felloapp/core/model/ReferralLeader.dart';
import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/core/model/UserFundWallet.dart';
import 'package:felloapp/core/model/UserIciciDetail.dart';
import 'package:felloapp/core/model/UserTicketWallet.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/pan_service.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/model/UserAugmontDetail.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/util/size_config.dart';

//Dart & Flutter Imports
import 'dart:async';
import 'dart:math';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:flutter/material.dart';

//Pub Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

class BaseUtil extends ChangeNotifier {
  final Log log = new Log("BaseUtil");
  final Logger logger = locator<Logger>();
  final DBModel _dbModel = locator<DBModel>();
  final LocalDBModel _lModel = locator<LocalDBModel>();
  final AppState _appState = locator<AppState>();
  final UserService _userService = locator<UserService>();

  BaseUser _myUser;
  UserFundWallet _userFundWallet;
  UserTicketWallet _userTicketWallet;
  User firebaseUser;
  FirebaseAnalytics baseAnalytics;
  PaymentService _payService;
  List<FeedCard> feedCards;
  int _dailyPickCount;
  String userRegdPan;
  List<int> todaysPicks;

  ///Tambola global objects
  DailyPick weeklyDigits;
  List<TambolaBoard> userWeeklyBoards;

  ///ICICI global objects
  UserIciciDetail _iciciDetail;
  UserTransaction _currentICICITxn;
  UserTransaction _currentICICINonInstantWthrlTxn;
  PanService panService;

  ///Augmont global objects
  UserAugmontDetail _augmontDetail;
  UserTransaction _currentAugmontTxn;
  AugmontRates augmontGoldRates;

  ///KYC global object
  TambolaWinnersDetail tambolaWinnersDetail;
  List<PrizeLeader> prizeLeaders = [];
  List<ReferralLeader> referralLeaders = [];
  String myUserDpUrl;
  List<UserTransaction> userMiniTxnList;
  List<ReferralDetail> userReferralsList;
  ReferralDetail myReferralInfo;
  static PackageInfo packageInfo;
  Map<String, dynamic> freshchatKeys;
  double activeGoldWithdrawalQuantity;
  int withdrawFlowStackCount;

  /// Objects for Transaction list Pagination
  DocumentSnapshot lastTransactionListDocument;
  bool hasMoreTransactionListDocuments = true;

  DateTime _userCreationTimestamp;
  int isOtpResendCount = 0;
  bool show_security_prompt = false;
  String zeroBalanceAssetUri;

  ///Flags in various screens defined as global variables
  bool isUserOnboarded,
      isLoginNextInProgress,
      isEditProfileNextInProgress,
      isRedemptionOtpInProgress,
      isAugmontRegnInProgress,
      isAugmontRegnCompleteAnimateInProgress,
      isSimpleKycInProgress,
      isIciciDepositRouteLogicInProgress,
      isEditAugmontBankDetailInProgress,
      isAugDepositRouteLogicInProgress,
      isAugWithdrawRouteLogicInProgress,
      isAugWithdrawalInProgress,
      isAugmontRealTimeBalanceFetched,
      isWeekWinnersFetched,
      isPrizeLeadersFetched,
      isReferralLeadersFetched,
      weeklyDrawFetched,
      weeklyTicksFetched,
      referralsFetched,
      userReferralInfoFetched,
      isProfilePictureUpdated,
      isReferralLinkBuildInProgressWhatsapp,
      isReferralLinkBuildInProgressOther,
      isHomeCardsFetched,
      isGoogleSignInProgress,
      show_home_tutorial,
      show_game_tutorial,
      show_finance_tutorial;
  static bool isDeviceOffline, ticketRequestSent, playScreenFirst;
  static int ticketCountBeforeRequest,
      infoSliderIndex,
      _atomicTicketGenerationLeftCount,
      ticketGenerateCount,
      atomicTicketDeletionLeftCount;

  _setRuntimeDefaults() {
    isUserOnboarded = false;
    isLoginNextInProgress = false;
    isEditProfileNextInProgress = false;
    isRedemptionOtpInProgress = false;
    isAugmontRegnInProgress = false;
    isAugmontRegnCompleteAnimateInProgress = false;
    isSimpleKycInProgress = false;
    isIciciDepositRouteLogicInProgress = false;
    isEditAugmontBankDetailInProgress = false;
    isAugDepositRouteLogicInProgress = false;
    isAugWithdrawRouteLogicInProgress = false;
    isAugWithdrawalInProgress = false;
    isAugmontRealTimeBalanceFetched = false;
    isWeekWinnersFetched = false;
    isPrizeLeadersFetched = false;
    isReferralLeadersFetched = false;
    weeklyDrawFetched = false;
    weeklyTicksFetched = false;
    referralsFetched = false;
    userReferralInfoFetched = false;
    isProfilePictureUpdated = false;
    isReferralLinkBuildInProgressWhatsapp = false;
    isReferralLinkBuildInProgressOther = false;
    isHomeCardsFetched = false;
    show_home_tutorial = false;
    show_game_tutorial = false;
    show_finance_tutorial = false;
    isGoogleSignInProgress = false;
    isDeviceOffline = false;
    ticketRequestSent = false;
    ticketCountBeforeRequest = Constants.NEW_USER_TICKET_COUNT;
    infoSliderIndex = 0;
    playScreenFirst = true;
    _atomicTicketGenerationLeftCount = 0;
    atomicTicketDeletionLeftCount = 0;
    show_security_prompt = false;
  }

  Future init() async {
    logger.i('inside init base util');
    _setRuntimeDefaults();

    //Analytics logs app open state.
    BaseAnalytics.init();
    BaseAnalytics.analytics.logAppOpen();

    //remote config for various remote variables
    logger.i('base util remote config');
    await BaseRemoteConfig.init();

    setPackageInfo();

    ///fetch on-boarding status and User details
    firebaseUser = _userService.firebaseUser;
    isUserOnboarded = await _userService.isUserOnborded;

    if (isUserOnboarded) {
      ///get user creation time
      _userCreationTimestamp = firebaseUser.metadata.creationTime;

      ///pick zerobalance asset
      Random rnd = new Random();
      zeroBalanceAssetUri = 'zerobal/zerobal_${rnd.nextInt(4) + 1}';

      ///see if security needs to be shown -> Move to save tab
      show_security_prompt = await _lModel.showSecurityPrompt();

      await getProfilePicUrl(); //Caching profile image

      setUserDefaults();
    }
  }

  void setUserDefaults() async {
    ///get user wallet -> Try moving it to view and viewmodel for finance
    _userFundWallet = await _dbModel.getUserFundWallet(firebaseUser.uid);
    if (_userFundWallet == null) _compileUserWallet();

    ///get user ticket balance --> Try moving it to view and viewmodel for game
    _userTicketWallet = await _dbModel.getUserTicketWallet(firebaseUser.uid);
    if (_userTicketWallet == null) {
      await _initiateNewTicketWallet();
    }

    ///prefill pan details if available --> Profile Section (Show pan number eye)
    panService = new PanService();
    if (!checkKycMissing) {
      userRegdPan = await panService.getUserPan();
    }

    ///prefill augmont details if available --> Save Tab
    if (myUser.isAugmontOnboarded) {
      augmontDetail = await _dbModel.getUserAugmontDetails(myUser.uid);
    }
  }

  void setPackageInfo() async {
    //Appversion //add it seperate method
    packageInfo = await PackageInfo.fromPlatform();
  }

  acceptNotificationsIfAny(BuildContext context) {
    ///if payment completed in the background:
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
    if (_payService != null) _payService.addPaymentStatusListener(null);
  }

  Future<bool> isUnreadFreshchatSupportMessages() async {
    try {
      var unreadCount = await Freshchat.getUnreadCountAsync;
      return (unreadCount['count'] > 0);
    } catch (e) {
      log.error('Error reading unread count variable: $e');
      Map<String, dynamic> errorDetails = {
        'User number': _myUser.mobile,
        'Error Type': 'Unread message count failed'
      };
      _dbModel.logFailure(_myUser.uid, FailType.FreshchatFail, errorDetails);
      return false;
    }
  }

  Future<void> refreshFunds() async {
    //TODO: ADD LOADER
    print("-----------------> I got called");
    return _dbModel.getUserFundWallet(myUser.uid).then((aValue) {
      if (aValue != null) {
        userFundWallet = aValue;
        if (userFundWallet.augGoldQuantity > 0)
          _updateAugmontBalance(); //setstate call in method

      }
      notifyListeners();
    });
  }

  static Widget getAppBar(BuildContext context, String title) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          AppState.backButtonDispatcher.didPopRoute();
        },
      ),
      elevation: 1.0,
      backgroundColor: UiConstants.primaryColor,
      iconTheme: IconThemeData(
        color: UiConstants.accentColor, //change your color here
      ),
      title: Text(title ?? '${Constants.APP_NAME}',
          style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.largeTextSize)),
    );
  }

  bool get checkKycMissing {
    bool skFlag = (myUser.isSimpleKycVerified != null &&
        myUser.isSimpleKycVerified == true);
    bool augFlag = false;
    if (myUser.isAugmontOnboarded) {
      final DateTime _dt = new DateTime(2021, 8, 28);
      //if the person regd for augmont before v2.5.4 release, then their kyc is complete
      augFlag = (augmontDetail != null &&
          augmontDetail.createdTime != null &&
          augmontDetail.createdTime.toDate().isBefore(_dt));
    }
    return (!skFlag && !augFlag);
  }

  showPositiveAlert(String title, String message, BuildContext context,
      {int seconds}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      )..show(AppState.delegate.navigatorKey.currentContext);
    });
  }

  showNegativeAlert(String title, String message, BuildContext context,
      {int seconds}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      )..show(AppState.delegate.navigatorKey.currentContext);
    });
  }

  showNoInternetAlert(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context, listen: false);

    if (connectivityStatus == ConnectivityStatus.Offline) {
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
      return true;
    }
    return false;
  }

  fetchWeeklyPicks({bool forcedRefresh}) async {
    if (forcedRefresh) weeklyDrawFetched = false;
    if (!weeklyDrawFetched) {
      try {
        log.debug('Requesting for weekly picks');
        DailyPick _picks = await _dbModel.getWeeklyPicks();
        weeklyDrawFetched = true;
        if (_picks != null) {
          weeklyDigits = _picks;
        }
        switch (DateTime.now().weekday) {
          case 1:
            todaysPicks = weeklyDigits.mon;
            break;
          case 2:
            todaysPicks = weeklyDigits.tue;
            break;
          case 3:
            todaysPicks = weeklyDigits.wed;
            break;
          case 4:
            todaysPicks = weeklyDigits.thu;
            break;
          case 5:
            todaysPicks = weeklyDigits.fri;
            break;
          case 6:
            todaysPicks = weeklyDigits.sat;
            break;
          case 7:
            todaysPicks = weeklyDigits.sun;
            break;
        }
        if (todaysPicks == null) {
          log.debug("Today's picks are not generated yet");
        }
      } catch (e) {
        log.error('$e');
      }
    }
  }

  Future<bool> getDrawStatus() async {
    // CHECKING IF THE PICK ARE DRAWN OR NOT
    if ((weeklyDrawFetched != null && !weeklyDrawFetched) ||
        weeklyDigits == null) await fetchWeeklyPicks(forcedRefresh: true);
    //CHECKING FOR THE FIRST TIME OPENING OF TAMBOLA AFTER THE PICKS ARE DRAWN FOR THIS PARTICULAR DAY
    notifyListeners();
    if (todaysPicks != null &&
        DateTime.now().weekday != await _lModel.getDailyPickAnimLastDay())
      return true;

    return false;
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
      _appState.setCurrentTabIndex = 0;

      //remove fcm token from remote
      await _dbModel.updateClientToken(myUser, '');

      //TODO better fix required
      ///IMP: When a user signs out and attempts
      /// to sign in again without closing the apcp,
      /// the old variables are still in effect
      /// resetting them like below for now
      _myUser = null;
      _userFundWallet = null;
      _userTicketWallet = null;
      firebaseUser = null;
      baseAnalytics = null;
      _payService = null;
      feedCards = null;
      _dailyPickCount = null;
      userRegdPan = null;
      weeklyDigits = null;
      userWeeklyBoards = null;
      _iciciDetail = null;
      _currentICICITxn = null;
      _currentICICINonInstantWthrlTxn = null;
      panService = null;
      _augmontDetail = null;
      augmontGoldRates = null;
      _currentAugmontTxn = null;
      tambolaWinnersDetail = null;
      prizeLeaders = [];
      referralLeaders = [];
      myUserDpUrl = null;
      userMiniTxnList = null;
      userReferralsList = null;
      myReferralInfo = null;
      packageInfo = null;
      freshchatKeys = null;
      _userCreationTimestamp = null;
      lastTransactionListDocument = null;
      hasMoreTransactionListDocuments = true;
      isOtpResendCount = 0;
      show_security_prompt = false;
      AppState.delegate.appState.setCurrentTabIndex = 0;
      _setRuntimeDefaults();

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

  Future<void> getProfilePicUrl() async {
    try {
      if (myUser != null) myUserDpUrl = await _dbModel.getUserDP(myUser.uid);
      if (myUserDpUrl != null) {
        print("got the image");
        notifyListeners();
      }
    } catch (e) {
      log.error(e.toString());
    }
  }

  static void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openTambolaHome() async {
    AppState.delegate.appState.setCurrentTabIndex = 1;
    if (await getDrawStatus()) {
      await _lModel.saveDailyPicksAnimStatus(DateTime.now().weekday).then(
            (value) =>
                print("Daily Picks Draw Animation Save Status Code: $value"),
          );
      AppState.delegate.appState.currentAction =
          PageAction(state: PageState.addPage, page: TPickDrawPageConfig);
    } else
      AppState.delegate.appState.currentAction =
          PageAction(state: PageState.addPage, page: THomePageConfig);
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
  }

  Future<bool> _initiateNewTicketWallet() async {
    _userTicketWallet = UserTicketWallet.newTicketWallet();
    int _t = userTicketWallet.initTck;
    _userTicketWallet = await _dbModel.updateInitUserTicketCount(
        myUser.uid, _userTicketWallet, Constants.NEW_USER_TICKET_COUNT);
    //updateInitUserTicketCount method returns no change if operations fails
    return (_userTicketWallet.initTck != _t);
  }

  void setDisplayPictureUrl(String url) {
    myUserDpUrl = url;
    notifyListeners();
  }

  void setName(String newName) {
    myUser.name = newName;
    notifyListeners();
  }

  void setKycVerified(bool val) {
    myUser.isSimpleKycVerified = val;
    notifyListeners();
  }

  void setUsername(String userName) {
    myUser.username = userName;
    notifyListeners();
  }

  void setEmailVerified() {
    myUser.isEmailVerified = true;
    notifyListeners();
  }

  void setEmail(String email) {
    myUser.email = email;
  }

  void refreshAugmontBalance() async {
    _dbModel.getUserFundWallet(myUser.uid).then((aValue) {
      if (aValue != null) {
        userFundWallet = aValue;
        if (userFundWallet.augGoldQuantity > 0) _updateAugmontBalance();
      }
    });
  }

  Future<void> _updateAugmontBalance() async {
    if (augmontDetail == null ||
        (userFundWallet.augGoldQuantity == 0 &&
            userFundWallet.augGoldBalance == 0)) return;
    AugmontModel().getRates().then((currRates) {
      if (currRates == null ||
          currRates.goldSellPrice == null ||
          userFundWallet.augGoldQuantity == 0) return;

      augmontGoldRates = currRates;
      double gSellRate = augmontGoldRates.goldSellPrice;
      userFundWallet.augGoldBalance =
          BaseUtil.digitPrecision(userFundWallet.augGoldQuantity * gSellRate);
      notifyListeners(); //might cause ui error if screen no longer active
    }).catchError((err) {
      if (_myUser.uid != null) {
        var errorDetails = {'error_msg': err.toString()};
        _dbModel.logFailure(
            _myUser.uid, FailType.UserAugmontBalanceUpdateFailed, errorDetails);
      }
      print('$err');
    });
  }

  void updateAugmontDetails(
      String holderName, String accountNumber, String ifscode) {
    _augmontDetail.bankHolderName = holderName;
    _augmontDetail.bankAccNo = accountNumber;
    _augmontDetail.ifsc = ifscode;
    notifyListeners();
  }

  void updateAugmontOnboarded(bool newValue) {
    _myUser.isAugmontOnboarded = newValue;
    notifyListeners();
  }

  void flipSecurityValue(bool value) {
    _myUser.userPreferences.setPreference(Preferences.APPLOCK, (value) ? 1 : 0);
    // saveSecurityValue(this.isSecurityEnabled);
    AppState.unsavedPrefs = true;
    notifyListeners();
  }

  void toggleTambolaNotificationStatus(bool value) {
    _myUser.userPreferences
        .setPreference(Preferences.TAMBOLANOTIFICATIONS, (value) ? 1 : 0);
    AppState.unsavedPrefs = true;
    notifyListeners();
  }

  //Saving and fetching app lock user preference
  // void saveSecurityValue(bool newValue) async {
  //   try {
  //     SharedPreferences _prefs = await SharedPreferences.getInstance();
  //     _prefs.setBool("securityEnabled", newValue);
  //   } catch(e) {
  //     log.debug("Error while saving security enabled value");
  //   }
  // }
  //
  // Future<bool> getSecurityValue() async {
  //   try {
  //     SharedPreferences _prefs = await SharedPreferences.getInstance();
  //     if(_prefs.containsKey("securityEnabled")) {
  //       bool _savedSecurityValue = _prefs.getBool("securityEnabled");
  //       if(_savedSecurityValue!=null) {
  //         return _savedSecurityValue;
  //       }
  //       else {
  //         return false;
  //       }
  //     }
  //   } catch(e) {
  //     log.debug("Error while retrieving security enabled value");
  //   }
  //   return false;
  // }

  static String getMonthName({@required int monthNum, bool trim = true}) {
    String res = "January";
    switch (monthNum) {
      case 1:
        res = "January";
        break;
      case 2:
        res = "February";
        break;
      case 3:
        res = "March";
        break;
      case 4:
        res = "April";
        break;
      case 5:
        res = "May";
        break;
      case 6:
        res = "June";
        break;
      case 7:
        res = "July";
        break;
      case 8:
        res = "August";
        break;
      case 9:
        res = "September";
        break;
      case 10:
        res = "October";
        break;
      case 11:
        res = "November";
        break;
      case 12:
        res = "December";
        break;
      default:
        res = "Janurary";
    }
    if (trim) return res.substring(0, 3);
    return res;
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
    notifyListeners();
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
    notifyListeners();
  }

  int get atomicTicketGenerationLeftCount => _atomicTicketGenerationLeftCount;

  set atomicTicketGenerationLeftCount(int value) {
    _atomicTicketGenerationLeftCount = value;
    notifyListeners();
  }

  int get dailyPicksCount => _dailyPickCount;

  Future<bool> isOfflineSnackBar(BuildContext context) async {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context, listen: false);

    if (connectivityStatus == ConnectivityStatus.Offline) {
      await showNegativeAlert('Offline', 'Please connect to internet', context,
          seconds: 3);
      return true;
    }
    return false;
  }
}

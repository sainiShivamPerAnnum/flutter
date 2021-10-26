import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/golden_ticket_claim.dart';
import 'package:felloapp/ui/modals_sheets/security_modal_sheet.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RootViewModel extends BaseModel {
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final HttpModel _httpModel = locator<HttpModel>();
  final FcmHandler _fcmListener = locator<FcmHandler>();
  final LocalDBModel _localDBModel = locator<LocalDBModel>();
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final AppState _appState = locator<AppState>();
  final Logger _logger = locator<Logger>();
  final winnerService = locator<WinnerService>();

  BuildContext rootContext;
  bool _isInitialized = false;

  String get myUserDpUrl => _userService.myUserDpUrl;
  int get currentTabIndex => _appState.rootIndex;

  Future<void> refresh() async {
    await _userCoinService.getUserCoinBalance();
    await _userService.getUserFundWalletData();
  }

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  List<Widget> pages;

  onInit() {
    pages = <Widget>[Save(), Play(), Win()];
    AppState().setCurrentTabIndex = 1;
    AppState().setRootLoadValue = true;
    _initDynamicLinks(AppState.delegate.navigatorKey.currentContext);
    _verifyManualReferral(AppState.delegate.navigatorKey.currentContext);
  }

  onDispose() {
    if (_baseUtil != null) _baseUtil.cancelIncomingNotifications();
    _fcmListener.addIncomingMessageListener(null);
  }

  openAlertsScreen() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: NotificationsConfig);
  }

  showDrawer() {
    // print("drawer opened");
    //AppState.screenStack.add(ScreenItem.dialog);
    scaffoldKey.currentState.openDrawer();
  }

  showTicketModal(BuildContext context) {
    AppState.screenStack.add(ScreenItem.dialog);
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return WantMoreTicketsModalSheet();
        });
  }

  void onItemTapped(int index) {
    AppState.delegate.appState.setCurrentTabIndex = index;
    switch (index) {
      case 1:
        AppState.isSaveOpened = true;
        break;
      case 2:
        winnerService.fetchWinners();
        break;
    }
    notifyListeners();
  }

  _initAdhocNotifications() {
    if (_fcmListener != null && _baseUtil != null) {
      _fcmListener.addIncomingMessageListener((valueMap) {
        if (valueMap['title'] != null && valueMap['body'] != null) {
          BaseUtil.showPositiveAlert(valueMap['title'], valueMap['body'],
              seconds: 5);
        }
      });
    }
  }

  void _showSecurityBottomSheet() {
    showModalBottomSheet(
        context: AppState.delegate.navigatorKey.currentContext,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        backgroundColor: UiConstants.bottomNavBarColor,
        builder: (context) {
          return const SecurityModalSheet();
        });
  }

  initialize() async {
    if (!_isInitialized) {
      _isInitialized = true;
      _localDBModel.showHomeTutorial.then((value) {
        if (value) {
          //show tutorial
          _localDBModel.setShowHomeTutorial = false;
          // AppState.delegate.parseRoute(Uri.parse('dashboard/walkthrough'));
          AppState.delegate.appState.currentAction =
              PageAction(state: PageState.addPage, page: WalkThroughConfig);
          notifyListeners();
        }
      });

      _initAdhocNotifications();

      _baseUtil.getProfilePicture();
      // show security modal
      if (_baseUtil.show_security_prompt &&
          _baseUtil.myUser.isAugmontOnboarded &&
          _baseUtil.myUser.userPreferences.getPreference(Preferences.APPLOCK) ==
              0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSecurityBottomSheet();
          _localDBModel.updateSecurityPrompt(false);
        });
      }
      _baseUtil.isUnreadFreshchatSupportMessages().then((flag) {
        if (flag) {
          BaseUtil.showPositiveAlert('You have unread support messages',
              'Go to the Contact Us section to view',
              seconds: 4);
        }
      });
    }
  }

  Future<dynamic> _verifyManualReferral(BuildContext context) async {
    if (BaseUtil.manualReferralCode == null) return null;
    try {
      PendingDynamicLinkData dynamicLinkData =
          await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(
              '${FlavorConfig.instance.values.dynamicLinkPrefix}/app/referral/${BaseUtil.manualReferralCode}'));
      Uri deepLink = dynamicLinkData?.link;
      _logger.d(deepLink.toString());
      if (deepLink != null)
        return _processDynamicLink(_baseUtil.myUser.uid, deepLink, context);
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<dynamic> _initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink == null) return null;

      _logger.d('Received deep link. Process the referral');
      return _processDynamicLink(_baseUtil.myUser.uid, deepLink, context);
    }, onError: (OnLinkErrorException e) async {
      _logger.e('Error in fetching deeplink');
      _logger.e(e);
      return null;
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      _logger.d('Received deep link. Process the referral');
      return _processDynamicLink(_baseUtil.myUser.uid, deepLink, context);
    }
  }

  _processDynamicLink(String userId, Uri deepLink, BuildContext context) async {
    String _uri = deepLink.toString();
    if (_uri.startsWith(Constants.GOLDENTICKET_DYNAMICLINK_PREFIX)) {
      //Golden ticket dynamic link
      int flag = await _submitGoldenTicket(userId, _uri, context);
    } else {
      BaseUtil.manualReferralCode =
          null; //make manual Code null in case user used both link and code

      //Referral dynamic link
      int addUserTicketCount = await _submitReferral(
          _baseUtil.myUser.uid, _userService.myUserName, _uri);
      if (addUserTicketCount == null || addUserTicketCount < 0) {
        _logger.d('Processing complete. No extra tickets to be added');
      } else {
        _logger.d('$addUserTicketCount tickets need to be added for the user');
      }
    }
  }

  Future<int> _submitReferral(
      String userId, String userName, String deepLink) async {
    try {
      String prefix = 'https://fello.in/';
      if (deepLink.startsWith(prefix)) {
        String referee = deepLink.replaceAll(prefix, '');
        _logger.d(referee);
        if (prefix.length > 0 && prefix != userId) {
          return _httpModel
              .postUserReferral(userId, referee, userName)
              .then((userTicketUpdateCount) {
            _logger.d('User deserves $userTicketUpdateCount more tickets');
            return userTicketUpdateCount;
          });
        } else
          return -1;
      } else
        return -1;
    } catch (e) {
      _logger.e(e);
      return -1;
    }
  }

  Future<int> _submitGoldenTicket(
      String userId, String deepLink, BuildContext context) async {
    try {
      String prefix = "https://fello.in/goldenticketdynlnk/";
      if (!deepLink.startsWith(prefix)) return -1;
      String docId = deepLink.replaceAll(prefix, '');
      if (docId != null && docId.isNotEmpty) {
        return _httpModel
            .postGoldenTicketRedemption(userId, docId)
            .then((redemptionMap) {
          //_logger.d('Flag is ${tckCount.toString()}');
          if (redemptionMap != null &&
              redemptionMap['flag'] &&
              redemptionMap['count'] > 0) {
            AppState.screenStack.add(ScreenItem.dialog);
            return showDialog(
              context: context,
              builder: (_) => GoldenTicketClaimDialog(
                ticketCount: redemptionMap['count'],
                cashPrize: redemptionMap['amt'],
              ),
            );
          } else {
            AppState.screenStack.add(ScreenItem.dialog);
            return showDialog(
              context: context,
              builder: (_) => GoldenTicketClaimDialog(
                ticketCount: 0,
                failMsg: redemptionMap['fail_msg'],
              ),
            );
          }
        });
      }
      return -1;
    } catch (e) {
      _logger.e('$e');
      return -1;
    }
  }
}

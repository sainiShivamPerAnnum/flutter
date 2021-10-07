import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/golden_ticket_claim.dart';
import 'package:felloapp/ui/modals/security_modal_sheet.dart';
import 'package:felloapp/ui/modals/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class RootViewModel extends BaseModel {
  Log log = new Log("Root_ViewModel");
  BaseUtil _baseUtil = locator<BaseUtil>();
  HttpModel _httpModel = locator<HttpModel>();
  FcmHandler _fcmListener = locator<FcmHandler>();
  LocalDBModel _localDBModel = locator<LocalDBModel>();
  UserService _userService = locator<UserService>();

  BuildContext rootContext;
  bool _isInitialized = false;

  String get myUserDpUrl => _userService.myUserDpUrl;

  refresh() {
    notifyListeners();
  }

  String get userTicketCount =>
      _baseUtil.userTicketWallet.getActiveTickets().toString();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Widget> pages;

  onInit() {
    pages = <Widget>[Play(), Save(), Win()];
    AppState().setRootLoadValue = true;
    _initDynamicLinks(AppState.delegate.navigatorKey.currentContext);
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
    AppState().setCurrentTabIndex = index;
    notifyListeners();
  }

  _initAdhocNotifications() {
    if (_fcmListener != null && _baseUtil != null) {
      _fcmListener.addIncomingMessageListener((valueMap) {
        if (valueMap['title'] != null && valueMap['body'] != null) {
          _baseUtil.showPositiveAlert(valueMap['title'], valueMap['body'],
              AppState.delegate.navigatorKey.currentContext,
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
          AppState.delegate.parseRoute(Uri.parse('dashboard/walkthrough'));
          notifyListeners();
        }
      });

      _initAdhocNotifications();

      //User service initialized;
      await _userService.init();
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
          _baseUtil.showPositiveAlert(
              'You have unread support messages',
              'Go to the Contact Us section to view',
              AppState.delegate.navigatorKey.currentContext,
              seconds: 4);
        }
      });
    }
  }

  Future<dynamic> _initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink == null) return null;

      log.debug('Received deep link. Process the referral');
      return _processDynamicLink(_baseUtil.myUser.uid, deepLink, context);
    }, onError: (OnLinkErrorException e) async {
      log.error('Error in fetching deeplink');
      log.error(e);
      return null;
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      log.debug('Received deep link. Process the referral');
      return _processDynamicLink(_baseUtil.myUser.uid, deepLink, context);
    }
  }

  _processDynamicLink(String userId, Uri deepLink, BuildContext context) async {
    String _uri = deepLink.toString();
    if (_uri.startsWith(Constants.GOLDENTICKET_DYNAMICLINK_PREFIX)) {
      //Golden ticket dynamic link
      int flag = await _submitGoldenTicket(userId, _uri, context);
    } else {
      //Referral dynamic link
      int addUserTicketCount = await _submitReferral(
          _baseUtil.myUser.uid, _userService.myUserName, _uri);
      if (addUserTicketCount == null || addUserTicketCount < 0) {
        log.debug('Processing complete. No extra tickets to be added');
      } else {
        log.debug('$addUserTicketCount tickets need to be added for the user');
      }
    }
  }

  Future<int> _submitReferral(
      String userId, String userName, String deepLink) async {
    try {
      String prefix = 'https://fello.in/';
      if (deepLink.startsWith(prefix)) {
        String referee = deepLink.replaceAll(prefix, '');
        log.debug(referee);
        if (prefix.length > 0 && prefix != userId) {
          return _httpModel
              .postUserReferral(userId, referee, userName)
              .then((userTicketUpdateCount) {
            log.debug('User deserves $userTicketUpdateCount more tickets');
            return userTicketUpdateCount;
          });
        } else
          return -1;
      } else
        return -1;
    } catch (e) {
      log.error(e);
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
          // log.debug('Flag is ${tckCount.toString()}');
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
      log.error('$e');
      return -1;
    }
  }
}

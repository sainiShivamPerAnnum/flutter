import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/core/model/quick_save_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/modalsheets/security_modal_sheet.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_view.dart';
import 'package:felloapp/ui/shared/spotlight_controller.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
// import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

enum NavBarItem { Journey, Save, Account, Play, Tambola }

class RootViewModel extends BaseViewModel {
  RootViewModel({S? l})
      : locale = l ?? locator<S>(),
        super();

  final BaseUtil _baseUtil = locator<BaseUtil>();

  final FcmListener _fcmListener = locator<FcmListener>();
  final FcmHandler _fcmHandler = locator<FcmHandler>();
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final JourneyService _journeyService = locator<JourneyService>();
  final UserRepository _userRepo = locator<UserRepository>();
  final TambolaService _tambolaService = locator<TambolaService>();
  final ScratchCardService _gtService = locator<ScratchCardService>();
  final BankAndPanService _bankAndKycService = locator<BankAndPanService>();
  final PowerPlayService _powerPlayService = locator<PowerPlayService>();
  final AppState appState = locator<AppState>();
  final SubService _subscriptionService = locator<SubService>();
  final S locale;
  int _bottomNavBarIndex = 0;
  static bool canExecuteStartupNotification = true;
  bool showHappyHourBanner = false;
  bool fetchCampaign = true;
  bool _isWelcomeAnimationInProgress = true;

  bool get isWelcomeAnimationInProgress => _isWelcomeAnimationInProgress;

  set isWelcomeAnimationInProgress(bool value) {
    _isWelcomeAnimationInProgress = value;
    notifyListeners();
  }

  // final WinnerService? winnerService = locator<WinnerService>();
  final ReferralRepo _refRepo = locator<ReferralRepo>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final ReferralService _referralService = locator<ReferralService>();
  final MarketingEventHandlerService _marketingService =
      locator<MarketingEventHandlerService>();
  final RootController _rootController = locator<RootController>();

  Future<void> refresh() async {
    if (_rootController.currentNavBarItemModel ==
        RootController.tambolaNavBar) {
      return;
    }

    await Future.wait([
      _userCoinService.getUserCoinBalance(),
      _userService.getUserFundWalletData(),
      _journeyService.checkForMilestoneLevelChange(),
      _gtService.updateUnscratchedGTCount(),
      _journeyService.getUnscratchedGT(),
      _subscriptionService.getSubscription(),
    ]);

    _txnHistoryService.signOut();
  }

  Future<void> onInit() async {
    log("onInit called");

    AppState.isUserSignedIn = true;
    appState.setRootLoadValue = true;

    if (!await verifyUserBootupDetails()) return;
    await checkForBootUpAlerts();

    _rootController.currentNavBarItemModel =
        _rootController.navItems.values.first;

    await Future.wait([
      _referralService.verifyReferral(),
      _referralService.initDynamicLinks(),
    ]);

    await initialize();
  }

  Future<void> initialize() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await _userService.userBootUpEE();

        await showLastWeekOverview();

        if (AppState.isFirstTime) {
          Future.delayed(const Duration(seconds: 1),
              SpotLightController.instance.showTourDialog);
        }

        handleStartUpNotificationData();

        await Future.wait([
          _userService.checkForNewNotifications(),
          _userService.getProfilePicture(),
          _fcmListener.refreshTopics(),
        ]);

        _initAdhocNotifications();

        if (!AppState.isFirstTime && fetchCampaign) {
          showMarketingCampings();
        }
      },
    );
  }

  void showMarketingCampings() {
    Future.delayed(const Duration(seconds: 2), _marketingService.getCampaigns);
  }

  Map<Widget, NavBarItemModel> get navBarItems =>
      locator<RootController>().navItems;

  void onDispose() {
    AppState.isUserSignedIn = false;
    appState.setRootLoadValue = false;
    _fcmHandler.addIncomingMessageListener(null);
  }

  void _initAdhocNotifications() {
    if (_fcmListener != null && _baseUtil != null) {
      _fcmHandler.addIncomingMessageListener((valueMap) {
        if (valueMap['title'] != null && valueMap['body'] != null) {
          if (AppState.screenStack.last == ScreenItem.dialog ||
              AppState.screenStack.last == ScreenItem.modalsheet) return;
          BaseUtil.showPositiveAlert(valueMap['title'], valueMap['body'],
              seconds: 5);
        }
      });
    }
  }

  FileType getFileType(String fileUrl) {
    String extension = fileUrl.toLowerCase().split('.').last;

    switch (extension) {
      case "svg":
        return FileType.SVG;
      case "json":
      case "lottie":
        return FileType.Lottie;
      case "png":
      case "jpeg":
      case "webp":
      case "jpg":
        return FileType.png;
      default:
        return FileType.Unknown;
    }
  }

  Widget centerTab(
    BuildContext context,
  ) {
    Widget childWidget;
    final quickSaveData = _userService.quickSaveModel?.data;

    if (quickSaveData == null || quickSaveData.isEmpty) {
      return defaultCenterButton();
    }

    if (quickSaveData.length == 1) {
      String fileUrl = quickSaveData[1].icon!;
      childWidget = BaseUtil.getWidgetBasedOnUrl(fileUrl);
    } else {
      childWidget = const Icon(
        Icons.add,
        color: Colors.white,
      );
    }

    void onTap() {
      if (quickSaveData.length == 1) {
        if (quickSaveData[0].action == null ||
            (quickSaveData[0].action?.isEmpty ?? false)) {
          BaseUtil().openRechargeModalSheet(
            investmentType: InvestmentType.AUGGOLD99,
          );
        } else {
          AppState.delegate!.parseRoute(Uri.parse(quickSaveData[0].action!));
        }
      } else {
        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          enableDrag: false,
          hapticVibrate: true,
          isBarrierDismissible: true,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          content: QuickSaveModalSheet(
            quickSaveData: quickSaveData,
          ),
        );
      }
    }

    return FloatingActionButton(
      elevation: 10,
      onPressed: onTap,
      backgroundColor: Colors.black,
      child: childWidget,
    );
  }

  Widget defaultCenterButton() {
    return FloatingActionButton(
      elevation: 10,
      backgroundColor: Colors.black,
      onPressed: () {
        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          enableDrag: false,
          hapticVibrate: true,
          isBarrierDismissible: true,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          content: const DefaultQuickSaveModalSheet(),
        );
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  void onCenterButtonTap() {}

  Future<void> openJourneyView() async {
    AppState.delegate!.appState.currentAction =
        PageAction(page: JourneyViewPageConfig, state: PageState.addPage);
  }

  void _showSecurityBottomSheet() {
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      isBarrierDismissible: false,
      borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: Radius.circular(SizeConfig.roundness12)),
      backgroundColor:
          UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
      content: SecurityModalSheet(),
    );
    _fcmHandler.addIncomingMessageListener((valueMap) {
      if (valueMap['title'] != null && valueMap['body'] != null) {
        BaseUtil.showPositiveAlert(valueMap['title'], valueMap['body'],
            seconds: 5);
      }
    });
  }

  Future<void> checkForBootUpAlerts() async {
    bool updateAvailable =
        PreferenceHelper.getBool(Constants.IS_APP_UPDATE_AVAILABLE, def: false);
    bool isMsgNoticeAvailable =
        PreferenceHelper.getBool(Constants.IS_MSG_NOTICE_AVAILABLE, def: false);
    if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
    if (updateAvailable) {
      AppState.isRootAvailableForIncomingTaskExecution = false;
      BaseUtil.openDialog(
        isBarrierDismissible: false,
        hapticVibrate: true,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: "App Update Available",
          description:
              "A new version of the app is available. Update now to enjoy the hassle free experience.",
          buttonText: "Update Now",
          cancelBtnText: "Not now",
          confirmAction: () {
            try {
              if (Platform.isIOS) {
                BaseUtil.launchUrl(Constants.APPLE_STORE_APP_LINK);
              } else if (Platform.isAndroid) {
                BaseUtil.launchUrl(Constants.PLAY_STORE_APP_LINK);
              }
            } catch (e) {
              _logger?.e(e.toString());
            }
            AppState.backButtonDispatcher!.didPopRoute();
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
            return false;
          },
        ),
      );
    } else if (isMsgNoticeAvailable) {
      AppState.isRootAvailableForIncomingTaskExecution = false;
      String msg = PreferenceHelper.getString(Constants.MSG_NOTICE);
      BaseUtil.openDialog(
        isBarrierDismissible: false,
        hapticVibrate: true,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: "Notice",
          description: msg,
          buttonText: "Ok",
          cancelBtnText: "Cancel",
          confirmAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
            return true;
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
            return false;
          },
        ),
      );
    }
  }

  Future<void> handleStartUpNotificationData() async {
    if (AppState.isRootAvailableForIncomingTaskExecution == true &&
        AppState.startupNotifMessage != null) {
      AppState.isRootAvailableForIncomingTaskExecution = false;
      await _fcmHandler.handleMessage(
        AppState.startupNotifMessage,
        MsgSource.Terminated,
      );
    }
  }

  Future<void> checkIfAppLockModalSheetIsRequired() async {
    // show security modal
    if (!canExecuteStartupNotification) return;

    bool showSecurityPrompt = PreferenceHelper.getBool(
        PreferenceHelper.CACHE_SHOW_SECURITY_MODALSHEET,
        def: true);
    if (showSecurityPrompt &&
        _userService.baseUser!.isAugmontOnboarded! &&
        _userService.userFundWallet!.augGoldQuantity > 0 &&
        _userService.baseUser!.userPreferences
                .getPreference(Preferences.APPLOCK) ==
            0) {
      canExecuteStartupNotification = false;
      Future.delayed(const Duration(seconds: 2), () {
        _showSecurityBottomSheet();
        PreferenceHelper.setBool(
            PreferenceHelper.CACHE_SHOW_SECURITY_MODALSHEET, false);
      });
    }
  }

  void setShowHappyHour(bool showHappyHour) {
    showHappyHourBanner = showHappyHour;
    notifyListeners();
  }

  Future<bool> verifyUserBootupDetails() async {
    bool flag = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_userService.baseUser != null && _userService.userBootUp != null) {
        //1.check if the account is blocked
        if (_userService.userBootUp!.data != null &&
            _userService.userBootUp!.data!.isBlocked != null &&
            _userService.userBootUp!.data!.isBlocked == true) {
          AppState.isRootAvailableForIncomingTaskExecution = false;
          AppState.isUpdateScreen = true;
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.replaceAll,
            page: BlockedUserPageConfig,
          );

          flag = false;
          return;
        }
        // //2.Checking for forced App Update
        if (_userService.userBootUp!.data!.isAppForcedUpdateRequired != null &&
            _userService.userBootUp!.data!.isAppForcedUpdateRequired == true) {
          AppState.isUpdateScreen = true;
          AppState.isRootAvailableForIncomingTaskExecution = false;
          AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.replaceAll, page: UpdateRequiredConfig);
          flag = false;
          return;
        }

        //3. Sign out the user automatically
        if (_userService.userBootUp!.data!.signOutUser != null &&
            _userService.userBootUp!.data!.signOutUser == true) {
          Haptic.vibrate();
          AppState.isRootAvailableForIncomingTaskExecution = false;
          _userService.signOut(() async {
            _analyticsService.track(eventName: AnalyticsEvents.signOut);
            _analyticsService.signOut();
            await _userRepo?.removeUserFCM(_userService.baseUser!.uid);
          }).then((flag) async {
            if (flag) {
              await BaseUtil().signOut();
              _tambolaService?.dispose();
              _analyticsService.signOut();
              _bankAndKycService?.dump();
              _subscriptionService.dispose();
              _powerPlayService.dump();
              AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.replaceAll, page: SplashPageConfig);
              BaseUtil.showPositiveAlert(
                'Session timed out ⚠️',
                'Please sign in again.',
              );
            }
          });
          flag = false;
          return;
        }

        //4. App update present (Not forced)
        if (_userService.userBootUp!.data!.isAppUpdateRequired != null) {
          PreferenceHelper.setBool(Constants.IS_APP_UPDATE_AVAILABLE,
              _userService.userBootUp!.data!.isAppUpdateRequired!);
        } else {
          PreferenceHelper.setBool(Constants.IS_APP_UPDATE_AVAILABLE, false);
        }

        //5. Clear all the caches
        if (_userService.userBootUp!.data!.cache!.keys != null) {
          for (String id
              in _userService.userBootUp!.data!.cache!.keys as List<String>) {
            CacheService.invalidateByKey(id);
          }
        }

        //6. Notice
        if (_userService.userBootUp?.data?.notice != null) {
          if (_userService.userBootUp!.data!.notice!.message != null &&
              _userService.userBootUp!.data!.notice!.message != "") {
            PreferenceHelper.setBool(Constants.IS_MSG_NOTICE_AVAILABLE, true);
            PreferenceHelper.setString(Constants.MSG_NOTICE,
                _userService.userBootUp!.data!.notice!.message!);
          } else {
            PreferenceHelper.setBool(Constants.IS_MSG_NOTICE_AVAILABLE, false);
          }

          if (_userService.userBootUp!.data!.notice!.url != null &&
              _userService.userBootUp!.data!.notice!.url != "") {
            AppState.isRootAvailableForIncomingTaskExecution = false;
            try {
              if (Platform.isIOS) {
                BaseUtil.launchUrl(_userService.userBootUp!.data!.notice!.url!);
              } else if (Platform.isAndroid) {
                BaseUtil.launchUrl(_userService.userBootUp!.data!.notice!.url!);
              }
            } catch (e) {
              _logger?.d(e.toString());
            }
          } else {}
        }
      }
    });
    return flag;
  }

  Future<void> showLastWeekOverview() async {
    if (isWelcomeAnimationInProgress &&
        AppState.isFirstTime == false &&
        await BaseUtil.isFirstTimeThisWeek()) {
      log('showLastWeekOverview condition ok', name: 'HomeVM');

      final response = await locator<CampaignRepo>().getLastWeekData();

      log('last_week => ${response.model?.toJson()}', name: 'HomeVM');

      try {
        if (response.isSuccess() &&
            response.model != null &&
            response.model?.data != null) {
          if (AppState.screenStack.length == 1 &&
              (AppState.screenStack.last != ScreenItem.dialog ||
                  AppState.screenStack.last != ScreenItem.modalsheet)) {
            unawaited(BaseUtil.openModalBottomSheet(
              addToScreenStack: true,
              backgroundColor: UiConstants.gameCardColor,
              content: LastWeekUi(
                model: response.model!.data!,
                fromRoot: true,
                callCampaign: true,
              ),
              hapticVibrate: true,
              isScrollControlled: true,
              isBarrierDismissible: false,
            ));

            fetchCampaign = false;
          } else {
            await PreferenceHelper.setInt(PreferenceHelper.LAST_WEEK_NUMBER, 0);
          }
        } else {
          await PreferenceHelper.setInt(PreferenceHelper.LAST_WEEK_NUMBER, 0);
        }
      } catch (e) {
        await PreferenceHelper.setInt(PreferenceHelper.LAST_WEEK_NUMBER, 0);
        debugPrint(e.toString());
      }
    }
  }
}

class QuickSaveModalSheet extends StatelessWidget {
  const QuickSaveModalSheet({Key? key, required this.quickSaveData})
      : super(key: key);

  final List<QuickSaveData> quickSaveData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
        decoration: BoxDecoration(
          color: const Color(0xff1B262C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding16),
            topRight: Radius.circular(SizeConfig.padding16),
          ),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Quick Actions with Fello
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding24),
                child: Text('Quick Actions with Fello',
                    style: TextStyles.rajdhaniSB.body1),
              ),
              SizedBox(height: SizeConfig.padding4),
              //Select anyone option to perform a quick action
              Text('Select anyone option to perform a quick action',
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.6))),
              SizedBox(height: SizeConfig.padding20),

              ...quickSaveData
                  .map((data) => GestureDetector(
                        onTap: () {
                          if (data.misc?.asset == 'AUGGOLD99') {
                            BaseUtil().openRechargeModalSheet(
                                investmentType: InvestmentType.AUGGOLD99,
                                amt: data.misc?.amount);
                          } else if (data.misc?.asset == 'LENDBOXP2P') {
                            BaseUtil().openRechargeModalSheet(
                                investmentType: InvestmentType.LENDBOXP2P,
                                amt: data.misc?.amount);
                          } else if (data.misc?.asset == "HH") {
                            BaseUtil.openDepositOptionsModalSheet(
                                amount: data.misc?.amount, timer: 0);
                          } else {
                            AppState.delegate!
                                .parseRoute(Uri.parse(data.action!));
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding26,
                              vertical: SizeConfig.padding16),
                          // height: SizeConfig.padding70,
                          margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness8),
                              border: Border.all(
                                  color: const Color(0xffD3D3D3)
                                      .withOpacity(0.2))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: SizeConfig.padding38,
                                child: BaseUtil.getWidgetBasedOnUrl(
                                  data.icon!,
                                  width: SizeConfig.padding54,
                                ),
                              ),
                              SizedBox(width: SizeConfig.padding26),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(data.title!,
                                      style: TextStyles.rajdhaniB.title5),
                                  Flexible(
                                    child: Text(
                                      data.subTitle!,
                                      style: TextStyles.sourceSans.body4.colour(
                                          Colors.white.withOpacity(0.6)),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList(),

              SizedBox(height: SizeConfig.padding20),
            ]),
      ),
    );
  }
}

class DefaultQuickSaveModalSheet extends StatelessWidget {
  const DefaultQuickSaveModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher?.didPopRoute();
        return true;
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
          decoration: BoxDecoration(
            color: const Color(0xff1B262C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.padding16),
              topRight: Radius.circular(SizeConfig.padding16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Quick Actions with Fello
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding24),
                child: Text('Quick Actions with Fello',
                    style: TextStyles.rajdhaniSB.body1),
              ),
              SizedBox(height: SizeConfig.padding4),
              //Select anyone option to perform a quick action
              Text('Select anyone option to perform a quick action',
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.6))),
              SizedBox(height: SizeConfig.padding20),

              GestureDetector(
                onTap: () {
                  AppState.backButtonDispatcher?.didPopRoute();
                  BaseUtil().openRechargeModalSheet(
                      investmentType: InvestmentType.AUGGOLD99, amt: 500);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding26,
                      vertical: SizeConfig.padding16),
                  // height: SizeConfig.padding70,
                  margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8),
                      border: Border.all(
                          color: const Color(0xffD3D3D3).withOpacity(0.2))),
                  child: Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.padding38,
                        child: Lottie.asset(
                          'assets/lotties/nav/journey.json',
                          fit: BoxFit.contain,
                          width: SizeConfig.padding54,
                        ),
                        // child: SvgPicture.asset(
                        //   'assets/svg/digitalgold.svg',
                        //   fit: BoxFit.contain,
                        //   width: SizeConfig.padding54,
                        // ),
                      ),
                      SizedBox(width: SizeConfig.padding32),
                      // const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Save ₹500 in Gold',
                              style: TextStyles.rajdhaniB.title5),
                          Flexible(
                            child: Text(
                              'Buy Gold worth ₹500 with fello',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white.withOpacity(0.6)),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppState.backButtonDispatcher?.didPopRoute();
                  BaseUtil().openRechargeModalSheet(
                      investmentType: InvestmentType.LENDBOXP2P, amt: 1000);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding26,
                      vertical: SizeConfig.padding16),
                  // height: SizeConfig.padding70,
                  // margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8),
                      border: Border.all(
                          color: const Color(0xffD3D3D3).withOpacity(0.2))),
                  child: Row(
                    children: [
                      SizedBox(
                          width: SizeConfig.padding38,
                          child: SvgPicture.asset(
                            'assets/svg/fello_flo.svg',
                            fit: BoxFit.cover,
                            width: SizeConfig.padding54,
                            // height: SizeConfig.padding46,
                          )),
                      SizedBox(width: SizeConfig.padding32),
                      // const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Save ₹1000 in Flo',
                              style: TextStyles.rajdhaniB.title5),
                          Flexible(
                            child: Text(
                              'Invest in Fello flo worth ₹1000',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white.withOpacity(0.6)),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.padding20),
            ],
          ),
        ),
      ),
    );
  }
}

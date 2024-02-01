import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/analytics_repo.dart';
import 'package:felloapp/core/repository/banking_repo.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/clientComms_repo.dart';
import 'package:felloapp/core/repository/coupons_repo.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/internal_ops_repo.dart';
import 'package:felloapp/core/repository/investment_actions_repo.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/lendbox_repo.dart';
import 'package:felloapp/core/repository/local/stories_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/repository/power_play_repo.dart';
import 'package:felloapp/core/repository/prizing_repo.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/repository/report_repo.dart';
import 'package:felloapp/core/repository/save_repo.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/repository/sip_repo.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/repository/user_stats_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/clever_tap_analytics.dart';
import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/core/service/analytics/singular_analytics.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_datapayload.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_v2/fcm_handler_v2.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/feature_flag_service/feature_flag_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/lcl_db_api.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/core/service/notifier_services/google_sign_in_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/prize_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/core/service/payments/razorpay_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/tambola/src/repos/tambola_repo.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_details/tambola_home_details_vm.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_tickets/tambola_home_tickets_vm.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/elements/coin_bar/coin_bar_vm.dart';
import 'package:felloapp/ui/elements/faq_card/faq_card_vm.dart';
import 'package:felloapp/ui/pages/asset_prefs/asset_pref_vm.dart';
import 'package:felloapp/ui/pages/campaigns/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_details/gold_pro_details_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_sell/gold_pro_sell_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_sell/gold_sell_vm.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_details/autosave_details_vm.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/detail_page/flo_premium_details_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/withdrawal/lendbox_withdrawal_vm.dart';
import 'package:felloapp/ui/pages/finance/mini_trans_card/mini_trans_card_vm.dart';
import 'package:felloapp/ui/pages/finance/transactions_history/transaction_history_vm.dart';
import 'package:felloapp/ui/pages/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/ui/pages/games/web/web_home/web_home_vm.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_banners/journey_banners_vm.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset.vm.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/ui/pages/hometabs/my_account/my_account_vm.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_vm.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_vm.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input/otp_input_vm.dart';
import 'package:felloapp/ui/pages/notifications/notifications_vm.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding_main/onboarding_main_vm.dart';
import 'package:felloapp/ui/pages/power_play/completed_match_details/completed_match_details_vm.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/view_model/leaderboard_view_model.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/season_leaderboard/season_leaderboard_vm.dart';
import 'package:felloapp/ui/pages/rewards/detailed_scratch_card/gt_detailed_vm.dart';
import 'package:felloapp/ui/pages/rewards/instant_scratch_card/gt_instant_vm.dart';
import 'package:felloapp/ui/pages/rewards/multiple_scratch_cards/multiple_scratch_cards_vm.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/sip/sip_vm.dart';
import 'package:felloapp/ui/pages/splash/splash_vm.dart';
import 'package:felloapp/ui/pages/support/faq/faq_page_vm.dart';
import 'package:felloapp/ui/pages/userProfile/bank_details/bank_details_vm.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/userProfile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/userProfile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/ui/pages/userProfile/settings/settings_vm.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card_vm.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/service/analytics/appflyer_analytics.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  //Utils
  locator.registerLazySingleton(CustomLogger.new);
  locator.registerLazySingleton(ApiPath.new);
  locator.registerLazySingleton(S.new);

  //Services
  locator.registerSingletonAsync<LocalDbService>(() async {
    final db = LocalDbService();
    await db.initialize();
    return db;
  });
  locator.registerLazySingleton<FeatureFlagService>(
    () => FeatureFlagService.init(
      features: AppConfig.toRaw,
    ),
  );
  locator.registerLazySingleton(Api.new);
  locator.registerLazySingleton(LocalApi.new);
  locator.registerLazySingleton(FcmHandlerDataPayloads.new);
  locator.registerLazySingleton(FcmHandler.new);
  locator.registerLazySingleton(() => FcmListener(locator()));

  locator.registerLazySingleton(AnalyticsProperties.new);
  locator.registerLazySingleton(AnalyticsService.new);
  locator.registerLazySingleton(MixpanelAnalytics.new);
  locator.registerLazySingleton(AppFlyerAnalytics.new);
  locator.registerLazySingleton(SingularAnalytics.new);
  locator.registerLazySingleton(CleverTapAnalytics.new);

  locator.registerLazySingleton(InternalOpsService.new);
  locator.registerLazySingleton(BankAndPanService.new);
  locator.registerLazySingleton(ReferralService.new);
  locator.registerLazySingleton(BackButtonActions.new);
  //Model Services
  locator.registerLazySingleton(BaseUtil.new);
  locator.registerLazySingleton(AppState.new);
  locator.registerLazySingleton(ConnectivityService.new);
  locator.registerLazySingleton(UserService.new);
  locator.registerLazySingleton(UserCoinService.new);
  locator.registerLazySingleton(AugmontTransactionService.new);
  locator.registerLazySingleton(LendboxTransactionService.new);
  locator.registerLazySingleton(TxnHistoryService.new);
  locator.registerLazySingleton(TambolaService.new);
  locator.registerLazySingleton(PrizeService.new);
  locator.registerLazySingleton(WinnerService.new);
  locator.registerLazySingleton(LeaderboardService.new);
  locator.registerLazySingleton(ScratchCardService.new);
  locator.registerLazySingleton(JourneyService.new);
  locator.registerLazySingleton(GoogleSignInService.new);
  locator.registerLazySingleton(RazorpayService.new);
  locator.registerSingletonAsync(SharedPreferences.getInstance);
  locator.registerLazySingleton(MarketingEventHandlerService.new);
  locator.registerLazySingleton(SubService.new);
  locator.registerLazySingleton(PowerPlayService.new);
  locator.registerLazySingleton(LendboxMaturityService.new);

  //Repository
  locator.registerLazySingleton(DBModel.new);
  // locator.registerLazySingleton(() => LocalDBModel());
  locator.registerLazySingleton(AugmontService.new);
  locator.registerLazySingleton(UserRepository.new);
  locator.registerLazySingleton(AnalyticsRepository.new);
  locator.registerLazySingleton(TambolaRepo.new);
  locator.registerLazySingleton(InvestmentActionsRepository.new);
  locator.registerLazySingleton(BankingRepository.new);
  locator.registerLazySingleton(CouponRepository.new);
  locator.registerLazySingleton(PaytmRepository.new);
  locator.registerLazySingleton(JourneyRepository.new);
  locator.registerLazySingleton(GameRepo.new);
  locator.registerLazySingleton(ReferralRepo.new);
  locator.registerLazySingleton(ScratchCardRepository.new);
  locator.registerLazySingleton(TransactionHistoryRepository.new);
  locator.registerLazySingleton(GetterRepository.new);
  locator.registerLazySingleton(InternalOpsRepository.new);
  locator.registerLazySingleton(PaymentRepository.new);
  locator.registerLazySingleton(SubscriptionRepo.new);
  locator.registerLazySingleton(SipRepository.new);
  locator.registerLazySingleton(SaveRepo.new);
  locator.registerLazySingleton(LendboxRepo.new);
  locator.registerLazySingleton(PrizingRepo.new);
  locator.registerLazySingleton(UserStatsRepo.new);
  locator.registerLazySingleton(RootController.new);
  locator.registerLazySingleton(PowerPlayRepository.new);
  locator.registerLazySingleton(ClientCommsRepo.new);
  locator.registerLazySingleton(ReportRepository.new);
  locator.registerLazySingleton(() => FcmHandlerV2(locator()));
  locator.registerLazySingleton<StoriesRepository>(
    () => StoriesRepository(locator()),
  );

  //ROOT
  locator.registerLazySingleton(CardActionsNotifier.new);

  /// SPLASH
  locator.registerFactory(LauncherViewModel.new);
  locator.registerFactory(RootViewModel.new);

  /// Hometabs
  locator.registerFactory(PlayViewModel.new);
  locator.registerFactory(SaveViewModel.new);
  locator.registerFactory(MyAccountVM.new);
  locator.registerFactory(JourneyPageViewModel.new);

  /// VIEW MODELS
  locator.registerFactory(TransactionsHistoryViewModel.new);
  locator.registerFactory(LoginControllerViewModel.new);
  locator.registerFactory(LoginNameInputViewModel.new);
  locator.registerFactory(LoginOtpViewModel.new);
  locator.registerFactory(LoginMobileViewModel.new);
  locator.registerFactory(UserProfileVM.new);
  locator.registerFactory(KYCDetailsViewModel.new);
  locator.registerFactory(BankDetailsViewModel.new);
  locator.registerFactory(GoldBuyViewModel.new);
  locator.registerFactory(GoldSellViewModel.new);
  // locator.registerFactory(TambolaHomeViewModel.new);
  locator.registerFactory(TambolaHomeTicketsViewModel.new);
  locator.registerFactory(TambolaHomeDetailsViewModel.new);
  locator.registerFactory(WebHomeViewModel.new);
  locator.registerFactory(WebGameViewModel.new);

  locator.registerFactory(ReferralDetailsViewModel.new);
  locator.registerFactory(MyWinningsViewModel.new);
  locator.registerFactory(NotificationsViewModel.new);
  locator.registerFactory(GTDetailedViewModel.new);
  locator.registerFactory(GTInstantViewModel.new);
  locator.registerFactory(MultipleScratchCardsViewModel.new);
  locator.registerFactory(TopSaverViewModel.new);
  // locator.registerFactory(AutosaveProcessViewModel.new);
  // locator.registerFactory(AutosaveDetailsViewModel.new);
  locator.registerFactory(CampaignRepo.new);
  locator.registerFactory(OnboardingViewModel.new);
  locator.registerFactory(JourneyBannersViewModel.new);
  locator.registerFactory(FaqPageViewModel.new);
  locator.registerFactory(LendboxBuyViewModel.new);
  locator.registerFactory(LendboxWithdrawalViewModel.new);
  locator.registerFactory(SettingsViewModel.new);
  locator.registerFactory(PowerPlayHomeViewModel.new);
  locator.registerFactory(LeaderBoardViewModel.new);
  locator.registerFactory(CompletedMatchDetailsVM.new);
  locator.registerFactory(SeasonLeaderboardViewModel.new);
  locator.registerFactory(LastWeekViewModel.new);
  //GOLDPRO
  locator.registerFactory(GoldProDetailsViewModel.new);
  locator.registerFactory(GoldProBuyViewModel.new);
  locator.registerFactory(GoldProSellViewModel.new);
  //WIDGETS
  locator.registerFactory(MiniTransactionCardViewModel.new);
  locator.registerFactory(FelloCoinBarViewModel.new);
  locator.registerFactory(FAQCardViewModel.new);
  locator.registerFactory(SourceAdaptiveAssetViewModel.new);
  locator.registerFactory(SubscriptionCardViewModel.new);
  locator.registerFactory(FloPremiumDetailsViewModel.new);
  locator.registerFactory(SipViewModel.new);
  locator.registerFactory(AssetPreferenceViewModel.new);

  // locator.registerFactory<UsernameInputViewModel>(() => UsernameInputViewModel());
  await locator.allReady();
}

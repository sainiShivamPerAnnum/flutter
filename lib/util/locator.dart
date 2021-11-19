import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/repository/investment_actions_repo.dart';
import 'package:felloapp/core/repository/prizes_repo.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/connectivity_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/lcl_db_api.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/core/service/prize_service.dart';
import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/augmont_gold_details_vm.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/augmont_gold_sell_vm.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_game/cricket_game_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_game/cricket_game_vm.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/dailyPicksDraw/dailyPicksDraw_viewModel.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_game/tambola_game_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_vm.dart';
import 'package:felloapp/ui/pages/others/profile/bank_details/bank_details_vm.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/ui/pages/others/profile/transactions_history/transaction_history_vm.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/splash/splash_vm.dart';
import 'package:felloapp/ui/widgets/appbars/fello_appbar_vm.dart';
import 'package:felloapp/ui/widgets/buttons/buy_gold_button/buyGoldBtn_vm.dart';
import 'package:felloapp/ui/widgets/buttons/sell_gold_button/sellGoldBtn_vm.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_vm.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_vm.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_vm.dart';
import 'package:felloapp/ui/widgets/simple_kyc_modalsheet/simple_kyc_modelsheet_vm.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //Utils
  locator.registerLazySingleton(() => Logger());
  locator.registerLazySingleton(() => ApiPath());
  locator.registerLazySingleton(() => S());

  //Services
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => LocalApi());
  locator.registerLazySingleton(() => FcmListener());
  locator.registerLazySingleton(() => FcmHandler());

  //Model Services
  locator.registerLazySingleton(() => BaseUtil());
  locator.registerLazySingleton(() => MixpanelService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => AppState());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => UserCoinService());
  locator.registerLazySingleton(() => TransactionService());
  locator.registerLazySingleton(() => TambolaService());
  locator.registerLazySingleton(() => PrizeService());
  locator.registerLazySingleton(() => WinnerService());

  //Repository
  locator.registerLazySingleton(() => DBModel());
  locator.registerLazySingleton(() => LocalDBModel());
  locator.registerLazySingleton(() => HttpModel());
  locator.registerLazySingleton(() => ICICIModel());
  locator.registerLazySingleton(() => AugmontModel());
  locator.registerLazySingleton(() => RazorpayModel());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => PrizesRepository());
  locator.registerLazySingleton(() => FlcActionsRepo());
  locator.registerLazySingleton(() => StatisticsRepository());
  locator.registerLazySingleton(() => WinnersRepository());
  locator.registerLazySingleton(() => InvestmentActionsRepository());

  // SPLASH
  locator.registerFactory(() => LauncherViewModel());

  // Hometabs
  locator.registerFactory(() => PlayViewModel());
  locator.registerFactory(() => SaveViewModel());
  locator.registerFactory(() => WinViewModel());
  locator.registerFactory(() => RootViewModel());

  //REST
  locator.registerFactory(() => TransactionsHistoryViewModel());
  locator.registerFactory(() => DailyPicksDrawViewModel());
  locator.registerFactory(() => UserProfileVM());
  locator.registerFactory(() => KYCDetailsViewModel());
  locator.registerFactory(() => BankDetailsViewModel());
  locator.registerFactory(() => AugmontGoldBuyViewModel());
  locator.registerFactory(() => AugmontGoldSellViewModel());
  locator.registerFactory(() => AugmontGoldDetailsViewModel());
  locator.registerFactory(() => CricketHomeViewModel());
  locator.registerFactory(() => CricketGameViewModel());
  locator.registerFactory(() => TambolaHomeViewModel());
  locator.registerFactory(() => TambolaGameViewModel());
  locator.registerFactory(() => PicksCardViewModel());
  locator.registerFactory(() => ReferralDetailsViewModel());
  locator.registerFactory(() => MyWinningsViewModel());

  //WIDGETS
  locator.registerFactory(() => SellGoldBtnVM());
  locator.registerFactory(() => BuyGoldBtnVM());
  locator.registerFactory(() => FDrawerVM());
  locator.registerFactory(() => FelloAppBarVM());
  locator.registerFactory(() => MiniTransactionCardViewModel());
  locator.registerFactory(() => FelloCoinBarViewModel());
  locator.registerFactory(() => SimpleKycModelsheetViewModel());

  //....
}

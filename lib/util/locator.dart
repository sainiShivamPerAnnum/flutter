import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/repository/fcl_actions_repo.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/connectivity_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/lcl_db_api.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/dailyPicksDraw/dailyPicksDraw_viewModel.dart';
import 'package:felloapp/ui/pages/tabs/profile/transactions/tran_viewModel.dart';
import 'package:felloapp/ui/pages/tabs/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/widgets/appbars/fello_appbar_vm.dart';
import 'package:felloapp/ui/widgets/buttons/buy_gold_button/buyGoldBtn_vm.dart';
import 'package:felloapp/ui/widgets/buttons/sell_gold_button/sellGoldBtn_vm.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_vm.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_vm.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //Utils
  locator.registerLazySingleton(() => Logger());
  locator.registerLazySingleton(() => ApiPath());

  //Services
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => LocalApi());
  locator.registerLazySingleton(() => FcmListener());
  locator.registerLazySingleton(() => FcmHandler());

  //Model Services
  locator.registerLazySingleton(() => BaseUtil());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => AppState());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => UserCoinService());
  locator.registerLazySingleton(() => TransactionService());

  //Repository
  locator.registerLazySingleton(() => DBModel());
  locator.registerLazySingleton(() => LocalDBModel());
  locator.registerLazySingleton(() => HttpModel());
  locator.registerLazySingleton(() => ICICIModel());
  locator.registerLazySingleton(() => AugmontModel());
  locator.registerLazySingleton(() => RazorpayModel());
  locator.registerLazySingleton(() => FlcActionsRepo());

  // Hometabs
  locator.registerFactory(() => PlayViewModel());
  locator.registerFactory(() => SaveViewModel());
  locator.registerFactory(() => WinViewModel());
  locator.registerFactory(() => RootViewModel());

  //REST
  locator.registerFactory(() => TranViewModel());
  locator.registerFactory(() => DailyPicksDrawViewModel());
  locator.registerFactory(() => UserProfileViewModel());

  //WIDGETS
  // locator.registerFactory(() => FBtnVM());
  // locator.registerFactory(() => RBtnVM());
  locator.registerFactory(() => SellGoldBtnVM());
  locator.registerFactory(() => BuyGoldBtnVM());
  locator.registerFactory(() => FDrawerVM());
  locator.registerFactory(() => FelloAppBarVM());
  locator.registerFactory(() => MiniTransactionCardViewModel());

  //....
}

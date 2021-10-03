import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/connectivity_service.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/core/service/lcl_db_api.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/tabs/games/dailyPicksDraw/dailyPicksDraw_viewModel.dart';
import 'package:felloapp/ui/pages/tabs/profile/transactions/tran_viewModel.dart';
import 'package:felloapp/ui/pages/tabs/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/widgets/buttons/flatButton/flatButton_viewModel.dart';
import 'package:felloapp/ui/widgets/buttons/raisedButton/raisedButton_viewModel.dart';
import 'package:felloapp/ui/widgets/miniTransactionWindow/miniTransCard_viewModel.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => LocalApi());
  locator.registerLazySingleton(() => DBModel());
  locator.registerLazySingleton(() => LocalDBModel());
  locator.registerLazySingleton(() => HttpModel());
  locator.registerLazySingleton(() => ICICIModel());
  locator.registerLazySingleton(() => AugmontModel());
  locator.registerLazySingleton(() => RazorpayModel());
  locator.registerLazySingleton(() => BaseUtil());
  locator.registerLazySingleton(() => FcmListener());
  locator.registerLazySingleton(() => FcmHandler());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => AppState());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => Logger());

  // Hometabs
  locator.registerFactory(() => PlayViewModel());
  locator.registerFactory(() => SaveViewModel());
  locator.registerFactory(() => WinViewModel());

  //REST
  locator.registerFactory(() => TranViewModel());
  //TODO: Whats draw model (view or view model) ?
  locator.registerFactory(() => DailyPicksDrawModel());
  locator.registerFactory(() => UserProfileViewModel());

  //WIDGETS
  locator.registerFactory(() => FBtnVM());
  locator.registerFactory(() => RBtnVM());
  locator.registerFactory(() => MiniTransactionCardViewModel());

  //....
}

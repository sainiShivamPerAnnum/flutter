import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/router/router_delegate.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/payment_service.dart';
import 'package:felloapp/core/service/lcl_db_api.dart';
import 'package:felloapp/util/app_state.dart';
import 'package:get_it/get_it.dart';

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
  locator.registerLazySingleton(() => KYCModel());
  locator.registerLazySingleton(() => BaseUtil());
  locator.registerLazySingleton(() => FcmListener());
  locator.registerLazySingleton(() => FcmHandler());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => AppState());
  //....
}

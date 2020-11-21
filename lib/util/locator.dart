import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/lcl_db_api.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => LocalApi());
  locator.registerLazySingleton(() => DBModel());
  locator.registerLazySingleton(() => LocalDBModel());
  locator.registerLazySingleton(() => BaseUtil());
  locator.registerLazySingleton(() => FcmListener());
  locator.registerLazySingleton(() => FcmHandler());
  //....
}


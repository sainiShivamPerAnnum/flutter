import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:get_it/get_it.dart';

import '../base_util.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => DBModel());
  locator.registerLazySingleton(() => BaseUtil());
  //....
}


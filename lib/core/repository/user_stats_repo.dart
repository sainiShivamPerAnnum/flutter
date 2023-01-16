import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/game_stats_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class UserStatsRepo extends BaseRepo with ChangeNotifier {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://l6e3g2pr2b.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://08wplse7he.execute-api.ap-south-1.amazonaws.com/prod";

  final Api _api = locator<Api>();
  final ApiPath _apiPaths = locator<ApiPath>();
  final _userService = locator<UserService>();

  late Completer<GameStats> completer;
  Future<void> getGameStats() async {
    completer = Completer();
    final token = await getBearerToken();
    try {
      final uid = _userService.baseUser?.uid ?? "";
      final res = await APIService.instance.getData(ApiPath.getGameStats(uid),
          token: 'Bearer $token', cBaseUrl: _baseUrl);

      completer.complete(GameStats.fromJson(res['data']));
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}

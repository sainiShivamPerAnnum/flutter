import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class UserCoinService extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();
  final UserRepository _userRepo = locator<UserRepository>();

  int? _flcBalance = 0;

  int? get flcBalance => _flcBalance;

  Future<void> init() async {
    await getUserCoinBalance();
  }

  void setFlcBalance(int? balance) {
    if (_flcBalance == null) {
      _flcBalance = balance;
      notifyListeners();

      _logger.d("Initial Coin Balance added");
    } else {
      _flcBalance = balance;
      notifyListeners();
      _logger.d("Coin Balance Updated");
    }
  }

  Future<void> getUserCoinBalance() async {
    _logger.d("FLC Balance called");
    final ApiResponse<FlcModel> response = await _userRepo.getCoinBalance();
    _logger.d(response.model?.toJson().toString());
    setFlcBalance(response.model?.flcBalance);
  }
}

import 'package:felloapp/core/enums/user_coin_service_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserCoinService
    extends PropertyChangeNotifier<UserCoinServiceProperties> {
  final _logger = locator<Logger>();
  final _flcActionsRepo = locator<FlcActionsRepo>();

  int _flcBalance = 0;

  int get flcBalance => _flcBalance;

  void setFlcBalance(int balance) {
    if (_flcBalance == null) {
      _flcBalance = balance;
      notifyListeners(UserCoinServiceProperties.coinBalance);

      _logger.d("Initial Coin Balance added");
    } else {
      _flcBalance = balance;
      notifyListeners(UserCoinServiceProperties.coinBalance);
      _logger.d("Coin Balance Updated");
    }
  }

  Future<void> getUserCoinBalance() async {
    final ApiResponse<FlcModel> response =
        await _flcActionsRepo.getCoinBalance();
    _logger.d(response.model.toJson().toString());
    setFlcBalance(response.model?.flcBalance);
  }
}

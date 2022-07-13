import 'package:felloapp/core/enums/user_coin_service_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserCoinService
    extends PropertyChangeNotifier<UserCoinServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _userRepo = locator<UserRepository>();

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
    final ApiResponse<FlcModel> response = await _userRepo.getCoinBalance();
    _logger.d(response.model?.toJson()?.toString());
    setFlcBalance(response.model?.flcBalance);
  }
}

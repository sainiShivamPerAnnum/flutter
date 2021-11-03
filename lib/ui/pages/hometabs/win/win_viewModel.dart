import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class WinViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final _winnersRepo = locator<WinnersRepository>();
  final _logger = locator<Logger>();
  final _winnerService = locator<WinnerService>();

  LocalDBModel _localDBModel = locator<LocalDBModel>();
  bool isWinnersLoading = false;
  WinnersModel _winners;

  WinnersModel get winners => _winners;

  double get winnings => _userService.userFundWallet.prizeBalance;

  set winners(val) {
    _winners = val;
    notifyListeners();
  }

  double get getUnclaimedPrizeBalance =>
      _userService.userFundWallet.unclaimedBalance;

  init() {
    // if (!AppState.isWinOpened) {
    //   _winnerService.fetchWinners();
    //   AppState.isWinOpened = true;
    // }
  }

  getWinningsButtonText() {
    if (_userService.userFundWallet.isPrizeBalanceUnclaimed())
      return "Redeem";
    else
      return "Share";
  }

  Future<PrizeClaimChoice> getClaimChoice() async {
    return await _localDBModel.getPrizeClaimChoice();
  }

  void navigateToMyWinnings() {
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: MyWinnigsPageConfig);
  }

  // fetchWinners() async {
  //   isWinnersLoading = true;
  //   notifyListeners();
  //   var temp = await _winnersRepo.getWinners("GM_CRIC2020", "weekly");
  //   if (temp != null) {
  //     winners = temp.model;
  //     _logger.d("Winners fetched");
  //   } else
  //     BaseUtil.showNegativeAlert(
  //         "Unable to fetch winners", "try again in sometime");
  //   isWinnersLoading = false;
  //   notifyListeners();
  // }
}

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/Prize-Card/card.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WinViewModel extends BaseModel {
  final _userService = locator<UserService>();

  LocalDBModel _localDBModel = locator<LocalDBModel>();

  double get getUnclaimedPrizeBalance =>
      _userService.userFundWallet.unclaimedBalance;

  getWinningsButtonText() {
    if (_userService.userFundWallet.isPrizeBalanceUnclaimed())
      return "Redeem";
    else
      return "Share";
  }

  prizeBalanceAction(BuildContext context) async {
    HapticFeedback.vibrate();
    if (_userService.userFundWallet.isPrizeBalanceUnclaimed())
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: FCard(
                isClaimed:
                    !_userService.userFundWallet.isPrizeBalanceUnclaimed(),
                unclaimedPrize: _userService.userFundWallet.unclaimedBalance,
              ),
            ),
          );
        },
      );
    else {
      final choice = await getClaimChoice();
      AppState.screenStack.add(ScreenItem.dialog);
      showDialog(
        context: context,
        builder: (ctx) => ShareCard(
          dpUrl: _userService.myUserDpUrl,
          claimChoice: choice,
          prizeAmount: _userService.userFundWallet.prizeBalance,
          username: _userService.baseUser.name,
        ),
      );
    }
  }

  Future<PrizeClaimChoice> getClaimChoice() async {
    return await _localDBModel.getPrizeClaimChoice();
  }

  void navigateToMyWinnings() {
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: MyWinnigsPageConfig);
  }
}

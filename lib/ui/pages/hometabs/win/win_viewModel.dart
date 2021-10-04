import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/ui/dialogs/Prize-Card/card.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WinViewModel extends BaseModel {
  BaseUtil _baseUtil = locator<BaseUtil>();
  LocalDBModel _localDBModel = locator<LocalDBModel>();

  getUnclaimedPrizeBalance() {
    return _baseUtil.userFundWallet.unclaimedBalance ?? 0.0;
  }

  getWinningsButtonText() {
    if (_baseUtil.userFundWallet.isPrizeBalanceUnclaimed())
      return "Redeem";
    else
      return "Share";
  }

  prizeBalanceAction(BuildContext context) async {
    HapticFeedback.vibrate();
    if (_baseUtil.userFundWallet.isPrizeBalanceUnclaimed())
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: FCard(
                isClaimed: !_baseUtil.userFundWallet.isPrizeBalanceUnclaimed(),
                unclaimedPrize: _baseUtil.userFundWallet.unclaimedBalance,
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
          dpUrl: _baseUtil.myUserDpUrl,
          claimChoice: choice,
          prizeAmount: _baseUtil.userFundWallet.prizeBalance,
          username: _baseUtil.myUser.name,
        ),
      );
    }
  }

  Future<PrizeClaimChoice> getClaimChoice() async {
    return await _localDBModel.getPrizeClaimChoice();
  }
}

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_viewmodel.dart';
import 'package:felloapp/ui/modals/augmont_deposit_modal_sheet.dart';
import 'package:felloapp/ui/pages/tabs/finance/augmont/augmont_withdraw_screen.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SellGoldBtnVM extends BaseModel {
  final Log log = new Log("AugmontService");
  GlobalKey<AugmontDepositModalSheetState> _modalKey2 = GlobalKey();
  BuildContext sellContext;
  BaseUtil _baseUtil = locator<BaseUtil>();
  DBModel _dbModel = locator<DBModel>();
  AugmontModel _augmontModel = locator<AugmontModel>();
  double _withdrawableGoldQnty;
  GlobalKey<AugmontWithdrawScreenState> _withdrawalDialogKey2 = GlobalKey();

  sellButtonAction(BuildContext sellContext) async {
    if (await _baseUtil.showNoInternetAlert(sellContext)) return;
    sellContext = sellContext;
    if (!_baseUtil.isAugWithdrawRouteLogicInProgress) {
      Haptic.vibrate();
      _onWithdrawalClicked();
      // double amt = await _augmontModel.getGoldBalance();
      // log.debug(amt.toString());
    }
  }

  _onWithdrawalClicked() async {
    Haptic.vibrate();
    _baseUtil.augmontDetail = (_baseUtil.augmontDetail == null)
        ? (await _dbModel.getUserAugmontDetails(_baseUtil.myUser.uid))
        : _baseUtil.augmontDetail;
    if (!_baseUtil.myUser.isAugmontOnboarded) {
      _baseUtil.showNegativeAlert('Not onboarded',
          'You havent been onboarded to Augmont yet', sellContext);
    } else if (_baseUtil.userFundWallet.augGoldQuantity == null ||
        _baseUtil.userFundWallet.augGoldQuantity == 0) {
      _baseUtil.showNegativeAlert('No Balance Available',
          'Your Augmont wallet has no balance presently', sellContext);
    } else {
      _baseUtil.isAugWithdrawRouteLogicInProgress = true;
      setState(ViewState.Busy);
      double _liveGoldQuantityBalance;
      try {
        _baseUtil.augmontGoldRates = await _augmontModel.getRates();
      } catch (e) {
        log.error('Failed to fetch current sell rates: $e');
      }
      try {
        _liveGoldQuantityBalance = await _augmontModel.getGoldBalance();
      } catch (e) {
        log.error('Failed to fetch current gold balance: $e');
      }
      try {
        double _w = await _dbModel
            .getNonWithdrawableAugGoldQuantity(_baseUtil.myUser.uid);
        _withdrawableGoldQnty = (_w != null)
            ? math.max(_liveGoldQuantityBalance - _w, 0)
            : _liveGoldQuantityBalance;
      } catch (e) {
        log.error('Failed to fetch non withdrawable gold quantity');
      }
      if (_baseUtil.augmontGoldRates == null ||
          _liveGoldQuantityBalance == null ||
          _liveGoldQuantityBalance == 0) {
        _baseUtil.isAugWithdrawRouteLogicInProgress = false;
        setState(ViewState.Idle);
        _baseUtil.showNegativeAlert('Couldn\'t complete your request',
            'Please try again in some time', sellContext);
      } else {
        _baseUtil.isAugWithdrawRouteLogicInProgress = false;
        setState(ViewState.Idle);
        AppState.delegate.appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: AugWithdrawalPageConfig,
          widget: AugmontWithdrawScreen(
            key: _withdrawalDialogKey2,
            passbookBalance: _liveGoldQuantityBalance,
            withdrawableGoldQnty: _withdrawableGoldQnty,
            sellRate: _baseUtil.augmontGoldRates.goldSellPrice,
            onAmountConfirmed: (Map<String, double> amountDetails) {
              _onInitiateWithdrawal(amountDetails['withdrawal_quantity']);
            },
            bankHolderName: _baseUtil.augmontDetail.bankHolderName,
            bankAccNo: _baseUtil.augmontDetail.bankAccNo,
            bankIfsc: _baseUtil.augmontDetail.ifsc,
          ),
        );
      }
    }
  }

  _onInitiateWithdrawal(double qnt) {
    if (_baseUtil.augmontGoldRates != null && qnt != null) {
      _augmontModel.initiateWithdrawal(_baseUtil.augmontGoldRates, qnt);
      _augmontModel.setAugmontTxnProcessListener(_onSellComplete);
    }
  }

  _onSellComplete(UserTransaction txn) async {
    if (_baseUtil.currentAugmontTxn != null) {
      if (_baseUtil.currentAugmontTxn.tranStatus !=
          UserTransaction.TRAN_STATUS_COMPLETE) {
        _withdrawalDialogKey2.currentState.onTransactionProcessed(false);
      } else {
        ///reduce tickets and amount
        _baseUtil.currentAugmontTxn.closingBalance =
            _baseUtil.getUpdatedWithdrawalClosingBalance(
                _baseUtil.currentAugmontTxn.amount);
        _baseUtil.currentAugmontTxn.ticketUpCount = _baseUtil
            .getTicketCountForTransaction(_baseUtil.currentAugmontTxn.amount);
        await _dbModel.updateUserTransaction(
            _baseUtil.myUser.uid, _baseUtil.currentAugmontTxn);

        ///update user wallet balance
        double _tempCurrentBalance = _baseUtil.userFundWallet.augGoldBalance;
        _baseUtil.userFundWallet = await _dbModel.updateUserAugmontGoldBalance(
            _baseUtil.myUser.uid,
            _baseUtil.userFundWallet,
            _baseUtil.augmontGoldRates.goldSellPrice,
            BaseUtil.toDouble(_baseUtil.currentAugmontTxn
                .augmnt[UserTransaction.subFldAugTotalGoldGm]),
            -1 * _baseUtil.currentAugmontTxn.amount);

        ///check if balance updated correctly
        if (_baseUtil.userFundWallet.augGoldBalance == _tempCurrentBalance) {
          //wallet balance was not updated. Transaction update failed
          Map<String, dynamic> _data = {
            'txn_id': _baseUtil.currentAugmontTxn.docKey,
            'aug_tran_id': _baseUtil
                .currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId],
            'note':
                'Transaction completed, but found inconsistency while updating balance'
          };
          await _dbModel.logFailure(_baseUtil.myUser.uid,
              FailType.UserAugmontWthdrwUpdateDiscrepancy, _data);
        }

        if (_baseUtil.currentAugmontTxn.ticketUpCount > 0) {
          ///update user ticket count
          int _tempCurrentCount = _baseUtil.userTicketWallet.augGold99Tck;
          _baseUtil.userTicketWallet =
              await _dbModel.updateAugmontGoldUserTicketCount(
                  _baseUtil.myUser.uid,
                  _baseUtil.userTicketWallet,
                  -1 * _baseUtil.currentAugmontTxn.ticketUpCount);

          ///check if ticket count updated correctly
          if (_baseUtil.userTicketWallet.augGold99Tck == _tempCurrentCount) {
            //ticket count did not update
            Map<String, dynamic> _data = {
              'txn_id': _baseUtil.currentAugmontTxn.docKey,
              'aug_tran_id': _baseUtil
                  .currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId],
              'note':
                  'Transaction completed, but found inconsistency while updating tickets'
            };
            await _dbModel.logFailure(_baseUtil.myUser.uid,
                FailType.UserAugmontWthdrwUpdateDiscrepancy, _data);
          }
        }

        ///update UI and clear global variables
        _baseUtil.currentAugmontTxn = null;
        _baseUtil.userMiniTxnList = null; //make null so it refreshes
        _withdrawalDialogKey2.currentState.onTransactionProcessed(true);
      }
    } else {
      _withdrawalDialogKey2.currentState.onTransactionProcessed(false);
    }
  }
}

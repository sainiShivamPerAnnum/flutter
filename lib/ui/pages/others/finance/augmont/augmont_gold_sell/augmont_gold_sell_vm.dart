import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/sell_confirmation_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'dart:math' as math;

class AugmontGoldSellViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  BaseUtil _baseUtil = locator<BaseUtil>();
  DBModel _dbModel = locator<DBModel>();
  AugmontModel _augmontModel = locator<AugmontModel>();
  UserService _userService = locator<UserService>();
  final _analyticsService = locator<AnalyticsService>();
  final _paymentRepo = locator<PaymentRepository>();

  bool isGoldRateFetching = false;
  bool isQntFetching = false;
  AugmontRates goldRates;
  bool _isGoldSellInProgress = false;
  FocusNode sellFieldNode = FocusNode();
  String sellNotice;

  double goldSellGrams = 0;
  double goldAmountFromGrams = 0.0;

  double nonWithdrawableQnt = 0.0;
  double withdrawableQnt = 0.0;
  TextEditingController goldAmountController;
  List<double> chipAmountList = [25, 50, 100];

  double get goldSellPrice => goldRates != null ? goldRates.goldSellPrice : 0.0;

  UserFundWallet get userFundWallet => _userService.userFundWallet;

  get isGoldSellInProgress => this._isGoldSellInProgress;

  set isGoldSellInProgress(value) {
    this._isGoldSellInProgress = value;
    notifyListeners();
  }

  init() async {
    setState(ViewState.Busy);
    _analyticsService.track(eventName: AnalyticsEvents.saveSell);
    goldAmountController = TextEditingController();
    await fetchNotices();
    fetchGoldRates();
    fetchLockedGoldQnt();

    if (_baseUtil.augmontDetail == null) {
      await _baseUtil.fetchUserAugmontDetail();
    }
    // Check if sell is locked the this particular user
    if (_baseUtil.augmontDetail != null &&
        _baseUtil.augmontDetail.sellNotice != null &&
        _baseUtil.augmontDetail.sellNotice.isNotEmpty)
      sellNotice = _baseUtil.augmontDetail.sellNotice;

    setState(ViewState.Idle);
  }

  fetchNotices() async {
    sellNotice = await _dbModel.showAugmontSellNotice();
  }

  Widget amoutChip(double amt) {
    return GestureDetector(
      onTap: () {
        Haptic.vibrate();
        sellFieldNode.unfocus();
        goldSellGrams = withdrawableQnt * (amt / 100);

        double updatedGrams = goldSellGrams * 10000;
        int checker = updatedGrams.truncate();
        goldSellGrams = checker / 10000;

        goldAmountController.text = goldSellGrams.toStringAsFixed(4);
        updateGoldAmount();
        notifyListeners();
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.229,
        height: SizeConfig.screenWidth * 0.103,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          color: amt.toInt() == 25
              ? UiConstants.tertiarySolid
              : UiConstants.tertiaryLight,
        ),
        alignment: Alignment.center,
        child: Text(
          "${amt.toInt()}%",
          style: TextStyles.body3.bold.colour(
            amt.toInt() == 25 ? Colors.white : UiConstants.tertiarySolid,
          ),
        ),
      ),
    );
  }

  updateGoldAmount() {
    if (goldSellPrice != 0.0)
      goldAmountFromGrams = BaseUtil.digitPrecision(
          double.tryParse(goldAmountController.text) * goldSellPrice, 4, false);
    else
      goldAmountFromGrams = 0.0;
    refresh();
  }

  fetchLockedGoldQnt() async {
    isQntFetching = true;
    refresh();
    await _userService.getUserFundWalletData();
    ApiResponse<double> qunatityApiResponse =
        await _paymentRepo.getWithdrawableAugGoldQuantity();
    if (qunatityApiResponse.code == 200) {
      withdrawableQnt = qunatityApiResponse.model;
      if (withdrawableQnt == null || withdrawableQnt < 0) withdrawableQnt = 0.0;
      if (userFundWallet == null ||
          userFundWallet.augGoldQuantity == null ||
          userFundWallet.augGoldQuantity <= 0.0)
        nonWithdrawableQnt = 0.0;
      else
        nonWithdrawableQnt = BaseUtil.digitPrecision(
            math.max(0.0, userFundWallet.augGoldQuantity - withdrawableQnt),
            4,
            false);
    } else {
      nonWithdrawableQnt = 0.0;
      withdrawableQnt = 0.0;
    }
    isQntFetching = false;
    refresh();
  }

  fetchGoldRates() async {
    isGoldRateFetching = true;
    refresh();
    goldRates = await _augmontModel.getRates();
    if (goldRates == null)
      BaseUtil.showNegativeAlert(
        'Portal unavailable',
        'The current rates couldn\'t be loaded. Please try again',
      );
    isGoldRateFetching = false;

    refresh();
  }

  Future<bool> verifyGoldSaleDetails() async {
    double sellGramAmount = double.tryParse(goldAmountController.text.trim());
    if (goldRates == null) {
      BaseUtil.showNegativeAlert(
        'Portal unavailable',
        'The current rates couldn\'t be loaded. Please try again',
      );
      return false;
    }

    if (sellGramAmount == null) {
      BaseUtil.showNegativeAlert(
          "No Amount Entered", "Please enter some amount");
      return false;
    }
    if (!_userService.baseUser.isAugmontOnboarded) {
      BaseUtil.showNegativeAlert(
        'Not registered',
        'You have not registered for digital gold yet',
      );
      return false;
    }
    if (sellGramAmount < 0.0001) {
      BaseUtil.showNegativeAlert(
          "Amount too low", "Please enter a greater amount");
      return false;
    }
    if (sellGramAmount > userFundWallet.augGoldQuantity) {
      BaseUtil.showNegativeAlert(
          "Insufficient balance", "Please enter a lower amount");
      return false;
    }
    if (sellGramAmount > withdrawableQnt) {
      BaseUtil.showNegativeAlert(
          "Sell not processed", "Purchased Gold can be sold after 2 days");
      return false;
    }

    if (_baseUtil.augmontDetail == null) {
      await _baseUtil.fetchUserAugmontDetail();
    }
    if (_baseUtil.augmontDetail == null) {
      BaseUtil.showNegativeAlert(
        'Sell Failed',
        'Please try again in sometime or contact us',
      );
      return false;
    }
    List<String> fractionalPart = sellGramAmount.toString().split('.');
    if (fractionalPart != null &&
        fractionalPart.length > 1 &&
        fractionalPart[1] != null &&
        fractionalPart[1].length > 4) {
      BaseUtil.showNegativeAlert(
        'Please try again',
        'Upto 4 decimals allowed',
      );
      return false;
    }
    if (_baseUtil.augmontDetail.isSellLocked) {
      BaseUtil.showNegativeAlert(
        'Sell Failed',
        "${sellNotice ?? 'Gold sell is currently on hold. Please try again after sometime.'}",
      );
      return false;
    }
    bool _disabled = await _dbModel.isAugmontSellDisabled();
    if (_disabled != null && _disabled) {
      BaseUtil.showNegativeAlert(
        'Sell Failed',
        'Gold sell is currently on hold. Please try again after sometime.',
      );
      return false;
    }
    return true;
  }

  initiateSell() async {
    double sellGramAmount = double.tryParse(goldAmountController.text.trim());
    isGoldSellInProgress = true;
    _augmontModel.initiateWithdrawal(goldRates, sellGramAmount);
    _augmontModel.setAugmontTxnProcessListener(_onSellTransactionComplete);
    final totalSellAmount =
        BaseUtil.digitPrecision(sellGramAmount * goldRates.goldSellPrice);
    _analyticsService.track(
      eventName: AnalyticsEvents.sellGold,
      properties: {'selling_amount': totalSellAmount},
    );
  }

  Future<void> _onSellTransactionComplete(UserTransaction txn) async {
    if (_baseUtil.currentAugmontTxn == null) return;
    if (txn.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE ||
        txn.tranStatus == UserTransaction.TRAN_STATUS_PROCESSING) {
      ///update UI
      onSellComplete(true);
      _augmontModel.completeTransaction();
      return true;
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_CANCELLED ||
        txn.tranStatus == UserTransaction.TRAN_STATUS_FAILED) {
      onSellComplete(false);
      _augmontModel.completeTransaction();
    }
  }

  onSellComplete(bool flag) {
    isGoldSellInProgress = false;
    if (flag) {
      navigateToSaleConfirmationView();
    } else {
      AppState.backButtonDispatcher.didPopRoute();
      BaseUtil.showNegativeAlert('Sell did not complete',
          'Your gold sell could not be completed at the moment',
          seconds: 5);
    }
  }

  Future navigateToSaleConfirmationView() async {
    try {
      await initiateSell();
    } catch (e) {}
    AppState.delegate.appState.currentAction = PageAction(
        page: SellConfirmationViewConfig,
        widget: SellAssetsConfirmationView(),
        state: PageState.addWidget);
  }
}

import 'dart:convert';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/withdrawable_gold_details_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class GoldSellViewModel extends BaseViewModel {
  final _logger = locator<CustomLogger>();
  BaseUtil _baseUtil = locator<BaseUtil>();
  DBModel _dbModel = locator<DBModel>();
  AugmontService _augmontModel = locator<AugmontService>();
  UserService _userService = locator<UserService>();
  UserCoinService _userCoinService = locator<UserCoinService>();
  AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();
  BankAndPanService _sellService = locator<BankAndPanService>();
  final _analyticsService = locator<AnalyticsService>();
  final _transactionHistoryService = locator<TransactionHistoryService>();
  final _paymentRepo = locator<PaymentRepository>();
  bool isGoldRateFetching = false;
  bool _isQntFetching = false;
  double _fieldWidth = 2;
  int _deductedTokensCount = 0;
  int get deductedTokensCount => this._deductedTokensCount;

  set deductedTokensCount(int value) {
    this._deductedTokensCount = value;
    notifyListeners();
  }

  get fieldWidth => this._fieldWidth;

  set fieldWidth(value) {
    this._fieldWidth = value;
    notifyListeners();
  }

  bool _showMaxCap = false;
  bool _showMinCap = false;
  bool get showMaxCap => this._showMaxCap;

  set showMaxCap(bool value) {
    this._showMaxCap = value;
    notifyListeners();
  }

  get showMinCap => this._showMinCap;

  set showMinCap(value) {
    this._showMinCap = value;
    notifyListeners();
  }

  get isQntFetching => this._isQntFetching;

  set isQntFetching(value) {
    this._isQntFetching = value;
    notifyListeners();
  }

  AugmontRates goldRates;
  FocusNode sellFieldNode = FocusNode();
  String _sellNotice;

  get sellNotice => this._sellNotice;

  set sellNotice(value) {
    this._sellNotice = value;
    notifyListeners();
  }

  double goldSellGrams = 0;
  double _goldAmountFromGrams = 0.0;

  double nonWithdrawableQnt = 0.0;
  double withdrawableQnt = 0.0;
  String withdrawableQtyMessage = "";
  TextEditingController goldAmountController;
  List<double> chipAmountList = [25, 50, 100];

  double get goldSellPrice => goldRates != null ? goldRates.goldSellPrice : 0.0;

  UserFundWallet get userFundWallet => _userService.userFundWallet;

  get goldAmountFromGrams => this._goldAmountFromGrams;

  set goldAmountFromGrams(value) {
    this._goldAmountFromGrams = value;
    notifyListeners();
  }

  init() async {
    deductedTokensCount = 0;
    setState(ViewState.Busy);
    _analyticsService.track(eventName: AnalyticsEvents.saveSell);
    goldAmountController = TextEditingController();
    await _userService.fetchUserAugmontDetail();
    setUpNoticeIfAny();
    fetchGoldRates();
    await fetchLockedGoldQnt();
    // FocusScope.of(AppState.delegate.navigatorKey.currentContext).requestFocus();
    setState(ViewState.Idle);
  }

  setUpNoticeIfAny() {
    sellNotice = _userService.userAugmontDetails.sellNotice;
  }

  // Widget amoutChip(double amt) {
  //   return GestureDetector(
  //     onTap: () {
  //       Haptic.vibrate();
  //       sellFieldNode.unfocus();
  //       goldSellGrams = withdrawableQnt * (amt / 100);

  //       double updatedGrams = goldSellGrams * 10000;
  //       int checker = updatedGrams.truncate();
  //       goldSellGrams = checker / 10000;

  //       goldAmountController.text = goldSellGrams.toStringAsFixed(4);
  //       updateGoldAmount();
  //       notifyListeners();
  //     },
  //     child: Container(
  //       width: SizeConfig.screenWidth * 0.229,
  //       height: SizeConfig.screenWidth * 0.103,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(SizeConfig.roundness12),
  //         color: amt.toInt() == 25
  //             ? UiConstants.tertiarySolid
  //             : UiConstants.tertiaryLight,
  //       ),
  //       alignment: Alignment.center,
  //       child: Text(
  //         "${amt.toInt()}%",
  //         style: TextStyles.body3.bold.colour(
  //           amt.toInt() == 25 ? Colors.white : UiConstants.tertiarySolid,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  updateGoldAmount(String val) {
    showMaxCap = false;
    showMinCap = false;
    if (val == null || val.isEmpty) {
      val = '0';
    }
    if (val.isNotEmpty) {
      if (val.contains('.')) {
        if (val.split('.').last.length > 4) {
          goldAmountController.text = val.substring(0, val.length - 1);
          val = goldAmountController.text;
          sellFieldNode.unfocus();
        }
      } else {
        if (val.length > 2) {
          goldAmountController.text = val.substring(0, val.length - 1);
          val = goldAmountController.text;
          sellFieldNode.unfocus();
        }
      }
      goldSellGrams = double.tryParse(val);
      if (goldSellPrice != 0.0) {
        _goldAmountFromGrams =
            BaseUtil.digitPrecision(goldSellGrams * goldSellPrice, 4, false);
        if (_goldAmountFromGrams < 10) showMinCap = true;
        if (_goldAmountFromGrams > 50000) showMaxCap = true;
      } else
        goldAmountFromGrams = 0.0;
      fieldWidth = val.contains('.')
          ? (val.length - 1) * SizeConfig.title5
          : val.length * SizeConfig.title5;
      refresh();
    }
  }

  fetchLockedGoldQnt() async {
    isQntFetching = true;
    refresh();
    await _userService.getUserFundWalletData();
    ApiResponse<WithdrawableGoldResponseModel> quantityApiResponse =
        await _paymentRepo.getWithdrawableAugGoldQuantity();
    if (quantityApiResponse.isSuccess()) {
      withdrawableQnt = quantityApiResponse.model.data.quantity;
      withdrawableQtyMessage = quantityApiResponse.model.message;
      nonWithdrawableQnt = quantityApiResponse.model.data.lockedQuantity;
    } else {
      nonWithdrawableQnt = 0.0;
      withdrawableQnt = _userService.userFundWallet.augGoldQuantity;
      // return BaseUtil.showNegativeAlert("", quantityApiResponse.errorMessage);
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

    if (sellGramAmount > withdrawableQnt) {
      BaseUtil.showNegativeAlert(
          "Please try a low amount", "Some of your gold is locked for now");
      return false;
    }
    if (goldAmountFromGrams > 50000) {
      BaseUtil.showNegativeAlert("Please enter a lower quantity",
          "A maximum of 8 gms can be sold in one go");
      return false;
    }
    if (goldAmountFromGrams < 10) {
      BaseUtil.showNegativeAlert("Please enter a higher quantity",
          "A minimum of ₹10 can be sold in one go");
      return false;
    }
    if (sellGramAmount > userFundWallet.augGoldQuantity) {
      BaseUtil.showNegativeAlert(
          "Insufficient balance", "Please enter a lower amount");
      return false;
    }
    // if (sellGramAmount > withdrawableQnt) {
    //   BaseUtil.showNegativeAlert(
    //       "Sell not processed", "Purchased Gold can be sold after 2 days");
    //   return false;
    // }

    if (_userService.userAugmontDetails == null) {
      await _userService.fetchUserAugmontDetail();
    }
    if (_userService.userAugmontDetails == null) {
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
    if (_userService.userAugmontDetails.isSellLocked) {
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
    _augTxnService.currentTxnAmount = goldAmountFromGrams;
    _augTxnService.currentTxnGms = sellGramAmount;
    _augTxnService.isGoldSellInProgress = true;
    AppState.screenStack.add(ScreenItem.loader);
    final res =
        await _augmontModel.initiateWithdrawal(goldRates, sellGramAmount);
    _augTxnService.isGoldSellInProgress = false;

    if (res)
      _augTxnService.currentTransactionState = TransactionState.ongoing;
    else
      _augTxnService.currentTransactionState = TransactionState.idle;
    // _augmontModel.setAugmontTxnProcessListener(_onSellTransactionComplete);

    final totalSellAmount =
        BaseUtil.digitPrecision(sellGramAmount * goldRates.goldSellPrice);
    _analyticsService.track(
      eventName: AnalyticsEvents.sellGold,
      properties: {'selling_amount': totalSellAmount},
    );
  }

  handleWithdrawalFcmResponse(String data) {
    _userCoinService.getUserCoinBalance();
    _transactionHistoryService.updateTransactions(InvestmentType.AUGGOLD99);
    _userService.getUserFundWalletData();
    final response = json.decode(data);
    AppState.unblockNavigation();
    print(response['status']);
    if (_augTxnService.currentTransactionState == TransactionState.ongoing) {
      if (response['status'] != null) {
        if (response['tickets'] != null) {
          deductedTokensCount = response['tickets'];
        }
        if (response['status'])
          _augTxnService.currentTransactionState = TransactionState.success;
        else {
          _augTxnService.currentTransactionState = TransactionState.idle;
          AppState.backButtonDispatcher.didPopRoute();
          BaseUtil.showNegativeAlert(
            'Sell did not complete',
            response["message"] ??
                'Your gold sell could not be completed at the moment',
          );
        }
      }
      return;
    } else {
      if (response != null &&
          response['status'] != null &&
          response['status'] == true) {
        BaseUtil.showPositiveAlert(
            response["message"], "Check transactions for more details");
      } else {
        BaseUtil.showNegativeAlert(
          'Sell did not complete',
          response["message"] ??
              'Your gold sell could not be completed at the moment',
        );
      }
    }
  }
}

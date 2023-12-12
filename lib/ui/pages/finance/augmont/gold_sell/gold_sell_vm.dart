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
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class GoldSellViewModel extends BaseViewModel {
  final CustomLogger _logger = locator<CustomLogger>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final DBModel _dbModel = locator<DBModel>();
  S locale = locator<S>();
  final AugmontService _augmontModel = locator<AugmontService>();
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();
  final BankAndPanService _sellService = locator<BankAndPanService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final TxnHistoryService _transactionHistoryService =
      locator<TxnHistoryService>();
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  final TambolaService _tambolaService = locator<TambolaService>();
  bool isGoldRateFetching = false;
  bool _isQntFetching = false;
  double _fieldWidth = 2;
  int? _deductedTokensCount = 0;

  int? get deductedTokensCount => _deductedTokensCount;

  set deductedTokensCount(int? value) {
    _deductedTokensCount = value;
    notifyListeners();
  }

  get fieldWidth => _fieldWidth;

  set fieldWidth(value) {
    _fieldWidth = value;
    notifyListeners();
  }

  bool _showMaxCap = false;
  bool _showMinCap = false;

  bool get showMaxCap => _showMaxCap;

  set showMaxCap(bool value) {
    _showMaxCap = value;
    notifyListeners();
  }

  get showMinCap => _showMinCap;

  set showMinCap(value) {
    _showMinCap = value;
    notifyListeners();
  }

  get isQntFetching => _isQntFetching;

  set isQntFetching(value) {
    _isQntFetching = value;
    notifyListeners();
  }

  AugmontRates? goldRates;
  FocusNode sellFieldNode = FocusNode();
  String? _sellNotice;

  get sellNotice => _sellNotice;

  set sellNotice(value) {
    _sellNotice = value;
    notifyListeners();
  }

  double goldSellGrams = 0;
  double _goldAmountFromGrams = 0.0;

  double? nonWithdrawableQnt = 0.0;
  double? withdrawableQnt = 0.0;
  String? withdrawableQtyMessage = "";
  TextEditingController? goldAmountController;
  List<double> chipAmountList = [25, 50, 100];

  double? get goldSellPrice =>
      goldRates != null ? goldRates!.goldSellPrice : 0.0;

  UserFundWallet? get userFundWallet => _userService.userFundWallet;

  get goldAmountFromGrams => _goldAmountFromGrams;

  set goldAmountFromGrams(value) {
    _goldAmountFromGrams = value;
    notifyListeners();
  }

  init() async {
    deductedTokensCount = 0;
    setState(ViewState.Busy);
    goldAmountController = TextEditingController();
    // await _userService.fetchUserAugmontDetail();
    // setUpNoticeIfAny();
    fetchGoldRates();
    await fetchLockedGoldQnt();
    // FocusScope.of(AppState.delegate.navigatorKey.currentContext).requestFocus();
    setState(ViewState.Idle);
  }

  // setUpNoticeIfAny() {
  //   sellNotice = _userService.userAugmontDetails.sellNotice;
  // }

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
    if (val.isEmpty) {
      val = '0';
    }
    // print(val);
    // print(val.split('').where((element) => element == '.').toList().length);
    // if (val.split('').where((element) => element == '.').toList().isNotEmpty &&
    //     val.characters.last == '.') {
    //   val = val.substring(0, val.length - 1);
    //   goldAmountController!.text = val;
    //   refresh();
    // }
    if (val.isNotEmpty) {
      if (val.contains('.')) {
        if (val.split('.').last.length > 4) {
          goldAmountController!.text = val.substring(0, val.length - 1);
          val = goldAmountController!.text;
          sellFieldNode.unfocus();
        }
      } else {
        if (val.length > 2) {
          goldAmountController!.text = val.substring(0, val.length - 1);
          val = goldAmountController!.text;
          sellFieldNode.unfocus();
        }
      }
      goldSellGrams = double.tryParse(val) ?? 0;
      if (goldSellPrice != 0.0) {
        _goldAmountFromGrams =
            BaseUtil.digitPrecision(goldSellGrams * goldSellPrice!, 4, false);
        if (_goldAmountFromGrams < 10) showMinCap = true;
        if (_goldAmountFromGrams > 50000) showMaxCap = true;
      } else {
        goldAmountFromGrams = 0.0;
      }
      fieldWidth = val.contains('.')
          ? (val.length - 1) * SizeConfig.title5
          : val.length * SizeConfig.title5;
      refresh();
    }
  }

  late WithdrawableGoldResponseModel responseModel;

  Future<void> fetchLockedGoldQnt() async {
    isQntFetching = true;
    refresh();
    await _userService.getUserFundWalletData();
    ApiResponse<WithdrawableGoldResponseModel> quantityApiResponse =
        await _paymentRepo.getWithdrawableAugGoldQuantity();
    if (quantityApiResponse.isSuccess()) {
      responseModel = quantityApiResponse.model!;
      withdrawableQnt = quantityApiResponse.model!.data!.quantity;
      withdrawableQtyMessage = quantityApiResponse.model!.message;
      nonWithdrawableQnt = quantityApiResponse.model!.data!.lockedQuantity;
    } else {
      nonWithdrawableQnt = 0.0;
      withdrawableQnt = _userService.userFundWallet!.augGoldQuantity;
      // return BaseUtil.showNegativeAlert("", quantityApiResponse.errorMessage);
    }
    isQntFetching = false;
    refresh();
  }

  fetchGoldRates() async {
    isGoldRateFetching = true;
    refresh();
    goldRates = await _augmontModel.getRates();
    if (goldRates == null) {
      BaseUtil.showNegativeAlert(
        locale.portalUnavailable,
        locale.currentRatesNotLoadedText1,
      );
    }
    isGoldRateFetching = false;

    refresh();
  }

  Future<bool> verifyGoldSaleDetails() async {
    double? sellGramAmount = double.tryParse(goldAmountController!.text.trim());
    if (goldRates == null) {
      BaseUtil.showNegativeAlert(
        locale.portalUnavailable,
        locale.currentRatesNotLoadedText1,
      );
      return false;
    }

    if (sellGramAmount == null) {
      BaseUtil.showNegativeAlert(locale.noAmountEntered, locale.enterAmount);
      return false;
    }
    // if (!_userService.baseUser.isAugmontOnboarded) {
    //   BaseUtil.showNegativeAlert(
    //     'Not registered',
    //     'You have not registered for digital gold yet',
    //   );
    //   return false;
    // }
    if (sellGramAmount < 0.0001) {
      BaseUtil.showNegativeAlert(locale.amountLow, locale.amountLowSubTitle);
      return false;
    }

    if (sellGramAmount > withdrawableQnt!) {
      BaseUtil.showNegativeAlert(locale.tryLowerAmount, locale.goldLocked);
      return false;
    }
    if (goldAmountFromGrams > 50000) {
      BaseUtil.showNegativeAlert(locale.enterLowQuantity, locale.max8gms);
      return false;
    }
    if (goldAmountFromGrams < 10) {
      BaseUtil.showNegativeAlert(locale.enterHigherQuant, locale.min10rs);
      return false;
    }
    if (sellGramAmount > userFundWallet!.augGoldQuantity) {
      BaseUtil.showNegativeAlert(locale.inSufficientBal, locale.tryLowerAmount);
      return false;
    }
    // if (sellGramAmount > withdrawableQnt) {
    //   BaseUtil.showNegativeAlert(
    //       "Sell not processed", "Purchased Gold can be sold after 2 days");
    //   return false;
    // }

    // if (_userService.userAugmontDetails == null) {
    //   await _userService.fetchUserAugmontDetail();
    // }
    // if (_userService.userAugmontDetails == null) {
    //   BaseUtil.showNegativeAlert(
    //     'Sell Failed',
    //     'Please try again in sometime or contact us',
    //   );
    //   return false;
    // }
    List<String> fractionalPart = sellGramAmount.toString().split('.');
    if (fractionalPart.length > 1 && fractionalPart[1].length > 4) {
      BaseUtil.showNegativeAlert(
        locale.obPleaseTryAgain,
        locale.upto4DecimalsAllowed,
      );
      return false;
    }
    // if (_userService.userAugmontDetails.isSellLocked) {
    //   BaseUtil.showNegativeAlert(
    //     'Sell Failed',
    //     "${sellNotice ?? 'Gold sell is currently on hold. Please try again after sometime.'}",
    //   );
    //   return false;
    // }
    // bool _disabled = await _dbModel!.isAugmontSellDisabled();
    // if (_disabled != null && _disabled) {
    //   BaseUtil.showNegativeAlert(
    //     locale.sellFailed,
    //     locale.sellFailedSubtitle,
    //   );
    //   return false;
    // }
    return true;
  }

  initiateSell() async {
    double sellGramAmount = double.tryParse(goldAmountController!.text.trim())!;
    _augTxnService.currentTxnAmount = goldAmountFromGrams;
    _augTxnService.currentTxnGms = sellGramAmount;
    _augTxnService.isGoldSellInProgress = true;

    AppState.screenStack.add(ScreenItem.loader);
    final res =
        await _augmontModel.initiateWithdrawal(goldRates!, sellGramAmount);
    _augTxnService.isGoldSellInProgress = false;

    if (res) {
      _augTxnService.currentTransactionState = TransactionState.ongoing;
    } else {
      _augTxnService.currentTransactionState = TransactionState.idle;
    }
    // _augmontModel.setAugmontTxnProcessListener(_onSellTransactionComplete);

    final totalSellAmount =
        BaseUtil.digitPrecision(sellGramAmount * goldRates!.goldSellPrice!);
    _analyticsService.track(
      eventName: AnalyticsEvents.sellInitiate,
      properties: {
        'Amount to be sold': totalSellAmount,
        "Weight (Gold)": goldAmountController!.text,
        "Asset": "Gold"
      },
    );
  }

  handleWithdrawalFcmResponse(String data) {
    _userCoinService.getUserCoinBalance();
    _transactionHistoryService.updateTransactions(InvestmentType.AUGGOLD99);
    _userService.getUserFundWalletData();
    final response = json.decode(data);
    // _tambolaService!.weeklyTicksFetched = false;
    AppState.unblockNavigation();
    print(response['status']);
    if (_augTxnService.currentTransactionState == TransactionState.ongoing) {
      if (response['status'] != null) {
        if (response['tickets'] != null) {
          deductedTokensCount = response['tickets'];
        }
        if (response['status']) {
          _augTxnService.currentTransactionState = TransactionState.success;
        } else {
          _augTxnService.currentTransactionState = TransactionState.idle;
          AppState.backButtonDispatcher!.didPopRoute();
          BaseUtil.showNegativeAlert(
            locale.sellInCompleteTitle,
            response["message"] ?? locale.sellInCompleteSubTitle,
          );
        }
      }
      return;
    } else {
      if (response != null &&
          response['status'] != null &&
          response['status'] == true) {
        BaseUtil.showPositiveAlert(
            response["message"], locale.checkTransactions);
      } else {
        BaseUtil.showNegativeAlert(
          locale.sellInCompleteTitle,
          response["message"] ?? locale.sellInCompleteSubTitle,
        );
      }
    }
  }
}

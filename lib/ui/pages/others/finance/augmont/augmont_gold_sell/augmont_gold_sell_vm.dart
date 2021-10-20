import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AugmontGoldSellViewModel extends BaseModel {
  final _logger = locator<Logger>();
  BaseUtil _baseUtil = locator<BaseUtil>();
  DBModel _dbModel = locator<DBModel>();
  AugmontModel _augmontModel = locator<AugmontModel>();
  FcmListener _fcmListener = locator<FcmListener>();
  UserService _userService = locator<UserService>();
  TransactionService _txnService = locator<TransactionService>();
  bool isGoldRateFetching = false;
  AugmontRates goldRates;
  bool isGoldBuyInProgress = false;
  double goldBuyAmount = 0;
  double goldAmountInGrams = 0.0;
  TextEditingController goldAmountController;
  List<double> chipAmountList = [25, 50, 100];
  double get goldSellPrice => goldRates != null ? goldRates.goldSellPrice : 0.0;
  UserFundWallet get userFundWallet => _userService.userFundWallet;

  init() {
    goldAmountController = TextEditingController();
    fetchGoldRates();
  }

  Widget amoutChip(double amt) {
    return GestureDetector(
      onTap: () {
        goldBuyAmount += amt;
        goldAmountController.text = goldBuyAmount.toString();
        updateGoldAmount();
        notifyListeners();
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.229,
        height: SizeConfig.screenWidth * 0.103,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          color: amt.toInt() == 100
              ? UiConstants.tertiarySolid
              : UiConstants.tertiaryLight,
        ),
        alignment: Alignment.center,
        child: Text(
          "${amt.toInt()}%",
          style: TextStyles.body3.bold.colour(
            amt.toInt() == 100 ? Colors.white : UiConstants.tertiarySolid,
          ),
        ),
      ),
    );
  }

  updateGoldAmount() {
    if (goldSellPrice != 0.0)
      goldAmountInGrams =
          double.tryParse(goldAmountController.text) / goldSellPrice;
    else
      goldAmountInGrams = 0.0;
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

  initiateSell() async {
    // if (await BaseUtil.showNoInternetAlert()) return;
    // if (checkAugmontStatus() == STATUS_OPEN) {
    //   if (goldAmountController.text.trim().isEmpty)
    //     return BaseUtil.showNegativeAlert(
    //         "No Amount Entered", "Please enter some amount");
    // }

    // isGoldBuyInProgress = true;
    // notifyListeners();
    // Haptic.vibrate();
    // _onDepositClicked();
    showSuccessGoldSellDialog();
  }

  showSuccessGoldSellDialog() {
    BaseUtil.openDialog(
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissable: false,
      content: FelloInfoDialog(
        asset: Assets.prizeClaimConfirm,
        title: "Successful!",
        subtitle:
            "Your withdrawal is successful, the amount will be credited in 1-2 business days!",
        action: Container(
          width: SizeConfig.screenWidth,
          child: FelloButtonLg(
            child: Text(
              "OK",
              style: TextStyles.body3.colour(Colors.white),
            ),
            color: UiConstants.primaryColor,
            onPressed: AppState.backButtonDispatcher.didPopRoute,
          ),
        ),
      ),
    );
  }
}

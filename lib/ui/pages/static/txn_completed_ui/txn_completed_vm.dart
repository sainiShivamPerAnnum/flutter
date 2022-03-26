import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';

class TransactionCompletedConfirmationScreenViewModel extends BaseModel {
  final _coinService = locator<UserCoinService>();
  bool _isAnimationInProgress = false;

  bool _isInvestmentAnimationInProgress = false;
  bool _isCoinAnimationInProgress = false;
  bool _showPlayButton = false;
  bool get showPlayButton => this._showPlayButton;
  AnimationController lottieAnimationController;

  set showPlayButton(bool showPlayButton) {
    this._showPlayButton = showPlayButton;
    notifyListeners();
  }

  int coinsCount = 200;

  get isInvestmentAnimationInProgress => this._isInvestmentAnimationInProgress;

  set isInvestmentAnimationInProgress(value) {
    this._isInvestmentAnimationInProgress = value;
    notifyListeners();
  }

  get isCoinAnimationInProgress => this._isCoinAnimationInProgress;

  set isCoinAnimationInProgress(value) {
    this._isCoinAnimationInProgress = value;
    notifyListeners();
  }

  get isAnimationInProgress => this._isAnimationInProgress;

  set isAnimationInProgress(value) {
    this._isAnimationInProgress = value;
    notifyListeners();
  }

  init(double amount) {
    Haptic.vibrate();
    coinsCount = _coinService.flcBalance - amount.toInt();
    initDepositSuccessAnimation(amount);
  }

  initDepositSuccessAnimation(double amount) async {
    isAnimationInProgress = true;
    isInvestmentAnimationInProgress = true;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 2500), () {
      isInvestmentAnimationInProgress = false;
      notifyListeners();
      initCoinAnimation(amount);
    });
  }

  initCoinAnimation(double amount) async {
    await Future.delayed(Duration(milliseconds: 100), () {
      isCoinAnimationInProgress = true;
      lottieAnimationController.forward();

      coinsCount = _coinService.flcBalance;
      notifyListeners();
    });
    // await Future.delayed(Duration(seconds: 2), () {
    //   coinContentOpacity = 0;
    //   notifyListeners();
    // });
    await Future.delayed(Duration(milliseconds: 2500), () {
      if (isAnimationInProgress) isAnimationInProgress = false;
      showPlayButton = true;
    });
  }
}

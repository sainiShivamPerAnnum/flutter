import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class GoldProBuyViewModel extends BaseViewModel {
  final AugmontTransactionService txnService =
      locator<AugmontTransactionService>();
  TextEditingController goldFieldController =
      TextEditingController(text: "2.5");

  bool _isDescriptionView = false;
  double _totalGoldBalance = 2.5;
  double _currentGoldBalance = 0.2;
  double _additionalGoldBalance = 0;
  double _expectedGoldReturns = 10500.0;
  double _totalGoldAmount = 2180;
  double get totalGoldAmount => _totalGoldAmount;

  set totalGoldAmount(double value) {
    _totalGoldAmount = value;
    notifyListeners();
  }

  double get totalGoldBalance => _totalGoldBalance;

  set totalGoldBalance(double value) {
    _totalGoldBalance = value;
    notifyListeners();
  }

  double get expectedGoldReturns => _expectedGoldReturns;

  set expectedGoldReturns(double value) {
    _expectedGoldReturns = value;
    notifyListeners();
  }

  double get currentGoldBalance => _currentGoldBalance;

  set currentGoldBalance(double value) {
    _currentGoldBalance = value;
    notifyListeners();
  }

  double get additionalGoldBalance => _additionalGoldBalance;

  set additionalGoldBalance(double value) {
    _additionalGoldBalance = value;
    notifyListeners();
  }

  get isDescriptionView => _isDescriptionView;
  set isDescriptionView(value) {
    _isDescriptionView = value;
    notifyListeners();
  }

  double _sliderValue = 0.25;
  get sliderValue => _sliderValue;

  set sliderValue(value) {
    _sliderValue = value;
    notifyListeners();
  }

  int _selectedChipValue = 1;
  get selectedChipValue => _selectedChipValue;

  set selectedChipValue(value) {
    _selectedChipValue = value;
    notifyListeners();
  }

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      txnService.currentTransactionState = TransactionState.idle;
    });
  }

  void dump() {
    goldFieldController.dispose();
  }

  onChipSelected(int val) {
    selectedChipValue = val;
  }

  updateSliderValue(double val) {
    sliderValue = val;
    print(sliderValue);
  }
}

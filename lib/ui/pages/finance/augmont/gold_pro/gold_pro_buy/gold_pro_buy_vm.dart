import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:flutter/material.dart';

class GoldProBuyViewModel extends BaseViewModel {
  TextEditingController goldFieldController =
      TextEditingController(text: "2.5");

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

  init() {}

  dump() {}

  onChipSelected(int val) {
    selectedChipValue = val;
  }

  updateSliderValue(double val) {
    sliderValue = val;
    print(sliderValue);
  }
}

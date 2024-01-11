import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:flutter/material.dart';

class SipViewModel extends BaseViewModel {
  AssetType? selectedType;
  TabController? tabController;
  int sipAmount = 500;
  int timePeriod = 5;
  double returnPercentage = 10;
  int maxSipValue = 5000;
  int minSipValue = 100;
  int maxTimePeriod = 10;
  int minTimePeriod = 1;

  String getReturn() {
    return "10000";
  }

  static String formatValue(double value) {
    return value == value.floor()
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
  }

  void changeTimePeriod(int value) {
    if (value > maxTimePeriod) {
      timePeriod = maxTimePeriod;
    } else if (value < minTimePeriod) {
      timePeriod = minTimePeriod;
    } else {
      timePeriod = value;
    }
    notifyListeners();
  }

  void changeSIPAmount(int value) {
    print("helooooooo");
    print(value);
    print(sipAmount);
    if (value > maxSipValue) {
      print("here");
      sipAmount = maxSipValue;
    } else if (value < minSipValue) {
      print("here 2");
      sipAmount = minSipValue;
    } else {
      print("here 3");
      sipAmount = value;
    }
    print("wowowowoowowowow");
    print(value);
    print(sipAmount);
    notifyListeners();
  }

  void changeSelectedAsset(AssetType newAsset) {
    selectedType = newAsset;
    notifyListeners();
  }
}

class SipDetails {
  String sipName;
  String startDate;
  String nextDueDate;
  String assetUrl;
  String sipInterval;
  int sipAmount;

  SipDetails(
      {required this.assetUrl,
      required this.nextDueDate,
      required this.sipAmount,
      required this.sipName,
      required this.sipInterval,
      required this.startDate});
}

enum AssetType { FELLOP2P, AUGMONT_GOLD }

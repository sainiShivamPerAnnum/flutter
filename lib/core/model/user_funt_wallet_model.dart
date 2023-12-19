import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/logger.dart';

class UserFundWallet {
  static Log log = const Log('UserFundWallet');

  //augmont
  double? _augGoldPrinciple;
  double? _augGoldBalance;
  double? _augGoldQuantity;

  //lendbox
  double? wLbBalance;
  double? wLbPrinciple;
  double? wLbProcessingAmt;
  double? wLbLifetimeInterest;

  //10% Flo
  double? wLbF1Balance;
  double? wLbF1Principle;
  double? wLbF1LifetimeInterest;

  //12% Flo
  double? wLbF2Balance;
  double? wLbF2Principle;
  double? wLbF2LifetimeInterest;

  double? netWorth;
  Map<String, dynamic>? tickets;

  //icici
  double? _iciciPrinciple;
  double? _iciciBalance;

  //prizes
  double? _prizeBalance;
  double? _lockedPrizeBalance;
  double? _prizeLifetimeWin;

  //on hold
  double? _processingRedemptionBalance;
  int? wTmbLifetimeWin;
  double? wAugFdQty;
  double? wAugTotal;
  bool? isGoldProUser;

  static const String fldAugmontGoldPrinciple = 'wAugPrinciple';
  static const String fldAugmontGoldBalance = 'wAugBalance';
  static const String fldAugmontGoldQuantity = 'wAugQuantity';
  static const String fldIciciPrinciple = 'wICPrinciple';
  static const String fldIciciBalance = 'wICBalance';
  static const String fldPrizeBalance = 'wPriBalance';
  static const String fldPrizeLockedBalance = 'wPriLockBalance';
  static const String fldPrizeLifetimeWin = 'wLifeTimeWin';
  static const String fldProcessingRedemption = 'wRedemptionProcessing';

  UserFundWallet(
      this._augGoldPrinciple,
      this._augGoldBalance,
      this._augGoldQuantity,
      this._iciciPrinciple,
      this._iciciBalance,
      this._prizeBalance,
      this._lockedPrizeBalance,
      this._prizeLifetimeWin,
      this._processingRedemptionBalance,
      this.wLbBalance,
      this.wLbPrinciple,
      this.wLbProcessingAmt,
      this.netWorth,
      this.tickets,
      this.wLbLifetimeInterest,
      this.wLbF1Balance,
      this.wLbF1Principle,
      this.wLbF1LifetimeInterest,
      this.wLbF2Balance,
      this.wLbF2Principle,
      this.wLbF2LifetimeInterest,
      this.wTmbLifetimeWin,
      this.wAugFdQty,
      this.wAugTotal,
      this.isGoldProUser);

  UserFundWallet.newWallet()
      : this(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {}, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, false);

  UserFundWallet.fromMap(Map<String, dynamic> data)
      : this(
            BaseUtil.toDouble(data[fldAugmontGoldPrinciple]),
            BaseUtil.toDouble(data[fldAugmontGoldBalance]),
            BaseUtil.toDouble(data[fldAugmontGoldQuantity]),
            BaseUtil.toDouble(data[fldIciciPrinciple]),
            BaseUtil.toDouble(data[fldIciciBalance]),
            BaseUtil.toDouble(data[fldPrizeBalance]),
            BaseUtil.toDouble(data[fldPrizeLockedBalance]),
            BaseUtil.toDouble(data[fldPrizeLifetimeWin]),
            BaseUtil.toDouble(data[fldProcessingRedemption]),
            BaseUtil.toDouble(data['wLbBalance']),
            BaseUtil.toDouble(data['wLbPrinciple']),
            BaseUtil.toDouble(data['wLbProcessingAmt']),
            BaseUtil.toDouble(data['netWorth']),
            data["tickets"],
            BaseUtil.toDouble(data['wLbLifetimeInterest']),
            BaseUtil.toDouble(data['wLbF1Balance']),
            BaseUtil.toDouble(data['wLbF1Principle']),
            BaseUtil.toDouble(data['wLbF1LifetimeInterest']),
            BaseUtil.toDouble(data['wLbF2Balance']),
            BaseUtil.toDouble(data['wLbF2Principle']),
            BaseUtil.toDouble(data['wLbF2LifetimeInterest']),
            BaseUtil.toInt(data['wTmbLifetimeWin']),
            BaseUtil.toDouble(data["wAugFdQty"] ?? 0.0),
            BaseUtil.toDouble(data["wAugTotal"] ?? 0.0),
            data['isGoldProUser'] ?? false);

  double getEstTotalWealth() {
    return BaseUtil.digitPrecision(
      BaseUtil.toDouble(_iciciBalance) +
          BaseUtil.toDouble(_augGoldBalance) +
          BaseUtil.toDouble(_prizeBalance) +
          BaseUtil.toDouble(_lockedPrizeBalance),
    );
  }

  double get prizeLifetimeWin => _prizeLifetimeWin!;

  set prizeLifetimeWin(double value) {
    _prizeLifetimeWin = value;
  }

  double get prizeBalance => _prizeBalance!;

  set prizeBalance(double value) {
    _prizeBalance = value;
  }

  double get iciciBalance => _iciciBalance!;

  set iciciBalance(double value) {
    _iciciBalance = value;
  }

  double get iciciPrinciple => _iciciPrinciple!;

  set iciciPrinciple(double value) {
    _iciciPrinciple = value;
  }

  double get augGoldQuantity => _augGoldQuantity!;

  set augGoldQuantity(double value) {
    _augGoldQuantity = value;
  }

  double get augGoldBalance => _augGoldBalance!;

  set augGoldBalance(double value) {
    _augGoldBalance = value;
  }

  double get augGoldPrinciple => _augGoldPrinciple!;

  set augGoldPrinciple(double value) {
    _augGoldPrinciple = value;
  }

  double get lockedPrizeBalance => _lockedPrizeBalance!;

  set lockedPrizeBalance(double value) {
    _lockedPrizeBalance = value;
  }

  double get processingRedemptionBalance => _processingRedemptionBalance!;

  bool isPrizeBalanceUnclaimed() {
    double a = _prizeBalance ?? 0.0;
    double b = _processingRedemptionBalance ?? 0.0;
    return a - b > 0;
  }

  double get unclaimedBalance {
    double a = _prizeBalance ?? 0.0;
    double b = _processingRedemptionBalance ?? 0.0;
    return math.max(a - b, 0);
  }
}

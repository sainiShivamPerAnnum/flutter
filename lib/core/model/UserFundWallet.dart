import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/logger.dart';

class UserFundWallet {
  static Log log = new Log('UserFundWallet');

  //augmont
  double _augGoldPrinciple;
  double _augGoldBalance;
  double _augGoldQuantity;

  //icici
  double _iciciPrinciple;
  double _iciciBalance;

  //prizes
  double _prizeBalance;
  double _prizeLifetimeWin;

  static final String fldAugmontGoldPrinciple = 'wAugPrinciple';
  static final String fldAugmontGoldBalance = 'wAugBalance';
  static final String fldAugmontGoldQuantity = 'wAugQuantity';
  static final String fldIciciPrinciple = 'wICPrinciple';
  static final String fldIciciBalance = 'wICBalance';
  static final String fldPrizeBalance = 'wPriBalance';
  static final String fldPrizeLifetimeWin = 'wLifeTimeWin';

  UserFundWallet(
      this._augGoldPrinciple,
      this._augGoldBalance,
      this._augGoldQuantity,
      this._iciciPrinciple,
      this._iciciBalance,
      this._prizeBalance,
      this._prizeLifetimeWin);

  UserFundWallet.newWallet() : this(0, 0, 0, 0, 0, 0, 0);

  UserFundWallet.fromMap(Map<String, dynamic> data)
      : this(
          BaseUtil.toDouble(data[fldAugmontGoldPrinciple]),
          BaseUtil.toDouble(data[fldAugmontGoldBalance]),
          BaseUtil.toDouble(data[fldAugmontGoldQuantity]),
          BaseUtil.toDouble(data[fldIciciPrinciple]),
          BaseUtil.toDouble(data[fldIciciBalance]),
          BaseUtil.toDouble(data[fldPrizeBalance]),
          BaseUtil.toDouble(data[fldPrizeLifetimeWin]),
        );

  Map<String, dynamic> cloneMap() => {
        fldAugmontGoldPrinciple: _augGoldPrinciple,
        fldAugmontGoldBalance: _augGoldBalance,
        fldAugmontGoldQuantity: _augGoldQuantity,
        fldIciciPrinciple: _iciciPrinciple,
        fldIciciBalance: _iciciBalance,
        fldPrizeBalance: _prizeBalance,
        fldPrizeLifetimeWin: _prizeLifetimeWin,
      };

  double get prizeLifetimeWin => _prizeLifetimeWin;

  set prizeLifetimeWin(double value) {
    _prizeLifetimeWin = value;
  }

  double get prizeBalance => _prizeBalance;

  set prizeBalance(double value) {
    _prizeBalance = value;
  }

  double get iciciBalance => _iciciBalance;

  set iciciBalance(double value) {
    _iciciBalance = value;
  }

  double get iciciPrinciple => _iciciPrinciple;

  set iciciPrinciple(double value) {
    _iciciPrinciple = value;
  }

  double get augGoldQuantity => _augGoldQuantity;

  set augGoldQuantity(double value) {
    _augGoldQuantity = value;
  }

  double get augGoldBalance => _augGoldBalance;

  set augGoldBalance(double value) {
    _augGoldBalance = value;
  }

  double get augGoldPrinciple => _augGoldPrinciple;

  set augGoldPrinciple(double value) {
    _augGoldPrinciple = value;
  }
}

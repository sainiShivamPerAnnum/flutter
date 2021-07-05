import 'package:felloapp/util/logger.dart';

class AugmontRates {
  static Log log = new Log('AugmontRates');
  String _blockId;
  double _goldBuyPrice;
  double _goldSellPrice;
  double _silverBuyPrice;
  double _silverSellPrice;
  double _cgstPercent;
  double _sgstPercent;

  AugmontRates(
      this._blockId,
      this._goldBuyPrice,
      this._goldSellPrice,
      this._silverBuyPrice,
      this._silverSellPrice,
      this._cgstPercent,
      this._sgstPercent);

  AugmontRates.fromMap(Map<String, dynamic> data)
      : this(
            data['blockId'],
            getDouble(data['rates']['gBuy']),
            getDouble(data['rates']['gSell']),
            getDouble(data['rates']['sBuy']),
            getDouble(data['rates']['sSell']),
            getDouble(data['taxes'][0]['taxPerc']),
            getDouble(data['taxes'][1]['taxPerc']));

  static double getDouble(String s) {
    if (s == null) {
      return null;
    }
    return double.tryParse(s);
  }

  double get sgstPercent => _sgstPercent;

  double get cgstPercent => _cgstPercent;

  double get silverSellPrice => _silverSellPrice;

  double get silverBuyPrice => _silverBuyPrice;

  double get goldSellPrice => _goldSellPrice;

  double get goldBuyPrice => _goldBuyPrice;

  String get blockId => _blockId;
}

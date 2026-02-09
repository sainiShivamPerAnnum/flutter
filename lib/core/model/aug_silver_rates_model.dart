import 'package:felloapp/util/logger.dart';

class AugmontSilverRates {
  static Log log = const Log('AugmontSilverRates');
  String? _blockId;
  double? _silverBuyPrice;
  double? _silverSellPrice;
  double? _silverBuyGst;
  double? _cgstPercent;
  double? _sgstPercent;
  double? _igstPercent;

  AugmontSilverRates(
      this._blockId,
      this._silverBuyPrice,
      this._silverSellPrice,
      this._silverBuyGst,
      this._cgstPercent,
      this._sgstPercent,
      this._igstPercent,
    );

  AugmontSilverRates.fromMap(Map<String, dynamic> data)
      : this(
            data['blockId'] ?? '',
            getDouble(data['rates']['sBuy']),
            getDouble(data['rates']['sSell']),
            getDouble(data['rates']['sBuyGst']),
            getDouble(data['taxes'][0]['taxPerc']),
            getDouble(data['taxes'][1]['taxPerc']),
            getDouble(data['taxes'][2]['taxPerc']));

  AugmontSilverRates.base() : this('', 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

  static double getDouble(dynamic s) {
    if (s == null) {
      return 0.0;
    }
    if (s.runtimeType == double) return s;
    return double.tryParse(s) ?? 0.0;
  }

  String? get blockId => _blockId;
  double? get goldSellPrice => _silverSellPrice;
  double? get silverBuyPrice => _silverBuyPrice;
  double? get silverBuyGst => _silverBuyGst;
  double? get sgstPercent => _sgstPercent;
  double? get cgstPercent => _cgstPercent;
  double? get igstPercent => _igstPercent;
}

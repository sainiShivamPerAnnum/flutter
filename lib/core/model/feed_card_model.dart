import 'package:felloapp/util/logger.dart';

class FeedCard {
  static Log log = new Log('HomeCard');
  int _id;
  final String _title;
  final String _subtitle;
  final String _btnText;
  final String _assetLocalLink;
  final String _assetRemoteLink;
  final int _clrCodeA;
  final int _clrCodeB;
  final String _actionUri;
  final bool _isHidden;
  final String _type;
  final Map<String, dynamic> _dataMap;

  FeedCard(
      this._id,
      this._title,
      this._subtitle,
      this._btnText,
      this._assetLocalLink,
      this._assetRemoteLink,
      this._actionUri,
      this._clrCodeA,
      this._clrCodeB,
      this._isHidden,
      this._type,
      this._dataMap);

  FeedCard.fromMap(Map<String, dynamic> cMap)
      : this(
            cMap['id'],
            cMap['title'],
            cMap['subtitle'],
            cMap['btnText'],
            cMap['assetLocalLink'],
            cMap['assetRemoteLink'],
            cMap['actionUri'],
            cMap['clrCodeA'],
            cMap['clrCodeB'],
            cMap['isHidden'],
            cMap['type'],
            cMap['dataMap']);

  String get subtitle => _subtitle;

  String get title => _title;

  int get clrCodeB => _clrCodeB;

  int get clrCodeA => _clrCodeA;

  String get assetLocalLink => _assetLocalLink;

  String get btnText => _btnText;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get actionUri => _actionUri;

  String get type => _type;

  bool get isHidden => _isHidden;

  String get assetRemoteLink => _assetRemoteLink;

  Map<String, dynamic> get dataMap => _dataMap;
}

import 'package:felloapp/ui/dialogs/guide_dialog.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class FeedCard {
  static Log log = new Log('HomeCard');
  final int _id;
  final String _title;
  final String _subtitle;
  final String _btnText;
  final String _assetLocalLink;
  final int _clrCodeA;
  final int _clrCodeB;
  final String _actionUri;

  FeedCard(this._id, this._title, this._subtitle, this._btnText,
      this._assetLocalLink, this._actionUri, this._clrCodeA, this._clrCodeB);

  FeedCard.fromMap(Map<String, dynamic> cMap)
      : this(cMap['id'], cMap['title'], cMap['subtitle'], cMap['btnText'],
            cMap['assetLocalLink'], cMap['actionUri'], cMap['clrCodeA'], cMap['clrCodeB']);

  String get subtitle => _subtitle;

  String get title => _title;

  int get clrCodeB => _clrCodeB;

  int get clrCodeA => _clrCodeA;

  String get assetLocalLink => _assetLocalLink;

  String get btnText => _btnText;

  int get id => _id;

  String get actionUri => _actionUri;
}

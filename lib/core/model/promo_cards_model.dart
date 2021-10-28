import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class PromoCardModel {
  static Log log = new Log('PromoCard');

  int _position;
  final String _title;
  final String _subtitle;
  final String _buttonText;
  final String _actionUri;
  final int _bgColor;
  final String _bgImage;

  get position => this._position;

  PromoCardModel(this._position, this._title, this._subtitle, this._actionUri,
      this._buttonText, this._bgColor, this._bgImage);

  PromoCardModel.fromMap(Map<String, dynamic> cMap)
      : this(
          cMap['position'],
          cMap['title'],
          cMap['subtitle'],
          cMap['actionUri'],
          cMap['btnText'],
          cMap['color'],
          cMap['bgImage']
        );

  set position(value) => this.position = value;

  String get title => this._title;

  String get subtitle => this._subtitle;

  String get buttonText => this._buttonText;

  String get actionUri => this._actionUri;

  int get bgColor => this._bgColor;

  String get bgImage => _bgImage;
}

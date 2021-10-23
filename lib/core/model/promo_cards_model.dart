import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class PromoCardModel {
  static Log log = new Log('PromoCard');

  int _id;
  final String _title;
  final String _subtitle;
  final String _buttonText;
  final String _actionUri;
  final int _bgColor;
  get id => this._id;

  PromoCardModel(
    this._id,
    this._title,
    this._subtitle,
    this._actionUri,
    this._buttonText,
    this._bgColor,
  );

  PromoCardModel.fromMap(Map<String, dynamic> cMap)
      : this(
          cMap['id'],
          cMap['title'],
          cMap['subtitle'],
          cMap['actionUri'],
          cMap['btntext'],
          cMap['color'],
        );

  set id(value) => this._id = value;

  String get title => this._title;

  String get subtitle => this._subtitle;

  String get buttonText => this._buttonText;

  String get actionUri => this._actionUri;

  int get bgColor => this._bgColor;
}

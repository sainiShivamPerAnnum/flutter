import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  //final String _id;
  final String _code;
  final String _description;
  final Timestamp _expireOn;
  final Timestamp _createdOn;
  final int _maxuse;
  final int _priority;
  final Additionals _additionals;
  final int _minPurchase;

  CouponModel(
    //this._id,
    this._code,
    this._description,
    this._expireOn,
    this._createdOn,
    this._maxuse,
    this._priority,
    this._minPurchase,
    this._additionals,
  );

  CouponModel.fromMap(Map<String, dynamic> cMap)
      : this(
            //cMap['id'],
            cMap['code'],
            cMap['description'],
            cMap['expiresOn'],
            cMap['createdOn'],
            cMap['maxUse'],
            cMap['priority'],
            cMap['minPurchase'],
            cMap['additionals'] != null
                ? Additionals.fromMap(cMap['additionals'])
                : null);

  //String get id => this._id;
  String get code => this._code;
  String get description => this._description;

  Timestamp get expireOn => this._expireOn;
  Timestamp get createdOn => this._createdOn;

  int get maxuse => this._maxuse;
  int get priority => this._priority;
  int get minPurchase => this._minPurchase;

  Additionals get additionals => this._additionals;
}

class Additionals {
  final String _title;
  // final String _subtitle;
  final String _bgImage;
  final int _bgColor;
  final String _btnText;

  Additionals(
    this._title,
    // this._subtitle,
    this._bgColor,
    this._bgImage,
    this._btnText,
  );

  Additionals.fromMap(Map<String, dynamic> cMap)
      : this(
          cMap['title'] ?? "",
          // cMap['subtitle'],
          cMap['bgColor'] ?? 0,
          cMap['bgImage'] ?? "",
          cMap['btnText'] ?? "",
        );

  String get title => this._title;
  // String get subtitle => this._subtitle;
  String get bgImage => this._bgImage;
  int get bgColor => this._bgColor;
  String get btnText => this._btnText;
}

// Additionals contains data for decoration of the offercard
// can be updated later
// Current contents will be
// title
//subtitle
// button text
// background image
//background color

import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  //final String _id;
  final String _code;
  final String _description;
  final Timestamp _expireOn;
  final Timestamp _createdOn;
  final int _maxuse;
  final int _priority;
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
        );

  //String get id => this._id;
  String get code => this._code;
  String get description => this._description;

  Timestamp get expireOn => this._expireOn;
  Timestamp get createdOn => this._createdOn;

  int get maxuse => this._maxuse;
  int get priority => this._priority;
  int get minPurchase => this._minPurchase;
}

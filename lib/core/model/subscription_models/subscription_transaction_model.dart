import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AutopayTransactionModel {
  double amount;
  String status;
  String txnId;
  String txnDateTime;
  String currency;
  String paymentMode;
  String bankTxnId;
  String gatewayName;
  String bankName;
  String note;
  AugmontDataModel augmontMap;
  double closingBalance;
  Timestamp createdOn;
  AutopayTransactionModel({
    @required this.amount,
    @required this.status,
    @required this.txnId,
    @required this.txnDateTime,
    @required this.currency,
    @required this.paymentMode,
    @required this.bankTxnId,
    @required this.gatewayName,
    @required this.bankName,
    @required this.note,
    @required this.augmontMap,
    @required this.closingBalance,
    @required this.createdOn,
  });

  AutopayTransactionModel copyWith({
    double amount,
    String status,
    String txnId,
    String txnDateTime,
    String currency,
    String paymentMode,
    String bankTxnId,
    String gatewayName,
    String bankName,
    String note,
    AugmontDataModel augmontMap,
    double closingBalance,
    Timestamp createdOn,
  }) {
    return AutopayTransactionModel(
      amount: amount ?? this.amount,
      status: status ?? this.status,
      txnId: txnId ?? this.txnId,
      txnDateTime: txnDateTime ?? this.txnDateTime,
      currency: currency ?? this.currency,
      paymentMode: paymentMode ?? this.paymentMode,
      bankTxnId: bankTxnId ?? this.bankTxnId,
      gatewayName: gatewayName ?? this.gatewayName,
      bankName: bankName ?? this.bankName,
      note: note ?? this.note,
      augmontMap: augmontMap ?? this.augmontMap,
      closingBalance: closingBalance ?? this.closingBalance,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'status': status,
      'txnId': txnId,
      'txnDateTime': txnDateTime,
      'currency': currency,
      'paymentMode': paymentMode,
      'bankTxnId': bankTxnId,
      'gatewayName': gatewayName,
      'bankName': bankName,
      'note': note,
      'augmontMap': augmontMap.toMap(),
      'closingBalance': closingBalance,
      'createdOn': createdOn,
    };
  }

  factory AutopayTransactionModel.fromMap(Map<String, dynamic> map) {
    return AutopayTransactionModel(
      amount: map['amount']?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      txnId: map['txnId'] ?? '',
      txnDateTime: map['txnDateTime'] ?? '',
      currency: map['currency'] ?? '',
      paymentMode: map['paymentMode'] ?? '',
      bankTxnId: map['bankTxnId'] ?? '',
      gatewayName: map['gatewayName'] ?? '',
      bankName: map['bankName'] ?? '',
      note: map['note'] ?? '',
      augmontMap: AugmontDataModel.fromMap(map['augmontMap'] ?? {}),
      closingBalance: map['closingBalance']?.toDouble() ?? 0.0,
      createdOn: map['createdOn'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AutopayTransactionModel.fromJson(String source) =>
      AutopayTransactionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AutopayTransactionModel(amount: $amount, status: $status, txnId: $txnId, txnDateTime: $txnDateTime, currency: $currency, paymentMode: $paymentMode, bankTxnId: $bankTxnId, gatewayName: $gatewayName, bankName: $bankName, note: $note, augmontMap: $augmontMap, closingBalance: $closingBalance, createdOn: $createdOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutopayTransactionModel &&
        other.amount == amount &&
        other.status == status &&
        other.txnId == txnId &&
        other.txnDateTime == txnDateTime &&
        other.currency == currency &&
        other.paymentMode == paymentMode &&
        other.bankTxnId == bankTxnId &&
        other.gatewayName == gatewayName &&
        other.bankName == bankName &&
        other.note == note &&
        other.augmontMap == augmontMap &&
        other.closingBalance == closingBalance &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        status.hashCode ^
        txnId.hashCode ^
        txnDateTime.hashCode ^
        currency.hashCode ^
        paymentMode.hashCode ^
        bankTxnId.hashCode ^
        gatewayName.hashCode ^
        bankName.hashCode ^
        note.hashCode ^
        augmontMap.hashCode ^
        closingBalance.hashCode ^
        createdOn.hashCode;
  }
}

class AugmontDataModel {
  String aAugTranId;
  String aBlockId;
  double aGoldBalance;
  double aGoldInTxn;
  double aLockPrice;
  String aPaymode;
  double aTaxedGoldBalance;
  AugmontDataModel({
    @required this.aAugTranId,
    @required this.aBlockId,
    @required this.aGoldBalance,
    @required this.aGoldInTxn,
    @required this.aLockPrice,
    @required this.aPaymode,
    @required this.aTaxedGoldBalance,
  });

  AugmontDataModel copyWith({
    String aAugTranId,
    String aBlockId,
    double aGoldBalance,
    double aGoldInTxn,
    double aLockPrice,
    String aPaymode,
    double aTaxedGoldBalance,
  }) {
    return AugmontDataModel(
      aAugTranId: aAugTranId ?? this.aAugTranId,
      aBlockId: aBlockId ?? this.aBlockId,
      aGoldBalance: aGoldBalance ?? this.aGoldBalance,
      aGoldInTxn: aGoldInTxn ?? this.aGoldInTxn,
      aLockPrice: aLockPrice ?? this.aLockPrice,
      aPaymode: aPaymode ?? this.aPaymode,
      aTaxedGoldBalance: aTaxedGoldBalance ?? this.aTaxedGoldBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aAugTranId': aAugTranId,
      'aBlockId': aBlockId,
      'aGoldBalance': aGoldBalance,
      'aGoldInTxn': aGoldInTxn,
      'aLockPrice': aLockPrice,
      'aPaymode': aPaymode,
      'aTaxedGoldBalance': aTaxedGoldBalance,
    };
  }

  factory AugmontDataModel.fromMap(Map<String, dynamic> map) {
    return AugmontDataModel(
      aAugTranId: map['aAugTranId'] ?? '',
      aBlockId: map['aBlockId'] ?? '',
      aGoldBalance: map['aGoldBalance']?.toDouble() ?? 0.0,
      aGoldInTxn: map['aGoldInTxn']?.toDouble() ?? 0.0,
      aLockPrice: map['aLockPrice']?.toDouble() ?? 0.0,
      aPaymode: map['aPaymode'] ?? '',
      aTaxedGoldBalance: map['aTaxedGoldBalance']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AugmontDataModel.fromJson(String source) =>
      AugmontDataModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AugmontDataModel(aAugTranId: $aAugTranId, aBlockId: $aBlockId, aGoldBalance: $aGoldBalance, aGoldInTxn: $aGoldInTxn, aLockPrice: $aLockPrice, aPaymode: $aPaymode, aTaxedGoldBalance: $aTaxedGoldBalance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AugmontDataModel &&
        other.aAugTranId == aAugTranId &&
        other.aBlockId == aBlockId &&
        other.aGoldBalance == aGoldBalance &&
        other.aGoldInTxn == aGoldInTxn &&
        other.aLockPrice == aLockPrice &&
        other.aPaymode == aPaymode &&
        other.aTaxedGoldBalance == aTaxedGoldBalance;
  }

  @override
  int get hashCode {
    return aAugTranId.hashCode ^
        aBlockId.hashCode ^
        aGoldBalance.hashCode ^
        aGoldInTxn.hashCode ^
        aLockPrice.hashCode ^
        aPaymode.hashCode ^
        aTaxedGoldBalance.hashCode;
  }
}

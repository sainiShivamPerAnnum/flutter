// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/foundation.dart';

parseTimeStamp(dynamic data) {
  if (data != null) {
    if (data.runtimeType == Timestamp) {
      return data;
    } else {
      return Timestamp(data["_seconds"], data["_nanoseconds"]);
    }
  } else {
    return null;
  }
}

parseTransactionStatusSummary(Map? summary) {
  List<TransactionStatusMapItemModel> txnSummary = [];
  if (summary != null) {
    summary.forEach((key, value) {
      TimestampModel? timeStamp;
      String? result;
      if (value.runtimeType == String) {
        result = value;
      } else {
        timeStamp = TimestampModel.fromMap(value as Map<String, dynamic>);
      }

      if (timeStamp != null) {
        txnSummary.add(
            TransactionStatusMapItemModel(title: key, timestamp: timeStamp));
      } else if (result != null) {
        txnSummary
            .add(TransactionStatusMapItemModel(title: key, value: result));
      } else {
        txnSummary.add(TransactionStatusMapItemModel(title: key, value: "NA"));
      }
    });
  }
  return txnSummary;
}

class UserTransaction {
  static Log log = const Log('UserTransaction');
  String? _docKey;
  double _amount;
  double _closingBalance;
  String? _type;
  String? _subType;
  String? _redeemType;
  String? _tranStatus;
  String? _couponCode;
  Map<String, dynamic>? _rzp;
  Map<String, dynamic>? _augmnt;
  Map<String, dynamic>? misMap;
  Timestamp? _timestamp;
  Timestamp? _updatedTime;
  Map<String, dynamic>? couponMap;
  LbMap lbMap;
  List<TransactionStatusMapItemModel>? transactionUpdatesMap;

  static const String fldAmount = 'tAmount';
  static const String fldClosingBalance = 'tClosingBalance';
  static const String fldSubType = 'tSubtype';
  static const String fldRedeemType = 'tRedeemType';
  static const String fldType = 'tType';
  static const String fldTranStatus = 'tTranStatus';
  static const String fldCouponCode = 'tCouponCode';
  static const String fldRzpMap = 'tRzpMap';
  static const String fldAugmontMap = 'tAugmontMap';
  static const String fldTimestamp = 'timestamp';
  static const String fldUpdatedTime = 'tUpdateTime';
  static const String fldtransactionUpdatesMap = "transactionUpdatesMap";

  ///paytm submap feilds
  static const String subFldPaytmBankName = 'bankName';
  static const String subFldPaytmBankTranId = 'bankTxnId';
  static const String subFldPaytmGatewayName = 'gatewayName';
  static const String subFldPaytmPaymentMode = 'paymentMode';
  static const String subFldPaytmStatus = 'status';
  static const String subFldPaytmTxnAmount = 'txnAmount';
  static const String subFldPaytmTxnDate = 'txnDate';
  static const String subFldPaytmTxnId = 'txnId';

  ///razorpay submap fields
  static const String subFldRzpOrderId = 'rOrderId';
  static const String subFldRzpPaymentId = 'rPaymentId';
  static const String subFldRzpStatus = 'rStatus';

  ///augmont submap fields
  static const String subFldAugBlockId = 'aBlockId';
  static const String subFldAugLockPrice = 'aLockPrice';
  static const String subFldAugPaymode = 'aPaymode';
  static const String subFldMerchantTranId = 'aTranId';
  static const String subFldAugTranId = 'aAugTranId';
  static const String subFldAugCurrentGoldGm = 'aGoldInTxn';
  static const String subFldAugTotalGoldGm = 'aGoldBalance';
  static const String subFldAugPostTaxTotal = 'aTaxedGoldBalance';

  ///Icici submap fields
  static const String subFldIciciTranId = 'iTranId';
  static const String subFldIciciWithdrawType = 'iWithType';
  static const String subFldIciciMultipleId = 'iMultipleId';
  static const String subFldIciciBankRnn = 'iBankRnn';
  static const String subFldIciciUpiTime = 'iUpiDateTime';
  static const String subFldIciciTxnOtpId = 'iWthlOtpId';
  static const String subFldIciciTxnOtpVerified = 'iWthOtpVerified';

  ///Transaction statuses
  static const String TRAN_STATUS_PENDING = 'PENDING';
  static const String TRAN_STATUS_COMPLETE = 'COMPLETE';
  static const String TRAN_STATUS_CANCELLED = 'CANCELLED';
  static const String TRAN_STATUS_REFUNDED = 'REFUNDED';
  static const String TRAN_STATUS_FAILED = 'FAILED';
  static const String TRAN_STATUS_PROCESSING = 'PROCESSING';

  ///Razorpay payment status
  static const String RZP_TRAN_STATUS_NEW = 'NEW';
  static const String RZP_TRAN_STATUS_FAILED = 'FAILED';
  static const String RZP_TRAN_STATUS_COMPLETE = 'COMPLETE';

  ///Transaction types
  static const String TRAN_TYPE_DEPOSIT = 'DEPOSIT';
  static const String TRAN_TYPE_WITHDRAW = 'WITHDRAWAL';
  static const String TRAN_TYPE_PRIZE = 'PRIZE';

  ///Transaction Subtype
  static const String TRAN_SUBTYPE_ICICI = 'ICICI1565';
  static const String TRAN_SUBTYPE_AUGMONT_GOLD = 'AUGGOLD99';
  static const String TRAN_SUBTYPE_TAMBOLA_WIN = 'TMB_WIN';
  static const String TRAN_SUBTYPE_CRICKET_WIN = 'CRIC2020_WIN';
  static const String TRAN_SUBTYPE_REF_BONUS = 'REF_BONUS';
  static const String TRAN_SUBTYPE_GLDN_TCK = 'GLD_TCK_WIN';
  static const String TRAN_SUBTYPE_REWARD_REDEEM = 'REWARD_REDEMPTION';

  // REWARD REDEEM type
  static const String TRAN_REDEEMTYPE_AUGMONT_GOLD = "GOLD_CREDIT";
  static const String TRAN_REDEEMTYPE_AMZ_VOUCHER = "AMZ_VOUCHER";

  UserTransaction(
    this._docKey,
    this._amount,
    this._closingBalance,
    this._subType,
    this._type,
    this._redeemType,
    this._tranStatus,
    this._couponCode,
    this._rzp,
    this._augmnt,
    this._timestamp,
    this._updatedTime,
    this.transactionUpdatesMap,
    this.misMap,
    this.couponMap,
    this.lbMap,
  );

  UserTransaction.fromMap(Map<String, dynamic> data, String documentID)
      : this(
          documentID,
          BaseUtil.toDouble(data[fldAmount] ?? 0),
          BaseUtil.toDouble(data[fldClosingBalance] ?? 0),
          data[fldSubType] ?? '',
          data[fldType] ?? '',
          data[fldRedeemType] ?? '',
          data[fldTranStatus] ?? '',
          data[fldCouponCode] ?? '',
          data[fldRzpMap] ?? {},
          data[fldAugmontMap] ?? {},
          parseTimeStamp(data[fldTimestamp]) ?? Timestamp(0, 0),
          parseTimeStamp(data[fldUpdatedTime]) ?? Timestamp(0, 0),
          parseTransactionStatusSummary(data[fldtransactionUpdatesMap]) ?? '',
          data['miscMap'] ?? {},
          data["coupon"] ?? {},
          LbMap.fromMap(data["lbMap"] ?? {}),
        );

  UserTransaction.fromJSON(Map<String, dynamic> data, String documentID)
      : this(
          documentID,
          BaseUtil.toDouble(data[fldAmount]),
          BaseUtil.toDouble(data[fldClosingBalance]),
          data[fldSubType],
          data[fldType],
          data[fldRedeemType],
          data[fldTranStatus],
          data[fldCouponCode],
          data[fldRzpMap],
          data[fldAugmontMap],
          Timestamp(0, 0),
          Timestamp(0, 0),
          data[fldtransactionUpdatesMap],
          data['miscMap'],
          data["coupon"],
          LbMap.fromMap(data["lbMap"] ?? {}),
        );

  toJson() {
    return {
      fldAmount: _amount,
      fldClosingBalance: _closingBalance,
      fldSubType: _subType,
      fldType: _type,
      fldTranStatus: _tranStatus,
      fldCouponCode: _couponCode,
      fldRzpMap: _rzp,
      fldAugmontMap: _augmnt,
      fldTimestamp: _timestamp,
      fldUpdatedTime: Timestamp.now(),
    };
  }

  static toBase() => null;

  bool isExpired() {
    DateTime txnTime = _updatedTime!.toDate();
    DateTime nowTime = DateTime.now();
    DateTime txnExpireTime = txnTime.add(const Duration(hours: 1));

    return nowTime.isAfter(txnExpireTime);
  }

  String? get tranStatus => _tranStatus;

  set tranStatus(String? value) {
    _tranStatus = value;
  }

  String? get couponCode => _couponCode;
  set couponCode(String? value) {
    _couponCode = value;
  }

  String? get type => _type;

  set type(String? value) {
    _type = value;
  }

  String? get subType => _subType;

  set subType(String? value) {
    _subType = value;
  }

  String? get redeemType => _redeemType;

  set redeemType(String? value) {
    _redeemType = value;
  }

  double get closingBalance => _closingBalance;

  set closingBalance(double value) {
    _closingBalance = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  Map<String, dynamic>? get rzp => _rzp;

  set rzp(Map<String, dynamic>? value) {
    _rzp = value;
  }

  Map<String, dynamic>? get augmnt => _augmnt;

  set augmnt(Map<String, dynamic>? value) {
    _augmnt = value;
  }

  String? get docKey => _docKey;

  set docKey(String? value) {
    _docKey = value;
  }

  Timestamp? get timestamp => _timestamp;

  set timestamp(Timestamp? value) {
    _timestamp = value;
  }
}

class TransactionStatusMapItemModel {
  String? title;
  TimestampModel? timestamp;
  String? value;
  TransactionStatusMapItemModel({
    @required this.title,
    this.timestamp,
    this.value,
  });

  TransactionStatusMapItemModel copyWith({
    String? title,
    TimestampModel? timestamp,
    String? value,
  }) {
    return TransactionStatusMapItemModel(
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'timestamp': timestamp!.toMap(),
      'value': value,
    };
  }

  factory TransactionStatusMapItemModel.fromMap(Map<String, dynamic> map) {
    return TransactionStatusMapItemModel(
      title: map.keys.first,
      timestamp: map.values.first.runtimeType == Map
          ? TimestampModel.fromMap(map.values.first as Map<String, dynamic>)
          : TimestampModel(nanoseconds: 0, seconds: 0),
      value: map.values.first.runtimeType == String ? map.values.first : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionStatusMapItemModel.fromJson(String source) =>
      TransactionStatusMapItemModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TransactionStatusMapItemModel(title: $title, timestamp: $timestamp, value: $value)';

  @override
  bool operator ==(covariant TransactionStatusMapItemModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.timestamp == timestamp &&
        other.value == value;
  }

  @override
  int get hashCode => title.hashCode ^ timestamp.hashCode ^ value.hashCode;
}

class LbMap {
  String? fundType;
  TimestampModel? maturityAt;
  String? maturityPref;
  double? gainAmount;
  bool? hasDecidedPref;
  bool? hasMatured;

  LbMap(
      {this.fundType,
      this.maturityAt,
      this.maturityPref,
      this.gainAmount,
      this.hasDecidedPref,
      this.hasMatured});

  factory LbMap.fromMap(Map<String, dynamic> map) {
    return LbMap(
      fundType: map['fundType'] != null ? map['fundType'] as String : "",
      maturityAt: map['maturityAt'] != null
          ? TimestampModel.fromMap(map['maturityAt'])
          : TimestampModel.currentTimeStamp(),
      maturityPref:
          map['maturityPref'] != null ? map['maturityPref'] as String : "NA",
      gainAmount:
          map['gainAmount'] != null ? (map['gainAmount'] * 1.0) as double : 1.0,
      hasDecidedPref: map['hasDecidedPref'] ?? false,
      hasMatured: map['hasMatured'] ?? false,
    );
  }
}

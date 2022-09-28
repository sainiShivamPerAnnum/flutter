// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/util/logger.dart';

parseTimeStamp(dynamic data) {
  if (data != null) {
    if (data.runtimeType == Timestamp)
      return data;
    else
      return Timestamp(data["_seconds"], data["_nanoseconds"]);
  } else
    return null;
}

parseTransactionStatusSummary(List<dynamic> summary) {
  List<TransactionStatusMapItemModel> txnSummary = [];
  if (summary != null) {
    summary.forEach((s) {
      if (s.runtimeType == String || s.runtimeType == bool) return;
      final response = s.entries.first.value;
      TimestampModel timeStamp;
      String result;
      // print("Summary Timestamp : $s");
      // print("Summary Timestamp : ${s.entries.first.value.runtimeType}");

      // Map<String, dynamic> res;
      // res.entries.first.value
      if (response.runtimeType == String) {
        print("Summary Timestamp : $response");
        result = response.toString();
      } else
        timeStamp = TimestampModel.fromMap(response as Map<String, dynamic>);

      if (timeStamp != null) {
        txnSummary.add(TransactionStatusMapItemModel(
            title: s.entries.first.key, timestamp: timeStamp));
      } else if (result != null)
        txnSummary.add(TransactionStatusMapItemModel(
            title: s.entries.first.key, value: result));
      else
        txnSummary.add(TransactionStatusMapItemModel(
            title: s.entries.first.key, value: "NA"));
    });
  }

  return txnSummary;
}

class UserTransaction {
  static Log log = new Log('UserTransaction');
  String _docKey;
  double _amount;
  double _closingBalance;
  String _type;
  String _subType;
  String _redeemType;
  int _ticketUpCount;
  String _note;
  String _userId;
  String _tranStatus;
  Map<String, dynamic> _icici;
  Map<String, dynamic> _rzp;
  Map<String, dynamic> _augmnt;
  Map<String, dynamic> _paytmMap;
  Timestamp _timestamp;
  Timestamp _updatedTime;
  List<TransactionStatusMapItemModel> miscMap;

  static final String fldAmount = 'tAmount';
  static final String fldPaytmMap = 'paytmMap';
  static final String fldClosingBalance = 'tClosingBalance';
  static final String fldNote = 'tNote';
  static final String fldSubType = 'tSubtype';
  static final String fldRedeemType = 'tRedeemType';
  static final String fldType = 'tType';
  static final String fldTicketUpCount = 'tTicketUpdCount';
  static final String fldTranStatus = 'tTranStatus';
  static final String fldRzpMap = 'tRzpMap';
  static final String fldAugmontMap = 'tAugmontMap';
  static final String fldIciciMap = 'tIciciMap';
  static final String fldUserId = 'tUserId';
  static final String fldTimestamp = 'timestamp';
  static final String fldUpdatedTime = 'tUpdateTime';
  static const String fldMiscMap = "miscMap";

  ///paytm submap feilds
  static final String subFldPaytmBankName = 'bankName';
  static final String subFldPaytmBankTranId = 'bankTxnId';
  static final String subFldPaytmGatewayName = 'gatewayName';
  static final String subFldPaytmPaymentMode = 'paymentMode';
  static final String subFldPaytmStatus = 'status';
  static final String subFldPaytmTxnAmount = 'txnAmount';
  static final String subFldPaytmTxnDate = 'txnDate';
  static final String subFldPaytmTxnId = 'txnId';

  ///razorpay submap fields
  static final String subFldRzpOrderId = 'rOrderId';
  static final String subFldRzpPaymentId = 'rPaymentId';
  static final String subFldRzpStatus = 'rStatus';

  ///augmont submap fields
  static final String subFldAugBlockId = 'aBlockId';
  static final String subFldAugLockPrice = 'aLockPrice';
  static final String subFldAugPaymode = 'aPaymode';
  static final String subFldMerchantTranId = 'aTranId';
  static final String subFldAugTranId = 'aAugTranId';
  static final String subFldAugCurrentGoldGm = 'aGoldInTxn';
  static final String subFldAugTotalGoldGm = 'aGoldBalance';
  static final String subFldAugPostTaxTotal = 'aTaxedGoldBalance';

  ///Icici submap fields
  static final String subFldIciciTranId = 'iTranId';
  static final String subFldIciciWithdrawType = 'iWithType';
  static final String subFldIciciMultipleId = 'iMultipleId';
  static final String subFldIciciBankRnn = 'iBankRnn';
  static final String subFldIciciUpiTime = 'iUpiDateTime';
  static final String subFldIciciTxnOtpId = 'iWthlOtpId';
  static final String subFldIciciTxnOtpVerified = 'iWthOtpVerified';

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
    this._note,
    this._subType,
    this._type,
    this._redeemType,
    this._ticketUpCount,
    this._userId,
    this._tranStatus,
    this._icici,
    this._rzp,
    this._augmnt,
    this._timestamp,
    this._paytmMap,
    this._updatedTime,
    this.miscMap,
  );

  UserTransaction.fromMap(Map<String, dynamic> data, String documentID)
      : this(
          documentID,
          BaseUtil.toDouble(data[fldAmount]),
          BaseUtil.toDouble(data[fldClosingBalance]),
          data[fldNote],
          data[fldSubType],
          data[fldType],
          data[fldRedeemType],
          data[fldTicketUpCount],
          data[fldUserId],
          data[fldTranStatus],
          data[fldIciciMap],
          data[fldRzpMap],
          data[fldAugmontMap],
          parseTimeStamp(data[fldTimestamp]),
          data[fldPaytmMap],
          parseTimeStamp(data[fldUpdatedTime]),
          parseTransactionStatusSummary(data[fldMiscMap]),
        );

  UserTransaction.fromJSON(Map<String, dynamic> data, String documentID)
      : this(
            documentID,
            BaseUtil.toDouble(data[fldAmount]),
            BaseUtil.toDouble(data[fldClosingBalance]),
            data[fldNote],
            data[fldSubType],
            data[fldType],
            data[fldRedeemType],
            data[fldTicketUpCount],
            data[fldUserId],
            data[fldTranStatus],
            data[fldIciciMap],
            data[fldRzpMap],
            data[fldAugmontMap],
            null,
            data[fldPaytmMap],
            null,
            data[fldMiscMap]);
  //TODO JSON response received as HashMap for Timestamps

  // //ICICI investment initiated by new investor
  // UserTransaction.mfDeposit(String tranId, String multipleId,
  //     String upiTimestamp, double amount, String userId)
  //     : this(
  //           null,
  //           amount,
  //           0,
  //           'NA',
  //           TRAN_SUBTYPE_ICICI,
  //           TRAN_TYPE_DEPOSIT,
  //           null,
  //           0,
  //           userId,
  //           TRAN_STATUS_PENDING,
  //           {
  //             subFldIciciTranId: tranId,
  //             subFldIciciMultipleId: multipleId,
  //             subFldIciciUpiTime: upiTimestamp
  //           },
  //           null,
  //           null,
  //           Timestamp.now(),
  //           data[fldPaytmMap],
  //           Timestamp.now());

  //ICICI withdrawal initiated and completed by active investor
  // UserTransaction.mfWithdrawal(String tranId, String bankRnn, String note,
  //     String upiTimestamp, double amount, String userId)
  //     : this(
  //           null,
  //           amount,
  //           0,
  //           note ?? 'NA',
  //           TRAN_SUBTYPE_ICICI,
  //           TRAN_TYPE_WITHDRAW,
  //           null,
  //           0,
  //           userId,
  //           TRAN_STATUS_COMPLETE,
  //           {
  //             subFldIciciTranId: tranId,
  //             subFldIciciBankRnn: bankRnn,
  //             subFldIciciUpiTime: upiTimestamp
  //           },
  //           null,
  //           null,
  //           Timestamp.now(),
  //           Timestamp.now());

  // UserTransaction.mfNonInstantWithdrawal(String tranId, String note,
  //     String upiTimestamp, double amount, String userId)
  //     : this(
  //           null,
  //           amount,
  //           0,
  //           note ?? 'NA',
  //           TRAN_SUBTYPE_ICICI,
  //           TRAN_TYPE_WITHDRAW,
  //           null,
  //           0,
  //           userId,
  //           TRAN_STATUS_COMPLETE,
  //           {
  //             subFldIciciTranId: tranId,
  //             subFldIciciWithdrawType: 'NONINSTANT',
  //             subFldIciciUpiTime: upiTimestamp
  //           },
  //           null,
  //           null,
  //           Timestamp.now(),
  //           Timestamp.now());

  //Augmont gold investment initiated by investor
  UserTransaction.newGoldDeposit(double amount, double postTax, String blockId,
      double lockPrice, double quantity, String paymode, String userId)
      : this(
            null,
            amount,
            0,
            'NA',
            TRAN_SUBTYPE_AUGMONT_GOLD,
            TRAN_TYPE_DEPOSIT,
            null,
            0,
            userId,
            TRAN_STATUS_PENDING,
            null,
            null,
            {
              subFldAugBlockId: blockId,
              subFldAugLockPrice: lockPrice,
              subFldAugPaymode: paymode,
              subFldAugCurrentGoldGm: quantity,
              subFldAugPostTaxTotal: postTax
            },
            Timestamp.now(),
            null,
            Timestamp.now(),
            []);

  //Augmont gold investment initiated by investor
  UserTransaction.newGoldWithdrawal(double amount, String blockId,
      double lockPrice, double quantity, String userId)
      : this(
            null,
            amount,
            0,
            'NA',
            TRAN_SUBTYPE_AUGMONT_GOLD,
            TRAN_TYPE_WITHDRAW,
            null,
            0,
            userId,
            TRAN_STATUS_PENDING,
            null,
            null,
            {
              subFldAugBlockId: blockId,
              subFldAugLockPrice: lockPrice,
              subFldAugCurrentGoldGm: quantity
            },
            Timestamp.now(),
            null,
            Timestamp.now(),
            []);

  toJson() {
    return {
      fldAmount: _amount,
      fldClosingBalance: _closingBalance,
      fldNote: _note,
      fldSubType: _subType,
      fldType: _type,
      fldTicketUpCount: _ticketUpCount,
      fldUserId: _userId,
      fldTranStatus: _tranStatus,
      fldIciciMap: _icici,
      fldRzpMap: _rzp,
      fldAugmontMap: _augmnt,
      fldTimestamp: _timestamp,
      fldPaytmMap: _paytmMap,
      fldUpdatedTime: Timestamp.now(),
    };
  }

  bool isExpired() {
    DateTime txnTime = _updatedTime.toDate();
    DateTime nowTime = DateTime.now();
    DateTime txnExpireTime = txnTime.add(new Duration(hours: 1));

    return nowTime.isAfter(txnExpireTime);
  }

  String get tranStatus => _tranStatus;

  set tranStatus(String value) {
    _tranStatus = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  int get ticketUpCount => _ticketUpCount;

  set ticketUpCount(int value) {
    _ticketUpCount = value;
  }

  String get subType => _subType;

  set subType(String value) {
    _subType = value;
  }

  String get redeemType => _redeemType;

  set redeemType(String value) {
    _redeemType = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  double get closingBalance => _closingBalance;

  set closingBalance(double value) {
    _closingBalance = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  Map<String, dynamic> get icici => _icici;

  set icici(Map<String, dynamic> value) {
    _icici = value;
  }

  Map<String, dynamic> get rzp => _rzp;

  set rzp(Map<String, dynamic> value) {
    _rzp = value;
  }

  Map<String, dynamic> get augmnt => _augmnt;
  Map<String, dynamic> get paytmMap => _paytmMap;

  set augmnt(Map<String, dynamic> value) {
    _augmnt = value;
  }

  String get docKey => _docKey;

  set docKey(String value) {
    _docKey = value;
  }

  Timestamp get timestamp => _timestamp;

  set timestamp(Timestamp value) {
    _timestamp = value;
  }
}

class TransactionStatusMapItemModel {
  String title;
  TimestampModel timestamp;
  String value;
  TransactionStatusMapItemModel({
    @required this.title,
    this.timestamp,
    this.value,
  });

  TransactionStatusMapItemModel copyWith({
    String title,
    TimestampModel timestamp,
    String value,
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
      'timestamp': timestamp.toMap(),
      'value': value,
    };
  }

  factory TransactionStatusMapItemModel.fromMap(Map<String, dynamic> map) {
    return TransactionStatusMapItemModel(
      title: map.keys.first,
      timestamp: map.values.first.runtimeType == Map
          ? TimestampModel.fromMap(map.values.first as Map<String, dynamic>)
          : null,
      value: map.values.first.runtimeType == String ? map.values.first : null,
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

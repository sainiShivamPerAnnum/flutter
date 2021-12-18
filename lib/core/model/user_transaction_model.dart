import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/logger.dart';

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
  Timestamp _timestamp;
  Timestamp _updatedTime;

  static final String fldAmount = 'tAmount';
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
      this._updatedTime);

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
            data[fldTimestamp],
            data[fldUpdatedTime]);

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
            null);
  //TODO JSON response received as HashMap for Timestamps

  //ICICI investment initiated by new investor
  UserTransaction.mfDeposit(String tranId, String multipleId,
      String upiTimestamp, double amount, String userId)
      : this(
            null,
            amount,
            0,
            'NA',
            TRAN_SUBTYPE_ICICI,
            TRAN_TYPE_DEPOSIT,
            null,
            0,
            userId,
            TRAN_STATUS_PENDING,
            {
              subFldIciciTranId: tranId,
              subFldIciciMultipleId: multipleId,
              subFldIciciUpiTime: upiTimestamp
            },
            null,
            null,
            Timestamp.now(),
            Timestamp.now());

  //ICICI withdrawal initiated and completed by active investor
  UserTransaction.mfWithdrawal(String tranId, String bankRnn, String note,
      String upiTimestamp, double amount, String userId)
      : this(
            null,
            amount,
            0,
            note ?? 'NA',
            TRAN_SUBTYPE_ICICI,
            TRAN_TYPE_WITHDRAW,
            null,
            0,
            userId,
            TRAN_STATUS_COMPLETE,
            {
              subFldIciciTranId: tranId,
              subFldIciciBankRnn: bankRnn,
              subFldIciciUpiTime: upiTimestamp
            },
            null,
            null,
            Timestamp.now(),
            Timestamp.now());

  UserTransaction.mfNonInstantWithdrawal(String tranId, String note,
      String upiTimestamp, double amount, String userId)
      : this(
            null,
            amount,
            0,
            note ?? 'NA',
            TRAN_SUBTYPE_ICICI,
            TRAN_TYPE_WITHDRAW,
            null,
            0,
            userId,
            TRAN_STATUS_COMPLETE,
            {
              subFldIciciTranId: tranId,
              subFldIciciWithdrawType: 'NONINSTANT',
              subFldIciciUpiTime: upiTimestamp
            },
            null,
            null,
            Timestamp.now(),
            Timestamp.now());

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
            Timestamp.now());

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
            Timestamp.now());

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

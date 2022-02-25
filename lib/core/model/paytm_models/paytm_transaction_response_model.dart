class TransactionResponseModel {
  bool success;
  Data data;

  TransactionResponseModel({this.success, this.data});

  TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'data': data.toMap(),
    };
  }

  factory TransactionResponseModel.fromMap(Map<String, dynamic> map) {
    return TransactionResponseModel(
      success: map['success'] ?? false,
      data: Data.fromMap(map['data']),
    );
  }

  @override
  String toString() =>
      'TransactionResponseModel(success: $success, data: $data)';
}

class Data {
  PaytmMap paytmMap;
  double tAmount;
  String tTranStatus;
  String tNote;
  TxnDate tUpdatedOn;

  Data(
      {this.paytmMap,
      this.tAmount,
      this.tTranStatus,
      this.tNote,
      this.tUpdatedOn});

  Data.fromJson(Map<String, dynamic> json) {
    paytmMap = json['paytmMap'] != null
        ? new PaytmMap.fromJson(json['paytmMap'])
        : null;
    tAmount = json['tAmount'];
    tTranStatus = json['tTranStatus'];
    tNote = json['tNote'];
    tUpdatedOn = json['tUpdatedOn'] != null
        ? new TxnDate.fromJson(json['tUpdatedOn'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paytmMap != null) {
      data['paytmMap'] = this.paytmMap.toJson();
    }
    data['tAmount'] = this.tAmount;
    data['tTranStatus'] = this.tTranStatus;
    data['tNote'] = this.tNote;
    if (this.tUpdatedOn != null) {
      data['tUpdatedOn'] = this.tUpdatedOn.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'paytmMap': paytmMap.toMap(),
      'tAmount': tAmount,
      'tTranStatus': tTranStatus,
      'tNote': tNote,
      'tUpdatedOn': tUpdatedOn.toMap(),
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      paytmMap: PaytmMap.fromMap(map['paytmMap']),
      tAmount: map['tAmount']?.toDouble() ?? 0.0,
      tTranStatus: map['tTranStatus'] ?? '',
      tNote: map['tNote'] ?? '',
      tUpdatedOn: TxnDate.fromMap(map['tUpdatedOn']),
    );
  }

  @override
  String toString() {
    return 'Data(paytmMap: $paytmMap, tAmount: $tAmount, tTranStatus: $tTranStatus, tNote: $tNote, tUpdatedOn: $tUpdatedOn)';
  }
}

class PaytmMap {
  String txnId;
  String status;
  String bankTxnId;
  String txnType;
  double txnAmount;
  String gatewayName;
  String paymentMode;
  String bankName;
  TxnDate txnDate;

  PaytmMap(
      {this.txnId,
      this.status,
      this.bankTxnId,
      this.txnType,
      this.txnAmount,
      this.gatewayName,
      this.paymentMode,
      this.bankName,
      this.txnDate});

  PaytmMap.fromJson(Map<String, dynamic> json) {
    txnId = json['txnId'];
    status = json['status'];
    bankTxnId = json['bankTxnId'];
    txnType = json['txnType'];
    txnAmount = json['txnAmount'];
    gatewayName = json['gatewayName'];
    paymentMode = json['paymentMode'];
    bankName = json['bankName'];
    txnDate =
        json['txnDate'] != null ? new TxnDate.fromJson(json['txnDate']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['txnId'] = this.txnId;
    data['status'] = this.status;
    data['bankTxnId'] = this.bankTxnId;
    data['txnType'] = this.txnType;
    data['txnAmount'] = this.txnAmount;
    data['gatewayName'] = this.gatewayName;
    data['paymentMode'] = this.paymentMode;
    data['bankName'] = this.bankName;
    if (this.txnDate != null) {
      data['txnDate'] = this.txnDate.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'txnId': txnId,
      'status': status,
      'bankTxnId': bankTxnId,
      'txnType': txnType,
      'txnAmount': txnAmount,
      'gatewayName': gatewayName,
      'paymentMode': paymentMode,
      'bankName': bankName,
      'txnDate': txnDate.toMap(),
    };
  }

  factory PaytmMap.fromMap(Map<String, dynamic> map) {
    return PaytmMap(
      txnId: map['txnId'] ?? '',
      status: map['status'] ?? '',
      bankTxnId: map['bankTxnId'] ?? '',
      txnType: map['txnType'] ?? '',
      txnAmount: map['txnAmount']?.toDouble() ?? 0.0,
      gatewayName: map['gatewayName'] ?? '',
      paymentMode: map['paymentMode'] ?? '',
      bankName: map['bankName'] ?? '',
      txnDate: TxnDate.fromMap(map['txnDate']),
    );
  }

  @override
  String toString() {
    return 'PaytmMap(txnId: $txnId, status: $status, bankTxnId: $bankTxnId, txnType: $txnType, txnAmount: $txnAmount, gatewayName: $gatewayName, paymentMode: $paymentMode, bankName: $bankName, txnDate: $txnDate)';
  }
}

class TxnDate {
  int iSeconds;
  int iNanoseconds;

  TxnDate({this.iSeconds, this.iNanoseconds});

  TxnDate.fromJson(Map<String, dynamic> json) {
    iSeconds = json['_seconds'];
    iNanoseconds = json['_nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_seconds'] = this.iSeconds;
    data['_nanoseconds'] = this.iNanoseconds;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'iSeconds': iSeconds,
      'iNanoseconds': iNanoseconds,
    };
  }

  factory TxnDate.fromMap(Map<String, dynamic> map) {
    return TxnDate(
      iSeconds: map['iSeconds']?.toInt() ?? 0,
      iNanoseconds: map['iNanoseconds']?.toInt() ?? 0,
    );
  }

  @override
  String toString() =>
      'TxnDate(iSeconds: $iSeconds, iNanoseconds: $iNanoseconds)';
}

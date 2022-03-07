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

  Data({this.paytmMap, this.tAmount, this.tTranStatus, this.tNote});

  Data.fromJson(Map<String, dynamic> json) {
    paytmMap = json['paytmMap'] != null
        ? new PaytmMap.fromJson(json['paytmMap'])
        : null;
    tAmount = json['tAmount'];
    tTranStatus = json['tTranStatus'];
    tNote = json['tNote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paytmMap != null) {
      data['paytmMap'] = this.paytmMap.toJson();
    }
    data['tAmount'] = this.tAmount;
    data['tTranStatus'] = this.tTranStatus;
    data['tNote'] = this.tNote;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'paytmMap': paytmMap.toMap(),
      'tAmount': tAmount,
      'tTranStatus': tTranStatus,
      'tNote': tNote,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
        paytmMap: PaytmMap.fromMap(map['paytmMap']),
        tAmount: map['tAmount']?.toDouble() ?? 0.0,
        tTranStatus: map['tTranStatus'] ?? '',
        tNote: map['tNote'] ?? '');
  }

  @override
  String toString() {
    return 'Data(paytmMap: $paytmMap, tAmount: $tAmount, tTranStatus: $tTranStatus, tNote: $tNote)';
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

  PaytmMap(
      {this.txnId,
      this.status,
      this.bankTxnId,
      this.txnType,
      this.txnAmount,
      this.gatewayName,
      this.paymentMode,
      this.bankName});

  PaytmMap.fromJson(Map<String, dynamic> json) {
    txnId = json['txnId'];
    status = json['status'];
    bankTxnId = json['bankTxnId'];
    txnType = json['txnType'];
    txnAmount = json['txnAmount'];
    gatewayName = json['gatewayName'];
    paymentMode = json['paymentMode'];
    bankName = json['bankName'];
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
      'bankName': bankName
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
    );
  }

  @override
  String toString() {
    return 'PaytmMap(txnId: $txnId, status: $status, bankTxnId: $bankTxnId, txnType: $txnType, txnAmount: $txnAmount, gatewayName: $gatewayName, paymentMode: $paymentMode, bankName: $bankName)';
  }
}

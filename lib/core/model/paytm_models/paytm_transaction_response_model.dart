class TransactionResponseModel {
  String message;
  Data data;

  TransactionResponseModel({this.message, this.data});

  TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Head head;
  Body body;

  Data({this.head, this.body});

  Data.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? Head.fromJson(json['head']) : null;
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body.toJson();
    }
    return data;
  }
}

class Head {
  String responseTimestamp;
  String version;
  String signature;

  Head({this.responseTimestamp, this.version, this.signature});

  Head.fromJson(Map<String, dynamic> json) {
    responseTimestamp = json['responseTimestamp'];
    version = json['version'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['responseTimestamp'] = this.responseTimestamp;
    data['version'] = this.version;
    data['signature'] = this.signature;
    return data;
  }
}

class Body {
  ResultInfo resultInfo;
  String txnId;
  String orderId;
  String txnAmount;
  String txnType;
  String mid;
  String refundAmt;
  String txnDate;
  String splitSettlementInfo;

  Body(
      {this.resultInfo,
      this.txnId,
      this.orderId,
      this.txnAmount,
      this.txnType,
      this.mid,
      this.refundAmt,
      this.txnDate,
      this.splitSettlementInfo});

  Body.fromJson(Map<String, dynamic> json) {
    resultInfo = json['resultInfo'] != null
        ? new ResultInfo.fromJson(json['resultInfo'])
        : null;
    txnId = json['txnId'];
    orderId = json['orderId'];
    txnAmount = json['txnAmount'];
    txnType = json['txnType'];
    mid = json['mid'];
    refundAmt = json['refundAmt'];
    txnDate = json['txnDate'];
    splitSettlementInfo = json['splitSettlementInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.resultInfo != null) {
      data['resultInfo'] = this.resultInfo.toJson();
    }
    data['txnId'] = this.txnId;
    data['orderId'] = this.orderId;
    data['txnAmount'] = this.txnAmount;
    data['txnType'] = this.txnType;
    data['mid'] = this.mid;
    data['refundAmt'] = this.refundAmt;
    data['txnDate'] = this.txnDate;
    data['splitSettlementInfo'] = this.splitSettlementInfo;
    return data;
  }
}

class ResultInfo {
  String resultStatus;
  String resultCode;
  String resultMsg;

  ResultInfo({this.resultStatus, this.resultCode, this.resultMsg});

  ResultInfo.fromJson(Map<String, dynamic> json) {
    resultStatus = json['resultStatus'];
    resultCode = json['resultCode'];
    resultMsg = json['resultMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['resultStatus'] = this.resultStatus;
    data['resultCode'] = this.resultCode;
    data['resultMsg'] = this.resultMsg;
    return data;
  }
}

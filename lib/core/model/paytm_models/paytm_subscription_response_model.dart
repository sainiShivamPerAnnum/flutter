class SubscriptionResponseModel {
  bool success;
  Data data;

  SubscriptionResponseModel({this.success, this.data});

  SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
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
}

class Data {
  ResultInfo resultInfo;
  String subsId;
  String status;
  String subStatus;
  String orderId;
  String upfrontTxnId;
  SubsPaymentInstDetails subsPaymentInstDetails;
  String lastOrderId;
  String lastOrderStatus;
  String lastOrderCreationDate;
  String lastOrderAmount;
  String amountType;
  String maxAmount;
  String mid;
  String frequencyUnit;
  String frequency;
  String merchantName;
  String expiryDate;
  String createdDate;
  String updatedDate;
  String custId;
  String upfrontTxnAmount;

  Data(
      {this.resultInfo,
      this.subsId,
      this.status,
      this.subStatus,
      this.orderId,
      this.upfrontTxnId,
      this.subsPaymentInstDetails,
      this.lastOrderId,
      this.lastOrderStatus,
      this.lastOrderCreationDate,
      this.lastOrderAmount,
      this.amountType,
      this.maxAmount,
      this.mid,
      this.frequencyUnit,
      this.frequency,
      this.merchantName,
      this.expiryDate,
      this.createdDate,
      this.updatedDate,
      this.custId,
      this.upfrontTxnAmount});

  Data.fromJson(Map<String, dynamic> json) {
    resultInfo = json['resultInfo'] != null
        ? new ResultInfo.fromJson(json['resultInfo'])
        : null;
    subsId = json['subsId'];
    status = json['status'];
    subStatus = json['subStatus'];
    orderId = json['orderId'];
    upfrontTxnId = json['upfrontTxnId'];
    subsPaymentInstDetails = json['subsPaymentInstDetails'] != null
        ? new SubsPaymentInstDetails.fromJson(json['subsPaymentInstDetails'])
        : null;
    lastOrderId = json['lastOrderId'];
    lastOrderStatus = json['lastOrderStatus'];
    lastOrderCreationDate = json['lastOrderCreationDate'];
    lastOrderAmount = json['lastOrderAmount'];
    amountType = json['amountType'];
    maxAmount = json['maxAmount'];
    mid = json['mid'];
    frequencyUnit = json['frequencyUnit'];
    frequency = json['frequency'];
    merchantName = json['merchantName'];
    expiryDate = json['expiryDate'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    custId = json['custId'];
    upfrontTxnAmount = json['upfrontTxnAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.resultInfo != null) {
      data['resultInfo'] = this.resultInfo.toJson();
    }
    data['subsId'] = this.subsId;
    data['status'] = this.status;
    data['subStatus'] = this.subStatus;
    data['orderId'] = this.orderId;
    data['upfrontTxnId'] = this.upfrontTxnId;
    if (this.subsPaymentInstDetails != null) {
      data['subsPaymentInstDetails'] = this.subsPaymentInstDetails.toJson();
    }
    data['lastOrderId'] = this.lastOrderId;
    data['lastOrderStatus'] = this.lastOrderStatus;
    data['lastOrderCreationDate'] = this.lastOrderCreationDate;
    data['lastOrderAmount'] = this.lastOrderAmount;
    data['amountType'] = this.amountType;
    data['maxAmount'] = this.maxAmount;
    data['mid'] = this.mid;
    data['frequencyUnit'] = this.frequencyUnit;
    data['frequency'] = this.frequency;
    data['merchantName'] = this.merchantName;
    data['expiryDate'] = this.expiryDate;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    data['custId'] = this.custId;
    data['upfrontTxnAmount'] = this.upfrontTxnAmount;
    return data;
  }
}

class ResultInfo {
  String code;
  String message;
  String status;

  ResultInfo({this.code, this.message, this.status});

  ResultInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class SubsPaymentInstDetails {
  String paymentMode;

  SubsPaymentInstDetails({this.paymentMode});

  SubsPaymentInstDetails.fromJson(Map<String, dynamic> json) {
    paymentMode = json['paymentMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentMode'] = this.paymentMode;
    return data;
  }
}

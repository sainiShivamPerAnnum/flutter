class SubscriptionResponseModel {
  bool? success;
  Data? data;

  SubscriptionResponseModel({this.success, this.data});

  SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : Data.base();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  ResultInfo? resultInfo;
  String? subsId;
  String? status;
  String? subStatus;
  String? orderId;
  String? upfrontTxnId;
  SubsPaymentInstDetails? subsPaymentInstDetails;
  String? lastOrderId;
  String? lastOrderStatus;
  String? lastOrderCreationDate;
  String? lastOrderAmount;
  String? amountType;
  String? maxAmount;
  String? mid;
  String? frequencyUnit;
  String? frequency;
  String? merchantName;
  String? expiryDate;
  String? createdDate;
  String? updatedDate;
  String? custId;
  String? upfrontTxnAmount;

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

  Data.base() {
    resultInfo = ResultInfo.base();
    subsId = status = '';
    subStatus = '';
    orderId = '';
    upfrontTxnId = '';
    subsPaymentInstDetails = SubsPaymentInstDetails.base();
    lastOrderId = '';
    lastOrderStatus = '';
    lastOrderCreationDate = '';
    lastOrderAmount = '';
    amountType = '';
    maxAmount = '';
    mid = '';
    frequencyUnit = '';
    frequency = '';
    merchantName = '=';
    expiryDate = '';
    createdDate = '';
    updatedDate = '';
    custId = '';
    upfrontTxnAmount = '';
  }

  Data.fromJson(Map<String, dynamic> json) {
    resultInfo = json['resultInfo'] != null
        ? ResultInfo.fromJson(json['resultInfo'])
        : ResultInfo.base();
    subsId = json['subsId'] ?? '';
    status = json['status'] ?? '';
    subStatus = json['subStatus'] ?? '';
    orderId = json['orderId'] ?? '';
    upfrontTxnId = json['upfrontTxnId'] ?? '';
    subsPaymentInstDetails = json['subsPaymentInstDetails'] != null
        ? SubsPaymentInstDetails.fromJson(json['subsPaymentInstDetails'])
        : SubsPaymentInstDetails.base();
    lastOrderId = json['lastOrderId'] ?? '';
    lastOrderStatus = json['lastOrderStatus'] ?? '';
    lastOrderCreationDate = json['lastOrderCreationDate'] ?? '';
    lastOrderAmount = json['lastOrderAmount'] ?? '';
    amountType = json['amountType'] ?? '';
    maxAmount = json['maxAmount'] ?? '';
    mid = json['mid'] ?? '';
    frequencyUnit = json['frequencyUnit'] ?? '';
    frequency = json['frequency'] ?? '';
    merchantName = json['merchantName'] ?? '';
    expiryDate = json['expiryDate'] ?? '';
    createdDate = json['createdDate'] ?? '';
    updatedDate = json['updatedDate'] ?? '';
    custId = json['custId'] ?? '';
    upfrontTxnAmount = json['upfrontTxnAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (resultInfo != null) {
      data['resultInfo'] = resultInfo!.toJson();
    }
    data['subsId'] = subsId;
    data['status'] = status;
    data['subStatus'] = subStatus;
    data['orderId'] = orderId;
    data['upfrontTxnId'] = upfrontTxnId;
    if (subsPaymentInstDetails != null) {
      data['subsPaymentInstDetails'] = subsPaymentInstDetails!.toJson();
    }
    data['lastOrderId'] = lastOrderId;
    data['lastOrderStatus'] = lastOrderStatus;
    data['lastOrderCreationDate'] = lastOrderCreationDate;
    data['lastOrderAmount'] = lastOrderAmount;
    data['amountType'] = amountType;
    data['maxAmount'] = maxAmount;
    data['mid'] = mid;
    data['frequencyUnit'] = frequencyUnit;
    data['frequency'] = frequency;
    data['merchantName'] = merchantName;
    data['expiryDate'] = expiryDate;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    data['custId'] = custId;
    data['upfrontTxnAmount'] = upfrontTxnAmount;
    return data;
  }
}

class ResultInfo {
  String? code;
  String? message;
  String? status;

  ResultInfo({this.code, this.message, this.status});

  ResultInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    message = json['message'] ?? '';
    status = json['status'] ?? '';
  }
  ResultInfo.base() {
    code = '';
    message = '';
    status = '';
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = code;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class SubsPaymentInstDetails {
  String? paymentMode;

  SubsPaymentInstDetails({this.paymentMode});

  SubsPaymentInstDetails.base() {
    paymentMode = '';
  }

  SubsPaymentInstDetails.fromJson(Map<String, dynamic> json) {
    paymentMode = json['paymentMode'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['paymentMode'] = paymentMode;
    return data;
  }
}

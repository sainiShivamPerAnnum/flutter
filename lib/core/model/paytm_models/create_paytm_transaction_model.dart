class CreatePaytmTransactionModel {
  bool? success;
  Data? data;

  CreatePaytmTransactionModel({this.success, this.data});

  CreatePaytmTransactionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    data = json['data'] != null ? json[data] : Data.base();
  }
  CreatePaytmTransactionModel.base() {
    success = false;
    data = Data.base();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'data': data!.toMap(),
    };
  }

  factory CreatePaytmTransactionModel.fromMap(Map<String, dynamic> map) {
    return CreatePaytmTransactionModel(
      success: map['success'] ?? false,
      data: map['data'] != null ? Data.fromMap(map['data']) : Data.base(),
    );
  }

  CreatePaytmTransactionModel copyWith({
    bool? success,
    Data? data,
  }) {
    return CreatePaytmTransactionModel(
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }

  @override
  String toString() => 'CreateTransactionModel(success: $success, data: $data)';
}

class Data {
  String? temptoken;
  String? orderId;
  String? callbackUrl;
  String? txnId;

  Data({this.temptoken, this.orderId, this.callbackUrl, this.txnId});

  Data.base() {
    temptoken = '';
    orderId = '';
    callbackUrl = '';
    txnId = '';
  }
  Data.fromJson(Map<String, dynamic> json) {
    temptoken = json['temptoken'] ?? '';
    orderId = json['orderId'] ?? '';
    callbackUrl = json['callbackUrl'] ?? '';
    txnId = json['txnId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temptoken'] = this.temptoken;
    data['orderId'] = this.orderId;
    data['callbackUrl'] = this.callbackUrl;
    data['txnId'] = this.txnId;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'temptoken': temptoken,
      'orderId': orderId,
      'callbackUrl': callbackUrl,
      'txnId': txnId,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      temptoken: map['temptoken'] ?? '',
      orderId: map['orderId'] ?? '',
      callbackUrl: map['callbackUrl'] ?? '',
      txnId: map['txnId'] ?? '',
    );
  }

  @override
  String toString() =>
      'Data(temptoken: $temptoken, orderId: $orderId, callbackUrl: $callbackUrl)';

  Data copyWith({
    String? temptoken,
    String? orderId,
    String? callbackUrl,
    String? txnId,
  }) {
    return Data(
      temptoken: temptoken ?? this.temptoken,
      orderId: orderId ?? this.orderId,
      callbackUrl: callbackUrl ?? this.callbackUrl,
      txnId: txnId ?? this.txnId,
    );
  }
}

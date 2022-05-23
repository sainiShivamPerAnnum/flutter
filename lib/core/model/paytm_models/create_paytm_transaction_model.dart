class CreatePaytmTransactionModel {
  bool success;
  Data data;

  CreatePaytmTransactionModel({this.success, this.data});

  CreatePaytmTransactionModel.fromJson(Map<String, dynamic> json) {
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

  factory CreatePaytmTransactionModel.fromMap(Map<String, dynamic> map) {
    return CreatePaytmTransactionModel(
      success: map['success'] ?? false,
      data: Data.fromMap(map['data']),
    );
  }

  CreatePaytmTransactionModel copyWith({
    bool success,
    Data data,
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
  String temptoken;
  String orderId;
  String callbackUrl;

  Data({this.temptoken, this.orderId, this.callbackUrl});

  Data.fromJson(Map<String, dynamic> json) {
    temptoken = json['temptoken'];
    orderId = json['orderId'];
    callbackUrl = json['callbackUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temptoken'] = this.temptoken;
    data['orderId'] = this.orderId;
    data['callbackUrl'] = this.callbackUrl;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'temptoken': temptoken,
      'orderId': orderId,
      'callbackUrl': callbackUrl,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      temptoken: map['temptoken'] ?? '',
      orderId: map['orderId'] ?? '',
      callbackUrl: map['callbackUrl'] ?? '',
    );
  }

  @override
  String toString() =>
      'Data(temptoken: $temptoken, orderId: $orderId, callbackUrl: $callbackUrl)';

  Data copyWith({
    String temptoken,
    String orderId,
    String callbackUrl,
  }) {
    return Data(
      temptoken: temptoken ?? this.temptoken,
      orderId: orderId ?? this.orderId,
      callbackUrl: callbackUrl ?? this.callbackUrl,
    );
  }
}

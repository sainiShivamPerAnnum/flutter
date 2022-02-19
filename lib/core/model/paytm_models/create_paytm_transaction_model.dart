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

  Data({this.temptoken, this.orderId});

  Data.fromJson(Map<String, dynamic> json) {
    temptoken = json['temptoken'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temptoken'] = this.temptoken;
    data['orderId'] = this.orderId;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'temptoken': temptoken,
      'orderId': orderId,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      temptoken: map['temptoken'] ?? '',
      orderId: map['orderId'] ?? '',
    );
  }

  @override
  String toString() => 'Data(temptoken: $temptoken, orderId: $orderId)';

  Data copyWith({
    String temptoken,
    String orderId,
  }) {
    return Data(
      temptoken: temptoken ?? this.temptoken,
      orderId: orderId ?? this.orderId,
    );
  }
}

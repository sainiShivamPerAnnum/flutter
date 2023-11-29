import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  String? intent;
  String? nbIntent;
  String? pg;
  String? mid;
  Data({
    this.temptoken,
    this.orderId,
    this.callbackUrl,
    this.txnId,
    this.intent,
    this.nbIntent,
    this.pg,
    this.mid,
  });

  factory Data.base() {
    return Data();
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      temptoken: map['temptoken'] != null ? map['temptoken'] as String : null,
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
      callbackUrl:
          map['callbackUrl'] != null ? map['callbackUrl'] as String : null,
      txnId: map['txnId'] != null ? map['txnId'] as String : null,
      intent: map['intent'] != null ? map['intent'] as String : null,
      nbIntent: map['nbIntent'] != null ? map['nbIntent'] as String : null,
      pg: map['pg'] != null ? map['pg'] as String : null,
      mid: map['mid'] != null ? map['mid'] as String : null,
    );
  }

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Data(temptoken: $temptoken, orderId: $orderId, callbackUrl: $callbackUrl, txnId: $txnId, intent: $intent, pg: $pg, mid: $mid)';
  }
}

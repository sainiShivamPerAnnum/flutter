class CreateSubscriptionResponseModel {
  bool success;
  Data data;

  CreateSubscriptionResponseModel({this.success, this.data});

  CreateSubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
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

  factory CreateSubscriptionResponseModel.fromMap(Map<String, dynamic> map) {
    return CreateSubscriptionResponseModel(
      success: map['success'] ?? false,
      data: Data.fromMap(map['data']),
    );
  }

  @override
  String toString() =>
      'CreateSubscriptionResponseModel(success: $success, data: $data)';
}

class Data {
  String temptoken;
  String subscriptionId;
  String orderId;
  String callbackUrl;

  Data({this.temptoken, this.subscriptionId, this.orderId, this.callbackUrl});

  Data.fromJson(Map<String, dynamic> json) {
    temptoken = json['temptoken'];
    subscriptionId = json['subscriptionId'];
    orderId = json['orderId'];
    callbackUrl = json['callbackUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['temptoken'] = this.temptoken;
    data['subscriptionId'] = this.subscriptionId;
    data['orderId'] = this.orderId;
    data['callbackUrl'] = this.callbackUrl;

    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'temptoken': temptoken,
      'orderId': orderId,
      'subscriptionId': subscriptionId,
      'callbackUrl': callbackUrl,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
        temptoken: map['temptoken'] ?? '',
        subscriptionId: map['subscriptionId'] ?? '',
        orderId: map['orderId'] ?? '',
        callbackUrl: map['callbackUrl'] ?? '');
  }

  @override
  String toString() {
    return 'Data(tempToken: $temptoken, subscriptionId: $subscriptionId, orderId: $orderId, callbackUrl: $callbackUrl)';
  }
}

class CreateSubscriptionResponseModel {
  bool? success;
  Data? data;

  CreateSubscriptionResponseModel({this.success, this.data});

  CreateSubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
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

  factory CreateSubscriptionResponseModel.fromMap(Map<String, dynamic> map) {
    return CreateSubscriptionResponseModel(
      success: map['success'] ?? false,
      data: map['data'] != null ? Data.fromMap(map['data']) : null,
    );
  }

  @override
  String toString() =>
      'CreateSubscriptionResponseModel(success: $success, data: $data)';
}

class Data {
  String? temptoken;
  String? subscriptionId;
  String? orderId;
  String? callbackUrl;
  String? authenticationUrl;

  Data(
      {this.temptoken,
      this.subscriptionId,
      this.orderId,
      this.callbackUrl,
      this.authenticationUrl});

  Data.base() {
    temptoken = '';
    subscriptionId = '';
    orderId = '';
    callbackUrl = '';
    authenticationUrl = '';
  }

  Data.fromJson(Map<String, dynamic> json) {
    temptoken = json['temptoken'] ?? '';
    subscriptionId = json['subscriptionId'] ?? '';
    orderId = json['orderId'] ?? '';
    callbackUrl = json['callbackUrl'] ?? '';
    authenticationUrl = json['authenticationUrl'] ?? '';
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['temptoken'] = temptoken;
    data['subscriptionId'] = subscriptionId;
    data['orderId'] = orderId;
    data['callbackUrl'] = callbackUrl;
    data['authenticationUrl'] = authenticationUrl;

    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'temptoken': temptoken,
      'orderId': orderId,
      'subscriptionId': subscriptionId,
      'callbackUrl': callbackUrl,
      'authenticationUrl': authenticationUrl
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
        temptoken: map['temptoken'] ?? '',
        subscriptionId: map['subscriptionId'] ?? '',
        orderId: map['orderId'] ?? '',
        callbackUrl: map['callbackUrl'] ?? '',
        authenticationUrl: map['authenticationUrl'] ?? '');
  }

  @override
  String toString() {
    return 'Data(tempToken: $temptoken, subscriptionId: $subscriptionId, orderId: $orderId, callbackUrl: $callbackUrl authenticationUrl: $authenticationUrl)';
  }
}

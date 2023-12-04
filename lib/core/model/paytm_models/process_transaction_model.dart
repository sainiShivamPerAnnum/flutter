// ignore_for_file: unused_label

class ProcessTransactionModel {
  String? message;
  Data? data;

  ProcessTransactionModel({this.message, this.data});

  ProcessTransactionModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    data = json['data'] != null ? Data.fromJson(json['data']) : Data.base();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Head? head;
  Body? body;

  Data({this.head, this.body});

  Data.fromJson(Map<String, dynamic> json) {
    head = Head.fromJson(json['head'] ?? '');
    body = json['body'] != null ? Body.fromJson(json['body']) : Body.base();
  }

  Data.base() {
    head = Head.base();
    body = Body.base();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (head != null) {
      data['head'] = head!.toJson();
    }
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Head {
  String? responseTimestamp;
  String? version;

  Head({this.responseTimestamp, this.version});

  Head.base() {
    responseTimestamp = '';
    version = '';
  }

  Head.fromJson(Map<String, dynamic> json) {
    responseTimestamp = json['responseTimestamp'] ?? '';
    version = json['version'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responseTimestamp'] = responseTimestamp;
    data['version'] = version;
    return data;
  }
}

class Body {
  ResultInfo? resultInfo;
  DeepLinkInfo? deepLinkInfo;
  RiskContent? riskContent;

  Body({this.resultInfo, this.deepLinkInfo, this.riskContent});

  Body.base() {
    resultInfo = ResultInfo.base();
    deepLinkInfo = DeepLinkInfo.base();
    riskContent = RiskContent.base();
  }

  Body.fromJson(Map<String, dynamic> json) {
    resultInfo = json['resultInfo'] != null
        ? ResultInfo.fromJson(json['resultInfo'])
        : ResultInfo.base();
    deepLinkInfo = json['deepLinkInfo'] != null
        ? DeepLinkInfo.fromJson(json['deepLinkInfo'])
        : DeepLinkInfo.base();
    riskContent = json['riskContent'] != null
        ? RiskContent.fromJson(json['riskContent'])
        : RiskContent.base();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (resultInfo != null) {
      data['resultInfo'] = resultInfo!.toJson();
    }
    if (deepLinkInfo != null) {
      data['deepLinkInfo'] = deepLinkInfo!.toJson();
    }
    if (riskContent != null) {
      data['riskContent'] = riskContent!.toJson();
    }
    return data;
  }
}

class ResultInfo {
  String? resultStatus;
  String? resultCode;
  String? resultMsg;

  ResultInfo({this.resultStatus, this.resultCode, this.resultMsg});

  ResultInfo.base() {
    resultCode = '';
    resultMsg = '';
    resultStatus = '';
  }
  ResultInfo.fromJson(Map<String, dynamic> json) {
    resultStatus = json['resultStatus'] ?? '';
    resultCode = json['resultCode'] ?? '';
    resultMsg = json['resultMsg'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultStatus'] = resultStatus;
    data['resultCode'] = resultCode;
    data['resultMsg'] = resultMsg;
    return data;
  }
}

class DeepLinkInfo {
  String? deepLink;
  String? orderId;
  String? cashierRequestId;
  String? transId;

  DeepLinkInfo(
      {this.deepLink, this.orderId, this.cashierRequestId, this.transId});

  DeepLinkInfo.base() {
    deepLink = '';
    orderId = '';
    cashierRequestId = '';
    transId = '';
  }
  DeepLinkInfo.fromJson(Map<String, dynamic> json) {
    deepLink = json['deepLink'] ?? '';
    orderId = json['orderId'] ?? '';
    cashierRequestId = json['cashierRequestId'] ?? '';
    transId = json['transId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deepLink'] = deepLink;
    data['orderId'] = orderId;
    data['cashierRequestId'] = cashierRequestId;
    data['transId'] = transId;
    return data;
  }
}

class RiskContent {
  String? eventLinkId;

  RiskContent({this.eventLinkId});

  RiskContent.base() {
    eventLinkId = '';
  }
  RiskContent.fromJson(Map<String, dynamic> json) {
    eventLinkId = json['eventLinkId'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventLinkId'] = eventLinkId;
    return data;
  }
}

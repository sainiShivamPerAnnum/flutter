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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head!.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body!.toJson();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['responseTimestamp'] = this.responseTimestamp;
    data['version'] = this.version;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.resultInfo != null) {
      data['resultInfo'] = this.resultInfo!.toJson();
    }
    if (this.deepLinkInfo != null) {
      data['deepLinkInfo'] = this.deepLinkInfo!.toJson();
    }
    if (this.riskContent != null) {
      data['riskContent'] = this.riskContent!.toJson();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['resultStatus'] = this.resultStatus;
    data['resultCode'] = this.resultCode;
    data['resultMsg'] = this.resultMsg;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['deepLink'] = this.deepLink;
    data['orderId'] = this.orderId;
    data['cashierRequestId'] = this.cashierRequestId;
    data['transId'] = this.transId;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['eventLinkId'] = this.eventLinkId;
    return data;
  }
}

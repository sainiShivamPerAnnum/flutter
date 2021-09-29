class PanVerificationResModel {
  String service;
  String itemId;
  String task;
  Essentials essentials;
  String accessToken;
  String id;
  Response response;

  PanVerificationResModel(
      {this.service,
      this.itemId,
      this.task,
      this.essentials,
      this.accessToken,
      this.id,
      this.response});

  PanVerificationResModel.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    itemId = json['itemId'];
    task = json['task'];
    essentials = json['essentials'] != null
        ? new Essentials.fromJson(json['essentials'])
        : null;
    accessToken = json['accessToken'];
    id = json['id'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service'] = this.service;
    data['itemId'] = this.itemId;
    data['task'] = this.task;
    if (this.essentials != null) {
      data['essentials'] = this.essentials.toJson();
    }
    data['accessToken'] = this.accessToken;
    data['id'] = this.id;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Essentials {
  String number;
  String name;
  String fuzzy;

  Essentials({this.number, this.name, this.fuzzy});

  Essentials.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    fuzzy = json['fuzzy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['name'] = this.name;
    data['fuzzy'] = this.fuzzy;
    return data;
  }
}

class Response {
  String name;
  String number;
  String fuzzy;
  int id;
  Instance instance;
  Result result;

  Response(
      {this.name,
      this.number,
      this.fuzzy,
      this.id,
      this.instance,
      this.result});

  Response.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];
    fuzzy = json['fuzzy'];
    id = json['id'];
    instance = json['instance'] != null
        ? new Instance.fromJson(json['instance'])
        : null;
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['number'] = this.number;
    data['fuzzy'] = this.fuzzy;
    data['id'] = this.id;
    if (this.instance != null) {
      data['instance'] = this.instance.toJson();
    }
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Instance {
  String id;
  String callbackUrl;

  Instance({this.id, this.callbackUrl});

  Instance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    callbackUrl = json['callbackUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['callbackUrl'] = this.callbackUrl;
    return data;
  }
}

class Result {
  bool verified;
  String message;
  String upstreamName;

  Result({this.verified, this.message, this.upstreamName});

  Result.fromJson(Map<String, dynamic> json) {
    verified = json['verified'];
    message = json['message'];
    upstreamName = json['upstreamName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verified'] = this.verified;
    data['message'] = this.message;
    data['upstreamName'] = this.upstreamName;
    return data;
  }
}

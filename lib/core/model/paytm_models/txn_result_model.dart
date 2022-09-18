class TxnResultModel {
  String message;
  Data data;

  TxnResultModel({this.message, this.data});

  TxnResultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  bool isUpdating;
  Gt gt;

  Data({this.isUpdating = true, this.gt});

  Data.fromJson(Map<String, dynamic> json) {
    isUpdating = json['isUpdating'];
    gt = json['gt'] != null ? Gt.fromJson(json['gt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isUpdating'] = this.isUpdating;
    if (this.gt != null) {
      data['gt'] = this.gt.toJson();
    }
    return data;
  }
}

class Gt {
  bool canTransfer;
  Timestamp timestamp;
  Timestamp redeemedTimestamp;
  String eventType;
  String gtType;
  bool isRewarding;
  String version;
  String note;
  String prizeSubtype;
  String userId;
  List<RewardArr> rewardArr;

  Gt(
      {this.canTransfer,
      this.timestamp,
      this.redeemedTimestamp,
      this.eventType,
      this.gtType,
      this.isRewarding,
      this.version,
      this.note,
      this.prizeSubtype,
      this.userId,
      this.rewardArr});

  Gt.fromJson(Map<String, dynamic> json) {
    canTransfer = json['canTransfer'];
    timestamp = json['timestamp'] != null
        ? new Timestamp.fromJson(json['timestamp'])
        : null;
    redeemedTimestamp = json['redeemedTimestamp'] != null
        ? new Timestamp.fromJson(json['redeemedTimestamp'])
        : null;
    eventType = json['eventType'];
    gtType = json['gtType'];
    isRewarding = json['isRewarding'];
    version = json['version'];
    note = json['note'];
    prizeSubtype = json['prizeSubtype'];
    userId = json['userId'];
    if (json['rewardArr'] != null) {
      rewardArr = <RewardArr>[];
      json['rewardArr'].forEach((v) {
        rewardArr.add(new RewardArr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['canTransfer'] = this.canTransfer;
    if (this.timestamp != null) {
      data['timestamp'] = this.timestamp.toJson();
    }
    if (this.redeemedTimestamp != null) {
      data['redeemedTimestamp'] = this.redeemedTimestamp.toJson();
    }
    data['eventType'] = this.eventType;
    data['gtType'] = this.gtType;
    data['isRewarding'] = this.isRewarding;
    data['version'] = this.version;
    data['note'] = this.note;
    data['prizeSubtype'] = this.prizeSubtype;
    data['userId'] = this.userId;
    if (this.rewardArr != null) {
      data['rewardArr'] = this.rewardArr.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timestamp {
  int iSeconds;
  int iNanoseconds;

  Timestamp({this.iSeconds, this.iNanoseconds});

  Timestamp.fromJson(Map<String, dynamic> json) {
    iSeconds = json['_seconds'];
    iNanoseconds = json['_nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_seconds'] = this.iSeconds;
    data['_nanoseconds'] = this.iNanoseconds;
    return data;
  }
}

class RewardArr {
  int value;
  String type;

  RewardArr({this.value, this.type});

  RewardArr.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}

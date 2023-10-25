class TxnResultModel {
  String? message;
  Data? data;

  TxnResultModel({this.message, this.data});

  TxnResultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? isUpdating;
  Gt? gt;

  Data({this.isUpdating = true, this.gt});

  Data.base() {
    isUpdating = false;
    gt = Gt.base();
  }

  Data.fromJson(Map<String, dynamic> json) {
    isUpdating = json['isUpdating'] ?? false;
    gt = json['gt'] != null ? Gt.fromJson(json['gt']) : Gt.base();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isUpdating'] = isUpdating;
    if (gt != null) {
      data['gt'] = gt!.toJson();
    }
    return data;
  }
}

class Gt {
  bool? canTransfer;
  Timestamp? timestamp;
  Timestamp? redeemedTimestamp;
  String? eventType;
  String? gtType;
  bool? isRewarding;
  String? version;
  String? note;
  String? prizeSubtype;
  String? userId;
  List<RewardArr>? rewardArr;

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

  Gt.base() {
    canTransfer = false;
    timestamp = Timestamp.base();
    redeemedTimestamp = Timestamp.base();
    eventType = '';
    gtType = '';
    isRewarding = false;
    version = '';
    note = '';
    prizeSubtype = '';
    userId = '';
    rewardArr = [];
  }

  Gt.fromJson(Map<String, dynamic> json) {
    canTransfer = json['canTransfer'];
    timestamp = json['timestamp'] != null
        ? Timestamp.fromJson(json['timestamp'])
        : Timestamp.base();
    redeemedTimestamp = json['redeemedTimestamp'] != null
        ? Timestamp.fromJson(json['redeemedTimestamp'])
        : Timestamp.base();
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
        rewardArr!.add(RewardArr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['canTransfer'] = canTransfer;
    if (timestamp != null) {
      data['timestamp'] = timestamp!.toJson();
    }
    if (redeemedTimestamp != null) {
      data['redeemedTimestamp'] = redeemedTimestamp!.toJson();
    }
    data['eventType'] = eventType;
    data['gtType'] = gtType;
    data['isRewarding'] = isRewarding;
    data['version'] = version;
    data['note'] = note;
    data['prizeSubtype'] = prizeSubtype;
    data['userId'] = userId;
    if (rewardArr != null) {
      data['rewardArr'] = rewardArr!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timestamp {
  int? iSeconds;
  int? iNanoseconds;

  Timestamp({this.iSeconds, this.iNanoseconds});

  Timestamp.base() {
    iSeconds = 0;
    iNanoseconds = 0;
  }

  Timestamp.fromJson(Map<String, dynamic> json) {
    iSeconds = json['_seconds'];
    iNanoseconds = json['_nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_seconds'] = iSeconds;
    data['_nanoseconds'] = iNanoseconds;
    return data;
  }
}

class RewardArr {
  int? value;
  String? type;

  RewardArr({this.value, this.type});

  RewardArr.base() {
    value = 0;
    type = '';
  }

  RewardArr.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value'] = value;
    data['type'] = type;
    return data;
  }
}

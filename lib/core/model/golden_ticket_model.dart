import 'package:cloud_firestore/cloud_firestore.dart';

class GoldenTicket {
  String gtId;
  bool canTransfer;
  String eventType;
  String gtType;
  bool isRewarding;
  String note;
  String prizeSubtype;
  CreatedAt redeemedTimestamp;
  List<Reward> rewardArr;
  CreatedAt timestamp;
  String userId;
  String version;

  GoldenTicket({
    this.gtId,
    this.userId,
    this.timestamp,
    this.eventType,
    this.prizeSubtype,
    this.note,
    this.gtType,
    this.canTransfer,
    this.isRewarding,
    this.rewardArr,
    this.redeemedTimestamp,
    this.version,
  });

  GoldenTicket.fromJson(Map<String, dynamic> json, String docId) {
    gtId = docId;
    userId = json['userId'];
    timestamp = json['timestamp'] != null
        ? CreatedAt.fromJson(json['timestamp'])
        : null;
    eventType = json['eventType'];
    gtType = json['gtType'];
    prizeSubtype = json['prizeSubtype'];
    note = json['note'];
    canTransfer = json['canTransfer'];
    isRewarding = json['isRewarding'];
    redeemedTimestamp = json['redeemedTimestamp'] != null
        ? CreatedAt.fromJson(json['redeemedTimestamp'])
        : null;
    rewardArr =
        json['rewardArr'] != null ? Reward.objArray(json['rewardArr']) : [];
    version = json['version'];
  }
}

class Reward {
  String type;
  int value;

  Reward({
    this.type,
    this.value,
  });

  Reward.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  static List<Reward> objArray(List<dynamic> list) {
    List<Reward> rewards = [];
    list.forEach((e) {
      rewards.add(Reward.fromJson(e));
    });
    return rewards;
  }

  toString() {
    return "Type: $type || Value: $value";
  }
}

class CreatedAt {
  CreatedAt({
    this.seconds,
    this.nanoseconds,
  });

  int seconds;
  int nanoseconds;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_seconds'] = this.seconds;
    data['_nanoseconds'] = this.nanoseconds;
    return data;
  }

  factory CreatedAt.fromMap(Map<String, dynamic> json) => CreatedAt(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
      );

  Map<String, dynamic> toMap() => {
        "_seconds": seconds,
        "_nanoseconds": nanoseconds,
      };

  factory CreatedAt.fromJson(Map<String, dynamic> json) => CreatedAt(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
      );
}

// Why a reward map, why not directly a reward array
// with reward class object